<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VerifyOTP.aspx.cs" Inherits="cafe.VerifyOTP" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Verify OTP | Bittu Cafe</title>

    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI';
            background: linear-gradient(135deg, #000, #1a1a1a);
            color: white;
        }

        .box {
            max-width: 400px;
            margin: 100px auto;
            background: #111;
            padding: 30px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 0 20px rgba(255,165,0,0.3);
        }

        h2 {
            color: orange;
            margin-bottom: 20px;
        }

        .input {
            width: 100%;
            padding: 12px;
            border-radius: 10px;
            border: 1px solid #333;
            background: #000;
            color: white;
            margin-bottom: 15px;
            text-align: center;
            font-size: 18px;
            letter-spacing: 5px;
        }

        .input:focus {
            outline: none;
            border: 1px solid orange;
        }

        .btn {
            width: 100%;
            padding: 12px;
            background: linear-gradient(45deg, orange, #ff5e00);
            border: none;
            border-radius: 10px;
            color: black;
            font-weight: bold;
            cursor: pointer;
        }

        .btn:hover {
            transform: scale(1.05);
        }

        .msg {
            margin-top: 10px;
            color: red;
        }
    </style>
</head>

<body>
<form runat="server">

<div class="box">

    <h2>🔐 Enter OTP</h2>

    <asp:TextBox ID="txtOTP" runat="server"
        CssClass="input"
        placeholder="Enter 6-digit OTP"
        MaxLength="6" />

    <asp:Button ID="btnVerify" runat="server"
        Text="Verify OTP"
        CssClass="btn"
        OnClick="btnVerify_Click" />

    <asp:Label ID="lblMsg" runat="server" CssClass="msg"></asp:Label>

</div>

</form>
</body>
</html>