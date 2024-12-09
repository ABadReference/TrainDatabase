<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("user") == null) {
%>
<!DOCTYPE html>
<html>
<head>
    <title>Not Logged In</title>
    <style>
        body {
            background-color: lightblue;
            font-family: Arial, sans-serif;
            text-align: center;
            padding-top: 50px;
        }
        a {
            text-decoration: none;
            color: #4285F4;
            font-size: 18px;
        }
    </style>
</head>
<body>
    <h2>You are not logged in</h2>
    <a href="login.jsp">Please Login</a>
</body>
</html>
<%
    } else {
        String username = (String) session.getAttribute("user");
        String firstName = (String) session.getAttribute("Fname");
        boolean isAdmin = (boolean) session.getAttribute("isAdmin")
%>
<!DOCTYPE html>
<html>
<head>
    <title>Train Schedule System - Welcome</title>
    <style>
        body {
            background-color: lightblue;
            font-family: Arial, sans-serif;
            text-align: center;
            margin: 0;
            padding: 0;
        }
        .center {
            display: block;
            margin-left: auto;
            margin-right: auto;
        }
        .content {
            border-radius: 25px;
            border: 2px solid black;
            background-color: lightgray;
            width: 300px;
            padding: 30px;
            margin: 20px auto;
        }
        .content h1 {
            color: black;
        }
        .content p {
            color: black;
            font-size: 18px;
        }
        .button {
            margin-top: 20px;
        }
        .button a {
            display: inline-block;
            background-color: #4285F4;
            color: #ffffff;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
        }
        .button a:hover {
            background-color: #3071A9;
        }
        .button b {
            display: inline-block;
            background-color: #4285F4;
            color: #ffffff;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
        }
        .button b:hover {
            background-color: #FF0000;
        }
    </style>
</head>
<body>
<% if (isAdmin) { %>
    <h1>Train Schedule System</h1>
    <div class="content" id="rcorner">
        <p><b>Welcome, <%= firstName %><b></p>
        <div class="button">
            <a href="editSchedule.jsp">Edit Customer Representative</a>
        </div>
        <div class="button">
            <a href="customerQueries.jsp">Review Customer Queries</a>
        </div>
        <div class="button">
            <a href="viewTrains.jsp">View Train Schedule</a>
        </div>
        <div class="button">
            <a href="customerReservations.jsp">View Reservations</a>
        </div>
        <div class="button">
            <b href="logout.jsp">Log Out</b>
        </div>
    </div>
<% } else { %>
    <h1>Train Schedule System</h1>
    <div class="content" id="rcorner">
        <p><b>Welcome, <%= firstName %><b></p>
        <div class="button">
            <a href="editSchedule.jsp">Edit Train Schedule</a>
        </div>
        <div class="button">
            <a href="customerQueries.jsp">Review Customer Queries</a>
        </div>
        <div class="button">
            <a href="viewTrains.jsp">View Train Schedule</a>
        </div>
        <div class="button">
            <a href="customerReservations.jsp">View Reservations</a>
        </div>
        <div class="button">
            <b href="logout.jsp">Log Out</b>
        </div>
    </div>
    <% } %>
</body>
</html>
<%
    }
%>
