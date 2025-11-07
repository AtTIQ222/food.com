<%@page import="java.sql.*"%>
<%
    if(session.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = (int) session.getAttribute("user_id");
    int recipeId = Integer.parseInt(request.getParameter("recipe_id"));
    String commentText = request.getParameter("comment_text");

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/foodcom", "root", "");

        String query = "INSERT INTO comment (recipe_id, user_id, comment_text) VALUES (?, ?, ?)";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, recipeId);
        ps.setInt(2, userId);
        ps.setString(3, commentText);

        ps.executeUpdate();
        ps.close();
        con.close();

        response.sendRedirect("view-recipe.jsp?id=" + recipeId);
    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>