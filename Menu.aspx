<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Menu.aspx.cs" Inherits="cafe.Menu" %>

<!DOCTYPE html>
<html>
<head runat="server">
<title>Bittu Cafe | Menu</title>

<style>
body{
    margin:0;
    background:#000;
    color:#fff;
    font-family:'Segoe UI';
}

/* HEADER */
.header{
    padding:18px;
    background:linear-gradient(90deg,#111,#000);
    text-align:center;
    font-size:24px;
    color:orange;
    font-weight:bold;
}

/* GRID */
.menu-list{
    display:grid;
    grid-template-columns:repeat(auto-fill,minmax(260px,1fr));
    gap:18px;
    padding:18px;
    padding-bottom:90px;
}

/* CARD */
.food-card{
    background:#111;
    border-radius:16px;
    overflow:hidden;
    position:relative;
    transition:0.3s;
}

.food-card:hover{
    transform:translateY(-5px);
    box-shadow:0 0 20px rgba(255,165,0,0.25);
}

/* IMAGE */
.food-img{
    width:100%;
    height:230px;
    object-fit:cover;
}

/* INFO */
.food-info{
    padding:12px;
}

.food-name{
    font-size:18px;
    font-weight:600;
}

.food-price{
    color:orange;
    font-weight:bold;
}

/* ADD BUTTON */
.add-btn{
    position:absolute;
    bottom:10px;
    right:10px;
    background:orange;
    color:#000;
    border:none;
    padding:6px 14px;
    border-radius:10px;
    font-weight:bold;
    cursor:pointer;
}

/* QTY BOX */
.qty-box{
    position:absolute;
    bottom:10px;
    right:10px;
    display:flex;
    align-items:center;
    background:#000;
    border:1px solid orange;
    border-radius:10px;
}

.qty-btn{
    background:none;
    border:none;
    color:orange;
    padding:6px 10px;
    font-size:18px;
    cursor:pointer;
}

/* FLOAT CART */
.cart-bar{
    position:fixed;
    bottom:0;
    width:100%;
    background:#111;
    border-top:2px solid orange;
    padding:12px 20px;
    display:flex;
    justify-content:space-between;
    align-items:center;
}

.cart-btn{
    background:orange;
    color:#000;
    padding:10px 18px;
    border-radius:12px;
    font-weight:bold;
    text-decoration:none;
}

.cart-count{
    background:orange;
    color:black;
    padding:4px 10px;
    border-radius:20px;
}
</style>

</head>

<body>

<form runat="server">

<asp:ScriptManager runat="server" />

<div class="header">
    🍽 <asp:Label ID="lblCategory" runat="server" />
</div>

<asp:UpdatePanel runat="server">
<ContentTemplate>

<div class="menu-list">

<asp:Repeater ID="rptMenu" runat="server" OnItemCommand="rptMenu_ItemCommand">
<ItemTemplate>

<div class="food-card">

<img src='<%# ResolveUrl("~/" + Eval("ImagePath")) %>' class="food-img" />

<div class="food-info">
    <div class="food-name"><%# Eval("ItemName") %></div>
    <div class="food-price">₹ <%# Eval("Price") %></div>
</div>

<!-- ADD -->
<asp:Panel runat="server" Visible='<%# Convert.ToInt32(Eval("Qty")) == 0 %>'>
    <asp:LinkButton runat="server" CssClass="add-btn"
        CommandName="Add"
        CommandArgument='<%# Eval("MenuId") %>'>
        ADD
    </asp:LinkButton>
</asp:Panel>

<!-- QTY -->
<asp:Panel runat="server" Visible='<%# Convert.ToInt32(Eval("Qty")) > 0 %>'>
    <div class="qty-box">

        <asp:LinkButton runat="server" CssClass="qty-btn"
            CommandName="Minus"
            CommandArgument='<%# Eval("MenuId") %>'>-</asp:LinkButton>

        <span><%# Eval("Qty") %></span>

        <asp:LinkButton runat="server" CssClass="qty-btn"
            CommandName="Add"
            CommandArgument='<%# Eval("MenuId") %>'>+</asp:LinkButton>

    </div>
</asp:Panel>

</div>

</ItemTemplate>
</asp:Repeater>

</div>

<!-- FLOAT CART -->
<div class="cart-bar">
<div>
🛒 Cart <span class="cart-count">
<asp:Label ID="lblCartCount" runat="server" />
</span>
</div>

<a href="Cart.aspx" class="cart-btn">View Cart →</a>
</div>

</ContentTemplate>
</asp:UpdatePanel>

</form>
</body>
</html>