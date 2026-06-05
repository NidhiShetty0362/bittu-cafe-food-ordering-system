<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="cafe.ForgotPassword" %>

<!DOCTYPE html>
<html>
<head runat="server">
<title>Forgot Password | Bittu Cafe</title>

<style>

/* ===== BACKGROUND ===== */
body {
    margin: 0;
    font-family: 'Segoe UI';
    background: linear-gradient(135deg, #000, #1a1a1a);
    color: white;
}

/* ===== CONTAINER ===== */
.container {
    max-width: 420px;
    margin: 70px auto;
    background: #111;
    border-radius: 15px;
    overflow: hidden;
    box-shadow: 0 0 25px rgba(255,102,0,0.3);
    animation: fadeIn 0.8s ease-in-out;
}

/* ===== ANIMATION ===== */
@keyframes fadeIn {
    from {opacity:0; transform: translateY(20px);}
    to {opacity:1; transform: translateY(0);}
}

/* ===== BANNER ===== */
.banner {
    background: linear-gradient(45deg, #ff6600, #ff3300);
    padding: 25px;
    text-align: center;
}

.banner img {
    width: 110px;
    border-radius: 50%;
}

/* ===== CONTENT ===== */
.content {
    padding: 30px;
}

h2 {
    text-align: center;
    color: orange;
    margin-bottom: 10px;
}

/* SUB TEXT */
.sub {
    text-align: center;
    font-size: 13px;
    color: #aaa;
    margin-bottom: 20px;
}

/* ===== INPUT BOX ===== */
.input-box {
    display: flex;
    background: #222;
    border-radius: 10px;
    padding: 12px;
    margin-bottom: 15px;
    align-items: center;
    transition: 0.3s;
}

.input-box:focus-within {
    box-shadow: 0 0 10px orange;
}

.input-box span {
    margin-right: 10px;
    font-size: 18px;
}

.input-box input {
    background: none;
    border: none;
    outline: none;
    color: white;
    width: 100%;
    font-size: 16px;
}

/* ===== BUTTON ===== */
.btn {
    width: 100%;
    padding: 14px;
    background: linear-gradient(45deg, orange, #ff5e00);
    border: none;
    border-radius: 10px;
    color: black;
    font-size: 16px;
    font-weight: bold;
    cursor: pointer;
    transition: 0.3s;
}

.btn:hover {
    transform: scale(1.05);
    box-shadow: 0 0 15px rgba(255,140,0,0.7);
}

.btn:active {
    transform: scale(0.98);
}

/* ===== MESSAGE ===== */
.msg {
    text-align: center;
    margin-top: 10px;
    color: #ff4d4d;
}

/* ===== FOOTER ===== */
.footer {
    text-align: center;
    margin-top: 15px;
}

.footer a {
    color: orange;
    font-weight: bold;
    text-decoration: none;
}

.footer a:hover {
    text-decoration: underline;
}

</style>

</head>

<body>
<form runat="server">

<div class="container">

    <!-- LOGO -->
    <div class="banner">
        <img src="logo/bittu.jpg" />
    </div>

    <!-- CONTENT -->
    <div class="content">

        <h2>🔐 Forgot Password</h2>
        <div class="sub">Enter your username to receive OTP</div>

        <!-- USERNAME -->
        <div class="input-box">
            <span>👤</span>
            <asp:TextBox ID="txtUser" runat="server"
                placeholder="Enter Username"></asp:TextBox>
        </div>

        <!-- BUTTON -->
        <asp:Button ID="btnSendOTP" runat="server"
            Text="Send OTP"
            CssClass="btn"
            OnClick="btnSendOTP_Click" />

        <!-- MESSAGE -->
        <asp:Label ID="lblMsg" runat="server" CssClass="msg"></asp:Label>

        <!-- BACK -->
        <div class="footer">
            <a href="Login.aspx">← Back to Login</a>
        </div>

    </div>

</div>

</form>
</body>
</html>