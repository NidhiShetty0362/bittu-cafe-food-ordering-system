<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserProfile.aspx.cs" Inherits="cafe.UserProfile" %>

<!DOCTYPE html>
<html>
<head runat="server">
<title>User Profile</title>

<style>

body {
    margin: 0;
    font-family: 'Segoe UI';
    background: #0d0d0d;
    color: white;
    transition: 0.3s;
}

/* LIGHT MODE */
.light-mode {
    background: #f5f5f5;
    color: black;
}

/* CARD */
.profile-card {
    width: 380px;
    margin: 60px auto;
    background: rgba(26,26,26,0.9);
    padding: 25px;
    border-radius: 18px;
    text-align: center;
    box-shadow: 0 0 25px rgba(255,165,0,0.2);
    backdrop-filter: blur(8px);
    transition: 0.3s;
}

.profile-card:hover {
    transform: scale(1.05);
    box-shadow: 0 0 35px rgba(255,140,0,0.5);
}

/* IMAGE */
.profile-img {
    width: 90px;
    height: 90px;
    border-radius: 50%;
    margin-bottom: 15px;
}

/* TEXT */
h2 {
    color: orange;
}

.info {
    margin: 8px 0;
    color: #ccc;
}

/* BUTTON */
.btn {
    margin-top: 10px;
    padding: 12px;
    background: linear-gradient(45deg, orange, #ff5e00);
    border: none;
    border-radius: 10px;
    font-weight: bold;
    cursor: pointer;
    width: 100%;
    transition: 0.3s;
}

.btn:hover {
    transform: scale(1.05);
}

/* INPUT */
.input {
    width: 100%;
    padding: 10px;
    margin-top: 8px;
    border-radius: 8px;
    border: none;
    background: #222;
    color: white;
}

/* SECTION */
.section {
    margin-top: 20px;
    text-align: left;
}

/* STATS */
.stats {
    background: #111;
    padding: 10px;
    border-radius: 10px;
    margin-top: 10px;
}

/* TOGGLE */
.toggle {
    position: absolute;
    right: 20px;
    top: 20px;
    cursor: pointer;
}

</style>

<script>
function toggleMode() {
    document.body.classList.toggle("light-mode");
}

function confirmLogout() {
    return confirm("Are you sure you want to logout?");
}
</script>

</head>

<body>

<form runat="server">

<div class="toggle" onclick="toggleMode()">🌙</div>

<div class="profile-card">

<img src="logo/user.png" class="profile-img" />

<h2><asp:Label ID="lblUsername" runat="server" /></h2>

<div class="info">📧 <asp:Label ID="lblEmail" runat="server" /></div>

<div class="info">📅 Joined: <asp:Label ID="lblDate" runat="server" /></div>

<!-- STATS -->
<div class="section">
<h3>📊 Stats</h3>
<div class="stats">
🛒 Orders: <asp:Label ID="lblOrders" runat="server" /><br />
💰 Spent: ₹<asp:Label ID="lblSpent" runat="server" />
</div>
</div>

<!-- CHANGE PASSWORD -->
<div class="section">
<h3>🔐 Change Password</h3>

<asp:TextBox ID="txtOld" runat="server" CssClass="input" TextMode="Password" placeholder="Old Password"></asp:TextBox>
<asp:TextBox ID="txtNew" runat="server" CssClass="input" TextMode="Password" placeholder="New Password"></asp:TextBox>
<asp:TextBox ID="txtConfirm" runat="server" CssClass="input" TextMode="Password" placeholder="Confirm Password"></asp:TextBox>

<asp:Button ID="btnChange" runat="server"
Text="Change Password"
CssClass="btn"
OnClick="btnChange_Click" />
</div>

<asp:Label ID="lblMsg" runat="server" ForeColor="Red"></asp:Label>

<!-- LOGOUT -->
<asp:Button ID="btnLogout" runat="server"
Text="Logout"
CssClass="btn"
OnClientClick="return confirmLogout();"
OnClick="btnLogout_Click" />

</div>

</form>

</body>
</html>