<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%
    int recipeId = Integer.parseInt(request.getParameter("id"));
    Integer currentUserId = (Integer) session.getAttribute("user_id");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Recipe - FOOD.com</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
        }
        .navbar {
            background: white;
            padding: 1rem 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .navbar h1 { color: #667eea; display: inline-block; }
        .navbar a {
            float: right;
            margin-left: 20px;
            padding: 10px 20px;
            text-decoration: none;
            color: white;
            background: #667eea;
            border-radius: 5px;
        }
        .container {
            max-width: 900px;
            margin: 40px auto;
            padding: 20px;
        }
        .recipe-card {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .recipe-card h2 {
            color: #667eea;
            margin-bottom: 20px;
        }
        .recipe-info {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
            margin: 20px 0;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 10px;
        }
        .info-item {
            text-align: center;
        }
        .info-item strong {
            display: block;
            color: #667eea;
            font-size: 1.5rem;
        }
        .section {
            margin: 30px 0;
        }
        .section h3 {
            color: #667eea;
            margin-bottom: 15px;
        }
        .comment-section {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        .comment {
            border-bottom: 1px solid #ddd;
            padding: 15px 0;
        }
        .comment:last-child { border-bottom: none; }
        .comment-form textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 8px;
            margin-bottom: 10px;
        }
        .btn {
            padding: 10px 20px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>🍴 FOOD.com</h1>
        <a href="dashboard.jsp">Dashboard</a>
        <a href="recipes.jsp">All Recipes</a>
    </div>
    <div class="container">
<%
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/foodcom", "root", "");

        String query = "SELECT r.*, u.username, u.full_name, c.category_name FROM recipe r " +
                      "JOIN user u ON r.user_id = u.user_id " +
                      "JOIN category c ON r.category_id = c.category_id " +
                      "WHERE r.recipe_id = ?";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, recipeId);
        ResultSet rs = ps.executeQuery();

        if(rs.next()) {
%>
        <div class="recipe-card">
            <h2><%= rs.getString("title") %></h2>
            <p><strong>By:</strong> <%= rs.getString("full_name") %> | <strong>Category:</strong> <%= rs.getString("category_name") %></p>

            <div class="recipe-info">
                <div class="info-item">
                    <strong><%= rs.getInt("prep_time") %></strong>
                    <span>Prep Time (mins)</span>
                </div>
                <div class="info-item">
                    <strong><%= rs.getInt("cook_time") %></strong>
                    <span>Cook Time (mins)</span>
                </div>
                <div class="info-item">
                    <strong><%= rs.getInt("servings") %></strong>
                    <span>Servings</span>
                </div>
            </div>

            <div class="section">
                <h3>📝 Ingredients</h3>
                <p><%= rs.getString("ingredients").replace("\n", "<br>") %></p>
            </div>

            <div class="section">
                <h3>👨‍🍳 Cooking Steps</h3>
                <p><%= rs.getString("steps").replace("\n", "<br>") %></p>
            </div>
        </div>
<%
        }
        rs.close();
        ps.close();
%>
        <div class="comment-section">
            <h3>💬 Comments</h3>
<%
        // Display comments
        String commentQuery = "SELECT c.*, u.username, u.full_name FROM comment c " +
                             "JOIN user u ON c.user_id = u.user_id " +
                             "WHERE c.recipe_id = ? ORDER BY c.created_at DESC";
        PreparedStatement ps2 = con.prepareStatement(commentQuery);
        ps2.setInt(1, recipeId);
        ResultSet rs2 = ps2.executeQuery();

        while(rs2.next()) {
            out.println("<div class='comment'>");
            out.println("<strong>" + rs2.getString("full_name") + "</strong>");
            out.println("<p>" + rs2.getString("comment_text") + "</p>");
            out.println("<small>" + rs2.getString("created_at") + "</small>");
            out.println("</div>");
        }

        rs2.close();
        ps2.close();

        // Add comment form if user is logged in
        if(currentUserId != null) {
%>
            <div class="comment-form">
                <h4>Add a Comment</h4>
                <form action="add-comment.jsp" method="post">
                    <input type="hidden" name="recipe_id" value="<%= recipeId %>">
                    <textarea name="comment_text" required placeholder="Write your comment..."></textarea>
                    <button type="submit" class="btn">Post Comment</button>
                </form>
            </div>
<%
        }

        con.close();
    } catch(Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>
        </div>
    </div>
</body>
</html>