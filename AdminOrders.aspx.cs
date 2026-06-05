using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace cafe
{
    public partial class AdminOrders : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["BittuDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadOrders();
            }
        }

        void LoadOrders()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Orders ORDER BY OrderId DESC", con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvOrders.DataSource = dt;
                gvOrders.DataBind();
            }
        }

        protected void gvOrders_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string orderType = DataBinder.Eval(e.Row.DataItem, "OrderType").ToString();
                string status = DataBinder.Eval(e.Row.DataItem, "Status").ToString();
                string etm = DataBinder.Eval(e.Row.DataItem, "EstimatedTime")?.ToString();

                DropDownList ddl = (DropDownList)e.Row.FindControl("ddlStatus");
                TextBox txtETM = (TextBox)e.Row.FindControl("txtETM");

                ddl.Items.Clear();

                if (orderType == "Delivery")
                {
                    ddl.Items.Add("Pending");
                    ddl.Items.Add("Preparing");
                    ddl.Items.Add("Out for Delivery");
                    ddl.Items.Add("Delivered");

                    txtETM.Visible = true;
                    txtETM.Text = etm;
                }
                else
                {
                    ddl.Items.Add("Pending");
                    ddl.Items.Add("Preparing");
                    ddl.Items.Add("Completed");

                    txtETM.Visible = false;
                }

                ddl.SelectedValue = status;
            }
        }

        protected void gvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "UpdateStatus")
            {
                int orderId = Convert.ToInt32(e.CommandArgument);

                GridViewRow row = (GridViewRow)((Control)e.CommandSource).NamingContainer;

                DropDownList ddl = (DropDownList)row.FindControl("ddlStatus");
                TextBox txtETM = (TextBox)row.FindControl("txtETM");

                string status = ddl.SelectedValue;
                string etm = txtETM.Text;

                using (SqlConnection con = new SqlConnection(cs))
                {
                    SqlCommand cmd = new SqlCommand(@"
                UPDATE Orders 
                SET Status=@s, EstimatedTime=@etm 
                WHERE OrderId=@id", con);

                    // ✅ 🔥 PUT IT HERE
                    cmd.Parameters.AddWithValue("@s", status.Trim());

                    cmd.Parameters.AddWithValue("@etm",
                        string.IsNullOrEmpty(etm)
                        ? (object)DBNull.Value
                        : etm.Trim());

                    cmd.Parameters.AddWithValue("@id", orderId);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                lblMsg.Text = "✅ Status + ETM Updated!";
                LoadOrders();
            }
        }
    }
}