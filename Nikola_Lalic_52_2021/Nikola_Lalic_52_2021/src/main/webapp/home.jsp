<%@ page import="com.example.nikola_lalic_52_2021.database.Database" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.example.nikola_lalic_52_2021.utils.Game" %>
<%@ page import="java.text.DecimalFormat" %><%--
  Created by IntelliJ IDEA.
  User: Lalic
  Date: 6/16/2024
  Time: 3:26 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:useBean id="LogoutBean" class="com.example.nikola_lalic_52_2021.utils.Logout" scope="page"></jsp:useBean>
<jsp:setProperty name="LogoutBean" property="*"></jsp:setProperty>
<jsp:useBean id="BuyBean" class="com.example.nikola_lalic_52_2021.utils.BuyBean" scope="page"></jsp:useBean>
<jsp:setProperty name="BuyBean" property="*"></jsp:setProperty>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <script src="script/script.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Game Ranger</title>
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

        #coming-soon
        {
            text-align: center;
            margin: 30px;
        }

        #explore-games
        {
            text-align: center;
            margin: 20px;
            margin-top: 40px;
        }
        .game-cards {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 20px;
            padding: 20px;
        }
        .game-card {
            width: 300px;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #333;
            text-align: center;
            color: #fff;
        }
        .dugmeDodaj {
            background-color: #73c476;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .dugmeDodaj:hover {
            background-color: #555;
        }

        .slideshow-container {
            max-width: 1000px;
            position: relative;
            margin: auto;
        }

        .prev, .next {
            cursor: pointer;
            position: absolute;
            top: 50%;
            width: auto;
            margin-top: -22px;
            padding: 16px;
            color: white;
            font-weight: bold;
            font-size: 18px;
            transition: 0.6s ease;
            border-radius: 0 3px 3px 0;
            user-select: none;
        }

        .next {
            right: 0;
            border-radius: 3px 0 0 3px;
        }

        .prev:hover, .next:hover {
            background-color: rgba(0,0,0,0.8);
        }

        .text {
            color: #f2f2f2;
            font-size: 15px;
            padding: 8px 12px;
            position: absolute;
            bottom: 8px;
            width: 100%;
            text-align: center;
        }

        .numbertext {
            color: #f2f2f2;
            font-size: 12px;
            padding: 8px 12px;
            position: absolute;
            top: 0;
        }

        .dot {
            cursor: pointer;
            height: 15px;
            width: 15px;
            margin: 0 2px;
            background-color: #bbb;
            border-radius: 50%;
            display: inline-block;
            transition: background-color 0.6s ease;
        }

        .active, .dot:hover {
            background-color: #717171;
        }

        .fade {
            animation-name: fade;
            animation-duration: 1.5s;
        }

        @keyframes fade {
            from {opacity: .4}
            to {opacity: 1}
        }

        .cardPicture
        {
            width: 90%;
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
        #listaZaKupovinu th,
        #listaZaKupovinu td {
            border: 1px solid #555;
            padding: 10px;
            text-align: left;
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

        #balance {
            color: #fff;
            background-color: #333;
            padding: 10px;
            border-radius: 5px;
            font-size: 16px;
        }

        #balance p {
            margin: 0;
            text-align: center;
        }

        #balance span {
            font-weight: bold;
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
    Database db;
    try {
        db = Database.getInstance();
    } catch (SQLException | ClassNotFoundException e) {
        throw new RuntimeException(e);
    }
    if (BuyBean.getGameId() != 0 && BuyBean.getPrice() <= (float) session.getAttribute("balance")) {
        float newBalance = (float) session.getAttribute("balance") - BuyBean.getPrice();
        db.BuyGame((String) session.getAttribute("username"), BuyBean.getGameId(), BuyBean.getPrice());
        session.setAttribute("balance", newBalance);
    }
    ArrayList<Game> games = db.GetGames((String) session.getAttribute("username"));
%>
<header>
    <img id="logo" src="images/logo.png" alt="Gaming Store Logo">
    <div id="nav-links">
        <a href="home.jsp">Home</a>

        <%
            if(session.getAttribute("username") != null) {
                if((int)session.getAttribute("admin") != 1)
                {
        %>
        <a href="myGames.jsp">My Games</a>
        <a href="myProfile.jsp">My Profile</a>
        <a href="applicationChat.jsp">Chat</a>

        <%
            }
            else
            {
                %>
                <a href="adminPage.jsp">Dashboard</a>
                <%
            }
            %>
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

<h1 id="coming-soon">Coming Soon...</h1>

<div class="slideshow-container">

    <div class="mySlides fade">
        <div class="numbertext">1 / 3</div>
        <img src="images/forhonor.jpg" style="width:100%">
        <div class="text">For Honor</div>
    </div>

    <div class="mySlides fade">
        <div class="numbertext">2 / 3</div>
        <img src="images/rust.jpg" style="width:100%">
        <div class="text"></div>
    </div>

    <div class="mySlides fade">
        <div class="numbertext">3 / 3</div>
        <img src="images/terraria.jpg" style="width:100%">
        <div class="text">Terraria</div>
    </div>

    <a class="prev" onclick="plusSlides(-1)">&#10094;</a>
    <a class="next" onclick="plusSlides(1)">&#10095;</a>
</div>
<br>

<div style="text-align:center">
    <span class="dot" onclick="currentSlide(1)"></span>
    <span class="dot" onclick="currentSlide(2)"></span>
    <span class="dot" onclick="currentSlide(3)"></span>
</div>

<h1 id="explore-games">Explore games</h1>
<%
    if(session.getAttribute("username")!=null)
    {
        %>
        <div id="balance">
            <p>Your Balance: $<span><%=session.getAttribute("balance")%></span></p>
        </div>
        <%
    }
%>

<div class="game-cards">
    <%
        for(Game game: games)
        {
            %>
                <div class="game-card">
                    <img class="cardPicture" src="images/<%=game.getImage()%>" alt="">
                    <h2><%=game.getName()%></h2>
                    <p>Price: $<%=game.getPrice()%></p>
                    <%
                        if(session.getAttribute("username")!=null){
                            if((int)session.getAttribute("admin")!=1) {
                                %>
                        <button class="dugmeDodaj" onclick="openConfirmationModal('<%=game.getName()%>', <%=game.getGameid()%>, <%=game.getPrice()%>)">Buy</button>

                        <%
                            }
                        }
                    %>

                </div>
            <%
        }
    %>
</div>
<div id="confirmationModal" class="modal">
    <div class="modal-content">
        <h2>Confirm Purchase</h2>
        <p>Are you sure you want to buy <span id="gameName"></span> for $<span id="gamePrice"></span>?</p>
        <form id="confirmationForm" action="home.jsp" method="post">
            <input type="hidden" id="gameIdInput" name="gameId">
            <input type="hidden" id="priceInput" name="price">
            <button type="submit">Yes</button>
            <button type="button" onclick="closeConfirmationModal()">Cancel</button>
        </form>
    </div>
</div>
<br>
<button id="helpButton" onclick="openHelpModal()">Help</button>

<div id="helpModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeHelpModal()">&times;</span>
        <h2>Help</h2>
        <p>Strana predvidjena za otkrivanje kao i kupovinu igara unutar ove aplikacije</p>
        <p>Slajder prikazuje igrice koje ce uskoro izaci na trziste</p>
        <p>Lista postojecih igara se nalazi ispod slajdera gde svaka igra ima mogucnost kupovine klikom na dugme "Buy" koje se dodaju u moju listu igara nakon kupovine (My Games)</p>
    </div>
</div>
<br>
<br>
<button id="helpButton" onclick="openHelpModal()">Help</button>

<div id="helpModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeHelpModal()">&times;</span>
        <h2>Help</h2>
        <p>Strana predvidjena adminima aplikacije da mogu da brisu igre, usere kao i dodaju nove igre.</p>
    </div>
</div>
<footer>
    <p>&copy; 2024 Game Ranger. All rights reserved. Nikola Lalic 52/2021.</p>
</footer>
<script>
    let slideIndex = 1;
    showSlides(slideIndex);

    function plusSlides(n) {
        showSlides(slideIndex += n);
    }

    function currentSlide(n) {
        showSlides(slideIndex = n);
    }

    function showSlides(n) {
        let i;
        let slides = document.getElementsByClassName("mySlides");
        let dots = document.getElementsByClassName("dot");
        if (n > slides.length) {slideIndex = 1}
        if (n < 1) {slideIndex = slides.length}
        for (i = 0; i < slides.length; i++) {
            slides[i].style.display = "none";
        }
        for (i = 0; i < dots.length; i++) {
            dots[i].className = dots[i].className.replace(" active", "");
        }
        slides[slideIndex-1].style.display = "block";
        dots[slideIndex-1].className += " active";
    }

    function openConfirmationModal(gameName, gameId, gamePrice) {
        document.getElementById('gameName').innerText = gameName;
        document.getElementById('gamePrice').innerText = gamePrice;
        document.getElementById('gameIdInput').value = gameId;
        document.getElementById('priceInput').value = gamePrice;
        document.getElementById('confirmationModal').style.display = 'block';
    }

    function closeConfirmationModal() {
        document.getElementById('confirmationModal').style.display = 'none';
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
