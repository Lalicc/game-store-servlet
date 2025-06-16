package com.example.nikola_lalic_52_2021.utils;

import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.*;

@ServerEndpoint("/gamingchat")
public class Chat {
    private static final Set<Session> sessions = Collections.synchronizedSet(new HashSet<>());
    private static final Set<String> connectedUsers = Collections.synchronizedSet(new HashSet<>());

    private Connection connect() throws SQLException {
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/gameranger", "root", "");
    }

    @OnOpen
    public void onOpen(Session session) {
        String gametag = session.getRequestParameterMap().get("gametag").get(0);
        session.getUserProperties().put("gametag", gametag);
        sessions.add(session);
        connectedUsers.add(gametag); // Mark user as connected
        broadcastUserList();
        broadcastMessage("System", gametag + " has joined the chat.", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        String gametag = (String) session.getUserProperties().get("gametag");
        String timestamp = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        broadcastMessage(gametag, message, timestamp);
    }

    @OnClose
    public void onClose(Session session) {
        String gametag = (String) session.getUserProperties().get("gametag");
        sessions.remove(session);
        connectedUsers.remove(gametag); // Mark user as disconnected
        broadcastUserList();
        broadcastMessage("System", gametag + " has left the chat.", new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        throwable.printStackTrace();
    }

    private void broadcastMessage(String username, String message, String timestamp) {
        String messageJson = "{\"type\": \"message\", \"username\": \"" + username + "\", \"message\": \"" + message + "\", \"timestamp\": \"" + timestamp + "\"}";

        synchronized (sessions) {
            for (Session s : sessions) {
                if (s.isOpen()) {
                    s.getAsyncRemote().sendText(messageJson);
                }
            }
        }
    }


    private void broadcastUserList() {
        synchronized (sessions) {
            for (Session s : sessions) {
                if (s.isOpen()) {
                    String userListJson = createJsonUserList();
                    s.getAsyncRemote().sendText(userListJson);
                }
            }
        }
    }

    private String createJsonUserList() {
        List<String> userList = new ArrayList<>(connectedUsers);
        StringBuilder jsonBuilder = new StringBuilder();
        jsonBuilder.append("{ \"type\": \"userList\", \"users\": [");
        for (int i = 0; i < userList.size(); i++) {
            jsonBuilder.append("\"").append(userList.get(i)).append("\"");
            if (i < userList.size() - 1) {
                jsonBuilder.append(",");
            }
        }
        jsonBuilder.append("] }");
        return jsonBuilder.toString();
    }
}
