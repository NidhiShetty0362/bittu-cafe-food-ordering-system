using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI.WebControls;

namespace cafe
{
    public partial class AddMenu : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["BittuDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategories();
                LoadMenu();
            }
        }

        // 🔹 LOAD CATEGORY DROPDOWN
        void LoadCategories()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT CategoryName FROM Category", con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlCategory.DataSource = dt;
                ddlCategory.DataTextField = "CategoryName";
                ddlCategory.DataValueField = "CategoryName";
                ddlCategory.DataBind();

                ddlCategory.Items.Insert(0, new ListItem("-- Select Category --", ""));
            }
        }

        // 🔹 ADD MENU ITEM
        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (ddlCategory.SelectedValue == "" || txtName.Text == "" || txtPrice.Text == "")
            {
                lblMsg.Text = "Please fill all fields ❗";
                return;
            }

            string imagePath = "";

            if (fuImage.HasFile)
            {
                string folder = Server.MapPath("~/MenuImages/");
                if (!Directory.Exists(folder))
                    Directory.CreateDirectory(folder);

                string fileName = Guid.NewGuid().ToString() + Path.GetExtension(fuImage.FileName);
                fuImage.SaveAs(folder + fileName);
                imagePath = "MenuImages/" + fileName;
            }

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(@"
                INSERT INTO MenuItems(Category, ItemName, Price, ImagePath)
                VALUES(@cat, @name, @price, @img)", con);

                cmd.Parameters.AddWithValue("@cat", ddlCategory.SelectedValue);
                cmd.Parameters.AddWithValue("@name", txtName.Text);
                cmd.Parameters.AddWithValue("@price", Convert.ToDecimal(txtPrice.Text));
                cmd.Parameters.AddWithValue("@img", imagePath);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            lblMsg.Text = "Menu item added ✅";

            txtName.Text = "";
            txtPrice.Text = "";
            ddlCategory.SelectedIndex = 0;

            LoadMenu();
        }

        // 🔹 LOAD MENU
        void LoadMenu()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM MenuItems", con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvMenu.DataSource = dt;
                gvMenu.DataBind();
            }
        }

        // 🔹 EDIT MODE
        protected void gvMenu_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvMenu.EditIndex = e.NewEditIndex;
            LoadMenu();
        }

        // 🔹 CANCEL EDIT
        protected void gvMenu_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvMenu.EditIndex = -1;
            LoadMenu();
        }

        // 🔹 UPDATE MENU
        protected void gvMenu_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int id = Convert.ToInt32(gvMenu.DataKeys[e.RowIndex].Value);
            GridViewRow row = gvMenu.Rows[e.RowIndex];

            string category = ((TextBox)row.FindControl("txtEditCategory")).Text;
            string name = ((TextBox)row.FindControl("txtEditName")).Text;
            string priceText = ((TextBox)row.FindControl("txtEditPrice")).Text;

            decimal price = 0;
            decimal.TryParse(priceText, out price);

            FileUpload fu = (FileUpload)row.FindControl("fuEditImage");

            string imagePath = "";

            if (fu != null && fu.HasFile)
            {
                string folder = Server.MapPath("~/MenuImages/");
                if (!Directory.Exists(folder))
                    Directory.CreateDirectory(folder);

                string fileName = Guid.NewGuid().ToString() + Path.GetExtension(fu.FileName);
                fu.SaveAs(folder + fileName);
                imagePath = "MenuImages/" + fileName;
            }

            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = imagePath != ""
                    ? @"UPDATE MenuItems 
                        SET Category=@cat, ItemName=@name, Price=@price, ImagePath=@img 
                        WHERE MenuId=@id"
                    : @"UPDATE MenuItems 
                        SET Category=@cat, ItemName=@name, Price=@price 
                        WHERE MenuId=@id";

                SqlCommand cmd = new SqlCommand(query, con);

                cmd.Parameters.AddWithValue("@cat", category);
                cmd.Parameters.AddWithValue("@name", name);
                cmd.Parameters.AddWithValue("@price", price);
                cmd.Parameters.AddWithValue("@id", id);

                if (imagePath != "")
                    cmd.Parameters.AddWithValue("@img", imagePath);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            gvMenu.EditIndex = -1;
            LoadMenu();

            lblMsg.Text = "Menu updated ✅";
        }

        // 🔹 DELETE MENU
        protected void gvMenu_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int id = Convert.ToInt32(gvMenu.DataKeys[e.RowIndex].Value);

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("DELETE FROM MenuItems WHERE MenuId=@id", con);
                cmd.Parameters.AddWithValue("@id", id);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            LoadMenu();
            lblMsg.Text = "Menu deleted 🗑️";
        }
    }
}