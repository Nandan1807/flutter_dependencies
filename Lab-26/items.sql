-- Database Schema
-- Table: Items
-- sql
CREATE TABLE Items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Sample Data for Items Table
-- sql
INSERT INTO Items (title, description)
VALUES
('Sample Item 1', 'This is a sample description for item 1'),
('Sample Item 2', 'This is a sample description for item 2');

-- Stored Procedures
-- 1. Procedure to Fetch All Items
-- sql
CREATE PROCEDURE GetAllItems()
BEGIN
    SELECT * FROM Items ORDER BY created_at DESC;
END

-- 2. Procedure to Add an Item
-- sql
CREATE PROCEDURE AddItem(IN itemTitle VARCHAR(255), IN itemDescription TEXT)
BEGIN
    INSERT INTO Items (title, description) VALUES (itemTitle, itemDescription);
END

-- 3. Procedure to Update an Item
-- sql
CREATE PROCEDURE UpdateItem(IN itemId INT, IN itemTitle VARCHAR(255), IN itemDescription TEXT)
BEGIN
    UPDATE Items
    SET title = itemTitle, description = itemDescription, updated_at = CURRENT_TIMESTAMP
    WHERE id = itemId;
END

-- 4. Procedure to Delete an Item
-- sql
CREATE PROCEDURE DeleteItem(IN itemId INT)
BEGIN
    DELETE FROM Items WHERE id = itemId;
END$$
