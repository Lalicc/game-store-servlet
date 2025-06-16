<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.example.nikola_lalic_52_2021.database.Database" %>
<%@ page import="com.example.nikola_lalic_52_2021.utils.Game" %>
<%@ page import="java.sql.Array" %>
<%@ page import="com.example.nikola_lalic_52_2021.utils.User" %>
<html>
<head>
    <title>Gaming Chat</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #1f1f1f;
            margin: 0;
            padding: 0;
            color: #fff;
            overflow: hidden;
            display: flex;
            flex-direction: column;
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
            width: 100%;
            box-sizing: border-box;
        }

        #logo {
            max-width: 45px;
        }

        #nav-links {
            display: flex;
            gap: 30px;
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

        #chat-wrapper {
            display: flex;
            flex: 1;
            background-color: #333;
            border-radius: 10px;
            overflow: hidden;
            margin: 20px;
        }

        #user-list {
            width: 25%;
            background-color: #222;
            padding: 20px;
            border-right: 1px solid #555;
            overflow-y: auto;
        }

        .user {
            padding: 10px;
            border-bottom: 1px solid #555;
            cursor: pointer;
        }

        .user:hover {
            background-color: #444;
        }

        #chat-container {
            width: 75%;
            display: flex;
            flex-direction: column;
        }

        #messages {
            flex-grow: 1;
            padding: 20px;
            overflow-y: auto;
            border-bottom: 1px solid #555;
        }

        .message-container {
            margin-bottom: 10px;
            padding: 10px;
            border-radius: 5px;
            background-color: #444;
        }

        .username {
            font-weight: bold;
            color: #73c476;
        }

        .timestamp {
            font-size: 0.8em;
            color: #aaa;
        }

        .message-content {
            margin-top: 5px;
        }

        #input-container {
            display: flex;
            background-color: #222;
            padding: 10px;
        }

        #message {
            flex-grow: 1;
            padding: 10px;
            border: none;
            border-radius: 5px;
            background-color: #444;
            color: #fff;
        }

        #send-button {
            padding: 10px 20px;
            margin-left: 10px;
            border: none;
            border-radius: 5px;
            background-color: #73c476;
            color: #fff;
            cursor: pointer;
        }

        #send-button:hover {
            background-color: #555;
        }

        footer {
            background-color: #1f1f1f;
            color: #fff;
            padding: 20px;
            text-align: center;
            width: 100%;
            box-sizing: border-box;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.5);
        }

        .modal-content {
            background-color: #333;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #555;
            width: 80%;
            max-width: 600px;
            border-radius: 10px;
        }

        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }

        .close:hover,
        .close:focus {
            color: #fff;
            text-decoration: none;
            cursor: pointer;
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
    if(session.getAttribute("username") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    Database db;
    try {
        db = Database.getInstance();
    } catch (SQLException | ClassNotFoundException e) {
        throw new RuntimeException(e);
    }

    ArrayList<User> users = db.getAllUsers();
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

<div id="chat-wrapper">
    <div id="user-list">
        <%
            for(User u : users) {
                if(u.getAdmin() == 0) {
        %>
        <div class="user" onclick="showUserInfo('<%=u.getGamename()%>', '<%=u.getEmail()%>', '<%=u.getFirst_name()%>', '<%=u.getLast_name()%>')"><%=u.getGamename()%></div>
        <%
                }
            }
        %>
    </div>

    <div id="chat-container">
        <div id="messages"></div>
        <div id="input-container">
            <input type="text" id="message" placeholder="Type a message"/>
            <button id="send-button" onclick="sendMessage()">Send</button>
        </div>
    </div>
</div>

<div id="userModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal()">&times;</span>
        <h2>User Info</h2>
        <p id="user-info"></p>
    </div>
</div>
<button id="helpButton" onclick="openHelpModal()">Help</button>

<div id="helpModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeHelpModal()">&times;</span>
        <h2>Help</h2>
        <p>Strana za komunikaciju sa drugim korisnicima aplikacije u realnom vremenu.</p>
        <p>Sa leve strane su prikazani korisnici koji su u cetu. Zelenom bojom je obelezen korisnik koji je ulogovan, dok su crvenom bojom obelezeni ostali ucesnici.</p>
        <p>Sa desne strane se nalazi cet.</p>
    </div>
</div>

<footer>
    <p>&copy; 2024 Game Ranger. All rights reserved. Nikola Lalic 52/2021.</p>
</footer>

<script type="text/javascript">
    let ws;
    let gamename = "<%= (String) session.getAttribute("gamename") %>";

    function sendMessage() {
        let message = document.getElementById("message").value;
        if (message.trim() !== "") {
            ws.send(message);
            document.getElementById("message").value = '';
        }
    }

    function updateUsersList(usernames) {
        const userList = document.getElementById("user-list");
        userList.innerHTML = '';
        usernames.forEach(username => {
            const userElement = document.createElement("div");
            userElement.className = "user";
            userElement.textContent = username;
            if (username === '<%= (String) session.getAttribute("gamename") %>') {
                userElement.style.color = "green";
            } else {
                userElement.style.color = "red";
            }
            userElement.onclick = () => showUserInfo(username);
            userList.appendChild(userElement);
        });
    }

    window.onload = function() {
        ws = new WebSocket("ws://localhost:8081/Nikola_Lalic_52_2021_war_exploded/gamingchat?gametag=" + encodeURIComponent(gamename));
        ws.onmessage = function(event) {
            const data = JSON.parse(event.data);

            if (data.type === "userList") {
                updateUsersList(data.users);
            } else if (data.type === "message") {
                const messages = document.getElementById("messages");
                const messageContainer = document.createElement('div');
                messageContainer.classList.add('message-container');

                const usernameElement = document.createElement('div');
                usernameElement.classList.add('username');
                usernameElement.innerHTML = '<strong>' + data.username + '</strong>';

                const timestampElement = document.createElement('div');
                timestampElement.classList.add('timestamp');
                timestampElement.textContent = data.timestamp;

                const messageContentElement = document.createElement('div');
                messageContentElement.classList.add('message-content');
                messageContentElement.textContent = data.message;

                messageContainer.appendChild(usernameElement);
                messageContainer.appendChild(timestampElement);
                messageContainer.appendChild(messageContentElement);

                messages.appendChild(messageContainer);
                messages.scrollTop = messages.scrollHeight;
            }
        };

    };

    function showUserInfo(username, email, firstName, lastName) {
        document.getElementById('user-info').innerHTML = 'Username: ' + username + '<br>Email: ' + email + '<br>First Name: ' + firstName + '<br>Last Name: ' + lastName;
        document.getElementById('userModal').style.display = 'block';
    }

    function closeModal() {
        document.getElementById('userModal').style.display = 'none';
    }

    window.onclick = function(event) {
        if (event.target == document.getElementById('userModal')) {
            closeModal();
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
