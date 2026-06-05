using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;

namespace cafe
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["BittuDB"].ConnectionString;

        protected void btnSendOTP_Click(object sender, EventArgs e)
        {
            lblMsg.Text = "";

            string user = txtUser.Text.Trim();

            if (string.IsNullOrEmpty(user))
            {
                lblMsg.Text = "⚠️ Enter username";
                return;
            }

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                SqlCommand cmd = new SqlCommand(
                "SELECT Email FROM Users WHERE Username=@u", con);

                cmd.Parameters.AddWithValue("@u", user);

                object emailObj = cmd.ExecuteScalar();

                if (emailObj != null)
                {
                    string email = emailObj.ToString();

                    // 🔐 Generate OTP
                    string otp = new Random().Next(100000, 999999).ToString();

                    SqlCommand update = new SqlCommand(
                    "UPDATE Users SET OTP=@o, OTPExpiry=DATEADD(MINUTE,5,GETDATE()) WHERE Username=@u", con);

                    update.Parameters.AddWithValue("@o", otp);
                    update.Parameters.AddWithValue("@u", user);
                    update.ExecuteNonQuery();

                    // 📧 Send OTP
                    SendOTP(email, otp);

                    Session["ResetUser"] = user;

                    Response.Redirect("ResetPassword.aspx");
                }
                else
                {
                    lblMsg.Text = "❌ Username not found";
                }
            }
        }

        // 📧 EMAIL OTP FUNCTION
        void SendOTP(string email, string otp)
        {
            try
            {
                MailMessage msg = new MailMessage();
                msg.To.Add(email);
                msg.From = new MailAddress("bittucafemankoli@gmail.com"); // 🔴 change
                msg.Subject = "Bittu Cafe OTP";
                msg.Body = "Your OTP is: " + otp;

                SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
                smtp.Credentials = new NetworkCredential("bittucafemankoli@gmail.com", "yrumhqnjxunpylgg"); // 🔴 change
                smtp.EnableSsl = true;

                smtp.Send(msg);
            }
            catch
            {
                // fallback for testing
                System.Diagnostics.Debug.WriteLine("OTP: " + otp);
            }
        }
    }
}