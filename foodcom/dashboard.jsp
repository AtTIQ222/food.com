<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%
    // Check if user is logged in
    if(session.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = (String) session.getAttribute("username");
    String fullName = (String) session.getAttribute("full_name");
    int userId = (int) session.getAttribute("user_id");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - FOOD.com</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
        }
        .navbar {
            background: white;
            padding: 1rem 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .navbar h1 {
            color: #667eea;
        }
        .navbar-right {
            display: flex;
            gap: 15px;
            align-items: center;
        }
        .navbar a {
            padding: 10px 20px;
            text-decoration: none;
            color: white;
            background: #667eea;
            border-radius: 5px;
            transition: 0.3s;
        }
        .navbar a:hover {
            background: #764ba2;
        }
        .user-info {
            color: #667eea;
            font-weight: bold;
        }
        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 20px;
        }
        .welcome-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            border-radius: 15px;
            margin-bottom: 30px;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        .stat-card h3 {
            color: #667eea;
            font-size: 2.5rem;
            margin-bottom: 10px;
        }
        .stat-card p {
            color: #666;
        }
        .section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .section h2 {
            color: #667eea;
            margin-bottom: 20px;
        }
        .recipe-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }
        .recipe-card {
            border: 2px solid #ddd;
            border-radius: 10px;
            padding: 20px;
            transition: 0.3s;
        }
        .recipe-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .recipe-card h3 {
            color: #667eea;
            margin-bottom: 10px;
        }
        .recipe-card p {
            color: #666;
            margin-bottom: 8px;
        }
        .btn {
            padding: 8px 16px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin-right: 10px;
        }
        .btn:hover {
            background: #764ba2;
        }
        .btn-danger {
            background: #dc3545;
        }
        .btn-danger:hover {
            background: #c82333;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>🍴 FOOD.com</h1>
        <div class="navbar-right">
            <span class="user-info">Welcome, <%= fullName %></span>
            <a href="add-recipe.jsp">Add Recipe</a>
            <a href="recipes.jsp">Browse All</a>
            <a href="logout.jsp">Logout</a>
        </div>
    </div>

    <div class="container">
        <div class="welcome-card">
            <h2>Welcome back, <%= fullName %>! 👨‍🍳</h2>
            <p>Start sharing your delicious recipes with the world!</p>
        </div>

        <div class="stats-grid">
<%
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/foodcom", "root", "");

        // Get total recipes by user
        PreparedStatement ps1 = con.prepareStatement("SELECT COUNT(*) FROM recipe WHERE user_id=?");
        ps1.setInt(1, userId);
        ResultSet rs1 = ps1.executeQuery();
        rs1.next();
        int myRecipes = rs1.getInt(1);

        // Get total comments by user
        PreparedStatement ps2 = con.prepareStatement("SELECT COUNT(*) FROM comment WHERE user_id=?");
        ps2.setInt(1, userId);
        ResultSet rs2 = ps2.executeQuery();
        rs2.next();
        int myComments = rs2.getInt(1);

        // Get total recipes in system
        Statement st = con.createStatement();
        ResultSet rs3 = st.executeQuery("SELECT COUNT(*) FROM recipe");
        rs3.next();
        int totalRecipes = rs3.getInt(1);
%>
            <div class="stat-card">
                <h3><%= myRecipes %></h3>
                <p>My Recipes</p>
            </div>
            <div class="stat-card">
                <h3><%= myComments %></h3>
                <p>My Comments</p>
            </div>
            <div class="stat-card">
                <h3><%= totalRecipes %></h3>
                <p>Total Recipes</p>
            </div>
<%
        rs1.close(); rs2.close(); rs3.close();
        ps1.close(); ps2.close(); st.close();
    } catch(Exception e) {
        out.println("<p>Error loading stats: " + e.getMessage() + "</p>");
    }
%>
        </div>

        <div class="section">
            <h2>My Recipes</h2>
            <div class="recipe-grid">
<%
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/foodcom", "root", "");

        String query = "SELECT r.*, c.category_name FROM recipe r " +
                       "JOIN category c ON r.category_id = c.category_id " +
                       "WHERE r.user_id=? ORDER BY r.created_at DESC LIMIT 6";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();

        if(!rs.next()) {
            out.println("<p>You haven't added any recipes yet. <a href='add-recipe.jsp'>Add your first recipe!</a></p>");
        } else {
            do {
%>
                <div class="recipe-card">
                    <h3><%= rs.getString("title") %></h3>
                    <p><strong>Category:</strong> <%= rs.getString("category_name") %></p>
                    <p><strong>Prep Time:</strong> <%= rs.getInt("prep_time") %> mins</p>
                    <p><strong>Cook Time:</strong> <%= rs.getInt("cook_time") %> mins</p>
                    <p><strong>Servings:</strong> <%= rs.getInt("servings") %></p>
                    <a href="view-recipe.jsp?id=<%= rs.getInt("recipe_id") %>" class="btn">View</a>
                    <a href="edit-recipe.jsp?id=<%= rs.getInt("recipe_id") %>" class="btn">Edit</a>
                    <a href="delete-recipe.jsp?id=<%= rs.getInt("recipe_id") %>" class="btn btn-danger" 
                       onclick="return confirm('Are you sure you want to delete this recipe?')">Delete</a>
                </div>
<%
            } while(rs.next());
        }

        rs.close();
        ps.close();
        con.close();
    } catch(Exception e) {
        out.println("<p>Error loading recipes: " + e.getMessage() + "</p>");
    }
%>
            </div>
        </div>
    </div>
</body>
</html>