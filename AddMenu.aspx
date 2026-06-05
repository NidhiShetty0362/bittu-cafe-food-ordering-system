<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddMenu.aspx.cs" Inherits="cafe.AddMenu" %>

<!DOCTYPE html>
<html>
<head runat="server">
<title>Admin | Menu Management</title>

<style>

/* ===== GLOBAL ===== */
body {
    margin: 0;
    font-family: 'Segoe UI';
    background: #0d0d0d;
    color: white;
}

/* ===== SIDEBAR ===== */
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

/* ===== MAIN ===== */
.main {
    margin-left: 220px;
    padding: 20px;
}

/* ===== CARD ===== */
.card {
    width: 420px;
    margin: 20px auto;
    background: #1a1a1a;
    padding: 25px;
    border-radius: 12px;
    box-shadow: 0 0 20px rgba(255,165,0,0.15);
}

.card h2 {
    text-align: center;
    color: orange;
}

/* ===== INPUT ===== */
input, select {
    width: 100%;
    padding: 12px;
    margin: 10px 0;
    border-radius: 6px;
    border: none;
    background: #2a2a2a;
    color: white;
}

/* ===== BUTTON ===== */
.btn {
    width: 100%;
    padding: 12px;
    background: linear-gradient(45deg, orange, #ff5e00);
    border: none;
    border-radius: 6px;
    font-weight: bold;
    cursor: pointer;
}

/* ===== MESSAGE ===== */
.msg {
    text-align: center;
    margin-top: 10px;
    color: lightgreen;
}

/* ===== TABLE ===== */
.grid {
    width: 95%;
    margin: 30px auto;
    border-collapse: collapse;
}

.grid th {
    background: orange;
    color: black;
    padding: 12px;
}

.grid td {
    background: #111;
    padding: 12px;
    text-align: center;
    border-bottom: 1px solid #333;
}

.grid tr:hover {
    background: #222;
}

/* ===== IMAGE ===== */
.menu-img {
    width: 70px;
    height: 70px;
    border-radius: 8px;
    object-fit: cover;
}

/* ===== ACTION BUTTONS ===== */
.action-btn {
    padding: 6px 12px;
    border-radius: 6px;
    text-decoration: none;
    margin: 2px;
    display: inline-block;
    font-weight: bold;
}

.edit { background: #3498db; color: white; }
.delete { background: #e74c3c; color: white; }
.update { background: #2ecc71; color: white; }
.cancel { background: gray; color: white; }

</style>
</head>

<body>

<form runat="server" enctype="multipart/form-data">

<!-- ✅ SIDEBAR -->
<div class="sidebar">
    <h2>☕ Admin</h2>
    <a href="AdminDashboard.aspx">Dashboard</a>
    <a href="AddCategory.aspx">Categories</a>
    <a href="AddMenu.aspx">Menu</a>
    <a href="AdminOrders.aspx">Orders</a>
    <a href="Users.aspx">Users</a>
    <a href="Login.aspx">Logout</a>
</div>

<!-- ✅ MAIN CONTENT -->
<div class="main">

<!-- ADD MENU -->
<div class="card">

<h2>🍽 Add Menu Item</h2>

<asp:DropDownList ID="ddlCategory" runat="server"></asp:DropDownList>

<asp:TextBox ID="txtName" runat="server" placeholder="Item Name"></asp:TextBox>

<asp:TextBox ID="txtPrice" runat="server" placeholder="Price"></asp:TextBox>

<asp:FileUpload ID="fuImage" runat="server" />

<asp:Button ID="btnSave" runat="server"
Text="Add Menu Item"
CssClass="btn"
OnClick="btnSave_Click" />

<asp:Label ID="lblMsg" runat="server" CssClass="msg"></asp:Label>

</div>

<!-- MENU TABLE -->
<h2 style="text-align:center; color:orange;">📋 Menu Items</h2>

<asp:GridView ID="gvMenu" runat="server"
AutoGenerateColumns="false"
CssClass="grid"
DataKeyNames="MenuId"
OnRowEditing="gvMenu_RowEditing"
OnRowUpdating="gvMenu_RowUpdating"
OnRowCancelingEdit="gvMenu_RowCancelingEdit"
OnRowDeleting="gvMenu_RowDeleting">

<Columns>

<asp:BoundField DataField="MenuId" HeaderText="ID" ReadOnly="true" />

<%-- CATEGORY --%>
<asp:TemplateField HeaderText="Category">
<ItemTemplate><%# Eval("Category") %></ItemTemplate>
<EditItemTemplate>
<asp:TextBox ID="txtEditCategory" runat="server"
Text='<%# Bind("Category") %>' />
</EditItemTemplate>
</asp:TemplateField>

<%-- NAME --%>
<asp:TemplateField HeaderText="Item Name">
<ItemTemplate><%# Eval("ItemName") %></ItemTemplate>
<EditItemTemplate>
<asp:TextBox ID="txtEditName" runat="server"
Text='<%# Bind("ItemName") %>' />
</EditItemTemplate>
</asp:TemplateField>

<%-- PRICE --%>
<asp:TemplateField HeaderText="Price">
<ItemTemplate>₹<%# Eval("Price") %></ItemTemplate>
<EditItemTemplate>
<asp:TextBox ID="txtEditPrice" runat="server"
Text='<%# Bind("Price") %>' />
</EditItemTemplate>
</asp:TemplateField>

<%-- IMAGE --%>
<asp:TemplateField HeaderText="Image">
<ItemTemplate>
<img src='<%# Eval("ImagePath") %>' class="menu-img" />
</ItemTemplate>
<EditItemTemplate>
<asp:FileUpload ID="fuEditImage" runat="server" />
<br />
<img src='<%# Eval("ImagePath") %>' width="50" />
</EditItemTemplate>
</asp:TemplateField>

<%-- ACTION --%>
<asp:TemplateField HeaderText="Action">

<ItemTemplate>
<asp:LinkButton runat="server" CommandName="Edit"
Text="Edit" CssClass="action-btn edit" />

<asp:LinkButton runat="server" CommandName="Delete"
Text="Delete" CssClass="action-btn delete"
OnClientClick="return confirm('Delete this item?');" />
</ItemTemplate>

<EditItemTemplate>
<asp:LinkButton runat="server" CommandName="Update"
Text="Update" CssClass="action-btn update"
CausesValidation="false" />

<asp:LinkButton runat="server" CommandName="Cancel"
Text="Cancel" CssClass="action-btn cancel"
CausesValidation="false" />
</EditItemTemplate>

</asp:TemplateField>

</Columns>

</asp:GridView>

</div>

</form>

</body>
</html>