using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI.WebControls;

namespace cafe
{
    public partial class AddCategory : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["BittuDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategory();
            }
        }

        void LoadCategory()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Category", con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvCategory.DataSource = dt;
                gvCategory.DataBind();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string imagePath = "";

            if (fuImage.HasFile)
            {
                string folder = Server.MapPath("~/CategoryImages/");

                if (!Directory.Exists(folder))
                    Directory.CreateDirectory(folder);

                string fileName = Guid.NewGuid().ToString() + Path.GetExtension(fuImage.FileName);

                fuImage.SaveAs(folder + fileName);

                imagePath = "CategoryImages/" + fileName;
            }

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(
                    "INSERT INTO Category(CategoryName, CategoryImage) VALUES(@name,@img)", con);

                cmd.Parameters.AddWithValue("@name", txtCategory.Text.Trim());
                cmd.Parameters.AddWithValue("@img", imagePath);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            txtCategory.Text = "";
            lblMsg.Text = "✅ Category Added Successfully";

            LoadCategory();
        }

        protected void gvCategory_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvCategory.EditIndex = e.NewEditIndex;
            LoadCategory();
        }

        protected void gvCategory_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvCategory.EditIndex = -1;
            LoadCategory();
        }

        protected void gvCategory_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int id = Convert.ToInt32(gvCategory.DataKeys[e.RowIndex].Value);

            GridViewRow row = gvCategory.Rows[e.RowIndex];

            TextBox txtName = row.FindControl("txtEditName") as TextBox;
            FileUpload fu = row.FindControl("fuEditImage") as FileUpload;

            if (txtName == null)
            {
                lblMsg.Text = "❌ Error: TextBox not found";
                return;
            }

            string name = txtName.Text.Trim();
            string imagePath = "";

            if (fu != null && fu.HasFile)
            {
                string folder = Server.MapPath("~/CategoryImages/");
                if (!Directory.Exists(folder))
                    Directory.CreateDirectory(folder);

                string fileName = Guid.NewGuid().ToString() + Path.GetExtension(fu.FileName);
                fu.SaveAs(folder + fileName);

                imagePath = "CategoryImages/" + fileName;
            }

            using (SqlConnection con = new SqlConnection(cs))
            {
                string query;

                if (!string.IsNullOrEmpty(imagePath))
                {
                    query = @"UPDATE Category 
                      SET CategoryName=@name, CategoryImage=@img 
                      WHERE CategoryId=@id";
                }
                else
                {
                    query = @"UPDATE Category 
                      SET CategoryName=@name 
                      WHERE CategoryId=@id";
                }

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@name", name);
                cmd.Parameters.AddWithValue("@id", id);

                if (!string.IsNullOrEmpty(imagePath))
                    cmd.Parameters.AddWithValue("@img", imagePath);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            gvCategory.EditIndex = -1;
            LoadCategory();

            lblMsg.Text = "✅ Category Updated Successfully";
        }

        protected void gvCategory_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int id = Convert.ToInt32(gvCategory.DataKeys[e.RowIndex].Value);

            string imagePath = "";

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                SqlCommand getCmd = new SqlCommand(
                    "SELECT CategoryImage FROM Category WHERE CategoryId=@id", con);

                getCmd.Parameters.AddWithValue("@id", id);

                object result = getCmd.ExecuteScalar();
                if (result != null)
                    imagePath = result.ToString();

                SqlCommand delCmd = new SqlCommand(
                    "DELETE FROM Category WHERE CategoryId=@id", con);

                delCmd.Parameters.AddWithValue("@id", id);
                delCmd.ExecuteNonQuery();
            }

            if (!string.IsNullOrEmpty(imagePath))
            {
                string fullPath = Server.MapPath("~/" + imagePath);
                if (File.Exists(fullPath))
                    File.Delete(fullPath);
            }

            LoadCategory();
            lblMsg.Text = "🗑️ Category Deleted Successfully";
        }
    }
}