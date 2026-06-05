using System;

namespace cafe
{
    public partial class PaymentCallback : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string success = Request.QueryString["success"];

            Payment p = new Payment();

            if (success == "1")
            {
                p.GetType().GetMethod("SaveOrder",
                    System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Instance)
                    .Invoke(p, new object[] { "Online", "Preparing" });
            }
            else
            {
                p.GetType().GetMethod("SaveOrder",
                    System.Reflection.BindingFlags.NonPublic | System.Reflection.BindingFlags.Instance)
                    .Invoke(p, new object[] { "Online", "Failed" });
            }

            Response.Redirect("MyOrders.aspx");
        }
    }
}