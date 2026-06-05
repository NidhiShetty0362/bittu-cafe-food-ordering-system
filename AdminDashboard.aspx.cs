using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Text;

namespace cafe
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        string cs = ConfigurationManager.ConnectionStrings["BittuDB"].ConnectionString;

        public string revenueLabels = "[]";
        public string revenueData = "[]";
        public string pieLabels = "[]";
        public string pieData = "[]";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCounts();
                LoadRevenueChart("month"); // default
                LoadPieChart();
            }
        }
        [System.Web.Services.WebMethod]
        public static int GetNewOrders()
        {
            string cs = ConfigurationManager.ConnectionStrings["BittuDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT COUNT(*) FROM Orders WHERE Status='Pending'", con);

                con.Open();
                return (int)cmd.ExecuteScalar();
            }
        }

        [System.Web.Services.WebMethod]
        public static object GetLatestOrder()
        {
            string cs = ConfigurationManager.ConnectionStrings["BittuDB"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(@"
            SELECT TOP 1 Username, TotalAmount, OrderType 
            FROM Orders 
            ORDER BY OrderId DESC", con);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    return new
                    {
                        Username = dr["Username"].ToString(),
                        TotalAmount = dr["TotalAmount"].ToString(),
                        OrderType = dr["OrderType"].ToString()
                    };
                }
            }

            return null;
        }
        protected void ddlFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadRevenueChart(ddlFilter.SelectedValue);
        }


        void LoadCounts()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                lblUsers.Text = GetCount(con, "Users").ToString();
                lblOrders.Text = GetCount(con, "Orders").ToString();
                lblMenu.Text = GetCount(con, "MenuItems").ToString();
                lblCategory.Text = GetCount(con, "Category").ToString();
            }
        }

        int GetCount(SqlConnection con, string table)
        {
            SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM " + table, con);
            return (int)cmd.ExecuteScalar();
        }

        void LoadRevenueChart(string filter = "month")
        {
            string groupBy = "";
            string where = "";

            if (filter == "week")
            {
                groupBy = "DATENAME(WEEKDAY, OrderDate)";
                where = "WHERE OrderDate >= DATEADD(DAY,-7,GETDATE())";
            }
            else if (filter == "month")
            {
                groupBy = "FORMAT(OrderDate,'dd')";
                where = "WHERE MONTH(OrderDate)=MONTH(GETDATE())";
            }
            else if (filter == "year")
            {
                groupBy = "FORMAT(OrderDate,'MMM')";
                where = "WHERE YEAR(OrderDate)=YEAR(GETDATE())";
            }

            StringBuilder labels = new StringBuilder("[");
            StringBuilder data = new StringBuilder("[");

            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = $@"
        SELECT {groupBy} AS X, SUM(TotalAmount) AS Total 
        FROM Orders
        {where}
        GROUP BY {groupBy}";

                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();

                SqlDataReader dr = cmd.ExecuteReader();

                while (dr.Read())
                {
                    labels.Append("'" + dr["X"] + "',");
                    data.Append(dr["Total"] + ",");
                }
            }

            labels.Append("]");
            data.Append("]");

            revenueLabels = labels.ToString();
            revenueData = data.ToString();
        }

        void LoadPieChart()
        {
            StringBuilder labels = new StringBuilder("[");
            StringBuilder data = new StringBuilder("[");

            using (SqlConnection con = new SqlConnection(cs))
            {
                SqlCommand cmd = new SqlCommand(
                    "SELECT ItemName, SUM(Quantity) AS Qty FROM OrderItems GROUP BY ItemName",
                    con);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                while (dr.Read())
                {
                    labels.Append("'" + dr["ItemName"] + "',");
                    data.Append(dr["Qty"] + ",");
                }
            }

            labels.Append("]");
            data.Append("]");

            pieLabels = labels.ToString();
            pieData = data.ToString();
        }
    }
}