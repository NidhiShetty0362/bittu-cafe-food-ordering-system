using System;
using System.Configuration;
using System.Data.SqlClient;

namespace cafe
{
    public partial class UserProfile : System.Web.UI.Page
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
                LoadUser();
                LoadStats();
            }
        }

        void LoadUser()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(
                "SELECT Username, Email, CreatedDate FROM Users WHERE Username=@u", con);

                cmd.Parameters.AddWithValue("@u", Session["User"].ToString());

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    lblUsername.Text = dr["Username"].ToString();
                    lblEmail.Text = dr["Email"].ToString();

                    if (dr["CreatedDate"] != DBNull.Value)
                        lblDate.Text = Convert.ToDateTime(dr["CreatedDate"]).ToString("dd MMM yyyy");
                    else
                        lblDate.Text = "N/A";
                }
            }
        }

        void LoadStats()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                SqlCommand cmd = new SqlCommand(@"
            SELECT 
                COUNT(*) AS TotalOrders,
                ISNULL(SUM(TotalAmount),0) AS TotalSpent
            FROM Orders
            WHERE Username=@u", con);

                cmd.Parameters.AddWithValue("@u", Session["User"].ToString());

                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    lblOrders.Text = dr["TotalOrders"].ToString();
                    lblSpent.Text = Convert.ToDecimal(dr["TotalSpent"]).ToString("0.00");
                }
            }
        }

        protected void btnChange_Click(object sender, EventArgs e)
        {
            if (txtNew.Text != txtConfirm.Text)
            {
                lblMsg.Text = "❌ Passwords do not match";
                return;
            }

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // check old password
                SqlCommand check = new SqlCommand(
                "SELECT COUNT(*) FROM Users WHERE Username=@u AND Password=@p", con);

                check.Parameters.AddWithValue("@u", Session["User"].ToString());
                check.Parameters.AddWithValue("@p", txtOld.Text);

                int valid = (int)check.ExecuteScalar();

                if (valid == 0)
                {
                    lblMsg.Text = "❌ Old password incorrect";
                    return;
                }

                // update password
                SqlCommand cmd = new SqlCommand(
                "UPDATE Users SET Password=@p WHERE Username=@u", con);

                cmd.Parameters.AddWithValue("@p", txtNew.Text);
                cmd.Parameters.AddWithValue("@u", Session["User"].ToString());

                cmd.ExecuteNonQuery();
            }

            lblMsg.ForeColor = System.Drawing.Color.LightGreen;
            lblMsg.Text = "✅ Password updated successfully";
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}