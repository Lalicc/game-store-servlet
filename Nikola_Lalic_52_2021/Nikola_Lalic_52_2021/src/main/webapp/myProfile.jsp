<%--
  Created by IntelliJ IDEA.
  User: Lalic
  Date: 6/16/2024
  Time: 4:46 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="LogoutBean" class="com.example.nikola_lalic_52_2021.utils.Logout" scope="page"></jsp:useBean>
<jsp:setProperty name="LogoutBean" property="*"></jsp:setProperty>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <script src="../script/cgi.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Gaming Store</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #1f1f1f;
            margin: auto;
            padding: 0;
            color: #fff;
            overflow-x: hidden;
        }

        header {
            background-color: #333;
            color: #fff;
            text-align: left;
            padding: 1em;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        #logo {
            max-width: 45px;
        }

        #nav-links {
            display: flex;
            gap: 30px;
            margin-right: 20px;
        }

        #nav-links a {
            text-decoration: none;
            color: #fff;
            font-weight: bold;
            transition: color 0.3s ease;
        }

        #nav-links a:hover {
            color: #717171;
        }

        #profile-container {
            background-color: #333;
            margin: auto;
            width: 70vh;
            padding: 30px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
            text-align: center;
        }

        #profile-info {
            display: flex;
            flex-direction: column;
            text-align: left;
        }

        #profile-info p {
            margin: 10px 0;
        }

        .textt{
            display:inline;

        }
        strong, p {
            display: inline !important;
        }
        #helpButton {
            position: fixed;
            bottom: 20px;
            left: 20px;
            z-index: 1001;
            padding: 10px 20px;
            background-color: #73c476;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        #helpModal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.7);
            overflow: auto;
            justify-content: center;
            align-items: center;
        }

        #helpModal .modal-content {
            background-color: #1f1f1f;
            margin: auto;
            padding: 20px;
            border: 1px solid #555;
            border-radius: 5px;
            width: 80%;
            max-width: 500px;
            text-align: center;
            color: #fff;
            position: relative;
        }

        #helpModal h2 {
            margin-top: 0;
        }

        #helpModal p {
            margin-bottom: 20px;
        }

        .close {
            position: absolute;
            top: 10px;
            right: 10px;
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }

        .close:hover,
        .close:focus {
            color: #fff;
            text-decoration: none;
            cursor: pointer;
        }
        footer {
            background-color: #1f1f1f;
            color: #fff;
            padding: 20px;
            text-align: center;
            bottom: 0;
            width: 100%;
            border-top: #555 solid 1px;
        }
        .logout-button {
            background-color: #73c476;
            color: white;
            padding: 5px 8px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .logout-button:hover {
            background-color: #555;
        }
    </style>
</head>
<body>
<%
    if(LogoutBean.getFlag() != null && LogoutBean.getFlag().equals("1")) {
        session.invalidate();
        response.sendRedirect("index.jsp");
        return;
    }
%>
<header>
    <img id="logo" src="images/logo.png" alt="Gaming Store Logo">
    <div id="nav-links">
        <a href="home.jsp">Home</a>

        <%
            if(session.getAttribute("username") != null) {
        %>
        <a href="myGames.jsp">My Games</a>
        <a href="myProfile.jsp">My Profile</a>
        <a href="applicationChat.jsp">Chat</a>
        <form action="home.jsp" method="post">
            <input type="hidden" name="flag" value="1">
            <input class="logout-button" type="submit" value="Logout">
        </form>
        <%
        }
        else{%>
        <a href="index.jsp">Login</a>
        <a href="register.jsp">Register</a>
        <%}
        %>
    </div>
</header>
<br><br><br>
<div id="profile-container">

    <h2>My Profile</h2>
    <div id="profile-info">
        <br>
        <strong>Username: </strong><p id="username"><%= session.getAttribute("username")%></p>
        <strong>Email: </strong><p id="email"><%= session.getAttribute("email")%></p>
        <strong>GameTag: </strong><p id="gamename"><%= session.getAttribute("gamename")%></p>
        <strong>Balance: </strong><p id="balance"><%= session.getAttribute("balance")%>$</p>
        <strong>First name: </strong><p id="first_name"><%= session.getAttribute("firstName")%></p>
        <strong>Last name: </strong><p id="last_name"><%= session.getAttribute("lastName")%></p>

    </div>
</div>
<button id="helpButton" onclick="openHelpModal()">Help</button>

<div id="helpModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeHelpModal()">&times;</span>
        <h2>Help</h2>
        <p>Strana za prikaz osnovnih informacija o ulogovanom korisniku</p>
    </div>
</div>

<script>
    function openHelpModal() {
        document.getElementById('helpModal').style.display = 'block';
    }

    function closeHelpModal() {
        document.getElementById('helpModal').style.display = 'none';
    }

    window.onclick = function(event) {
        var modal = document.getElementById('helpModal');
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }

</script>
</body>
</html>
