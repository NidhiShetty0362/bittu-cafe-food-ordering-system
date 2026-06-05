using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;

namespace cafe
{
    public partial class Login : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["BittuDB"].ConnectionString;

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                string username = txtUsername.Text.Trim();
                string password = txtPassword.Text.Trim();

                // ✅ ADMIN LOGIN
                SqlCommand adminCmd = new SqlCommand(
                "SELECT COUNT(*) FROM Admins WHERE Username=@u AND Password=@p", con);

                adminCmd.Parameters.AddWithValue("@u", username);
                adminCmd.Parameters.AddWithValue("@p", password);

                int adminCount = (int)adminCmd.ExecuteScalar();

                if (adminCount == 1)
                {
                    Session["Admin"] = username;
                    Response.Redirect("AdminDashboard.aspx");
                    return;
                }

                // ✅ USER LOGIN
                SqlCommand userCmd = new SqlCommand(
                "SELECT Email FROM Users WHERE Username=@u AND Password=@p", con);

                userCmd.Parameters.AddWithValue("@u", username);
                userCmd.Parameters.AddWithValue("@p", password);

                object email = userCmd.ExecuteScalar();

                if (email != null && !string.IsNullOrEmpty(email.ToString()))
                {
                    GenerateAndSendOTP(email.ToString(), username);

                    pnlLogin.Visible = false;
                    pnlOTP.Visible = true;
                }
                else
                {
                    lblMessage.Text = "❌ Invalid username or password";
                }
            }
        }

        protected void btnVerify_Click(object sender, EventArgs e)
        {
            if (Session["LoginOTP"] != null &&
                txtOTP.Text == Session["LoginOTP"].ToString())
            {
                Session["User"] = Session["LoginUser"].ToString();
                Response.Redirect("Home.aspx");
            }
            else
            {
                lblMessage.Text = "❌ Invalid OTP";
            }
        }

        // ✅ RESEND OTP BUTTON
        protected void btnResend_Click(object sender, EventArgs e)
        {
            if (Session["LoginUser"] == null) return;

            string username = Session["LoginUser"].ToString();

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                SqlCommand cmd = new SqlCommand(
                    "SELECT Email FROM Users WHERE Username=@u", con);

                cmd.Parameters.AddWithValue("@u", username);

                object email = cmd.ExecuteScalar();

                if (email != null)
                {
                    GenerateAndSendOTP(email.ToString(), username);
                    lblMessage.Text = "✅ OTP Resent!";
                }
            }
        }

        // 🔥 COMMON METHOD
        void GenerateAndSendOTP(string email, string username)
        {
            string otp = new Random().Next(100000, 999999).ToString();

            Session["LoginOTP"] = otp;
            Session["LoginUser"] = username;

            MailMessage msg = new MailMessage();
            msg.To.Add(email);
            msg.From = new MailAddress("bittucafemankoli@gmail.com");
            msg.Subject = "Login OTP";
            msg.Body = "Your OTP is: " + otp;

            SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
            smtp.Credentials = new NetworkCredential(
                "bittucafemankoli@gmail.com",
                "yrumhqnjxunpylgg"
            );

            smtp.EnableSsl = true;
            smtp.Send(msg);
        }
    }
}