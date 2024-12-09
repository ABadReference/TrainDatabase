<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <style>
        body {
            background-color: lightblue;
            font-family: Arial, sans-serif;
            text-align: center;
            margin: 0;
            padding: 0;
        }
        h1 {
            color: black;
            text-align: center;
        }
        .center {
            display: block;
            margin-left: auto;
            margin-right: auto;
        }
        div {
            width: 80%;
            padding: 20px;
            margin: 20px auto;
            text-align: center;
            background-color: lightgray;
            border: 2px solid black;
            border-radius: 25px;
        }
        fieldset {
            border: none;
            margin: auto;
        }
        .spacing {
            line-height: 1.5;
        }
        .margin {
            margin-top: 5px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        table th, table td {
            border: 1px solid black;
            padding: 8px;
            text-align: center;
        }
        table th {
            background-color: #f2f2f2;
        }
    </style>
    <head>
        <title>Train Schedule System - View Trains</title>
    </head>
    <body>
        <h1>Train Schedule System</h1>
        <div class="center">
            <fieldset class="spacing">
                <form action="searchTrain.jsp" method="post">
                    <label for="origin">Origin:</label>
                    <input type="text" id="origin" name="origin" required><br>
                    <label for="destination">Destination:</label>
                    <input type="text" id="destination" name="destination" required><br>
                    <label for="travelDate">Date of Travel:</label>
                    <input type="date" id="travelDate" name="travelDate" required><br>
                    <input class="margin" type="submit" value="Search">
                </form>
            </fieldset>
            <h2>Available Train Schedules</h2>
            <table>
                <thead>
                    <tr>
                        <th>Train Number</th>
                        <th>Origin</th>
                        <th>Destination</th>
                        <th>Departure Time</th>
                        <th>Arrival Time</th>
                        <th>Fare</th>
                        <th>Stops</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection conn = null;
                        Statement stmt = null;
                        ResultSet rs = null;

                        try {
                            conn = (Connection) session.getAttribute("dbConnection");
                            if (conn == null || conn.isClosed()) {
                                throw new Exception("Database connection is not available. Please log in again.");
                            }

                            String query = "SELECT t.TrainID, s.origin, s.destination, s.departure_time, s.arrival_time, s.fare " +
                                           "FROM schedule s JOIN trains t ON s.train_id = t.TrainID";
                            stmt = conn.createStatement();
                            rs = stmt.executeQuery(query);

                            // Loop through results and dynamically generate table rows
                            while (rs.next()) {
                                String trainID = rs.getString("TrainID");
                                String origin = rs.getString("origin");
                                String destination = rs.getString("destination");
                                String departureTime = rs.getString("departure_time");
                                String arrivalTime = rs.getString("arrival_time");
                                String fare = rs.getString("fare");
                    %>
                    <tr>
                        <td><%= trainID %></td>
                        <td><%= origin %></td>
                        <td><%= destination %></td>
                        <td><%= departureTime %></td>
                        <td><%= arrivalTime %></td>
                        <td>$<%= fare %></td>
                        <td><a href="stops.jsp?trainNumber=<%= trainID %>">View Stops</a></td>
                    </tr>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='7'>Error retrieving data: " + e.getMessage() + "</td></tr>");
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                        }
                    %>
                </tbody>
            </table>
            <fieldset class="spacing">
                <form action="sortTrains.jsp" method="post">
                    <label for="sortBy">Sort By:</label>
                    <select id="sortBy" name="sortBy">
                        <option value="departure">Departure Time</option>
                        <option value="arrival">Arrival Time</option>
                        <option value="fare">Fare</option>
                    </select>
                    <input class="margin" type="submit" value="Sort">
                </form>
            </fieldset>
        </div>
    </body>
</html>
