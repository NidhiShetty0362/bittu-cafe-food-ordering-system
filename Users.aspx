<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="cafe.Users" %>

<!DOCTYPE html>
<html>
<head runat="server">
<title>Users | Admin</title>

<style>

/* GLOBAL */
body {
    margin: 0;
    font-family: 'Segoe UI';
    background: #0d0d0d;
    color: white;
}

/* SIDEBAR */
.sidebar {
    width: 220px;
    height: 100vh;
    background: #111;
    position: fixed;
    padding-top: 20px;
}

.sidebar h2 {
    color: orange;
    text-align: center;
}

.sidebar a {
    display: block;
    padding: 12px 20px;
    color: #ccc;
    text-decoration: none;
}

.sidebar a:hover {
    background: orange;
    color: black;
}

/* MAIN */
.main {
    margin-left: 220px;
    padding: 20px;
}

/* CARD */
.card {
    background: #1a1a1a;
    padding: 20px;
    border-radius: 10px;
}

/* TABLE */
.grid {
    width: 100%;
    border-collapse: collapse;
}

.grid th {
    background: orange;
    color: black;
    padding: 10px;
}

.grid td {
    padding: 10px;
    text-align: center;
    background: #111;
}

/* BUTTON */
.btn-delete {
    background: red;
    color: white !important;
    padding: 6px 12px;
    border-radius: 6px;
    text-decoration: none;
    font-weight: bold;
}

h2 {
    color: orange;
}

</style>

</head>

<body>

<form runat="server">

<!-- SIDEBAR -->
<div class="sidebar">
    <h2>☕ Admin</h2>
    <a href="AdminDashboard.aspx">Dashboard</a>
    <a href="AddCategory.aspx">Categories</a>
    <a href="AddMenu.aspx">Menu</a>
    <a href="AdminOrders.aspx">Orders</a>
    <a href="Users.aspx">Users</a>
    <a href="Login.aspx">Logout</a>
</div>

<!-- MAIN -->
<div class="main">

<div class="card">

<h2>👥 Users List</h2>

<asp:GridView ID="gvUsers" runat="server"
    CssClass="grid"
    AutoGenerateColumns="false"
    DataKeyNames="UserId"
    OnRowDeleting="gvUsers_RowDeleting">

    <Columns>

        <asp:BoundField DataField="UserId" HeaderText="ID" />
        <asp:BoundField DataField="Username" HeaderText="Username" />
        <asp:BoundField DataField="Password" HeaderText="Password" />

        <asp:TemplateField HeaderText="Action">
            <ItemTemplate>
                <asp:LinkButton ID="btnDelete" runat="server"
                    CommandName="Delete"
                    CssClass="btn-delete"
                    Text="Delete"
                    OnClientClick="return confirm('Delete this user?');" />
            </ItemTemplate>
        </asp:TemplateField>

    </Columns>

</asp:GridView>

</div>
    </div>

</form>

</body>
</html>