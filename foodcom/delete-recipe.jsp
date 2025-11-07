<%@page import="java.sql.*"%>
<%
    if(session.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = (int) session.getAttribute("user_id");
    int recipeId = Integer.parseInt(request.getParameter("id"));

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/foodcom", "root", "");

        // Verify that the recipe belongs to the user
        String query = "DELETE FROM recipe WHERE recipe_id=? AND user_id=?";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, recipeId);
        ps.setInt(2, userId);

        int result = ps.executeUpdate();
        ps.close();
        con.close();

        if(result > 0) {
            out.println("<script>alert('Recipe deleted successfully!'); window.location='dashboard.jsp';</script>");
        } else {
            out.println("<script>alert('Error deleting recipe!'); window.location='dashboard.jsp';</script>");
        }
    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>