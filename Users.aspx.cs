using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace cafe
{
    public partial class Users : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 🔐 Admin session check
            if (Session["Admin"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUsers();
            }
        }

        void LoadUsers()
        {
            string cs = ConfigurationManager.ConnectionStrings["BittuDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                // ✅ Select only required columns (BEST PRACTICE)
                SqlDataAdapter da = new SqlDataAdapter(
                    "SELECT UserId, Username, Password FROM Users", con);

                DataTable dt = new DataTable();
                da.Fill(dt);

                gvUsers.DataSource = dt;
                gvUsers.DataBind();
            }
        }

        // 🗑 DELETE USER
        protected void gvUsers_RowDeleting(object sender, System.Web.UI.WebControls.GridViewDeleteEventArgs e)
        {
            int id = Convert.ToInt32(gvUsers.DataKeys[e.RowIndex].Value);

            string cs = ConfigurationManager.ConnectionStrings["BittuDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand("DELETE FROM Users WHERE UserId=@id", con);
                cmd.Parameters.AddWithValue("@id", id);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            LoadUsers(); // refresh grid
        }
    }
}