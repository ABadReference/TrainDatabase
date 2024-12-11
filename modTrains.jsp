<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Train Schedule System</title>
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
            }
            .center {
                margin: 0 auto;
                width: 90%;
                background-color: lightgray;
                border: 2px solid black;
                border-radius: 15px;
                padding: 20px;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin: 20px 0;
            }
            table th, table td {
                border: 1px solid black;
                padding: 10px;
                text-align: center;
            }
            table th {
                background-color: #f2f2f2;
            }
            .button {
                padding: 5px 10px;
                margin: 5px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
            }
            .button:hover {
                background-color: #0056b3;
            }
        </style>
    </head>
    <body>
        <h1>Train Schedule System</h1>
        <div class="center">
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
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection conn = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;

                        try {
                            conn = (Connection) session.getAttribute("dbConnection");
                            if (conn == null || conn.isClosed()) {
                                throw new Exception("Database connection is not available. Please log in again.");
                            }

                            String query = "SELECT s.schedule_id, t.TrainID, s.origin, s.destination, s.departure_time, s.arrival_time, s.fare " +
                                           "FROM schedule s JOIN trains t ON s.train_id = t.TrainID";
                            ps = conn.prepareStatement(query);
                            rs = ps.executeQuery();

                            while (rs.next()) {
                                int schedule_id = rs.getInt("schedule_id");
                                String trainID = rs.getString("TrainID");
                                String origin = rs.getString("origin");
                                String destination = rs.getString("destination");
                                String departure_time = rs.getString("departure_time");
                                String arrival_time = rs.getString("arrival_time");
                                String fare = rs.getString("fare");
                    %>
                    <tr>
                        <td><%= trainID %></td>
                        <td><%= origin %></td>
                        <td><%= destination %></td>
                        <td><%= departure_time %></td>
                        <td>
                            <form action="updateSchedule.jsp" method="post">
                                <input type="hidden" name="schedule_id" value="<%= schedule_id %>">
                                <input type="time" name="arrival_time" value="<%= arrival_time.substring(11, 16) %>">
                        </td>
                        <td>
                                <input type="number" step="0.01" name="fare" value="<%= fare %>">
                        </td>
                        <td>
                                <button type="submit" class="button">Update</button>
                            </form>
                            <form action="deleteSchedule.jsp" method="post" style="display:inline;">
                                <input type="hidden" name="schedule_id" value="<%= schedule_id %>">
                                <button type="submit" class="button" style="background-color: red;">Delete</button>
                            </form>
                        </td>
                    </tr>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='7'>Error retrieving data: " + e.getMessage() + "</td></tr>");
                        } finally {
                            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </body>
</html>
