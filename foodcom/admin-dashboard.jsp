<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%
    // Check if admin is logged in
    if(session.getAttribute("admin_id") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    
    String adminUsername = (String) session.getAttribute("admin_username");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - FOOD.com</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
        }
        .navbar {
            background: #dc3545;
            padding: 1rem 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .navbar h1 { color: white; }
        .navbar-right {
            display: flex;
            gap: 15px;
            align-items: center;
        }
        .navbar a {
            padding: 10px 20px;
            text-decoration: none;
            color: white;
            background: rgba(255,255,255,0.2);
            border-radius: 5px;
            transition: 0.3s;
        }
        .navbar a:hover { background: rgba(255,255,255,0.3); }
        .admin-badge {
            background: white;
            color: #dc3545;
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: bold;
        }
        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 20px;
        }
        .welcome-card {
            background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
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
            color: #dc3545;
            font-size: 2.5rem;
            margin-bottom: 10px;
        }
        .stat-card p { color: #666; }
        .section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .section h2 {
            color: #dc3545;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background: #dc3545;
            color: white;
        }
        .btn-delete {
            padding: 5px 15px;
            background: #dc3545;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <h1>🔐 FOOD.com Admin Panel</h1>
        <div class="navbar-right">
            <span class="admin-badge">Admin: <%= adminUsername %></span>
            <a href="logout.jsp">Logout</a>
        </div>
    </div>

    <div class="container">
        <div class="welcome-card">
            <h2>Welcome Admin! 👨‍💼</h2>
            <p>Manage the entire FOOD.com system from here</p>
        </div>

        <div class="stats-grid">
<%
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/foodcom", "root", "");
        
        // Total Users
        Statement st1 = con.createStatement();
        ResultSet rs1 = st1.executeQuery("SELECT COUNT(*) FROM user");
        rs1.next();
        int totalUsers = rs1.getInt(1);
        
        // Total Recipes
        Statement st2 = con.createStatement();
        ResultSet rs2 = st2.executeQuery("SELECT COUNT(*) FROM recipe");
        rs2.next();
        int totalRecipes = rs2.getInt(1);
        
        // Total Comments
        Statement st3 = con.createStatement();
        ResultSet rs3 = st3.executeQuery("SELECT COUNT(*) FROM comment");
        rs3.next();
        int totalComments = rs3.getInt(1);
        
        // Total Categories
        Statement st4 = con.createStatement();
        ResultSet rs4 = st4.executeQuery("SELECT COUNT(*) FROM category");
        rs4.next();
        int totalCategories = rs4.getInt(1);
%>
            <div class="stat-card">
                <h3><%= totalUsers %></h3>
                <p>Total Users</p>
            </div>
            <div class="stat-card">
                <h3><%= totalRecipes %></h3>
                <p>Total Recipes</p>
            </div>
            <div class="stat-card">
                <h3><%= totalComments %></h3>
                <p>Total Comments</p>
            </div>
            <div class="stat-card">
                <h3><%= totalCategories %></h3>
                <p>Categories</p>
            </div>
<%
        rs1.close(); rs2.close(); rs3.close(); rs4.close();
        st1.close(); st2.close(); st3.close(); st4.close();
    } catch(Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>
        </div>

        <div class="section">
            <h2>All Users</h2>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Joined</th>
                </tr>
<%
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/foodcom", "root", "");
        
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery("SELECT * FROM user ORDER BY created_at DESC");
        
        while(rs.next()) {
%>
                <tr>
                    <td><%= rs.getInt("user_id") %></td>
                    <td><%= rs.getString("username") %></td>
                    <td><%= rs.getString("full_name") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td><%= rs.getString("phone") %></td>
                    <td><%= rs.getString("created_at") %></td>
                </tr>
<%
        }
        rs.close();
        st.close();
        con.close();
    } catch(Exception e) {
        out.println("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>");
    }
%>
            </table>
        </div>

        <div class="section">
            <h2>All Recipes</h2>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Author</th>
                    <th>Category</th>
                    <th>Created</th>
                </tr>
<%
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/foodcom", "root", "");
        
        String query = "SELECT r.*, u.username, c.category_name FROM recipe r " +
                      "JOIN user u ON r.user_id = u.user_id " +
                      "JOIN category c ON r.category_id = c.category_id " +
                      "ORDER BY r.created_at DESC";
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(query);
        
        while(rs.next()) {
%>
                <tr>
                    <td><%= rs.getInt("recipe_id") %></td>
                    <td><%= rs.getString("title") %></td>
                    <td><%= rs.getString("username") %></td>
                    <td><%= rs.getString("category_name") %></td>
                    <td><%= rs.getString("created_at") %></td>
                </tr>
<%
        }
        rs.close();
        st.close();
        con.close();
    } catch(Exception e) {
        out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
    }
%>
            </table>
        </div>
    </div>
</body>
</html>
