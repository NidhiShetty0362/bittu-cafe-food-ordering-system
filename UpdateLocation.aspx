<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UpdateLocation.aspx.cs" Inherits="cafe.UpdateLocation" %>

<!DOCTYPE html>
<html>
<head runat="server">
<title>Update Location</title>

<link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />

<style>
body { background:#111; color:white; text-align:center; }
#map { height:400px; margin:20px; }
</style>
</head>

<body>
<form runat="server">

<h2>📍 Update Location</h2>

Order ID:
<asp:TextBox ID="txtOrderId" runat="server"></asp:TextBox><br />

Lat:
<asp:TextBox ID="txtLat" runat="server"></asp:TextBox><br />

Lng:
<asp:TextBox ID="txtLng" runat="server"></asp:TextBox><br />

<asp:Button ID="btnUpdate" runat="server" Text="Update" OnClick="btnUpdate_Click" />

<div id="map"></div>

</form>

<script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>

<script>
var map = L.map('map').setView([19.0760,72.8777],13);

L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);

var marker;

map.on('click', function(e){
    var lat = e.latlng.lat.toFixed(6);
    var lng = e.latlng.lng.toFixed(6);

    document.getElementById('<%= txtLat.ClientID %>').value = lat;
    document.getElementById('<%= txtLng.ClientID %>').value = lng;

    if(marker) marker.setLatLng(e.latlng);
    else marker = L.marker(e.latlng).addTo(map);
});
</script>

</body>
</html>