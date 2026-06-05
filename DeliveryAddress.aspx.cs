using System;

namespace cafe
{
    public partial class DeliveryAddress : System.Web.UI.Page
    {

        protected void btnContinue_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtAddress.Text) || string.IsNullOrEmpty(hfLat.Value))
            {
                Response.Write("<script>alert('Please select location on map')</script>");
                return;
            }

            Session["Name"] = txtName.Text;
            Session["Phone"] = txtPhone.Text;
            Session["Address"] = txtAddress.Text;
            Session["City"] = txtCity.Text;
            Session["Pincode"] = txtPincode.Text;

            Session["Lat"] = hfLat.Value;
            Session["Lng"] = hfLng.Value;

            Response.Redirect("Payment.aspx");
        }
    }
}