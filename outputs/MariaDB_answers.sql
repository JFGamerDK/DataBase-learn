-- MariaDB 期末上機考：解答版

USE finalexam;

-- A. 匯入後檢查
SELECT DATABASE();
SHOW TABLES;
DESCRIBE students;
SHOW CREATE TABLE students;

-- B. 資料表與資料 CRUD
DROP TABLE IF EXISTS books;
CREATE TABLE books (
    book_id INT NOT NULL AUTO_INCREMENT,
    title VARCHAR(80) NOT NULL,
    price INT DEFAULT 0,
    category VARCHAR(30),
    PRIMARY KEY (book_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO books (title, price, category) VALUES
('Database Systems', 850, 'Database'),
('MongoDB Basics', 620, 'Database'),
('Python Practice', 500, 'Programming');

UPDATE books
SET price = 680
WHERE title = 'MongoDB Basics';

ALTER TABLE books
MODIFY COLUMN price DECIMAL(8,2) NOT NULL DEFAULT 0;

ALTER TABLE books
ADD COLUMN stock INT NOT NULL DEFAULT 0;

ALTER TABLE books
RENAME COLUMN category TO subject;

SELECT * FROM books WHERE price < 550;
DELETE FROM books WHERE price < 550;
SELECT * FROM books ORDER BY book_id;

-- C1. 論文審查
SELECT DISTINCT viewer_id AS id
FROM comments
WHERE author_id = viewer_id
ORDER BY id;

-- C2. 熱門實驗室
SELECT l.name AS popular_lab
FROM labs AS l
JOIN students AS s ON s.lab_id = l.lab_id
WHERE s.id BETWEEN 202100000 AND 202199999
GROUP BY l.lab_id, l.name
HAVING COUNT(*) >= 3
ORDER BY l.lab_id;

-- C3. 櫥窗購物：WHERE o.order_id IS NULL 只能放在 LEFT JOIN 之後。
SELECT l.shopper_id, COUNT(*) AS count_no_buy
FROM logs AS l
LEFT JOIN orders AS o ON o.entered_id = l.entered_id
WHERE o.order_id IS NULL
GROUP BY l.shopper_id
ORDER BY l.shopper_id;

-- C4. 退選的組員：自我 LEFT JOIN。
SELECT t.student_id
FROM takes AS t
LEFT JOIN takes AS partner ON partner.student_id = t.parner_id
WHERE partner.student_id IS NULL
ORDER BY t.student_id;

-- C5. 通過率：AVG(0/1) 就是比例；LEFT JOIN 保留無人報名場次。
SELECT t.test_id, ROUND(AVG(s.result), 4) AS pass_rate
FROM tests AS t
LEFT JOIN signups AS s ON s.test_id = t.test_id
GROUP BY t.test_id
ORDER BY t.test_id;

-- 若題目要求無人報名時一定顯示 0：
SELECT t.test_id, COALESCE(ROUND(AVG(s.result), 4), 0) AS pass_rate
FROM tests AS t
LEFT JOIN signups AS s ON s.test_id = t.test_id
GROUP BY t.test_id
ORDER BY t.test_id;

-- D. View
CREATE OR REPLACE VIEW student_lab_view AS
SELECT s.id AS student_id, s.name AS student_name, l.name AS lab_name
FROM students AS s
LEFT JOIN labs AS l ON l.lab_id = s.lab_id;

SELECT *
FROM student_lab_view
WHERE lab_name = 'Cyber Security'
ORDER BY student_id;

CREATE OR REPLACE VIEW student_lab_view AS
SELECT s.id AS student_id, s.name AS student_name, l.name AS lab_name
FROM students AS s
LEFT JOIN labs AS l ON l.lab_id = s.lab_id
WHERE s.id BETWEEN 202100000 AND 202199999;

SHOW CREATE VIEW student_lab_view;
DROP VIEW IF EXISTS student_lab_view;

-- E. Windows 命令提示字元（cmd.exe）範例；請勿把這幾行當 SQL 執行。
-- 匯出：mariadb-dump -u root -p --databases finalexam > finalexam_backup.sql
-- 建庫：mariadb -u root -p -e "CREATE DATABASE finalexam_restore CHARACTER SET utf8mb4;"
-- 還原：mariadb -u root -p finalexam_restore < finalexam_backup.sql
-- 若備份使用 --databases，檔內會 USE finalexam；要改庫名時可改用：
-- mariadb-dump -u root -p finalexam > finalexam_tables.sql
-- mariadb -u root -p finalexam_restore < finalexam_tables.sql
-- MariaDB 互動模式也可用：SOURCE C:/完整路徑/finalexam.sql;

-- PowerShell 不支援 Bash/cmd 的輸入重導向 <；可改用：
-- cmd /c "mariadb -u root -p finalexam_restore < finalexam_tables.sql"

-- 投影片題目 #1 的使用者與權限範例（需管理員權限，請換成自己的學號與密碼）：
-- CREATE DATABASE nfu_40943199 CHARACTER SET utf8mb4;
-- CREATE USER 's3199'@'localhost' IDENTIFIED BY 'YourStrongPassword';
-- GRANT ALL PRIVILEGES ON nfu_40943199.* TO 's3199'@'localhost';
-- SHOW GRANTS FOR 's3199'@'localhost';

