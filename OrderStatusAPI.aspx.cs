using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Script.Serialization;

namespace cafe
{
    public partial class OrderStatusAPI : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Clear();
            Response.ContentType = "application/json";

            int orderId;

            if (!int.TryParse(Request.QueryString["orderId"], out orderId))
            {
                Response.Write("{\"Status\":\"Invalid\",\"ETM\":\"\"}");
                Response.End();
                return;
            }

            string status = "Pending";
            string etm = "";

            string cs = ConfigurationManager.ConnectionStrings["BittuDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT Status, EstimatedTime FROM Orders WHERE OrderId=@id", con);

                cmd.Parameters.AddWithValue("@id", orderId);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    status = dr["Status"].ToString().Trim();
                    etm = dr["EstimatedTime"] == DBNull.Value
                          ? ""
                          : dr["EstimatedTime"].ToString();
                }
            }

            var data = new { Status = status, ETM = etm };

            JavaScriptSerializer js = new JavaScriptSerializer();
            Response.Write(js.Serialize(data));
            Response.End();
        }
    }
}