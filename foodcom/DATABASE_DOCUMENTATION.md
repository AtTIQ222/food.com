# FOOD.COM - DATABASE DOCUMENTATION
## Complete Database Design & Normalization

**Project:** Recipe Sharing System  
**Student:** AttiQ Bahi  
**Semester:** 4th  
**Teacher:** Sir Dileep

---

## 📊 1. REQUIREMENTS ENGINEERING

### System Requirements:
The FOOD.com system allows users to:
1. **Register and Login** - Create accounts and authenticate
2. **Share Recipes** - Add recipes with details (title, ingredients, steps, time, servings)
3. **Categorize Recipes** - Organize recipes into categories (Desserts, Fast Food, etc.)
4. **Comment on Recipes** - Users can comment on any recipe
5. **Browse Recipes** - View all recipes and filter by category
6. **Rate Recipes** - Give ratings from 1-5 stars
7. **Manage Recipes** - Edit and delete own recipes

### Functional Requirements:
- User registration with unique email and username
- Secure login system
- Recipe CRUD operations (Create, Read, Update, Delete)
- Category-based recipe organization
- Comment system for user feedback
- Rating system for recipe quality
- Admin panel for system management

---

## 🗺️ 2. ERD (ENTITY RELATIONSHIP DIAGRAM)

### Entities:
1. **USER** - System users who share recipes
2. **ADMIN** - System administrators
3. **CATEGORY** - Recipe categories
4. **RECIPE** - Recipe details
5. **COMMENT** - Comments on recipes
6. **RATING** - Recipe ratings

### Relationships:

```
USER (1) ──────< (M) RECIPE
    │
    └──────< (M) COMMENT
    │
    └──────< (M) RATING

CATEGORY (1) ──────< (M) RECIPE

RECIPE (1) ──────< (M) COMMENT
    │
    └──────< (M) RATING
```

### Detailed ERD:

```
┌─────────────────┐
│     USER        │
├─────────────────┤
│ user_id (PK)    │
│ username        │
│ email           │
│ password        │
│ full_name       │
│ phone           │
│ created_at      │
└────────┬────────┘
         │ 1
         │
         │ M
    ┌────┴─────────────┐
    │     RECIPE       │
    ├──────────────────┤
    │ recipe_id (PK)   │
    │ user_id (FK)     │
    │ category_id (FK) │
    │ title            │
    │ ingredients      │
    │ steps            │
    │ prep_time        │
    │ cook_time        │
    │ servings         │
    │ image_url        │
    │ created_at       │
    └────────┬─────────┘
             │ 1
             │
             │ M
        ┌────┴──────────┐
        │   COMMENT     │
        ├───────────────┤
        │ comment_id(PK)│
        │ recipe_id (FK)│
        │ user_id (FK)  │
        │ comment_text  │
        │ created_at    │
        └───────────────┘

┌──────────────────┐
│    CATEGORY      │
├──────────────────┤
│ category_id (PK) │
│ category_name    │
│ description      │
│ created_at       │
└────────┬─────────┘
         │ 1
         │
         │ M
         └──> RECIPE
```

---

## 📝 3. ATTRIBUTES

### USER Table:
| Attribute    | Description                    |
|--------------|--------------------------------|
| user_id      | Unique user identifier         |
| username     | Unique username for login      |
| email        | User email address (unique)    |
| password     | Encrypted password             |
| full_name    | User's full name               |
| phone        | Contact phone number           |
| created_at   | Account creation timestamp     |

### ADMIN Table:
| Attribute        | Description                |
|------------------|----------------------------|
| admin_id         | Unique admin identifier         |
| admin_username   | Admin username          
|
| admin_password   | Admin password             |
| admin_email      | Admin email                |
| created_at       | Account creation timestamp |

### CATEGORY Table:
| Attribute      | Description                  |
|----------------|------------------------------|
| category_id    | Unique category identifier   |
| category_name  | Name of category             |
| description    | Category description         |
| created_at     | Creation timestamp           |

### RECIPE Table:
| Attribute     | Description                    |
|---------------|--------------------------------|
| recipe_id     | Unique recipe identifier       |
| user_id       | Foreign key to USER            |
| category_id   | Foreign key to CATEGORY        |
| title         | Recipe title                   |
| ingredients   | List of ingredients            |
| steps         | Cooking instructions           |
| prep_time     | Preparation time (minutes)     |
| cook_time     | Cooking time (minutes)         |
| servings      | Number of servings             |
| image_url     | Recipe image URL               |
| created_at    | Creation timestamp             |
| updated_at    | Last update timestamp          |

### COMMENT Table:
| Attribute     | Description                  |
|---------------|------------------------------|
| comment_id    | Unique comment identifier    |
| recipe_id     | Foreign key to RECIPE        |
| user_id       | Foreign key to USER          |
| comment_text  | Comment content              |
| created_at    | Comment timestamp            |

### RATING Table:
| Attribute     | Description                  |
|---------------|------------------------------|
| rating_id     | Unique rating identifier     |
| recipe_id     | Foreign key to RECIPE        |
| user_id       | Foreign key to USER          |
| rating_value  | Rating (1-5)                 |
| created_at    | Rating timestamp             |

---

## 🔢 4. DATA TYPES

### MySQL Data Types Used:

| Column Type          | Usage Example           | Purpose                      |
|---------------------|-------------------------|------------------------------|
| INT                 | user_id, recipe_id      | Integer identifiers          |
| AUTO_INCREMENT      | Primary keys            | Auto-generate IDs            |
| VARCHAR(50)         | username, category_name | Short text (max 50 chars)    |
| VARCHAR(100)        | email, full_name        | Medium text (max 100 chars)  |
| VARCHAR(150)        | title                   | Recipe titles                |
| VARCHAR(255)        | password, image_url     | Long text (max 255 chars)    |
| TEXT                | ingredients, steps      | Large text blocks            |
| DATETIME            | created_at, updated_at  | Date and time stamps         |
| CHECK               | rating_value (1-5)      | Value constraints            |

---

## 🔑 5. KEYS

### Primary Keys (PK):
- **USER:** user_id
- **ADMIN:** admin_id
- **CATEGORY:** category_id
- **RECIPE:** recipe_id
- **COMMENT:** comment_id
- **RATING:** rating_id

### Foreign Keys (FK):
1. **RECIPE.user_id** → USER.user_id
2. **RECIPE.category_id** → CATEGORY.category_id
3. **COMMENT.recipe_id** → RECIPE.recipe_id
4. **COMMENT.user_id** → USER.user_id
5. **RATING.recipe_id** → RECIPE.recipe_id
6. **RATING.user_id** → USER.user_id

### Unique Keys:
- USER.username (UNIQUE)
- USER.email (UNIQUE)
- ADMIN.admin_username (UNIQUE)
- ADMIN.admin_email (UNIQUE)
- CATEGORY.category_name (UNIQUE)
- RATING (recipe_id, user_id) - Composite UNIQUE (one rating per user per recipe)

---

## 🔒 6. CONSTRAINTS

### NOT NULL Constraints:
- All primary keys
- USER: username, email, password
- RECIPE: user_id, category_id, title, ingredients, steps
- COMMENT: recipe_id, user_id, comment_text
- RATING: recipe_id, user_id, rating_value

### UNIQUE Constraints:
- USER: username, email
- ADMIN: admin_username, admin_email
- CATEGORY: category_name
- RATING: Composite (recipe_id, user_id)

### CHECK Constraints:
- USER.email LIKE '%@%.%' (valid email format)
- RATING.rating_value BETWEEN 1 AND 5

### AUTO_INCREMENT:
- All primary keys automatically increment

### ON DELETE CASCADE:
- RECIPE: If user deleted → all their recipes deleted
- COMMENT: If recipe deleted → all comments deleted
- COMMENT: If user deleted → all their comments deleted
- RATING: If recipe deleted → all ratings deleted

### DEFAULT Values:
- created_at: CURRENT_TIMESTAMP
- updated_at: CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP

---

## 🔗 7. RELATIONSHIPS

### Relationship Table:

| Relationship         | Type        | Cardinality | Foreign Key            |
|---------------------|-------------|-------------|------------------------|
| USER → RECIPE       | One-to-Many | 1:M         | RECIPE.user_id         |
| CATEGORY → RECIPE   | One-to-Many | 1:M         | RECIPE.category_id     |
| USER → COMMENT      | One-to-Many | 1:M         | COMMENT.user_id        |
| RECIPE → COMMENT    | One-to-Many | 1:M         | COMMENT.recipe_id      |
| USER → RATING       | One-to-Many | 1:M         | RATING.user_id         |
| RECIPE → RATING     | One-to-Many | 1:M         | RATING.recipe_id       |

### Detailed Relationships:

1. **USER → RECIPE (1:M)**
   - One user can post many recipes
   - Each recipe belongs to exactly one user
   - Implementation: RECIPE.user_id references USER.user_id

2. **CATEGORY → RECIPE (1:M)**
   - One category can have many recipes
   - Each recipe belongs to exactly one category
   - Implementation: RECIPE.category_id references CATEGORY.category_id

3. **USER → COMMENT (1:M)**
   - One user can write many comments
   - Each comment is written by exactly one user
   - Implementation: COMMENT.user_id references USER.user_id

4. **RECIPE → COMMENT (1:M)**
   - One recipe can have many comments
   - Each comment is for exactly one recipe
   - Implementation: COMMENT.recipe_id references RECIPE.recipe_id

5. **USER → RATING (1:M)**
   - One user can rate many recipes
   - Each rating is given by exactly one user
   - Implementation: RATING.user_id references USER.user_id

6. **RECIPE → RATING (1:M)**
   - One recipe can have many ratings
   - Each rating is for exactly one recipe
   - Implementation: RATING.recipe_id references RECIPE.recipe_id

---

## 🏷️ 8. ENTITY IDENTIFICATION

| Entity Name | Table Name | Primary Key   | Purpose                          |
|-------------|-----------|---------------|----------------------------------|
| User        | user      | user_id       | System users who share recipes   |
| Admin       | admin     | admin_id      | System administrators            |
| Category    | category  | category_id   | Recipe categorization            |
| Recipe      | recipe    | recipe_id     | Recipe information and details   |
| Comment     | comment   | comment_id    | User comments on recipes         |
| Rating      | rating    | rating_id     | User ratings for recipes         |

---

## 📐 9. NORMALIZATION PROCESS

### First Normal Form (1NF):
✅ **Achieved**
- All attributes contain atomic values (no multi-valued attributes)
- Each column contains values of a single type
- Each column has a unique name
- Order doesn't matter

**Example:**
- Ingredients stored as TEXT (atomic value)
- Each user has one email, one phone (not arrays)

### Second Normal Form (2NF):
✅ **Achieved**
- Already in 1NF
- No partial dependencies (all non-key attributes depend on entire primary key)
- All tables have single-column primary keys

**Example:**
- In RECIPE table, all attributes (title, ingredients, steps) depend on recipe_id
- In COMMENT table, comment_text depends on comment_id (not just recipe_id or user_id)

### Third Normal Form (3NF):
✅ **Achieved**
- Already in 2NF
- No transitive dependencies (non-key attributes don't depend on other non-key attributes)
- All non-key attributes depend directly on primary key

**Example:**
- CATEGORY separated from RECIPE to avoid redundancy
- category_name stored only in CATEGORY table
- RECIPE only stores category_id (foreign key)

**Before Normalization (2NF but not 3NF):**
```
RECIPE: recipe_id, title, category_id, category_name, category_description
```
Problem: category_name depends on category_id (transitive dependency)

**After Normalization (3NF):**
```
RECIPE: recipe_id, title, category_id (FK)
CATEGORY: category_id, category_name, category_description
```

### Benefits of Normalization:
1. **No Data Redundancy** - Each piece of data stored once
2. **Data Integrity** - Consistent data across tables
3. **Easy Updates** - Update category name in one place
4. **No Anomalies** - No insertion, update, or deletion anomalies
5. **Scalability** - Easy to add new features

---

## 📊 10. SAMPLE DATA

### Categories:
1. Desserts
2. Fast Food
3. Main Course
4. Breakfast
5. Beverages
6. Appetizers
7. Salads

### Sample Users:
1. atif_khan (Atif Khan)
2. sara_ahmed (Sara Ahmed)
3. ali_hassan (Ali Hassan)

### Sample Recipes:
1. Chocolate Cake (Desserts)
2. Chicken Burger (Fast Food)
3. Biryani (Main Course)
4. Pancakes (Breakfast)
5. Mango Lassi (Beverages)

---

## 🎯 DATABASE FEATURES

### Referential Integrity:
- All foreign keys properly defined
- ON DELETE CASCADE for dependent records
- Maintains data consistency

### Data Validation:
- Email format validation
- Rating value range (1-5)
- Unique constraints on usernames and emails

### Indexing:
- Primary keys automatically indexed
- Foreign keys for faster joins
- Unique constraints create indexes

### Security:
- Password field for user authentication
- Separate admin table for system management

---

**© 2025 FOOD.com Database Design - By AttiQ Bahi**
