<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="cafe.Cart" %>

<!DOCTYPE html>
<html>
<head runat="server">
<title>Bittu Cafe | Cart</title>

<style>
body{
    margin:0;
    background:#000;
    color:#fff;
    font-family:'Segoe UI';
}

/* HEADER */
.header{
    background:#111;
    padding:15px 25px;
    display:flex;
    justify-content:space-between;
    align-items:center;
}
.header h2{ color:orange; }

/* CONTAINER */
.container{
    max-width:900px;
    margin:auto;
    padding:20px;
}

/* CARD */
.cart-card{
    display:flex;
    align-items:center;
    background:#111;
    padding:12px;
    border-radius:14px;
    margin-bottom:12px;
}

.cart-img{
    width:90px;
    height:90px;
    border-radius:12px;
    margin-right:15px;
}

.cart-name{font-size:17px;font-weight:600;}
.cart-price{color:orange;}

.qty-btn{
    background:orange;
    border:none;
    padding:6px 12px;
    border-radius:6px;
    cursor:pointer;
}

/* ORDER TYPE */
.order-type{
    text-align:center;
    margin:20px 0;
}

/* TOTAL */
.total{
    text-align:center;
    font-size:18px;
    margin-bottom:20px;
}

/* FOOTER */
.footer{
    position:fixed;
    bottom:0;
    width:100%;
    background:#111;
    padding:15px;
    text-align:center;
}

.place-btn{
    background:linear-gradient(45deg,orange,#ff5e00);
    border:none;
    padding:14px 30px;
    border-radius:12px;
    font-weight:bold;
}
</style>
</head>

<body>
<form runat="server">

<div class="header">
    <h2>🛒 Cart</h2>
</div>

<div class="container">

<asp:Repeater ID="rptCart" runat="server" OnItemCommand="rptCart_ItemCommand">
<ItemTemplate>

<div class="cart-card">
<img src='<%# ResolveUrl("~/" + Eval("ImagePath")) %>' class="cart-img" />

<div style="flex:1">
<div class="cart-name"><%# Eval("ItemName") %></div>
<div class="cart-price">₹ <%# Eval("Price") %></div>
</div>

<div>
<asp:LinkButton runat="server" CssClass="qty-btn"
CommandName="minus" CommandArgument='<%# Eval("CartId") %>'>-</asp:LinkButton>

<span><%# Eval("Qty") %></span>

<asp:LinkButton runat="server" CssClass="qty-btn"
CommandName="plus" CommandArgument='<%# Eval("CartId") %>'>+</asp:LinkButton>

<asp:LinkButton runat="server"
CommandName="delete" CommandArgument='<%# Eval("CartId") %>'>🗑</asp:LinkButton>
</div>

</div>

</ItemTemplate>
</asp:Repeater>

<!-- ORDER TYPE -->
<div class="order-type">
<h3 style="color:orange;">Select Order Type</h3>

<asp:RadioButton ID="rbDineIn" runat="server" GroupName="type" Text=" Dine In" />
<asp:RadioButton ID="rbTakeaway" runat="server" GroupName="type" Text=" Takeaway" />
<asp:RadioButton ID="rbDelivery" runat="server" GroupName="type" Text=" Delivery" />
</div>

<!-- TOTAL -->
<div class="total">
Total: ₹ <asp:Label ID="lblTotal" runat="server" ForeColor="Orange" />
</div>

</div>

<div class="footer">
<asp:Button ID="btnOrder" runat="server"
Text="Proceed to Payment 💳"
CssClass="place-btn"
OnClick="btnOrder_Click" />
</div>

</form>
</body>
</html>