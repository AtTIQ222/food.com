# FOOD.COM - Recipe Sharing System 🍴

**Student Name:** AttiQ Bahi  
**Semester:** 4th  
**Project Type:** JSP + Database Project  
**Teachers:** Sir Chetan (JSP) & Sir Dileep (Database)

---

## 📋 Project Overview

FOOD.com is a complete Recipe Sharing System built with JSP (Java Server Pages) and MySQL database. Users can:
- Register and login to their accounts
- Add, view, edit, and delete recipes
- Browse recipes by categories
- Comment on recipes
- View recipe details with ingredients and cooking steps

---

## 🗂️ Project Files Structure

### **JSP Files (Frontend + Backend):**
1. **index.html** - Home page with categories
2. **register.jsp** - User registration page
3. **login.jsp** - User login page
4. **dashboard.jsp** - User dashboard (after login)
5. **add-recipe.jsp** - Add new recipe form
6. **view-recipe.jsp** - View recipe details with comments
7. **recipes.jsp** - Browse all recipes with filters
8. **add-comment.jsp** - Add comment to recipe
9. **delete-recipe.jsp** - Delete recipe
10. **logout.jsp** - Logout functionality

### **Database Files:**
1. **foodcom_database.sql** - Complete MySQL database schema with sample data

---

## 🛠️ Installation & Setup Instructions

### **Step 1: Setup MySQL Database**

1. Open **MySQL Workbench** or **phpMyAdmin**
2. Import the database file:
   - Open `foodcom_database.sql` file
   - Execute the entire SQL script
   - This will create:
     - Database named `foodcom`
     - All tables (user, admin, category, recipe, comment, rating)
     - Sample data for testing

### **Step 2: Setup Apache Tomcat Server**

1. Download **Apache Tomcat 9.0** (if not installed)
2. Extract to: `C:\apache-tomcat-9.0.xx`
3. Download **MySQL Connector/J** (JDBC Driver):
   - Download from: https://dev.mysql.com/downloads/connector/j/
   - Extract `mysql-connector-java-x.x.xx.jar`
   - Copy to: `C:\apache-tomcat-9.0.xx\lib\`

### **Step 3: Deploy Project Files**

1. Create project folder in Tomcat webapps:
   ```
   C:\apache-tomcat-9.0.xx\webapps\foodcom\
   ```

2. Copy all JSP and HTML files to this folder:
   ```
   foodcom\
   ├── index.html
   ├── register.jsp
   ├── login.jsp
   ├── dashboard.jsp
   ├── add-recipe.jsp
   ├── view-recipe.jsp
   ├── recipes.jsp
   ├── add-comment.jsp
   ├── delete-recipe.jsp
   └── logout.jsp
   ```

### **Step 4: Start Apache Tomcat**

1. Go to: `C:\apache-tomcat-9.0.xx\bin\`
2. Double-click: **startup.bat**
3. Wait for server to start

### **Step 5: Access the Application**

Open your browser and go to:
```
http://localhost:8080/foodcom/index.html
```

---

## 🔐 Default Login Credentials

### **Test User Account:**
- **Username:** atif_khan
- **Password:** pass123

### **Test Admin Account:**
- **Username:** admin
- **Password:** admin123

---

## 📊 Database Design

### **Tables Created:**

1. **user** - Stores user information
   - user_id (PK)
   - username, email, password
   - full_name, phone
   - created_at

2. **admin** - Stores admin information
   - admin_id (PK)
   - admin_username, admin_password, admin_email

3. **category** - Recipe categories
   - category_id (PK)
   - category_name, description

4. **recipe** - Recipe information
   - recipe_id (PK)
   - user_id (FK), category_id (FK)
   - title, ingredients, steps
   - prep_time, cook_time, servings
   - image_url, created_at

5. **comment** - Recipe comments
   - comment_id (PK)
   - recipe_id (FK), user_id (FK)
   - comment_text, created_at

6. **rating** - Recipe ratings
   - rating_id (PK)
   - recipe_id (FK), user_id (FK)
   - rating_value (1-5)

### **Relationships:**
- 1 User → Many Recipes (One-to-Many)
- 1 Category → Many Recipes (One-to-Many)
- 1 User → Many Comments (One-to-Many)
- 1 Recipe → Many Comments (One-to-Many)
- 1 Recipe → Many Ratings (One-to-Many)

### **Normalization:**
- Database is normalized up to **3NF (Third Normal Form)**
- No redundant data
- All foreign key relationships properly defined
- Referential integrity maintained with ON DELETE CASCADE

---

## 🎯 Features Implemented

### **For Sir Chetan (JSP Requirements):**
✅ JSP files with HTML forms  
✅ Database connectivity using JDBC  
✅ PreparedStatement for SQL queries  
✅ Data insertion (INSERT)  
✅ Data retrieval (SELECT)  
✅ Data deletion (DELETE)  
✅ Session management for login  
✅ Form validation  

### **For Sir Dileep (Database Requirements):**
✅ Complete ERD (Entity Relationship Diagram)  
✅ All attributes defined  
✅ Proper data types selected  
✅ Primary Keys (PK) and Foreign Keys (FK)  
✅ Constraints (NOT NULL, UNIQUE, AUTO_INCREMENT)  
✅ Relationships (One-to-Many)  
✅ Entity identification  
✅ Normalization up to 3NF  

---

## 🧪 Testing the Application

### **Test Flow:**

1. **Homepage** → Browse categories
2. **Register** → Create new account
3. **Login** → Access dashboard
4. **Dashboard** → View your recipes and stats
5. **Add Recipe** → Create new recipe
6. **View Recipe** → See details and comments
7. **Browse Recipes** → Filter by category
8. **Add Comment** → Comment on recipes
9. **Delete Recipe** → Remove your recipe
10. **Logout** → End session

---

## 📝 Important Notes

### **Database Connection Settings:**
If your MySQL has a different password, update in all JSP files:

```java
Connection con = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/foodcom",
    "root",
    "YOUR_PASSWORD_HERE"  // Change this
);
```

### **Common Issues & Solutions:**

**Issue 1:** ClassNotFoundException for MySQL Driver
- **Solution:** Make sure `mysql-connector-java.jar` is in Tomcat's `lib` folder

**Issue 2:** Port 8080 already in use
- **Solution:** Change Tomcat port in `server.xml` or close other applications using port 8080

**Issue 3:** Database connection error
- **Solution:** Verify MySQL is running and credentials are correct

---

## 📚 Technologies Used

- **Frontend:** HTML5, CSS3, Inline Styles
- **Backend:** JSP (Java Server Pages)
- **Database:** MySQL 8.0
- **Server:** Apache Tomcat 9.0
- **JDBC:** MySQL Connector/J

---

## 🎓 Project Submission Checklist

✅ All JSP files created and working  
✅ Database schema designed and implemented  
✅ ERD diagram explained  
✅ Normalization up to 3NF completed  
✅ Sample data inserted  
✅ All CRUD operations working  
✅ User authentication implemented  
✅ Session management working  
✅ Comments system functional  
✅ README documentation provided  

---

## 📧 Contact

**Student:** AttiQ Bahi  
**Semester:** 4th  
**Project:** FOOD.com Recipe Sharing System

---

**© 2025 FOOD.com - Made by AttiQ Bahi**
