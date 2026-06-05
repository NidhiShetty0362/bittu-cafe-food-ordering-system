using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace cafe
{
    public partial class MyOrders : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadMyOrders();
            }
        }

        void LoadMyOrders()
        {
            string cs = ConfigurationManager.ConnectionStrings["BittuDB"].ConnectionString;

            DataTable dt = new DataTable();

            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"
        SELECT 
            O.OrderId,
            O.OrderDate,
            O.Status,
            O.PaymentMode,
            I.ItemName,
            I.Price,
            I.Quantity,
            I.Total
        FROM Orders O
        INNER JOIN OrderItems I ON O.OrderId = I.OrderId
        WHERE O.Username = @Username
        ORDER BY O.OrderId DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Username", Session["User"].ToString());

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }

            if (dt.Rows.Count > 0)
            {
                var orders = dt.AsEnumerable()
                    .GroupBy(r => new
                    {
                        OrderId = r["OrderId"],
                        OrderDate = r["OrderDate"],
                        Status = r["Status"],
                        PaymentMode = r["PaymentMode"]
                    })
                    .Select(g => new
                    {
                        OrderId = g.Key.OrderId,
                        OrderDate = g.Key.OrderDate,
                        Status = g.Key.Status,
                        PaymentMode = g.Key.PaymentMode,
                        Items = g.Select(x => x).ToList(),
                        TotalAmount = g.Sum(x => Convert.ToDecimal(x["Total"]))
                    }).ToList();

                rptOrders.DataSource = orders;
                rptOrders.DataBind();
                lblMsg.Text = "";
            }
            else
            {
                lblMsg.Text = "No orders found 🛒";
            }
        }
        
    }
}