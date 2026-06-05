using System;
using System.Configuration;
using System.Data.SqlClient;

namespace cafe
{
    public partial class VerifyOTP : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["BittuDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 🔐 Safety check
            if (Session["TempUser"] == null)
            {
                Response.Redirect("Login.aspx");
            }
        }

        protected void btnVerify_Click(object sender, EventArgs e)
        {
            lblMsg.Text = "";

            string user = Session["TempUser"].ToString();
            string otp = txtOTP.Text.Trim();

            if (string.IsNullOrEmpty(otp))
            {
                lblMsg.Text = "⚠️ Please enter OTP";
                return;
            }

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                SqlCommand cmd = new SqlCommand(@"
                    SELECT COUNT(*) 
                    FROM Users 
                    WHERE Username=@u 
                    AND OTP=@o 
                    AND OTPExpiry > GETDATE()", con);

                cmd.Parameters.AddWithValue("@u", user);
                cmd.Parameters.AddWithValue("@o", otp);

                int count = (int)cmd.ExecuteScalar();

                if (count > 0)
                {
                    // ✅ OTP correct → Login user
                    Session["User"] = user;

                    // 🔥 Clear temp session
                    Session["TempUser"] = null;

                    Response.Redirect("Home.aspx");
                }
                else
                {
                    lblMsg.Text = "❌ Invalid or Expired OTP";
                }
            }
        }
    }
}