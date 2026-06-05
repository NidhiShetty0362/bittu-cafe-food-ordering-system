<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="cafe.Home" %>

<!DOCTYPE html>
<html>
<head runat="server">
<title>Bittu Cafe</title>

<style>

/* ===== GLOBAL ===== */
body {
    margin: 0;
    font-family: 'Segoe UI';
    background: #0d0d0d;
    color: white;
}

/* ===== HEADER ===== */
.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 15px 30px;
    background: rgba(0,0,0,0.8);
    backdrop-filter: blur(10px);
    position: sticky;
    top: 0;
    z-index: 1000;
}

.logo img {
    border-radius: 50%;
}

/* NAV */
.nav a {
    margin-left: 20px;
    color: #ccc;
    text-decoration: none;
    font-weight: 500;
}

.nav a:hover {
    color: orange;
}

/* ===== HERO ===== */
.hero {
    height: 400px;
    background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.9)),
                url('logo/bg.jpg')  no-repeat center;
    background-size : cover;
    display: flex;
    flex-direction: column;
    justify-content: center;
    padding-left: 80px;
}

.hero h1 {
    font-size: 70px;
    color: orange;
}

.hero p {
    color: #ccc;
}

/* ===== SEARCH ===== */
.search-box {
    display: flex;
    justify-content: center;
    gap: 15px;
    margin: 25px 0;
}

.search-box input {
    width: 360px;
    padding: 12px 15px;
    border-radius: 30px;
    border: none;
    outline: none;
    background: #222;
    color: white;
}

.btn {
    padding: 12px 22px;
    border-radius: 30px;
    border: none;
    background: linear-gradient(45deg, orange, #ff5e00);
    font-weight: bold;
    cursor: pointer;
    transition: 0.3s;
}

.btn:hover {
    transform: scale(1.05);
}

.categories {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;   /* center when less items */
    gap: 25px;
    padding: 20px 40px;
}

/* FIX CARD SIZE */
.category-card {
    width: 260px;              /* ✅ fixed width (important) */
    background: #1a1a1a;
    border-radius: 18px;
    overflow: hidden;
    transition: 0.3s;
}

.category-card:hover {
    transform: translateY(-8px);
    box-shadow: 0 0 20px rgba(255,165,0,0.4);
}

/* IMAGE PERFECT FIT */
.category-card img {
    width: 100%;
    height: 280px;             /* ✅ fixed height */
    object-fit: cover;         /* ✅ no stretch */
    display: block;
}

/* NAME */
.category-name {
    padding: 12px;
    text-align: center;
    font-weight: bold;
    background: linear-gradient(45deg, orange, #ff5e00);
    color: black;
}
/* REMOVE LINK STYLE */
.category-card a {
    text-decoration: none;
    color: inherit;
    display: block;
}

/* ===== FOOTER SECTION ===== */
.footer-top {
    background: #111;
    padding: 30px 40px;
    margin-top: 40px;
    border-top: 1px solid #222;
}

.footer-content {
    display: flex;
    justify-content: space-between;
    flex-wrap: wrap;
}

.footer-box h3 {
    color: orange;
}

.footer-box p {
    color: #aaa;
}

/* BUTTONS */
.footer-buttons a {
    display: inline-block;
    margin: 8px 8px 0 0;
    padding: 10px 15px;
    border-radius: 8px;
    text-decoration: none;
    font-weight: bold;
}

.call {
    background: orange;
    color: black;
}

.whatsapp {
    background: #25D366;
    color: white;
}

.instagram {
    background: #E1306C;
    color: white;
}

/* ===== BOTTOM NAV ===== */
.bottom-nav {
    position: fixed;
    bottom: 0;
    width: 100%;
    background: #111;
    display: flex;
    justify-content: space-around;
    padding: 12px 0;
    border-top: 1px solid #222;
}

.bottom-nav a {
    color: #ccc;
    text-decoration: none;
    font-size: 14px;
}

.bottom-nav a:hover {
    color: orange;
}
.logo {
    display: flex;          
    align-items: center;   
    gap: 12px;              
}

.logo h1 {
    font-size: 22px;
    margin: 0;              
    color: orange;
    letter-spacing: 1px;
    
}
</style>
</head>

<body>

<form runat="server">

<!-- HEADER -->
<div class="header">
    <div class="logo">
        <img src="logo/bittu.jpg" width="60" height="60" />
        <h1>BITTU CAFE ☕</h1>
    </div>

    <div class="nav">
        <a href="Home.aspx">Home</a>
        <a href="MyOrders.aspx">Orders</a>
        <a href="Cart.aspx">Cart</a>
        <a href="UserProfile.aspx">Profile</a>
    </div>
</div>

<!-- HERO -->
<div class="hero">
    <h1>Fresh Coffee, Happy Mood ☕</h1>
    <p>Fast Delivery • Best Taste • Cozy Cafe</p>
</div>

<!-- SEARCH -->
<div class="search-box">
    <asp:TextBox ID="txtSearch" runat="server" placeholder="Search categories..." />
    <asp:Button ID="btnSearch" runat="server"
        Text="Search"
        CssClass="btn"
        OnClick="btnSearch_Click" />
</div>

<!-- CATEGORY GRID -->
<div class="categories">

<asp:Repeater ID="rptCategory" runat="server">
<ItemTemplate>

<div class="category-card">

<asp:LinkButton runat="server"
CommandArgument='<%# Eval("CategoryName") %>'
OnCommand="OpenMenu">

<img src='<%# Eval("CategoryImage") %>' />

<div class="category-name">
    <%# Eval("CategoryName") %>
</div>

</asp:LinkButton>

</div>

</ItemTemplate>
</asp:Repeater>

</div>

<!-- FOOTER -->
<div class="footer-top">

<div class="footer-content">

<div class="footer-box">
<h3>📍 Location</h3>
<p>Mankoli, Dombivali West</p>
<p>Open: 4 PM – 12 AM</p>
</div>

<div class="footer-box">
<h3>📞 Contact</h3>

<div class="footer-buttons">

<a href="tel:8828068202" class="call">Call Now</a>

<a href="https://wa.me/918828068202" target="_blank" class="whatsapp">
WhatsApp
</a>

<a href="https://instagram.com/_bittu_cafe_" target="_blank" class="instagram">
Instagram
</a>

</div>

</div>

</div>

</div>


</form>

</body>
</html>