<%@ page import="java.sql.*, com.cs336.pkg.ApplicationDB, java.io.StringWriter, java.io.PrintWriter" %>
<%
    String userid = request.getParameter("username");
    String pwd = request.getParameter("password");

    if (userid.isEmpty() || pwd.isEmpty()) {
        out.println("Please enter both username and password. <a href='login.jsp'>Try again</a>");
        return;
    }
    
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        
        con = (Connection) session.getAttribute("dbConnection");
        out.println(con == null);
        if (con == null || con.isClosed()) {
            ApplicationDB db = new ApplicationDB();
            con = db.getConnection();
            session.setAttribute("dbConnection", con);
        }

        // Use PreparedStatement to prevent SQL injection
        String query = "SELECT * FROM User WHERE username = ? AND password = ?";
        ps = con.prepareStatement(query);
        ps.setString(1, userid);
        ps.setString(2, pwd);

        // Execute the query
        rs = ps.executeQuery();

        if (rs.next()) {
            String firstName = rs.getString("Fname");
            boolean isAdmin = rs.getBoolean("isAdmin");
            boolean isRep  = rs.getBoolean("isRep");
            session.setAttribute("user", userid);
            session.setAttribute("Fname", firstName);

            if (isAdmin) {
                response.sendRedirect("adminDashboard.jsp");
            }
            if (isRep) {
                response.sendRedirect("repDashboard.jsp");
            }
            response.sendRedirect("userDashboard.jsp");
        } 
        else {
            response.sendRedirect("loginError.jsp");
        }
    } catch (Exception e) {

        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);
        e.printStackTrace(pw);
        out.println(sw.toString());
        out.println("An error occurred while processing your request. <a href='login.jsp'>Try again</a>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
