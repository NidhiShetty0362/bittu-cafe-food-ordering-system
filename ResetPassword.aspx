<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ResetPassword.aspx.cs" Inherits="cafe.ResetPassword" %>

<!DOCTYPE html>
<html>
<head runat="server">
<title>Reset Password | Bittu Cafe</title>

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
}

.input-box span {
    margin-right: 10px;
}

.input-box input {
    background: none;
    border: none;
    outline: none;
    color: white;
    width: 100%;
}

/* ===== BUTTON (OLD STYLE - NO HOVER EFFECT) ===== */
.btn {
    width: 100%;
    padding: 12px;
    background: linear-gradient(45deg, orange, #ff5e00);
    border: none;
    border-radius: 10px;
    color: black;
    font-weight: bold;
    cursor: pointer;
    margin-top: 5px;
    transition: 0.3s;
}

/* 🔥 ZOOM EFFECT */
.btn:hover {
    transform: scale(1.05);
    box-shadow: 0 0 10px rgba(255,165,0,0.6);
}

/* ===== TIMER ===== */
.timer {
    text-align: center;
    font-size: 13px;
    color: #aaa;
    margin-bottom: 10px;
}

/* ===== MESSAGE ===== */
.msg {
    text-align: center;
    margin-top: 10px;
    color: red;
}

/* ===== FOOTER ===== */
.footer {
    text-align: center;
    margin-top: 15px;
}

.footer a {
    color: orange;
    text-decoration: none;
    font-weight: bold;
}

</style>

<script>
    var seconds = 300;

    function startTimer() {
        var btn = document.getElementById("<%= btnResend.ClientID %>");
        btn.disabled = true;

        var timer = setInterval(function () {

            var min = Math.floor(seconds / 60);
            var sec = seconds % 60;

            document.getElementById("timerText").innerHTML =
                "Resend OTP in " + min + ":" + (sec < 10 ? "0" + sec : sec);

            seconds--;

            if (seconds < 0) {
                clearInterval(timer);
                document.getElementById("timerText").innerHTML = "Resend available";
                btn.disabled = false;
            }

        }, 1000);
    }

    window.onload = startTimer;
</script>

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

        <h2>🔁 Reset Password</h2>

        <!-- OTP -->
        <div class="input-box">
            <span>🔐</span>
            <asp:TextBox ID="txtOTP" runat="server" placeholder="Enter OTP"></asp:TextBox>
        </div>

        <!-- TIMER -->
        <div class="timer">
            <span id="timerText"></span>
        </div>

        <!-- RESEND -->
        <asp:Button ID="btnResend" runat="server"
            Text="Resend OTP"
            CssClass="btn"
            OnClick="btnResend_Click" />

        <!-- NEW PASSWORD -->
        <div class="input-box">
            <span>🔒</span>
            <asp:TextBox ID="txtNew" runat="server"
                TextMode="Password"
                placeholder="New Password"></asp:TextBox>
        </div>

        <!-- CONFIRM PASSWORD -->
        <div class="input-box">
            <span>🔁</span>
            <asp:TextBox ID="txtConfirm" runat="server"
                TextMode="Password"
                placeholder="Confirm Password"></asp:TextBox>
        </div>

        <!-- RESET -->
        <asp:Button ID="btnReset" runat="server"
            Text="Reset Password"
            CssClass="btn"
            OnClick="btnReset_Click" />

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