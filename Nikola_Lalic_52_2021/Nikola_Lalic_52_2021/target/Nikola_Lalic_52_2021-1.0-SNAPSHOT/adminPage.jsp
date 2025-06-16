<%@ page import="com.example.nikola_lalic_52_2021.database.Database" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.example.nikola_lalic_52_2021.utils.Game" %>
<%@ page import="com.example.nikola_lalic_52_2021.utils.User" %>
<%@ page import="com.example.nikola_lalic_52_2021.utils.DeleteUserBean" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="DeleteUserBean" class="com.example.nikola_lalic_52_2021.utils.DeleteUserBean" scope="page"></jsp:useBean>
<jsp:setProperty name="DeleteUserBean" property="*"></jsp:setProperty>
<jsp:useBean id="DeleteGameBean" class="com.example.nikola_lalic_52_2021.utils.DeleteGameBean" scope="page"></jsp:useBean>
<jsp:setProperty name="DeleteGameBean" property="*"></jsp:setProperty>
<jsp:useBean id="LogoutBean" class="com.example.nikola_lalic_52_2021.utils.Logout" scope="page"></jsp:useBean>
<jsp:setProperty name="LogoutBean" property="*"></jsp:setProperty>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <script src="script/script.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Page - Game Ranger</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #1f1f1f;
            color: #fff;
            margin: auto;
            padding: 0;
            overflow-x: hidden;
        }

        header {
            background-color: #333;
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

        .admin-table {
            width: 90%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: #333;
        }

        .admin-table th, .admin-table td {
            border: 1px solid #555;
            padding: 10px;
            text-align: left;
        }

        .admin-table th {
            background-color: #444;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
        }

        .action-buttons button {
            padding: 5px 10px;
            cursor: pointer;
            border: none;
            border-radius: 5px;
        }

        .edit-button {
            background-color: #73c476;
            color: white;
        }

        .delete-button {
            background-color: #e74c3c;
            color: white;
        }

        .add-button {
            background-color: #3498db;
            color: white;
            margin: 20px auto;
            display: block;
        }

        .modal {
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

        .modal-content {
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

        .modal-content h2 {
            margin-top: 0;
        }

        .modal-content p {
            margin-bottom: 20px;
        }

        .modal-content form button {
            padding: 10px 20px;
            margin-right: 10px;
            cursor: pointer;
            border: none;
            border-radius: 5px;
        }

        .modal-content form button[type="submit"] {
            background-color: #73c476;
            color: white;
        }

        .modal-content form button[type="button"] {
            background-color: #555;
            color: #fff;
        }

        .modal-content form button[type="submit"]:hover,
        .modal-content form button[type="button"]:hover {
            opacity: 0.8;
        }

        .modal-content form button[type="button"]:focus {
            outline: none;
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

    </style>
</head>
<body>
<%
    if(session.getAttribute("username") == null)
    {
        response.sendRedirect("index.jsp");
        return;
    }
    if(LogoutBean.getFlag() != null && LogoutBean.getFlag().equals("1")) {
        session.invalidate();
        response.sendRedirect("index.jsp");
        return;
    }
    Database db;
    try {
        db = Database.getInstance();
    } catch (SQLException | ClassNotFoundException e) {
        throw new RuntimeException(e);
    }

    if(DeleteUserBean.getUsername()!=null)
    {
        db.DeleteUser(DeleteUserBean.getUsername());
    }
    if(DeleteGameBean.getGameId()!=0)
    {
        db.DeleteGame(DeleteGameBean.getGameId());
    }
    ArrayList<User> users = db.getAllUsers();
    ArrayList<Game> games = db.GetGames((String) session.getAttribute("username"));
%>
<header>
    <img id="logo" src="images/logo.png" alt="Gaming Store Logo">
    <div id="nav-links">
        <a href="home.jsp">Home</a>
        <a href="adminPage.jsp">Dashboard</a>
        <form action="adminPage.jsp" method="post">
            <input type="hidden" name="flag" value="1">
            <input class="logout-button" type="submit" value="Logout">
        </form>
    </div>
</header>

<h1 style="text-align:center">Admin Dashboard</h1>

<h2 style="text-align:center">Manage Users</h2>
<table class="admin-table">
    <thead>
    <tr>
        <th>Username</th>
        <th>Email</th>
        <th>First name</th>
        <th>Last name</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <%
        for(User user: users) {
    %>
    <tr>
        <td><%= user.getUsername() %></td>
        <td><%= user.getEmail() %></td>
        <td><%= user.getFirst_name() %></td>
        <td><%= user.getLast_name() %></td>
        <td class="action-buttons">
            <button class="delete-button" onclick="openDeleteUserModal('<%= user.getUsername() %>')">Delete</button>
        </td>
    </tr>
    <%
        }
    %>
    </tbody>
</table>

<h2 style="text-align:center">Manage Games</h2>
<table class="admin-table">
    <thead>
    <tr>
        <th>Game Name</th>
        <th>Price</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <%
        for(Game game: games) {
    %>
    <tr>
        <td><%= game.getName() %></td>
        <td>$<%= game.getPrice() %></td>
        <td class="action-buttons">
            <button class="delete-button" onclick="openDeleteGameModal('<%= game.getGameid() %>')">Delete</button>
        </td>
    </tr>
    <%
        }
    %>
    </tbody>
</table>
<div id="deleteUserModal" class="modal">
    <div class="modal-content">
        <h2>Confirm Delete</h2>
        <p>Are you sure you want to delete user <span id="deleteUsername"></span>?</p>
        <form action="adminPage.jsp" method="post">
            <input type="hidden" id="deleteUsernameInput" name="username">
            <button type="submit">Yes</button>
            <button type="button" onclick="closeDeleteUserModal()">Cancel</button>
        </form>
    </div>
</div>

<div id="deleteGameModal" class="modal">
    <div class="modal-content">
        <h2>Confirm Delete</h2>
        <p>Are you sure you want to delete this game?</p>
        <form action="adminPage.jsp" method="post">
            <input type="hidden" id="deleteGameId" name="gameId">
            <button type="submit">Yes</button>
            <button type="button" onclick="closeDeleteGameModal()">Cancel</button>
        </form>
    </div>
</div>
<button id="helpButton" onclick="openHelpModal()">Help</button>

<div id="helpModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeHelpModal()">&times;</span>
        <h2>Help</h2>
        <p>Dashboard strana je dostupna samo administratorima ove aplikacije.</p>
        <p>Daje nam mogucnost pregleda i brisanja usera i dostupnih igara.</p>
    </div>
</div>

<footer>
    <p>&copy; 2023 Game Ranger. All rights reserved.</p>
</footer>

<script>
    function openDeleteUserModal(username) {
        document.getElementById('deleteUsername').textContent = username;
        document.getElementById('deleteUsernameInput').value = username;
        document.getElementById('deleteUserModal').style.display = 'flex';
    }
    function closeDeleteUserModal() {
        document.getElementById('deleteUserModal').style.display = 'none';
    }

    function openDeleteGameModal(gameId) {
        document.getElementById('deleteGameId').value = gameId;
        document.getElementById('deleteGameModal').style.display = 'flex';
    }
    function closeDeleteGameModal() {
        document.getElementById('deleteGameModal').style.display = 'none';
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
