using System;
using System.Configuration;
using System.Data.SqlClient;

namespace cafe
{
    public partial class UpdateLocation : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Request.QueryString["orderId"] != null)
                txtOrderId.Text = Request.QueryString["orderId"];
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            string cs = ConfigurationManager.ConnectionStrings["BittuDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(
                    "UPDATE Orders SET RiderLat=@lat, RiderLng=@lng WHERE OrderId=@id", con);

                cmd.Parameters.AddWithValue("@lat", txtLat.Text);
                cmd.Parameters.AddWithValue("@lng", txtLng.Text);
                cmd.Parameters.AddWithValue("@id", txtOrderId.Text);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            Response.Redirect("AdminOrders.aspx");
        }
    }
}