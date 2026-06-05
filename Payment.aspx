<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Payment.aspx.cs" Inherits="cafe.Payment" %>

<!DOCTYPE html>
<html>
<head runat="server">
<title>Bittu Cafe | Payment</title>

<style>
body{
    margin:0;
    background:#000;
    color:#fff;
    font-family:'Segoe UI';
}

/* CONTAINER */
.container{
    max-width:500px;
    margin:auto;
    padding:20px;
}

/* HEADER */
.header{
    text-align:center;
    font-size:24px;
    color:orange;
    font-weight:bold;
    margin-bottom:20px;
}

/* CARD */
.card{
    background:linear-gradient(145deg,#111,#1a1a1a);
    border-radius:16px;
    padding:18px;
    margin-bottom:15px;
    box-shadow:0 0 10px rgba(255,165,0,0.15);
}

/* ROW */
.row{
    display:flex;
    justify-content:space-between;
    margin-bottom:10px;
    font-size:15px;
}

/* TOTAL */
.total{
    font-size:20px;
    color:orange;
    font-weight:bold;
}

/* PAYMENT OPTION */
.payment-option{
    background:#000;
    padding:10px;
    border-radius:10px;
    margin:10px 0;
    border:1px solid #333;
    transition:0.3s;
}

.payment-option:hover{
    border:1px solid orange;
}

/* RADIO */
input[type=radio]{
    accent-color:orange;
    transform:scale(1.2);
    margin-right:8px;
}

/* BUTTON FIXED */
.footer{
    position:fixed;
    bottom:0;
    width:100%;
    background:#111;
    padding:15px;
    border-top:2px solid orange;
}

.btn-pay{
    width:100%;
    background:linear-gradient(45deg,orange,#ff5e00);
    color:#000;
    padding:14px;
    border-radius:12px;
    font-size:18px;
    font-weight:bold;
    border:none;
    cursor:pointer;
}

.btn-pay:hover{
    transform:scale(1.03);
}
</style>
</head>

<body>

<form runat="server">

<div class="container">

<div class="header">💳 Payment</div>

<!-- ORDER SUMMARY -->
<div class="card">

<div class="row">
<span>Order Type</span>
<span><asp:Label ID="lblOrderType" runat="server" /></span>
</div>

<hr style="border-color:#222" />

<div class="row total">
<span>Total Amount</span>
<span>₹ <asp:Label ID="lblTotal" runat="server" /></span>
</div>
<!-- ITEMS LIST -->
<asp:Repeater ID="rptItems" runat="server">
<ItemTemplate>

<div class="row">
    <span>
        <%# Eval("ItemName") %> x <%# Eval("Qty") %>
    </span>

    <span>
        ₹ <%# Eval("Total") %>
    </span>
</div>

</ItemTemplate>
</asp:Repeater>
</div>

<!-- PAYMENT OPTIONS -->
<div class="card">

<h3 style="color:orange;margin-bottom:10px;">Select Payment Mode</h3>

<!-- DINE IN -->
<asp:Panel ID="pnlDineIn" runat="server" Visible="false">

<div class="payment-option">
<asp:RadioButton ID="rbCounter" runat="server" GroupName="pay" />
Pay at Counter
</div>

<div class="payment-option">
<asp:RadioButton ID="rbOnline" runat="server" GroupName="pay" />
Pay Online (Razorpay)
</div>

</asp:Panel>

<!-- DELIVERY / TAKEAWAY -->
<asp:Panel ID="pnlDelivery" runat="server" Visible="false">

<div class="payment-option">
<asp:RadioButton ID="rbCOD" runat="server" GroupName="pay" />
Cash on Delivery
</div>

<div class="payment-option">
<asp:RadioButton ID="rbOnline2" runat="server" GroupName="pay" />
Pay Online (Razorpay)
</div>

</asp:Panel>

</div>

</div>

<!-- FIXED BUTTON -->
<div class="footer">
<asp:Button 
    ID="btnPayNow" 
    runat="server" 
    Text="Pay & Place Order 🚀"
    CssClass="btn-pay"
    OnClick="btnPayNow_Click" />
</div>

<!-- RAZORPAY -->
<script src="https://checkout.razorpay.com/v1/checkout.js"></script>

<script>
    function startRazorpay(orderId, amount) {

        var options = {
            "key": "<%= ConfigurationManager.AppSettings["RazorpayKey"] %>",
            "amount": amount,
            "currency": "INR",
            "name": "Bittu Cafe ☕",
            "description": "Food Order",
            "order_id": orderId,

            "handler": function (response) {
                window.location = "PaymentCallback.aspx?success=1";
            },

            "modal": {
                "ondismiss": function () {
                    window.location = "PaymentCallback.aspx?success=0";
                }
            },

            "theme": { "color": "#ff9800" }
        };

        var rzp = new Razorpay(options);
        rzp.open();
    }
</script>

</form>
</body>
</html>