using System;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;

namespace cafe
{
    public partial class Cart : System.Web.UI.Page
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
                LoadCart();
        }

        void LoadCart()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                string q = @"SELECT c.CartId,c.Qty,
                             m.ItemName,m.Price,m.ImagePath
                             FROM Cart c 
                             JOIN MenuItems m ON c.MenuId=m.MenuId
                             WHERE c.Username=@u";

                SqlCommand cmd = new SqlCommand(q, con);
                cmd.Parameters.AddWithValue("@u", Session["User"]);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptCart.DataSource = dt;
                rptCart.DataBind();

                decimal total = 0;
                foreach (DataRow row in dt.Rows)
                {
                    total += Convert.ToDecimal(row["Price"]) * Convert.ToInt32(row["Qty"]);
                }

                lblTotal.Text = total.ToString();

                Session["CartData"] = dt;
                Session["PayAmount"] = total;
            }
        }

        protected void rptCart_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                if (e.CommandName == "plus")
                    new SqlCommand("UPDATE Cart SET Qty=Qty+1 WHERE CartId=@id", con)
                    { Parameters = { new SqlParameter("@id", id) } }.ExecuteNonQuery();

                else if (e.CommandName == "minus")
                    new SqlCommand("UPDATE Cart SET Qty=CASE WHEN Qty>1 THEN Qty-1 ELSE 1 END WHERE CartId=@id", con)
                    { Parameters = { new SqlParameter("@id", id) } }.ExecuteNonQuery();

                else if (e.CommandName == "delete")
                    new SqlCommand("DELETE FROM Cart WHERE CartId=@id", con)
                    { Parameters = { new SqlParameter("@id", id) } }.ExecuteNonQuery();
            }

            LoadCart();
        }

        protected void btnOrder_Click(object sender, EventArgs e)
        {
            if (rbDineIn.Checked)
            {
                Session["OrderType"] = "DineIn";
                Response.Redirect("Payment.aspx"); // no address needed
            }
            else if (rbTakeaway.Checked)
            {
                Session["OrderType"] = "Takeaway";
                Response.Redirect("Payment.aspx"); // no address needed
            }
            else if (rbDelivery.Checked)
            {
                Session["OrderType"] = "Delivery";

                // ✅ IMPORTANT CHANGE HERE
                Response.Redirect("DeliveryAddress.aspx");
            }
            else
            {
                Response.Write("<script>alert('Select order type')</script>");
            }
        }
    }
}