<%@ page import="com.example.nikola_lalic_52_2021.database.Database" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.Dictionary" %>
<%@ page import="com.example.nikola_lalic_52_2021.utils.User" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="LoginBean" scope="page" class="com.example.nikola_lalic_52_2021.utils.Login"></jsp:useBean>
<jsp:setProperty name="LoginBean" property="*"></jsp:setProperty>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login - Game Ranger</title>
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

    #login-container {
      background-color: #333;
      padding: 30px;
      border-radius: 5px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
      text-align: center;
    }

    #login-form input {
      width: 400px;
      padding-top: 10px;
      padding-bottom: 10px;
      margin: 10px;
      border: none;
      border-radius: 3px;
      background-color: #555;
      color: #fff;
    }

    #login-form button {
      background-color: #73c476;
      color: white;
      padding: 10px 15px;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      transition: background-color 0.3s ease;
    }

    #login-form button:hover {
      background-color: #555;
    }
    #cbb
    {
      width: 5% !important;
    }
    #reg
    {
      text-decoration: none;
      color: #a1a0a0;
    }
    #reg:hover{
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
  if(session.getAttribute("username") != null) {
    response.sendRedirect("home.jsp");
    return;
  }
  Database db;
  try {
    db = Database.getInstance();
  } catch (SQLException | ClassNotFoundException e) {
    throw new RuntimeException(e);
  }
%>
<div id="login-container">
  <h2>Login to Game Ranger</h2>
  <form id="login-form" action="index.jsp" method="post">
    <input type="text" id="username" name="username" placeholder=" Username" required><br>
    <input type="password" id="password" name="password" placeholder=" Password" required><br>
    <input type="submit" value="Log in" id="login"><br><br>
    <span>Don't have an account? </span><a id="reg" href="register.jsp">Register now</a><br>
    <a style="font-size: 13px; color: #765454; text-decoration: none;" href="home.jsp">Discover our gaming world!</a>
    <p style='color:red;' id='errorLog'></p>
    <%
      if(LoginBean.getUsername() != null && LoginBean.getPassword() !=null) {
        try {
          User user = db.getUser(LoginBean.getUsername(), LoginBean.getPassword());
          if(user!=null)
          {
            session.setAttribute("email", user.getEmail());
            session.setAttribute("firstName", user.getFirst_name());
            session.setAttribute("lastName", user.getLast_name());
            session.setAttribute("balance", user.getBalance());
            session.setAttribute("admin", user.getAdmin());
            session.setAttribute("gamename", user.getGamename());
            session.setAttribute("username", user.getUsername());
            response.sendRedirect("home.jsp");
            return;
          }
          else{
    %>
    <p id='errorLogin' style='color:red;'><b>Pogresni kredencijali!</b></p>
    <%
          }
        } catch (SQLException e) {
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
    <p>Strana za logovanje korisnika</p>
    <p>Nakon unosa username-a i password-a, korisnik ima mogucnost pristupa aplikaciji.</p>
    <p>Ima mogucnost registracije ukoliko nema nalog, kao i mogucnost pregleda trivijalnih delova aplikacije.</p>
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