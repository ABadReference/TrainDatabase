<%@ page import="java.sql.*, com.cs336.pkg.ApplicationDB, java.io.StringWriter, java.io.PrintWriter" %>
<%
    String userid = request.getParameter("username");
    String pwd = request.getParameter("password");

    if (userid == null || userid.isEmpty() || pwd == null || pwd.isEmpty()) {
        out.println("Please enter both username and password. <a href='login.jsp'>Try again</a>");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        // Establish or retrieve the database connection
        con = (Connection) session.getAttribute("dbConnection");
        if (con == null || con.isClosed()) {
            ApplicationDB db = new ApplicationDB();
            con = db.getConnection();
            session.setAttribute("dbConnection", con);
        }

        // Check if the user is a customer
        String query = "SELECT * FROM Customers WHERE username = ? AND password = ?";
        ps = con.prepareStatement(query);
        ps.setString(1, userid);
        ps.setString(2, pwd);
        rs = ps.executeQuery();

        if (rs.next()) {
            // User is a customer
            String firstName = rs.getString("Fname");
            session.setAttribute("user", userid);
            session.setAttribute("Fname", firstName);
            response.sendRedirect("userDashboard.jsp");
        } else {
            // Check if the user is an employee
            query = "SELECT e.ssn, e.isAdmin, e.isRep, c.Fname FROM Employees e " +
                    "JOIN Customers c ON e.username = c.username WHERE e.username = ? AND c.password = ?";
            ps = con.prepareStatement(query);
            ps.setString(1, userid);
            ps.setString(2, pwd);
            rs = ps.executeQuery();

            if (rs.next()) {
                // User is an employee
                String firstName = rs.getString("Fname");
                boolean isAdmin = rs.getBoolean("isAdmin");
                boolean isRep = rs.getBoolean("isRep");

                session.setAttribute("user", userid);
                session.setAttribute("Fname", firstName);

                if (isAdmin) {
                    // Redirect to Admin Dashboard
                    response.sendRedirect("adminDashboard.jsp");
                } else if (isRep) {
                    // Redirect to Representative Dashboard
                    response.sendRedirect("repDashboard.jsp");
                } else {
                    // If user is neither admin nor rep (unexpected case)
                    response.sendRedirect("loginError.jsp");
                }
            } else {
                // User not found
                response.sendRedirect("loginError.jsp");
            }
        }
    } catch (Exception e) {
        // Handle any exceptions and display error message
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        e.printStackTrace(pw);
        out.println(sw.toString());
        out.println("An error occurred while processing your request. <a href='login.jsp'>Try again</a>");
    } finally {
        // Close database resources
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
