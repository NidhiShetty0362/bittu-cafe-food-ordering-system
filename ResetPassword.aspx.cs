using System;
using System.Configuration;
using System.Data.SqlClient;

namespace cafe
{
    public partial class ResetPassword : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["BittuDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 🚫 Block direct access
            if (Session["ResetUser"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }
        }

        // 🔁 RESET PASSWORD
        protected void btnReset_Click(object sender, EventArgs e)
        {
            lblMsg.Text = "";

            if (Session["ResetUser"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            string user = Session["ResetUser"].ToString();
            string otp = txtOTP.Text.Trim();
            string newPass = txtNew.Text.Trim();
            string confirmPass = txtConfirm.Text.Trim();

            // ✅ VALIDATION
            if (string.IsNullOrEmpty(otp) ||
                string.IsNullOrEmpty(newPass) ||
                string.IsNullOrEmpty(confirmPass))
            {
                lblMsg.Text = "⚠️ All fields are required";
                return;
            }

            if (newPass.Length < 4)
            {
                lblMsg.Text = "⚠️ Password must be at least 4 characters";
                return;
            }

            if (newPass != confirmPass)
            {
                lblMsg.Text = "❌ Passwords do not match";
                return;
            }

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // 🔍 VERIFY OTP
                SqlCommand check = new SqlCommand(@"
                    SELECT COUNT(*) FROM Users 
                    WHERE Username=@u 
                    AND OTP=@o 
                    AND OTPExpiry > GETDATE()", con);

                check.Parameters.AddWithValue("@u", user);
                check.Parameters.AddWithValue("@o", otp);

                int valid = (int)check.ExecuteScalar();

                if (valid == 0)
                {
                    lblMsg.Text = "❌ Invalid or expired OTP";
                    return;
                }

                // 🔐 UPDATE PASSWORD
                SqlCommand cmd = new SqlCommand(@"
                    UPDATE Users 
                    SET Password=@p,
                        OTP=NULL,
                        OTPExpiry=NULL
                    WHERE Username=@u", con);

                cmd.Parameters.AddWithValue("@p", newPass);
                cmd.Parameters.AddWithValue("@u", user);

                cmd.ExecuteNonQuery();
            }

            // 🧹 CLEAR SESSION
            Session["ResetUser"] = null;

            // 🔥 AUTO LOGIN
            Session["User"] = user;

            // 🚀 REDIRECT
            Response.Redirect("Home.aspx");
        }

        // 🔁 RESEND OTP
        protected void btnResend_Click(object sender, EventArgs e)
        {
            if (Session["ResetUser"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            string user = Session["ResetUser"].ToString();

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // 📧 GET EMAIL
                SqlCommand cmd = new SqlCommand(
                    "SELECT Email FROM Users WHERE Username=@u", con);

                cmd.Parameters.AddWithValue("@u", user);

                object emailObj = cmd.ExecuteScalar();

                if (emailObj != null)
                {
                    string otp = new Random().Next(100000, 999999).ToString();

                    // 🔄 UPDATE OTP
                    SqlCommand update = new SqlCommand(@"
                        UPDATE Users 
                        SET OTP=@o,
                            OTPExpiry=DATEADD(MINUTE,5,GETDATE()) 
                        WHERE Username=@u", con);

                    update.Parameters.AddWithValue("@o", otp);
                    update.Parameters.AddWithValue("@u", user);
                    update.ExecuteNonQuery();

                    // 📩 SEND EMAIL
                    SendOTP(emailObj.ToString(), otp);

                    lblMsg.Text = "✅ New OTP sent to your email";
                }
                else
                {
                    lblMsg.Text = "❌ Email not found";
                }
            }
        }

        // 📩 EMAIL FUNCTION
        void SendOTP(string email, string otp)
        {
            try
            {
                System.Net.Mail.MailMessage msg = new System.Net.Mail.MailMessage();
                msg.To.Add(email);
                msg.From = new System.Net.Mail.MailAddress("bittucafemankoli@gmail.com");
                msg.Subject = "Bittu Cafe - OTP Reset Password";
                msg.Body = "Your OTP is: " + otp;

                System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient("smtp.gmail.com", 587);
                smtp.Credentials = new System.Net.NetworkCredential(
                    "bittucafemankoli@gmail.com",
                    "yrumhqnjxunpylgg");

                smtp.EnableSsl = true;
                smtp.Send(msg);
            }
            catch (Exception ex)
            {
                lblMsg.Text = "❌ Email sending failed: " + ex.Message;
            }
        }
    }
}