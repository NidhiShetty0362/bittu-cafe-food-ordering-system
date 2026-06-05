<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="AdminOrders.aspx.cs"
    Inherits="cafe.AdminOrders" %>

<!DOCTYPE html>
<html>
<head runat="server">
<title>Admin Orders</title>

<style>
body { background:#0d0d0d; color:white; font-family:Segoe UI; }
.main { margin-left:220px; padding:20px; }

.grid { width:100%; border-collapse:collapse; }
.grid th { background:orange; color:black; padding:10px; }
.grid td { background:#111; padding:10px; text-align:center; }

.btn { background:orange; border:none; padding:6px 10px; cursor:pointer; }

.sidebar {
    width:220px; height:100vh;
    position:fixed; background:#111;
}

.sidebar a {
    display:block; color:#ccc;
    padding:10px; text-decoration:none;
}

.sidebar a:hover { background:orange; color:black; }
</style>
</head>

<body>
<form runat="server">

<div class="sidebar">
<h2>☕ Admin</h2>
<a href="AdminDashboard.aspx">Dashboard</a>
<a href="AddCategory.aspx">Categories</a>
<a href="AddMenu.aspx">Menu</a>
<a href="AdminOrders.aspx">Orders</a>
<a href="Users.aspx">Users</a>
<a href="Login.aspx">Logout</a>
</div>

<div class="main">
<h2>📦 Orders</h2>

<asp:GridView ID="gvOrders" runat="server"
AutoGenerateColumns="false"
CssClass="grid"
OnRowCommand="gvOrders_RowCommand"
OnRowDataBound="gvOrders_RowDataBound">

<Columns>

<asp:BoundField DataField="OrderId" HeaderText="Order ID" />
<asp:BoundField DataField="Username" HeaderText="User" />
<asp:BoundField DataField="OrderType" HeaderText="Type" />
<asp:BoundField DataField="TotalAmount" HeaderText="Amount" />
<asp:BoundField DataField="PaymentMode" HeaderText="Payment Mode" />

<asp:TemplateField HeaderText="Status">
<ItemTemplate>
<asp:DropDownList ID="ddlStatus" runat="server"></asp:DropDownList>
</ItemTemplate>
</asp:TemplateField>

<asp:TemplateField HeaderText="ETM (mins)">
<ItemTemplate>
<asp:TextBox ID="txtETM" runat="server" Width="60"></asp:TextBox>
</ItemTemplate>
</asp:TemplateField>

<asp:TemplateField HeaderText="Action">
<ItemTemplate>

<asp:Button ID="btnUpdate" runat="server"
Text="Update"
CssClass="btn"
CommandName="UpdateStatus"
CommandArgument='<%# Eval("OrderId") %>' />

</ItemTemplate>
</asp:TemplateField>

</Columns>
</asp:GridView>

<asp:Label ID="lblMsg" runat="server" ForeColor="Orange" />

</div>
</form>
</body>
</html>