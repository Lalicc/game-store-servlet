package com.example.nikola_lalic_52_2021.database;

import com.example.nikola_lalic_52_2021.utils.Game;
import com.example.nikola_lalic_52_2021.utils.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.Dictionary;
import java.util.Hashtable;

public class Database {
    private Connection conn = null;
    private static Database instance = null;

    private Database() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gameranger", "root", "");
    }

    public static synchronized Database getInstance() throws SQLException, ClassNotFoundException {
        if (instance == null) {
            instance = new Database();
        }
        return instance;
    }

    public User getUser(String username, String password) throws SQLException {
        String query = "SELECT * FROM users WHERE username=? AND password=?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);
            stmt.setString(2, password);
            try (ResultSet rs = stmt.executeQuery()) {
                if(rs.next()) {
                    User user = new User();
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setEmail(rs.getString("email"));
                    user.setAdmin(rs.getInt("admin"));
                    user.setBalance(rs.getFloat("balance"));
                    user.setFirst_name(rs.getString("first_name"));
                    user.setLast_name(rs.getString("last_name"));
                    user.setGamename(rs.getString("gamename"));
                    return user;
                }
                return null;
            }
        }
    }

    public ArrayList<User> getAllUsers() throws SQLException {
        String query = "SELECT * FROM users";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            try (ResultSet rs = stmt.executeQuery()) {
                ArrayList<User> users = new ArrayList<>();
                while(rs.next()) {
                    User user = new User();
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setEmail(rs.getString("email"));
                    user.setAdmin(rs.getInt("admin"));
                    user.setBalance(rs.getFloat("balance"));
                    user.setFirst_name(rs.getString("first_name"));
                    user.setLast_name(rs.getString("last_name"));
                    user.setGamename(rs.getString("gamename"));
                    users.add(user);
                }
                return users;
            }
        }
    }

    public void CreateUser(String email, String firstName, String lastName, String password, String gamename, String username) throws SQLException {
        String query = "INSERT INTO users(email, password, balance, first_name, last_name, admin, gamename,username) VALUES(?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stm = conn.prepareStatement(query)) {
            stm.setString(1, email);
            stm.setString(2, password);
            stm.setFloat(3, 99.99F);
            stm.setString(4, firstName);
            stm.setString(5, lastName);
            stm.setInt(6, 0);
            stm.setString(7, gamename);
            stm.setString(8, username);
            stm.executeUpdate();
        }
    }
    public ArrayList<Game> GetGamesForUser(String username) throws SQLException {
        String query = "SELECT g.gameid, g.name, g.price, g.image, g.description FROM `games` g JOIN `library` l ON g.gameid = l.gameid WHERE l.username = ?";
        try (PreparedStatement stm = conn.prepareStatement(query)) {
            stm.setString(1, username);
            try (ResultSet rs = stm.executeQuery()) {

                ArrayList<Game> games = new ArrayList<>();
                while (rs.next()) {
                    Game game = new Game();
                    game.setGameid(rs.getInt("gameid"));
                    game.setName(rs.getString("name"));
                    game.setDescription(rs.getString("description"));
                    game.setPrice(rs.getFloat("price"));
                    game.setImage(rs.getString("image"));
                    games.add(game);
                }
                return games;
            }
        }
    }
    public ArrayList<Game> GetGames(String username) throws SQLException {
        String query = "SELECT * FROM games g WHERE NOT EXISTS ( SELECT 1 FROM library l WHERE l.GameID = g.GameID AND l.username = ? )";
        try (PreparedStatement stm = conn.prepareStatement(query)) {
            stm.setString(1, username);
            try (ResultSet rs = stm.executeQuery()) {
                ArrayList<Game> games = new ArrayList<>();
                while (rs.next()) {
                    Game game = new Game();
                    game.setGameid(rs.getInt("gameid"));
                    game.setName(rs.getString("name"));
                    game.setDescription(rs.getString("description"));
                    game.setPrice(rs.getFloat("price"));
                    game.setImage(rs.getString("image"));
                    games.add(game);
                }
                return games;
            }
        }
    }

    public Game getGame(int gameid) throws SQLException {
        String query = "SELECT * FROM games WHERE gameid=?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, gameid);
            try (ResultSet rs = stmt.executeQuery()) {
                if(rs.next()) {
                    Game game = new Game();
                    game.setGameid(rs.getInt("gameid"));
                    game.setName(rs.getString("name"));
                    game.setDescription(rs.getString("description"));
                    game.setPrice(rs.getFloat("price"));
                    game.setImage(rs.getString("image"));
                    return game;
                }
                return null;
            }
        }
    }
    public void BuyGame(String username, int gameId, float gamePrice) throws SQLException {
        String insertQuery = "INSERT INTO library(username, gameid) VALUES(?, ?)";
        String updateBalanceQuery = "UPDATE users SET balance = balance - ? WHERE username = ?";

        try (PreparedStatement stmInsert = conn.prepareStatement(insertQuery);
             PreparedStatement stmUpdateBalance = conn.prepareStatement(updateBalanceQuery)) {

            stmInsert.setString(1, username);
            stmInsert.setInt(2, gameId);
            stmInsert.executeUpdate();

            stmUpdateBalance.setFloat(1, gamePrice);
            stmUpdateBalance.setString(2, username);
            stmUpdateBalance.executeUpdate();
        }
    }
    public void DeleteUser(String username) throws SQLException {
        String deleteLibraryQuery = "DELETE FROM library WHERE username = ?";
        String deleteUserQuery = "DELETE FROM users WHERE username = ?";
        try (PreparedStatement deleteLibraryStmt = conn.prepareStatement(deleteLibraryQuery);
             PreparedStatement deleteUserStmt = conn.prepareStatement(deleteUserQuery)) {

            deleteLibraryStmt.setString(1, username);
            deleteLibraryStmt.executeUpdate();

            deleteUserStmt.setString(1, username);
            deleteUserStmt.executeUpdate();
        }
    }
    public void DeleteGame(int gameId) throws SQLException {
        String query = "DELETE FROM games WHERE gameid = ?";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, gameId);
            stmt.executeUpdate();
        }
    }
}
