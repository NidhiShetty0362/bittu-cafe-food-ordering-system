<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="cafe.Login" %>

<!DOCTYPE html>
<html>
<head runat="server">
<title>Login | Bittu Cafe</title>

<style>

/* ===== GLOBAL ===== */
body {
    margin: 0;
    font-family: 'Segoe UI';
    background: radial-gradient(circle at top, #1a1a1a, #000);
    color: white;
}

/* ===== CONTAINER ===== */
.container {
    max-width: 400px;
    margin: 60px auto;
    border-radius: 18px;
    background: rgba(17,17,17,0.9);
    backdrop-filter: blur(12px);
    box-shadow: 0 0 35px rgba(255,102,0,0.3);
    overflow: hidden;
    animation: fadeIn 0.6s ease;
}

/* ===== ANIMATION ===== */
@keyframes fadeIn {
    from {opacity:0; transform: translateY(20px);}
    to {opacity:1; transform: translateY(0);}
}

/* ===== HEADER ===== */
.banner {
    background: linear-gradient(45deg, orange, #ff3c00);
    padding: 30px;
    text-align: center;
}

.banner img {
    width: 100px;
    border-radius: 50%;
    border: 3px solid white;
}

/* ===== CONTENT ===== */
.content {
    padding: 30px;
}

h1 {
    text-align: center;
    color: orange;
    margin-bottom: 25px;
}

/* ===== INPUT ===== */
.input-box {
    display: flex;
    align-items: center;
    background: #222;
    border-radius: 10px;
    padding: 12px 14px;
    margin-bottom: 15px;
    transition: 0.3s;
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
    border-radius: 12px;
    color: black;
    font-size: 16px;
    font-weight: bold;
    cursor: pointer;
}

.btn:hover {
    transform: scale(1.05);
    box-shadow: 0 0 15px orange;
}

/* RESEND BUTTON */
.btn-resend {
    width: 100%;
    padding: 14px;
    background: linear-gradient(45deg, #ff9900, #ff3300);
    border: none;
    border-radius: 12px;
    color: black;
    font-weight: bold;
    cursor: pointer;
}

/* ===== OTP ===== */
.otp-box input {
    text-align: center;
    font-size: 20px;
    letter-spacing: 4px;
}

/* ===== FOOTER ===== */
.footer {
    text-align: center;
    margin-top: 15px;
    font-size: 14px;
}

.footer a {
    color: orange;
    text-decoration: none;
}

/* ===== MESSAGE ===== */
.msg {
    text-align: center;
    margin-top: 10px;
    color: #ff4d4d;
}
/* 🔒 DISABLED BUTTON STYLE */
.btn:disabled {
    background: #333 !important;
    color: #777 !important;
    cursor: not-allowed;
    box-shadow: none;
    transform: none;
}
#timer {
    text-align: center;
    margin-top: 8px;
    color: orange;
}

</style>
</head>

<body>
<form runat="server">

<div class="container">

<!-- HEADER -->
<div class="banner">
    <img src="logo/bittu.jpg" />
</div>

<div class="content">

<h1>☕ Welcome Back</h1>

<!-- LOGIN PANEL -->
<asp:Panel ID="pnlLogin" runat="server">

    <div class="input-box">
        <asp:TextBox ID="txtUsername" runat="server" placeholder="Username"></asp:TextBox>
    </div>

    <div class="input-box">
        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Password"></asp:TextBox>
    </div>

    <asp:Button ID="btnLogin" runat="server"
        Text="Send OTP 🚀"
        CssClass="btn"
        OnClick="btnLogin_Click" />

</asp:Panel>

<!-- OTP PANEL -->
<asp:Panel ID="pnlOTP" runat="server" Visible="false">

    <div class="input-box otp-box">
        <asp:TextBox ID="txtOTP" runat="server" placeholder="Enter OTP"></asp:TextBox>
    </div>

    <asp:Button ID="btnVerify" runat="server"
        Text="Verify & Login 🔐"
        CssClass="btn"
        OnClick="btnVerify_Click" />

    <!-- RESEND OTP -->
   <asp:Button ID="btnResend" runat="server"
    Text="🔄 Resend OTP"
    CssClass="btn"
    Style="margin-top:15px;"
    OnClick="btnResend_Click"
    UseSubmitBehavior="false" />

    <div id="timer">Resend available in 30 sec</div>

</asp:Panel>

<!-- LINKS -->
<div class="footer">
    <a href="ForgotPassword.aspx">Forgot Password?</a>
</div>

<asp:Label ID="lblMessage" runat="server" CssClass="msg"></asp:Label>

<div class="footer">
    Don’t have an account?
    <a href="SignUp.aspx">Sign Up</a>
</div>

</div>
</div>

</form>

<!-- TIMER SCRIPT -->
<script>
    var timeLeft = 30;

    function startTimer() {

        var timerLabel = document.getElementById("timer");
        var resendBtn = document.getElementById("<%= btnResend.ClientID %>");

        resendBtn.disabled = true;

        var interval = setInterval(function () {

            timeLeft--;

            timerLabel.innerText = "Resend available in " + timeLeft + " sec";

            if (timeLeft <= 0) {
                clearInterval(interval);
                timerLabel.innerText = "You can resend OTP now";
                resendBtn.disabled = false;
            }

        }, 1000);
    }

    // START TIMER WHEN PAGE LOADS (OTP PANEL)
    window.onload = function () {
        var otpPanel = document.getElementById("<%= pnlOTP.ClientID %>");
        if (otpPanel && otpPanel.style.display !== "none") {
            startTimer();
        }
    };
</script>

</body>
</html>