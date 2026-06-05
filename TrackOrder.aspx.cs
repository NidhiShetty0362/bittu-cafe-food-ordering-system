using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.Script.Services;

namespace cafe
{
    public partial class TrackOrder : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json, UseHttpGet = true)]
        public static object GetStatus(int orderId)
        {
            string status = "Pending";
            string etm = "";

            try
            {
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
            }
            catch (Exception ex)
            {
                status = "Error";
                etm = ex.Message;
            }

            return new { Status = status, ETM = etm };
        }
    }
}