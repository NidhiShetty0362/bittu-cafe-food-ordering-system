<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddCategory.aspx.cs" Inherits="cafe.AddCategory" %>

<!DOCTYPE html>
<html>
<head runat="server">
<title>Admin - Categories</title>

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
input {
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

/* ===== IMAGE (FIXED SIZE SAME AS MENU) ===== */
.category-img {
    width: 70px;
    height: 70px;
    object-fit: cover;
    border-radius: 8px;
}

/* ===== ACTION BUTTONS (SAME AS MENU) ===== */
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

<!-- ADD CATEGORY -->
<div class="card">
    <h2>Add Category</h2>

    <asp:TextBox ID="txtCategory" runat="server" placeholder="Category Name"></asp:TextBox>

    <asp:FileUpload ID="fuImage" runat="server" />

    <asp:Button ID="btnSave" runat="server"
        Text="Add Category"
        CssClass="btn"
        OnClick="btnSave_Click" />

    <asp:Label ID="lblMsg" runat="server" CssClass="msg"></asp:Label>
</div>

<!-- CATEGORY TABLE -->
<h2 style="text-align:center; color:orange;">📂 Category List</h2>

<asp:GridView ID="gvCategory" runat="server"
    AutoGenerateColumns="false"
    CssClass="grid"
    DataKeyNames="CategoryId"
    OnRowEditing="gvCategory_RowEditing"
    OnRowCancelingEdit="gvCategory_RowCancelingEdit"
    OnRowUpdating="gvCategory_RowUpdating"
    OnRowDeleting="gvCategory_RowDeleting">

<Columns>

<asp:BoundField DataField="CategoryId" HeaderText="ID" ReadOnly="true" />

<%-- NAME --%>
<asp:TemplateField HeaderText="Category Name">
<ItemTemplate>
<%# Eval("CategoryName") %>
</ItemTemplate>
<EditItemTemplate>
<asp:TextBox ID="txtEditName" runat="server"
Text='<%# Bind("CategoryName") %>' />
</EditItemTemplate>
</asp:TemplateField>

<%-- IMAGE --%>
<asp:TemplateField HeaderText="Image">
<ItemTemplate>
<img src='<%# Eval("CategoryImage") %>' class="category-img" />
</ItemTemplate>
<EditItemTemplate>
<asp:FileUpload ID="fuEditImage" runat="server" />
<br />
<img src='<%# Eval("CategoryImage") %>' class="category-img" />
</EditItemTemplate>
</asp:TemplateField>

<%-- ACTION --%>
<asp:TemplateField HeaderText="Action">

<ItemTemplate>
<asp:LinkButton runat="server" CommandName="Edit"
Text="Edit" CssClass="action-btn edit" />

<asp:LinkButton runat="server" CommandName="Delete"
Text="Delete" CssClass="action-btn delete"
OnClientClick="return confirm('Delete this category?');" />
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