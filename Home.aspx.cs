using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace cafe
{
    public partial class Home : Page
    {
        string cs = ConfigurationManager.ConnectionStrings["BittuDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Protect page (user must be logged in)
            if (Session["User"] == null)
            {
                Response.Redirect("Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                LoadCategory();
            }
        }

        // Load categories from database
        void LoadCategory(string search = "")
        {
            string cs = ConfigurationManager.ConnectionStrings["BittuDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = "SELECT * FROM Category";

                if (!string.IsNullOrEmpty(search))
                {
                    query += " WHERE CategoryName LIKE @search";
                }

                SqlCommand cmd = new SqlCommand(query, con);

                if (!string.IsNullOrEmpty(search))
                {
                    cmd.Parameters.AddWithValue("@search", "%" + search + "%");
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptCategory.DataSource = dt;
                rptCategory.DataBind();
            }
        }

        protected void OpenMenu(object sender, CommandEventArgs e)
        {
            string category = e.CommandArgument.ToString();

            Response.Redirect("Menu.aspx?category=" + Server.UrlEncode(category));
        }
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadCategory(txtSearch.Text.Trim());
        }
    }
}