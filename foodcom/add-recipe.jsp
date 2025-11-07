<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%
    if(session.getAttribute("user_id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    int userId = (int) session.getAttribute("user_id");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Recipe - FOOD.com</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .form-container {
            background: white;
            max-width: 800px;
            margin: 40px auto;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        h2 {
            color: #667eea;
            text-align: center;
            margin-bottom: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
        }
        input, select, textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            font-family: inherit;
            transition: border 0.3s;
        }
        input:focus, select:focus, textarea:focus {
            outline: none;
            border-color: #667eea;
        }
        textarea {
            min-height: 120px;
            resize: vertical;
        }
        .form-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
        }
        button {
            width: 100%;
            padding: 14px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s;
        }
        button:hover {
            background: #764ba2;
        }
        .back-link {
            text-align: center;
            margin-top: 20px;
        }
        .back-link a {
            color: #667eea;
            text-decoration: none;
        }
        .message {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
        }
        .success {
            background: #d4edda;
            color: #155724;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2>🍴 Add New Recipe</h2>

        <form action="add-recipe.jsp" method="post">
            <div class="form-group">
                <label for="title">Recipe Title *</label>
                <input type="text" id="title" name="title" required>
            </div>

            <div class="form-group">
                <label for="category">Category *</label>
                <select id="category" name="category_id" required>
                    <option value="">Select Category</option>
<%
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/foodcom", "root", "");
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery("SELECT * FROM category ORDER BY category_name");

        while(rs.next()) {
            out.println("<option value='" + rs.getInt("category_id") + "'>" + 
                       rs.getString("category_name") + "</option>");
        }

        rs.close();
        st.close();
        con.close();
    } catch(Exception e) {
        out.println("<option>Error loading categories</option>");
    }
%>
                </select>
            </div>

            <div class="form-group">
                <label for="ingredients">Ingredients *</label>
                <textarea id="ingredients" name="ingredients" placeholder="Enter ingredients (one per line)" required></textarea>
            </div>

            <div class="form-group">
                <label for="steps">Cooking Steps *</label>
                <textarea id="steps" name="steps" placeholder="Enter cooking steps (one per line)" required></textarea>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="prep_time">Prep Time (mins)</label>
                    <input type="number" id="prep_time" name="prep_time" min="0">
                </div>

                <div class="form-group">
                    <label for="cook_time">Cook Time (mins)</label>
                    <input type="number" id="cook_time" name="cook_time" min="0">
                </div>

                <div class="form-group">
                    <label for="servings">Servings</label>
                    <input type="number" id="servings" name="servings" min="1">
                </div>
            </div>

            <div class="form-group">
                <label for="image_url">Image URL (optional)</label>
                <input type="text" id="image_url" name="image_url" placeholder="http://example.com/image.jpg">
            </div>

            <button type="submit">Add Recipe</button>
        </form>

        <div class="back-link">
            <a href="dashboard.jsp">← Back to Dashboard</a>
        </div>
    </div>

<%
    if(request.getMethod().equals("POST")) {
        String title = request.getParameter("title");
        int categoryId = Integer.parseInt(request.getParameter("category_id"));
        String ingredients = request.getParameter("ingredients");
        String steps = request.getParameter("steps");
        String prepTime = request.getParameter("prep_time");
        String cookTime = request.getParameter("cook_time");
        String servings = request.getParameter("servings");
        String imageUrl = request.getParameter("image_url");

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/foodcom", "root", "");

            String query = "INSERT INTO recipe (user_id, category_id, title, ingredients, steps, prep_time, cook_time, servings, image_url) " +
                          "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(query);

            ps.setInt(1, userId);
            ps.setInt(2, categoryId);
            ps.setString(3, title);
            ps.setString(4, ingredients);
            ps.setString(5, steps);
            ps.setInt(6, prepTime != null && !prepTime.isEmpty() ? Integer.parseInt(prepTime) : 0);
            ps.setInt(7, cookTime != null && !cookTime.isEmpty() ? Integer.parseInt(cookTime) : 0);
            ps.setInt(8, servings != null && !servings.isEmpty() ? Integer.parseInt(servings) : 1);
            ps.setString(9, imageUrl);

            int result = ps.executeUpdate();

            if(result > 0) {
                out.println("<script>alert('Recipe added successfully!'); window.location='dashboard.jsp';</script>");
            }

            ps.close();
            con.close();

        } catch(Exception e) {
            out.println("<div class='message error'>Error: " + e.getMessage() + "</div>");
        }
    }
%>
</body>
</html>