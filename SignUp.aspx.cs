using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;
using System.Web.UI;

namespace cafe
{
    public partial class SignUp : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["BittuDB"].ConnectionString;

        protected void btnSendOTP_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string otp = new Random().Next(100000, 999999).ToString();

            Session["SignupOTP"] = otp;
            Session["SignupEmail"] = email;

            SendOTP(email, otp);

            pnlEmail.Visible = false;
            pnlOTP.Visible = true;

            // ✅ 1 MIN TIMER
            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                "timer",
                "timeLeft=60;startTimer();",
                true
            );
        }

        protected void btnVerifyOTP_Click(object sender, EventArgs e)
        {
            if (Session["SignupOTP"] != null &&
                txtOTP.Text == Session["SignupOTP"].ToString())
            {
                pnlOTP.Visible = false;
                pnlUser.Visible = true;
            }
            else
            {
                lblMsg.Text = "❌ Invalid OTP";
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (txtPassword.Text != txtConfirm.Text)
            {
                lblMsg.Text = "❌ Passwords do not match";
                return;
            }

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                SqlCommand cmd = new SqlCommand(
                    "INSERT INTO Users(Username,Password,Email) VALUES(@u,@p,@e)", con);

                cmd.Parameters.AddWithValue("@u", txtUsername.Text);
                cmd.Parameters.AddWithValue("@p", txtPassword.Text);
                cmd.Parameters.AddWithValue("@e", Session["SignupEmail"]);

                cmd.ExecuteNonQuery();
            }

            // ✅ FIX: SET SESSION
            Session["User"] = txtUsername.Text;

            // ✅ NOW GO TO HOME
            Response.Redirect("Home.aspx");
        }

        protected void btnResend_Click(object sender, EventArgs e)
        {
            string email = Session["SignupEmail"].ToString();

            string otp = new Random().Next(100000, 999999).ToString();

            // ✅ STORE NEW OTP IN SESSION
            Session["SignupOTP"] = otp;

            SendOTP(email, otp);

            lblMsg.Text = "✅ OTP resent successfully";

            // ✅ 1 MIN TIMER RESET
            ScriptManager.RegisterStartupScript(
                this,
                GetType(),
                "timer",
                "timeLeft=60;startTimer();",
                true
            );
        }

        void SendOTP(string email, string otp)
        {
            MailMessage msg = new MailMessage();
            msg.To.Add(email);
            msg.From = new MailAddress("bittucafemankoli@gmail.com");
            msg.Subject = "OTP Verification";
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