<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Browse Recipes - FOOD.com</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f5f5; }
        .navbar { background: white; padding: 1rem 2rem; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .navbar h1 { color: #667eea; display: inline-block; }
        .navbar a { float: right; margin-left: 20px; padding: 10px 20px; text-decoration: none; 
                   color: white; background: #667eea; border-radius: 5px; }
        .container { max-width: 1200px; margin: 40px auto; padding: 20px; }
        .filter-bar { background: white; padding: 20px; border-radius: 10px; margin-bottom: 30px; }
        .filter-bar select { padding: 10px; border: 2px solid #ddd; border-radius: 5px; margin-right: 10px; }
        .recipe-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; }
        .recipe-card { background: white; border-radius: 10px; padding: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); 
                      transition: 0.3s; cursor: pointer; }
        .recipe-card:hover { transform: translateY(-5px); box-shadow: 0 5px 20px rgba(0,0,0,0.2); }
        .recipe-card h3 { color: #667eea; margin-bottom: 10px; }
        .recipe-card p { color: #666; margin-bottom: 5px; }
        .btn { display: inline-block; padding: 8px 16px; background: #667eea; color: white; 
              text-decoration: none; border-radius: 5px; margin-top: 10px; }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>🍴 FOOD.com</h1>
        <a href="index.html">Home</a>
        <% if(session.getAttribute("user_id") != null) { %>
            <a href="dashboard.jsp">Dashboard</a>
        <% } else { %>
            <a href="login.jsp">Login</a>
        <% } %>
    </div>
    <div class="container">
        <h2 style="margin-bottom: 30px; color: #667eea;">Browse All Recipes</h2>

        <div class="filter-bar">
            <form action="recipes.jsp" method="get">
                <select name="category" onchange="this.form.submit()">
                    <option value="">All Categories</option>
<%
    String selectedCategory = request.getParameter("category");
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/foodcom", "root", "");
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery("SELECT * FROM category ORDER BY category_name");
        while(rs.next()) {
            String selected = (selectedCategory != null && selectedCategory.equals(rs.getString("category_id"))) ? "selected" : "";
            out.println("<option value='" + rs.getInt("category_id") + "' " + selected + ">" + 
                       rs.getString("category_name") + "</option>");
        }
        rs.close(); st.close(); con.close();
    } catch(Exception e) { }
%>
                </select>
            </form>
        </div>

        <div class="recipe-grid">
<%
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/foodcom", "root", "");

        String query = "SELECT r.*, u.username, u.full_name, c.category_name FROM recipe r " +
                      "JOIN user u ON r.user_id = u.user_id " +
                      "JOIN category c ON r.category_id = c.category_id ";

        if(selectedCategory != null && !selectedCategory.isEmpty()) {
            query += "WHERE r.category_id = ? ";
        }
        query += "ORDER BY r.created_at DESC";

        PreparedStatement ps = con.prepareStatement(query);
        if(selectedCategory != null && !selectedCategory.isEmpty()) {
            ps.setInt(1, Integer.parseInt(selectedCategory));
        }

        ResultSet rs = ps.executeQuery();

        while(rs.next()) {
%>
            <div class="recipe-card" onclick="location.href='view-recipe.jsp?id=<%= rs.getInt("recipe_id") %>'">
                <h3><%= rs.getString("title") %></h3>
                <p><strong>By:</strong> <%= rs.getString("full_name") %></p>
                <p><strong>Category:</strong> <%= rs.getString("category_name") %></p>
                <p><strong>Prep:</strong> <%= rs.getInt("prep_time") %> mins | 
                   <strong>Cook:</strong> <%= rs.getInt("cook_time") %> mins</p>
                <p><strong>Servings:</strong> <%= rs.getInt("servings") %></p>
                <a href="view-recipe.jsp?id=<%= rs.getInt("recipe_id") %>" class="btn">View Recipe</a>
            </div>
<%
        }
        rs.close(); ps.close(); con.close();
    } catch(Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>
        </div>
    </div>
</body>
</html>