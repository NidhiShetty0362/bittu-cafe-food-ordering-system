using Razorpay.Api;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace cafe
{
    public partial class Payment : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["BittuDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                lblOrderType.Text = Session["OrderType"]?.ToString() ?? "";
                lblTotal.Text = Session["PayAmount"]?.ToString() ?? "0";

                LoadItems();
                SetupPaymentOptions();
            }
        }

        void LoadItems()
        {
            if (Session["CartData"] != null)
            {
                DataTable dt = (DataTable)Session["CartData"];

                if (!dt.Columns.Contains("Total"))
                    dt.Columns.Add("Total", typeof(decimal));

                foreach (DataRow row in dt.Rows)
                {
                    row["Total"] = Convert.ToDecimal(row["Price"]) * Convert.ToInt32(row["Qty"]);
                }

                rptItems.DataSource = dt;
                rptItems.DataBind();
            }
        }

        void SetupPaymentOptions()
        {
            string type = Session["OrderType"]?.ToString();

            pnlDineIn.Visible = (type == "DineIn");
            pnlDelivery.Visible = (type != "DineIn");
        }

        protected void btnPayNow_Click(object sender, EventArgs e)
        {
            if (Session["OrderType"] == null)
            {
                Response.Redirect("Cart.aspx");
                return;
            }

            string paymentMode = "";
            string type = Session["OrderType"].ToString();

            if (type == "DineIn")
            {
                if (rbCounter.Checked)
                    paymentMode = "Counter";
                else if (rbOnline.Checked)
                    paymentMode = "Online";
            }
            else
            {
                if (rbCOD.Checked)
                    paymentMode = "COD";
                else if (rbOnline2.Checked)
                    paymentMode = "Online";
            }

            if (string.IsNullOrEmpty(paymentMode))
            {
                Response.Write("<script>alert('Select payment method')</script>");
                return;
            }

            // ✅ SAVE ORDER
            int orderId = SaveOrder(paymentMode);
            Session["OrderId"] = orderId;

            if (paymentMode == "Online")
            {
                StartOnlinePayment();
            }
            else
            {
                RedirectAfterOrder();
            }
        }

        void RedirectAfterOrder()
        {
            string type = Session["OrderType"].ToString();
            int orderId = Convert.ToInt32(Session["OrderId"]);

            if (type == "Delivery")
            {
                Response.Redirect("TrackOrder.aspx?orderId=" + orderId);
            }
            else
            {
                Response.Redirect("MyOrders.aspx");
            }
        }

        void StartOnlinePayment()
        {
            decimal amount = Convert.ToDecimal(Session["PayAmount"]) * 100;

            string script = $@"
var options = {{
    key: 'rzp_test_SZJmkY2Laif1YY',
    amount: '{amount}',
    currency: 'INR',
    name: 'Cafe',
    description: 'Order Payment',
    handler: function (response) {{

        fetch('Payment.aspx/PaymentSuccess', {{
            method: 'POST',
            headers: {{ 'Content-Type': 'application/json' }}
        }})
        .then(() => {{

            var type = '{Session["OrderType"]}';
            var orderId = '{Session["OrderId"]}';

            if (type === 'Delivery') {{
                window.location.href = 'TrackOrder.aspx?orderId=' + orderId;
            }} else {{
                window.location.href = 'MyOrders.aspx';
            }}

        }});
    }}
}};

var rzp = new Razorpay(options);
rzp.open();
";

            ClientScript.RegisterStartupScript(this.GetType(), "rzp", script, true);
        }

        [System.Web.Services.WebMethod]
        public static string PaymentSuccess()
        {
            return "OK";
        }

        int SaveOrder(string paymentMode)
        {
            string username = Session["User"]?.ToString();
            string orderType = Session["OrderType"]?.ToString();

            int orderId = 0;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlTransaction trans = con.BeginTransaction();

                try
                {
                    SqlCommand cmd = new SqlCommand(@"
INSERT INTO Orders
(Username, OrderType, TotalAmount, PaymentMode, Status, Address, City, Pincode, Latitude, Longitude)
VALUES
(@Username, @OrderType, @TotalAmount, @PaymentMode, @Status, @Address, @City, @Pincode, @Lat, @Lng);
SELECT SCOPE_IDENTITY();", con, trans);

                    cmd.Parameters.AddWithValue("@Username", username);
                    cmd.Parameters.AddWithValue("@OrderType", orderType);
                    cmd.Parameters.AddWithValue("@TotalAmount", Session["PayAmount"]);
                    cmd.Parameters.AddWithValue("@PaymentMode", paymentMode);

                    // ✅ DEFAULT STATUS
                    cmd.Parameters.AddWithValue("@Status", "Pending");

                    cmd.Parameters.AddWithValue("@Address", Session["Address"] ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@City", Session["City"] ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@Pincode", Session["Pincode"] ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@Lat", Session["Lat"] ?? (object)DBNull.Value);
                    cmd.Parameters.AddWithValue("@Lng", Session["Lng"] ?? (object)DBNull.Value);

                    orderId = Convert.ToInt32(cmd.ExecuteScalar());

                    DataTable cart = (DataTable)Session["CartData"];

                    foreach (DataRow row in cart.Rows)
                    {
                        SqlCommand itemCmd = new SqlCommand(@"
INSERT INTO OrderItems
(OrderId, ItemName, Price, Quantity, Total)
VALUES
(@OrderId, @ItemName, @Price, @Qty, @Total)", con, trans);

                        itemCmd.Parameters.AddWithValue("@OrderId", orderId);
                        itemCmd.Parameters.AddWithValue("@ItemName", row["ItemName"]);
                        itemCmd.Parameters.AddWithValue("@Price", row["Price"]);
                        itemCmd.Parameters.AddWithValue("@Qty", row["Qty"]);
                        itemCmd.Parameters.AddWithValue("@Total",
                            Convert.ToDecimal(row["Price"]) * Convert.ToInt32(row["Qty"]));

                        itemCmd.ExecuteNonQuery();
                    }

                    SqlCommand clearCmd = new SqlCommand(
                        "DELETE FROM Cart WHERE Username=@u", con, trans);

                    clearCmd.Parameters.AddWithValue("@u", username);
                    clearCmd.ExecuteNonQuery();

                    trans.Commit();
                }
                catch
                {
                    trans.Rollback();
                    throw;
                }
            }

            return orderId;
        }
    }
}