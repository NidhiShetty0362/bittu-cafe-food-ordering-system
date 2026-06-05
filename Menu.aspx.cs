using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace cafe
{
    public partial class Menu : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["BittuDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string category = Request.QueryString["category"];

                if (string.IsNullOrEmpty(category))
                    category = "Chai Chaska";

                lblCategory.Text = category;

                LoadMenu(category);
                UpdateCartBar();
            }
        }

        // LOAD MENU
        void LoadMenu(string category)
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"SELECT m.MenuId, m.ItemName, m.Price, m.ImagePath,
                                ISNULL(c.Qty,0) Qty
                                FROM MenuItems m
                                LEFT JOIN Cart c 
                                ON m.MenuId = c.MenuId AND c.Username = @User
                                WHERE m.Category = @Category";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Category", category);
                cmd.Parameters.AddWithValue("@User", Session["User"] ?? "");

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptMenu.DataSource = dt;
                rptMenu.DataBind();
            }
        }

        // ADD / MINUS
        protected void rptMenu_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (Session["User"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            int menuId = Convert.ToInt32(e.CommandArgument);
            string user = Session["User"].ToString();

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                SqlCommand check = new SqlCommand(
                    "SELECT CartId, Qty FROM Cart WHERE Username=@u AND MenuId=@m", con);

                check.Parameters.AddWithValue("@u", user);
                check.Parameters.AddWithValue("@m", menuId);

                SqlDataReader dr = check.ExecuteReader();

                if (dr.Read())
                {
                    int id = Convert.ToInt32(dr["CartId"]);
                    int qty = Convert.ToInt32(dr["Qty"]);
                    dr.Close();

                    if (e.CommandName == "Add")
                    {
                        SqlCommand cmd = new SqlCommand("UPDATE Cart SET Qty=Qty+1 WHERE CartId=@id", con);
                        cmd.Parameters.AddWithValue("@id", id);
                        cmd.ExecuteNonQuery();
                    }
                    else if (e.CommandName == "Minus")
                    {
                        if (qty <= 1)
                        {
                            SqlCommand cmd = new SqlCommand("DELETE FROM Cart WHERE CartId=@id", con);
                            cmd.Parameters.AddWithValue("@id", id);
                            cmd.ExecuteNonQuery();
                        }
                        else
                        {
                            SqlCommand cmd = new SqlCommand("UPDATE Cart SET Qty=Qty-1 WHERE CartId=@id", con);
                            cmd.Parameters.AddWithValue("@id", id);
                            cmd.ExecuteNonQuery();
                        }
                    }
                }
                else
                {
                    dr.Close();

                    if (e.CommandName == "Add")
                    {
                        SqlCommand cmd = new SqlCommand(
                            "INSERT INTO Cart(Username,MenuId,Qty) VALUES(@u,@m,1)", con);

                        cmd.Parameters.AddWithValue("@u", user);
                        cmd.Parameters.AddWithValue("@m", menuId);

                        cmd.ExecuteNonQuery();
                    }
                }
            }

            LoadMenu(Request.QueryString["category"] ?? "Chai Chaska");
            UpdateCartBar();
        }

        // CART COUNT
        void UpdateCartBar()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                string q = "SELECT SUM(Qty) FROM Cart WHERE Username=@u";

                SqlCommand cmd = new SqlCommand(q, con);
                cmd.Parameters.AddWithValue("@u", Session["User"] ?? "");

                con.Open();
                object result = cmd.ExecuteScalar();

                lblCartCount.Text = (result == DBNull.Value || result == null) ? "0" : result.ToString();
            }
        }
    }
}