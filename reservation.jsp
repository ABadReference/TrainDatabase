<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <style>
        body {
            background-color: lightblue;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        h1 {
            color: black;
            text-align: center;
        }
        .container {
            width: 80%;
            margin: auto;
            background-color: lightgray;
            padding: 20px;
            border: 2px solid black;
            border-radius: 25px;
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
        }
        .left-section, .right-section {
            width: 45%;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
        }
        input, select, button {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid black;
            border-radius: 5px;
        }
        select, input[type="text"] {
            width: calc(100% - 20px);
        }
        button {
            background-color: #007bff;
            color: white;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table th, table td {
            border: 1px solid black;
            padding: 8px;
            text-align: center;
        }
        table th {
            background-color: #f2f2f2;
        }
        h2 {
            margin-top: 20px;
        }
        .footer {
            margin-top: 20px;
            display: flex;
            justify-content: flex-start;
        }
        .footer button {
            margin-top: 20px;
            margin-left: 100px; /* Move the button to the right */
            width: 200px;
        }
    </style>
    <head>
        <title>Reservation System</title>
    </head>
    <body>
        <h1>Reservation System</h1>
        <div class="container">
            <!-- Left Section -->
            <div class="left-section">
                <h2>Make a Reservation</h2>
                <div class="form-group">
                    <label for="train-route">Train Route:</label>
                    <select id="train-route" name="trainRoute">
                        <option value="T001">New Brunswick to Trenton</option>
                        <option value="T002">Trenton to New York</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="trip-type">Trip Type:</label>
                    <select id="trip-type" name="tripType">
                        <option value="one-way">One Way</option>
                        <option value="round-trip">Round Trip</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="reservation-date">Reservation Date:</label>
                    <input type="date" id="reservation-date" name="reservationDate" required>
                </div>
                <button type="submit">Reserve</button>
            </div>

            <!-- Right Section -->
            <div class="right-section">
                <h2>Manage Reservation</h2>
                <div class="form-group">
                    <label for="discount-type">Discount Type:</label>
                    <select id="discount-type" name="discountType">
                        <option value="none">None</option>
                        <option value="child">Child</option>
                        <option value="senior">Senior</option>
                        <option value="disabled">Disabled</option>
                    </select>
                    <button type="submit">Apply Discount</button>
                </div>
                <div class="form-group">
                    <label for="reservation-id">Reservation ID:</label>
                    <input type="text" id="reservation-id" name="reservationId" required>
                </div>
                <button type="submit">Cancel Reservation</button>
            </div>
        </div>

        <!-- Current Reservations -->
        <div class="container">
            <h2>Current Reservations</h2>
            <table>
                <thead>
                    <tr>
                        <th>Reservation ID</th>
                        <th>Train Route</th>
                        <th>Date</th>
                        <th>Trip Type</th>
                        <th>Total Fare</th>
                    </tr>
                </thead>
                <tbody>
                    <%-- Dynamic content for current reservations will go here --%>
                    <% 
                        Connection conn = null;
                        PreparedStatement ps = null;
                        ResultSet rs = null;
                        try {
                            conn = (Connection) session.getAttribute("dbConnection");
                            if (conn == null || conn.isClosed()) {
                                throw new Exception("Database connection is not available. Please log in again.");
                            }

                            String query = "SELECT r.reservation_id, s.origin, s.destination, r.date, r.trip_type, r.total_fare " +
                                           "FROM reservations r JOIN schedule s ON r.passenger_id = ?";

                            ps = conn.prepareStatement(query);
                            ps.setString(1, (String) session.getAttribute("username"));
                            rs = ps.executeQuery();

                            while (rs.next()) {
                                int reservationId = rs.getInt("reservation_id");
                                String origin = rs.getString("origin");
                                String destination = rs.getString("destination");
                                String date = rs.getString("date");
                                String tripType = rs.getString("trip_type");
                                String totalFare = rs.getString("total_fare");
                    %>
                    <tr>
                        <td><%= reservationId %></td>
                        <td><%= origin %> to <%= destination %></td>
                        <td><%= date %></td>
                        <td><%= tripType %></td>
                        <td>$<%= totalFare %></td>
                    </tr>
                    <% 
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
                        } finally {
                            if (rs != null) rs.close();
                            if (ps != null) ps.close();
                        }
                    %>
                </tbody>
            </table>
        </div>

        <!-- Footer Section -->
        <div class="footer">
            <form action="userDashboard.jsp" method="get">
                <button type="submit">Main Menu</button>
            </form>
        </div>
    </body>
</html>
