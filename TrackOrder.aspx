<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="TrackOrder.aspx.cs"
    Inherits="cafe.TrackOrder" %>

<!DOCTYPE html>
<html>
<head runat="server">
<title>Track Order</title>

<style>
body {
    background:#0d0d0d;
    color:white;
    font-family:Segoe UI;
    margin:0;
}

/* NAVBAR */
.navbar {
    background:#111;
    padding:12px;
    text-align:center;
    border-bottom:2px solid orange;
}

.navbar a {
    color:orange;
    margin:0 15px;
    text-decoration:none;
    font-weight:bold;
}

/* CONTAINER */
.container {
    max-width:600px;
    margin:40px auto;
    background:#111;
    padding:25px;
    border-radius:12px;
    box-shadow:0 0 15px rgba(255,165,0,0.3);
    text-align:center;
    transition: all 0.3s ease;
}

/* STATUS */
.status {
    font-size:22px;
    margin:15px 0;
    color:orange;
}

/* STEPS */
.steps {
    margin-top:25px;
    text-align:left;
}

.step {
    padding:10px;
    border-left:4px solid #333;
    margin:10px 0;
    transition: all 0.3s ease;
}

.active {
    border-color:orange;
    color:orange;
    font-weight:bold;
}

/* ETA */
.eta {
    margin-top:15px;
    color:#ccc;
}

/* DELIVERED */
.delivered {
    display:none;
    margin-top:20px;
}

.btn {
    background:orange;
    color:black;
    padding:10px 20px;
    text-decoration:none;
    font-weight:bold;
    border-radius:5px;
}
</style>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

</head>

<body>

<div class="navbar">
    <a href="Home.aspx">🏠 Home</a>
    <a href="MyOrders.aspx">📦 My Orders</a>
</div>

<form runat="server">
<asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" />

<div class="container">

<h2>📍 Track Your Order</h2>

<div class="status" id="statusText">Loading...</div>

<div class="eta">
⏱ Estimated Time: <span id="etaText">--</span>
</div>

<div class="steps">
    <div id="step1" class="step active">✔ Order Placed</div>
    <div id="step2" class="step">👨‍🍳 Preparing</div>
    <div id="step3" class="step">🚴 Out for Delivery</div>
    <div id="step4" class="step">🏁 Delivered</div>
</div>

<div id="deliveredBox" class="delivered">
    <h3 style="color:lime;">✅ Order Delivered</h3>
    <a href="Home.aspx" class="btn">🏠 Explore Website</a>
</div>

</div>
</form>

<script>

    let orderId = '<%= Request.QueryString["orderId"] %>';
    let lastStatus = "";

    function getStatus() {

        if (!orderId) return;

        $.ajax({
            url: "OrderStatusAPI.aspx",
            type: "GET",
            data: { orderId: orderId },

            success: function (data) {

                let res = typeof data === "string" ? JSON.parse(data) : data;

                if (!res) return;

                let status = res.Status.trim();

                document.getElementById("statusText").innerText = status;
                document.getElementById("etaText").innerText = res.ETM || "--";

                updateSteps(status);

                if (status !== lastStatus) {
                    animateChange();
                    lastStatus = status;
                }
            },

            error: function (err) {
                console.log("ERROR:", err);
            }
        });
    }

    function updateSteps(status) {

        status = status.toLowerCase();

        let steps = ["step1", "step2", "step3", "step4"];
        steps.forEach(id => document.getElementById(id).classList.remove("active"));

        document.getElementById("step1").classList.add("active");

        if (status === "preparing")
            document.getElementById("step2").classList.add("active");

        if (status === "out for delivery") {
            document.getElementById("step2").classList.add("active");
            document.getElementById("step3").classList.add("active");
        }

        if (status === "delivered") {
            document.getElementById("step2").classList.add("active");
            document.getElementById("step3").classList.add("active");
            document.getElementById("step4").classList.add("active");

            document.getElementById("deliveredBox").style.display = "block";
            clearInterval(window.trackInterval);
        }
    }

    function animateChange() {
        let box = document.querySelector(".container");

        box.style.transform = "scale(1.05)";
        box.style.boxShadow = "0 0 25px orange";

        setTimeout(() => {
            box.style.transform = "scale(1)";
            box.style.boxShadow = "0 0 15px rgba(255,165,0,0.3)";
        }, 400);
    }

    window.trackInterval = setInterval(getStatus, 3000);
    window.onload = getStatus;

</script>

</body>
</html>