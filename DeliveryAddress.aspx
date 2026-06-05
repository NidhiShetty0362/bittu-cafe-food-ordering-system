<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="DeliveryAddress.aspx.cs"
    Inherits="cafe.DeliveryAddress" %>

<!DOCTYPE html>
<html>
<head runat="server">
<title>Delivery Address</title>

<style>
body{background:black;color:white;font-family:Segoe UI;}
.container{max-width:400px;margin:auto;padding:20px;}
input{width:100%;padding:10px;margin:8px 0;border-radius:8px;border:none;}
.btn{background:orange;padding:12px;width:100%;border:none;border-radius:10px;}
</style>
</head>

<body>
<form runat="server">

<div class="container">

<h2>📍 Delivery Address</h2>

<asp:TextBox ID="txtName" runat="server" placeholder="Full Name" />
<asp:TextBox ID="txtPhone" runat="server" placeholder="Phone Number" />
<asp:TextBox ID="txtAddress" runat="server" placeholder="Address" />
<asp:TextBox ID="txtCity" runat="server" placeholder="City" />
<asp:TextBox ID="txtPincode" runat="server" placeholder="Pincode" />

<!-- Hidden fields for GPS -->
<asp:HiddenField ID="hfLat" runat="server" />
<asp:HiddenField ID="hfLng" runat="server" />

<button type="button" onclick="getLocation()">📍 Use Current Location</button>

<asp:Button ID="btnContinue" runat="server"
    Text="Continue to Payment"
    CssClass="btn"
    OnClick="btnContinue_Click" />

</div>

<script>
function getLocation() {
    navigator.geolocation.getCurrentPosition(function(pos) {
        document.getElementById('<%= hfLat.ClientID %>').value = pos.coords.latitude;
        document.getElementById('<%= hfLng.ClientID %>').value = pos.coords.longitude;
        alert("Location captured!");
    });
}
</script>

</form>
</body>
</html>