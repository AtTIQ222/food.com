
-- ============================================
-- FOOD.COM DATABASE SCHEMA
-- Complete Database Design with Normalization (3NF)
-- ============================================

-- Drop existing database if exists
DROP DATABASE IF EXISTS foodcom;
CREATE DATABASE foodcom;
USE foodcom;

-- ============================================
-- TABLE 1: USER
-- Stores all user information
-- ============================================
CREATE TABLE user (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    phone VARCHAR(15),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_email CHECK (email LIKE '%@%.%')
);

-- ============================================
-- TABLE 2: ADMIN
-- Stores admin user information
-- ============================================
CREATE TABLE admin (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    admin_username VARCHAR(50) NOT NULL UNIQUE,
    admin_password VARCHAR(255) NOT NULL,
    admin_email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABLE 3: CATEGORY
-- Stores recipe categories
-- ============================================
CREATE TABLE category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABLE 4: RECIPE
-- Stores all recipe information
-- ============================================
CREATE TABLE recipe (
    recipe_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    category_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    ingredients TEXT NOT NULL,
    steps TEXT NOT NULL,
    prep_time INT,
    cook_time INT,
    servings INT,
    image_url VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES category(category_id) ON DELETE CASCADE
);

-- ============================================
-- TABLE 5: COMMENT
-- Stores comments on recipes
-- ============================================
CREATE TABLE comment (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    recipe_id INT NOT NULL,
    user_id INT NOT NULL,
    comment_text TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (recipe_id) REFERENCES recipe(recipe_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
);

-- ============================================
-- TABLE 6: RATING
-- Stores recipe ratings (Normalized separately)
-- ============================================
CREATE TABLE rating (
    rating_id INT AUTO_INCREMENT PRIMARY KEY,
    recipe_id INT NOT NULL,
    user_id INT NOT NULL,
    rating_value INT NOT NULL CHECK (rating_value BETWEEN 1 AND 5),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (recipe_id) REFERENCES recipe(recipe_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_recipe_rating (recipe_id, user_id)
);

-- ============================================
-- INSERT SAMPLE DATA
-- ============================================

-- Insert Categories
INSERT INTO category (category_name, description) VALUES
('Desserts', 'Sweet dishes and desserts'),
('Fast Food', 'Quick and easy fast food recipes'),
('Main Course', 'Main dishes for lunch and dinner'),
('Breakfast', 'Morning breakfast recipes'),
('Beverages', 'Drinks and beverages'),
('Appetizers', 'Starters and appetizers'),
('Salads', 'Healthy salad recipes');

-- Insert Sample Users
INSERT INTO user (username, email, password, full_name, phone) VALUES
('atif_khan', 'atif@gmail.com', 'pass123', 'Atif Khan', '03001234567'),
('sara_ahmed', 'sara@gmail.com', 'pass456', 'Sara Ahmed', '03009876543'),
('ali_hassan', 'ali@gmail.com', 'pass789', 'Ali Hassan', '03111234567');

-- Insert Admin
INSERT INTO admin (admin_username, admin_password, admin_email) VALUES
('admin', 'admin123', 'admin@foodcom.pk');

-- Insert Sample Recipes
INSERT INTO recipe (user_id, category_id, title, ingredients, steps, prep_time, cook_time, servings, image_url) VALUES
(1, 1, 'Chocolate Cake', 'Flour, Sugar, Cocoa, Eggs, Butter', 'Mix ingredients, Bake at 180C for 30 mins', 15, 30, 8, 'chocolate_cake.jpg'),
(1, 2, 'Chicken Burger', 'Chicken, Bun, Lettuce, Mayo, Cheese', 'Grill chicken, Assemble burger', 10, 15, 2, 'burger.jpg'),
(2, 3, 'Biryani', 'Rice, Chicken, Spices, Yogurt, Onions', 'Cook chicken with spices, Layer with rice, Dum cook', 30, 45, 6, 'biryani.jpg'),
(2, 4, 'Pancakes', 'Flour, Milk, Eggs, Sugar, Baking powder', 'Mix batter, Cook on griddle', 5, 10, 4, 'pancakes.jpg'),
(3, 5, 'Mango Lassi', 'Mango, Yogurt, Sugar, Milk', 'Blend all ingredients', 5, 0, 2, 'lassi.jpg');

-- Insert Sample Comments
INSERT INTO comment (recipe_id, user_id, comment_text) VALUES
(1, 2, 'Delicious cake! Made it for my birthday'),
(1, 3, 'Perfect recipe, thanks for sharing'),
(2, 2, 'Best burger recipe ever!'),
(3, 1, 'Authentic biryani taste'),
(3, 3, 'My family loved it');

-- Insert Sample Ratings
INSERT INTO rating (recipe_id, user_id, rating_value) VALUES
(1, 2, 5),
(1, 3, 4),
(2, 2, 5),
(3, 1, 5),
(3, 3, 4),
(4, 1, 5),
(5, 2, 4);

-- ============================================
-- USEFUL QUERIES FOR YOUR PROJECT
-- ============================================

-- View all recipes with user and category info
-- SELECT r.recipe_id, r.title, u.username, c.category_name, r.created_at
-- FROM recipe r
-- JOIN user u ON r.user_id = u.user_id
-- JOIN category c ON r.category_id = c.category_id;

-- View recipe with comments
-- SELECT r.title, c.comment_text, u.username, c.created_at
-- FROM recipe r
-- JOIN comment c ON r.recipe_id = c.recipe_id
-- JOIN user u ON c.user_id = u.user_id
-- WHERE r.recipe_id = 1;

-- View recipe average rating
-- SELECT r.title, AVG(rt.rating_value) as avg_rating, COUNT(rt.rating_id) as total_ratings
-- FROM recipe r
-- LEFT JOIN rating rt ON r.recipe_id = rt.recipe_id
-- GROUP BY r.recipe_id;
