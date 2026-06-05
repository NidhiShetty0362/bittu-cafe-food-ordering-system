<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SignUp.aspx.cs" Inherits="cafe.SignUp" %>

<!DOCTYPE html>
<html>
<head runat="server">
<title>Sign Up | Bittu Cafe</title>

<style>

/* ===== BACKGROUND ===== */
body {
    margin: 0;
    font-family: 'Segoe UI';
    background: linear-gradient(135deg, #000, #1a1a1a);
    color: white;
}

/* ===== MAIN CARD ===== */
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
    margin-bottom: 20px;
}

/* ===== STEP TEXT ===== */
.step {
    text-align: center;
    font-size: 13px;
    color: #aaa;
    margin-bottom: 15px;
}

/* ===== INPUT ===== */
.input-box {
    display: flex;
    align-items: center;
    background: #222;
    border-radius: 10px;
    padding: 12px;
    margin-bottom: 15px;
    transition: 0.3s;
}

.input-box:focus-within {
    box-shadow: 0 0 10px orange;
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

/* ===== BUTTON ===== */
.btn {
    width: 100%;
    padding: 14px;
    background: linear-gradient(45deg, orange, #ff5e00);
    border: none;
    border-radius: 10px;
    color: black;
    font-weight: bold;
    cursor: pointer;
    transition: 0.3s;
}

.btn:hover {
    transform: scale(1.05);
}

/* ===== RESEND ===== */
.resend-box {
    text-align: center;
    margin-bottom: 15px;
}

#timerText {
    display: block;
    color: #aaa;
    margin-bottom: 8px;
}

/* ===== MESSAGE ===== */
.msg {
    color: red;
    text-align: center;
    margin-top: 10px;
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

</style>

<script>
    var timeLeft = 60;

    function startTimer() {

        var timer = setInterval(function () {

            if (timeLeft <= 0) {
                clearInterval(timer);
                document.getElementById("timer").innerHTML = "Resend available";
            } else {
                document.getElementById("timer").innerHTML =
                    "Resend in " + timeLeft + " sec";
            }

            timeLeft--;

        }, 1000);
    }
</script>

</head>

<body>

<form runat="server">

<div class="container">

    <!-- LOGO -->
    <div class="banner">
        <img src="logo/bittu.jpg" />
    </div>

    <div class="content">

        <h2>✨ Create Account</h2>

        <!-- STEP 1 EMAIL -->
        <asp:Panel ID="pnlEmail" runat="server">
            <div class="step">Step 1 • Verify Email</div>

            <div class="input-box">
                <span>📧</span>
                <asp:TextBox ID="txtEmail" runat="server" placeholder="Enter Email"></asp:TextBox>
            </div>

            <asp:Button ID="btnSendOTP" runat="server"
                Text="Send OTP"
                CssClass="btn"
                OnClick="btnSendOTP_Click" />
        </asp:Panel>

        <!-- STEP 2 OTP -->
        <asp:Panel ID="pnlOTP" runat="server" Visible="false">
            <div class="step">Step 2 • Enter OTP</div>

            <div class="input-box">
                <span>🔐</span>
                <asp:TextBox ID="txtOTP" runat="server" placeholder="Enter OTP"></asp:TextBox>
            </div>

            <!-- RESEND -->
            <div class="resend-box">
                <span id="timerText"></span>

                <asp:Button ID="btnResend" runat="server"
                    Text="Resend OTP"
                    CssClass="btn"
                    Enabled="false"
                    OnClick="btnResend_Click" />
            </div>

            <asp:Button ID="btnVerifyOTP" runat="server"
                Text="Verify OTP"
                CssClass="btn"
                OnClick="btnVerifyOTP_Click" />
        </asp:Panel>

        <!-- STEP 3 USER -->
        <asp:Panel ID="pnlUser" runat="server" Visible="false">
            <div class="step">Step 3 • Create Account</div>

            <div class="input-box">
                <span>👤</span>
                <asp:TextBox ID="txtUsername" runat="server" placeholder="Username"></asp:TextBox>
            </div>

            <div class="input-box">
                <span>🔒</span>
                <asp:TextBox ID="txtPassword" runat="server"
                    TextMode="Password"
                    placeholder="Password"></asp:TextBox>
            </div>

            <div class="input-box">
                <span>🔁</span>
                <asp:TextBox ID="txtConfirm" runat="server"
                    TextMode="Password"
                    placeholder="Confirm Password"></asp:TextBox>
            </div>

            <asp:Button ID="btnRegister" runat="server"
                Text="Create Account"
                CssClass="btn"
                OnClick="btnRegister_Click" />
        </asp:Panel>

        <asp:Label ID="lblMsg" runat="server" CssClass="msg"></asp:Label>

        <div class="footer">
            Already have an account?
            <a href="Login.aspx">Login</a>
        </div>

    </div>

</div>

</form>

</body>
</html>