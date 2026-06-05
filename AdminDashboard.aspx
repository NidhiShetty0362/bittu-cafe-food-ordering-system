<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="cafe.AdminDashboard" %>

<!DOCTYPE html>
<html>
<head runat="server">
<title>Admin Dashboard</title>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

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
}

.sidebar h2 {
    color: orange;
    text-align: center;
    padding: 20px 0;
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

/* ===== STATS ===== */
.stats {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px,1fr));
    gap: 20px;
}

.stat-card {
    background: #1a1a1a;
    padding: 20px;
    border-radius: 12px;
    text-align: center;
    transition: 0.3s;
}

.stat-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 0 15px rgba(255,165,0,0.4);
}

.stat-icon {
    font-size: 30px;
}

.stat-title {
    color: #aaa;
}

.stat-value {
    font-size: 28px;
    color: orange;
}

/* ===== FILTER ===== */
.filter {
    margin-top: 20px;
}

select {
    padding: 8px;
    border-radius: 6px;
}

/* ===== CHART ===== */
.chart-row {
    display: flex;
    gap: 20px;
    margin-top: 20px;
}

.chart-box {
    background: #1a1a1a;
    padding: 15px;
    border-radius: 12px;
    flex: 1;
    height: 280px;   /* 👈 SMALL SIZE */
}

canvas {
    height: 220px !important; /* 👈 CONTROL SIZE */
}

.blink {
    animation: blinkAnim 1s infinite;
}

@keyframes blinkAnim {
    0% { opacity: 1; }
    50% { opacity: 0.3; }
    100% { opacity: 1; }
}

</style>

<script>

    // AUTO REFRESH
    setInterval(function () {
        location.reload();
    }, 5000);

</script>

</head>

<body>

<form runat="server">

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

<h2 style="color:orange;">📊 Dashboard</h2>
<!-- 🔊 AUDIO -->
<audio id="orderSound" src="sounds/alert.mp3"></audio>

<!-- 🚨 ORDER POPUP -->
<div id="orderPopup" style="
    display:none;
    position:fixed;
    top:20px;
    right:20px;
    background:#1a1a1a;
    padding:15px;
    border-radius:10px;
    box-shadow:0 0 15px orange;
    width:260px;
    z-index:999;
">
    <h4 style="color:orange;">🆕 New Order</h4>
    <div id="popupContent"></div>
</div>
<!-- STATS -->
<div class="stats">

<div class="stat-card">
<div class="stat-icon">👥</div>
<div class="stat-title">Users</div>
<div class="stat-value"><asp:Label ID="lblUsers" runat="server" /></div>
</div>

<div class="stat-card">
<div class="stat-icon">🧾</div>
<div class="stat-title">Orders</div>
<div class="stat-value"><asp:Label ID="lblOrders" runat="server" /></div>
</div>

<div class="stat-card">
<div class="stat-icon">🍔</div>
<div class="stat-title">Menu</div>
<div class="stat-value"><asp:Label ID="lblMenu" runat="server" /></div>
</div>

<div class="stat-card">
<div class="stat-icon">📂</div>
<div class="stat-title">Categories</div>
<div class="stat-value"><asp:Label ID="lblCategory" runat="server" /></div>
</div>

</div>

<!-- FILTER + NOTIFICATION BAR -->
<div style="display:flex; justify-content:space-between; align-items:center; margin-top:20px;">

    <!-- FILTER -->
    <div class="filter">
        <asp:DropDownList ID="ddlFilter" runat="server" AutoPostBack="true"
            OnSelectedIndexChanged="ddlFilter_SelectedIndexChanged">
            <asp:ListItem Value="week">Weekly</asp:ListItem>
            <asp:ListItem Value="month" Selected="True">Monthly</asp:ListItem>
            <asp:ListItem Value="year">Yearly</asp:ListItem>
        </asp:DropDownList>
    </div>

    <!-- 🔔 NOTIFICATION -->
    <div style="position:relative;">
        🔔 Orders 
        <span id="notifCount" 
              style="background:red; padding:4px 8px; border-radius:50%; font-size:12px;">
              0
        </span>
    </div>

</div>

<!-- CHARTS -->
<div class="chart-row">

<div class="chart-box">
<canvas id="revenueChart"></canvas>
</div>

<div class="chart-box">
<canvas id="pieChart"></canvas>
</div>

</div>

<script>

    // REVENUE CHART
    new Chart(document.getElementById('revenueChart'), {
        type: 'line',
        data: {
            labels: <%= revenueLabels %>,
        datasets: [{
            label: 'Revenue',
            data: <%= revenueData %>,
            borderWidth: 2
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false
    }
});

// PIE CHART
new Chart(document.getElementById('pieChart'), {
    type: 'pie',
    data: {
        labels: <%= pieLabels %>,
        datasets: [{
            data: <%= pieData %>
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false
    }
});

</script>
<script>

    let lastCount = 0;

    setInterval(function () {

        fetch("AdminDashboard.aspx/GetNewOrders", {
            method: "POST",
            headers: { "Content-Type": "application/json" }
        })
            .then(res => res.json())
            .then(data => {

                let count = data.d;
                let badge = document.getElementById("notifCount");

                badge.innerText = count;

                // 🔴 BLINK if orders exist
                if (count > 0) {
                    badge.classList.add("blink");
                } else {
                    badge.classList.remove("blink");
                }

                // 🔔 NEW ORDER DETECTED
                if (count > lastCount) {

                    // PLAY SOUND
                    document.getElementById("orderSound").play();

                    // LOAD ORDER DETAILS
                    fetch("AdminDashboard.aspx/GetLatestOrder", {
                        method: "POST",
                        headers: { "Content-Type": "application/json" }
                    })
                        .then(res => res.json())
                        .then(order => {

                            let o = order.d;

                            document.getElementById("popupContent").innerHTML =
                                "<b>User:</b> " + o.Username + "<br/>" +
                                "<b>Total:</b> ₹" + o.TotalAmount + "<br/>" +
                                "<b>Type:</b> " + o.OrderType;

                            let popup = document.getElementById("orderPopup");
                            popup.style.display = "block";

                            // AUTO HIDE
                            setTimeout(() => {
                                popup.style.display = "none";
                            }, 5000);
                        });
                }

                lastCount = count;

            });

    }, 5000);

</script>
</div>

</form>
</body>
</html>