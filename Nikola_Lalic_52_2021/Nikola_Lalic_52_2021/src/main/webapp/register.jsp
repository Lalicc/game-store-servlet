<%@ page import="com.example.nikola_lalic_52_2021.database.Database" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.example.nikola_lalic_52_2021.utils.Register" %><%--
  Created by IntelliJ IDEA.
  User: Lalic
  Date: 6/16/2024
  Time: 3:22 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="RegisterBean" class="com.example.nikola_lalic_52_2021.utils.Register" scope="page"></jsp:useBean>
<jsp:setProperty name="RegisterBean" property="*"></jsp:setProperty>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <script src="../script/cgi.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Game Ranger</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #1f1f1f;
            color: #fff;
            margin: auto;
            width: 100vh;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
        }

        #register-container {
            background-color: #333;
            padding: 30px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
            text-align: center;
        }

        #register-form input {
            width: 600px;
            padding-top: 10px;
            padding-bottom: 10px;
            margin: 5px;
            border: none;
            border-radius: 3px;
            background-color: #555;
            color: #fff;
        }

        #register-form button {
            background-color: #73c476;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        #register-form button:hover {
            background-color: #555;
        }
        #log
        {
            text-decoration: none;
            color: #a1a0a0;
        }
        #log:hover{
            color: #555;
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
    if(session.getAttribute("username") != null){
        response.sendRedirect("home.jsp");
        return;
    }
    Database db = null;
    try {
        db = Database.getInstance();
    } catch (SQLException | ClassNotFoundException e) {
        throw new RuntimeException(e);
    }
%>
<div id="register-container">
    <h2>Register to Game Ranger</h2>
    <form id="register-form" method="post" action="register.jsp">
        <input type="text" id="first_name" name="first_name" placeholder=" First Name" required><br>
        <input type="text" id="last_name" name="last_name" placeholder=" Last Name" required><br>
        <input type="text" id="username" name="username" placeholder=" Username" required><br>
        <input type="password" id="password" name="password" placeholder=" Password" required><br>
        <input type="text" id="gamename" name="gamename" placeholder="Game Tag" required><br>
        <input type="email" id="email" name="email" placeholder=" Email" required><br><br>
        <input type="submit" value="Register" name="RegisterBean"><br>
        <span>Alredy have an account? </span><a id="log" href="index.jsp">Log in</a>
        <p style='color:red;' id='err'></p>
        <%
            if(RegisterBean.getUsername() != null){
                try
                {
                    db.CreateUser(RegisterBean.getEmail(), RegisterBean.getFirst_name(), RegisterBean.getLast_name(), RegisterBean.getPassword(), RegisterBean.getGamename(), RegisterBean.getUsername());
                    response.sendRedirect("index.jsp");
                    return;
                }
                catch (SQLException e)
                {
                    throw new RuntimeException(e);
                }
            }
        %>
    </form>
</div>
<button id="helpButton" onclick="openHelpModal()">Help</button>

<div id="helpModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeHelpModal()">&times;</span>
        <h2>Help</h2>
        <p>Strana za registraciju novih korisnika.</p>
        <p>Korisnik unosi osnovne podatke o sebi poput imena, prezimena, email-a itd i nakon toga moze pristupiti aplikaciji.</p>
        <p>Ukoliko korisnik vec ima nalog, ima opciju za odlazak na stranu Login.</p>
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
