using System;
using System.Configuration;
using System.Data.SqlClient;

namespace cafe
{
    public partial class GetOrderStatus : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Clear();
            Response.ContentType = "application/json";

            string orderParam = Request.QueryString["orderId"];
            int orderId;

            if (string.IsNullOrEmpty(orderParam) || !int.TryParse(orderParam, out orderId))
            {
                Response.Write("{\"status\":\"Pending\"}");
                Response.End();
                return;
            }

            string cs = ConfigurationManager.ConnectionStrings["BittuDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT Status FROM Orders WHERE OrderId=@id", con);

                cmd.Parameters.AddWithValue("@id", orderId);

                con.Open();
                object result = cmd.ExecuteScalar();

                string status = result != null ? result.ToString() : "Pending";

                Response.Write("{\"status\":\"" + status + "\"}");
                Response.End();
            }
        }
    }
}