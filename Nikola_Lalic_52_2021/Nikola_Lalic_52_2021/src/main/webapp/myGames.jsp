<%@ page import="java.util.ArrayList" %>
<%@ page import="com.example.nikola_lalic_52_2021.utils.Game" %>
<%@ page import="com.example.nikola_lalic_52_2021.database.Database" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.List" %><%--
  Created by IntelliJ IDEA.
  User: Lalic
  Date: 6/16/2024
  Time: 4:47 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="LogoutBean" class="com.example.nikola_lalic_52_2021.utils.Logout" scope="page"></jsp:useBean>
<jsp:setProperty name="LogoutBean" property="*"></jsp:setProperty>
<%
    List<Game> games = new ArrayList<>();
    Database db;
    try {
        db = Database.getInstance();
    } catch (SQLException | ClassNotFoundException e) {
        throw new RuntimeException(e);
    }
    games = db.GetGamesForUser((String) session.getAttribute("username"));
%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <script src="script/script.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Games - Gaming Store</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #1f1f1f;
            color: #fff;
            margin: 0;
            padding: 0;
            height: 100vh;
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

        #cont
        {
            display: flex;
        }
        #sidebar {
            background-color: #333;
            width: 200px;
            padding: 20px;
            height: 100vh;
            border-top: #1f1f1f solid 1px;

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
        #sidebar ul {
            list-style-type: none;
            padding: 0;
            margin: 0;
        }

        #sidebar li {
            margin-bottom: 10px;
            cursor: pointer;
        }

        #main-content {
            flex-grow: 1;
            padding: 20px;
        }

        #game-details {
            background-color: #333;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
        }

        #game-details h2 {
            margin-bottom: 20px;
        }

        #game-list {
            display: flex;
            justify-content: space-between;
        }
        .item:hover
        {
            color: #6b6b6b;
        }

        .pic{
            width:700px;
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
<script>
    var games = [
        <% for (Game game : games) { %>
        {
            id: <%= game.getGameid() %>,
            name: "<%= game.getName() %>",
            description: "<%= game.getDescription() %>",
            image: "<%= game.getImage() %>"
        }<% if (games.indexOf(game) != games.size() - 1) { %>,<% } %>
        <% } %>
    ];
    console.log(games);
</script>
<body>
<%
    if(session.getAttribute("username") == null)
    {
        session.invalidate();
        response.sendRedirect("index.jsp");
        return;
    }
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

<div id="cont">
    <div id="sidebar">
        <h2>My Games</h2>
        <ul id="gameList">
            <%
                for(Game g : games) {
                %>
                    <li class="item" onclick="showGameDetails(<%= g.getGameid() %>)">
                        <%= g.getName() %>
                    </li>
                <%
                }
            %>
        </ul>
    </div>

    <div id="main-content">
        <div id="game-list">
            <div id="game-details">
                <h2 id="title">Game Details</h2>
                <div id="image"></div>
                <p id="game-description">Izaberite igru da vidite detalje.</p>
            </div>
        </div>
    </div>
</div>
<button id="helpButton" onclick="openHelpModal()">Help</button>

<div id="helpModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeHelpModal()">&times;</span>
        <h2>Help</h2>
        <p>Strana namenjena za prikaz mojih kupljenih igrica.</p>
        <p>Klikom na kupljenu igricu sa liste(levo), prikazuju se detalji o istoj..</p>
    </div>
</div>

<script>
    function showGameDetails(gameID) {
        var game = games.find(g => g.id === gameID);
        if (game) {
            console.log(`Loading image from: images/${game.image}`);
            document.querySelector("#title").innerText = game.name;
            document.querySelector("#game-description").innerText = game.description;
            document.querySelector("#image").innerHTML = '<img class="pic" src="images/' + game.image + '" alt="' + game.name + '">';
        } else {
            console.error('Game not found');
        }
    }

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
