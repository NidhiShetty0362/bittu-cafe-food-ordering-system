<%@ Page Language="C#" AutoEventWireup="true" 
    CodeBehind="MyOrders.aspx.cs"
    Inherits="cafe.MyOrders" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>My Orders | Bittu Cafe</title>

    <style>
        body {
            background: black;
            font-family: 'Segoe UI';
            color: white;
        }

        h2 {
            text-align: center;
            color: orange;
        }

        .order-box {
            max-width: 800px;
            margin: auto;
        }

        .order {
            background: #111;
            padding: 15px;
            margin: 15px 0;
            border-radius: 10px;
            border-left: 4px solid orange;
        }

        .item {
            margin-left: 10px;
            font-size: 14px;
            color: #ccc;
        }

        .status {
            float: right;
            color: lightgreen;
            font-weight: bold;
        }

        .total {
            margin-top: 10px;
            font-weight: bold;
            color: orange;
        }

        .date {
            font-size: 12px;
            color: #888;
        }

        .btn {
            margin-top: 10px;
            background: orange;
            border: none;
            padding: 8px 15px;
            border-radius: 8px;
            cursor: pointer;
        }

        /* POPUP */
        .popup {
            position: fixed;
            bottom: -100%;
            left: 0;
            width: 100%;
            height: 40%;
            background: #111;
            transition: 0.4s;
            border-top-left-radius: 20px;
            border-top-right-radius: 20px;
            box-shadow: 0 -5px 20px rgba(0,0,0,0.5);
        }

        .popup-content {
            padding: 20px;
            text-align: center;
            animation: slideUp 0.4s ease;
        }

        .popup button {
            background: orange;
            border: none;
            padding: 10px 20px;
            border-radius: 10px;
            margin-top: 15px;
        }

        .popup.show {
            bottom: 0;
        }

        /* ANIMATION */
        @keyframes slideUp {
            from { transform: translateY(50px); opacity:0; }
            to { transform: translateY(0); opacity:1; }
        }

    </style>

    <script>
        function showTracking(status) {

            var msg = "";

            if (status === "Out for Delivery") {
                msg = "🚚 Your order is arriving soon!";
            }
            else if (status === "Preparing") {
                msg = "👨‍🍳 Your order is being prepared";
            }
            else {
                msg = "📦 Order placed successfully";
            }

            document.getElementById("trackStatus").innerText =
                "Status: " + status;

            document.getElementById("trackMsg").innerText = msg;

            document.getElementById("trackingPopup").classList.add("show");
        }

        function closePopup() {
            document.getElementById("trackingPopup").classList.remove("show");
        }
    </script>

</head>

<body>

<form runat="server">

<h2>🧾 My Orders</h2>

<div class="order-box">

    <asp:Repeater ID="rptOrders" runat="server">
        <ItemTemplate>

            <div class="order">

                <div>
                    <b>Order #<%# Eval("OrderId") %></b><span class="status"><%# Eval("Status") %>/ <%# Eval("PaymentMode") %>
                    </span>
                </div>

                <div class="date">
                    <%# Eval("OrderDate") %>
                </div>

                <hr />

                <!-- ITEMS -->
                <asp:Repeater ID="rptItems" runat="server" DataSource='<%# Eval("Items") %>'>
                <ItemTemplate>
                    <div class="item">
                        <%# ((System.Data.DataRow)Container.DataItem)["ItemName"] %> -
                        ₹<%# ((System.Data.DataRow)Container.DataItem)["Price"] %>x
                        <%# ((System.Data.DataRow)Container.DataItem)["Quantity"] %> =
                        ₹<%# ((System.Data.DataRow)Container.DataItem)["Total"] %></div>
                </ItemTemplate>
                </asp:Repeater>

                <div class="total">
                    Total: ₹<%# Eval("TotalAmount") %></div>

                <!-- TRACK BUTTON -->
                <asp:Button 
                ID="btnTrack"
                runat="server"
                Text="📍 Track Order"
                CssClass="btn"
                Visible='<%# Eval("Status").ToString() == "Out for Delivery" %>'
                PostBackUrl='<%# "TrackOrder.aspx?orderId=" + Eval("OrderId") %>' />
            </div>

        </ItemTemplate>
    </asp:Repeater>

</div>

<!-- POPUP -->
<div id="trackingPopup" class="popup">
    <div class="popup-content">

        <h3>🚚 Order Tracking</h3>

        <p id="trackStatus"></p>

        <p id="trackMsg" style="color:lightgreen;"></p>

        <button onclick="closePopup()">Close</button>

    </div>
</div>

<asp:Label ID="lblMsg" runat="server" ForeColor="Orange" />

</form>

</body>
</html>