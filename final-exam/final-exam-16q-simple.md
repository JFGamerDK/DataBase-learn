# 資料庫系統期末上機考：16 題原題簡化版

*MariaDB × MongoDB*

完全依照題庫、DDL 與範例的基本寫法；每題包含語法、操作步驟、實際指令與驗證方式。

不加入 CHARACTER SET、COLLATE、ENGINE、外鍵命名等延伸設定

請將「學號」「密碼」「檔案路徑」換成自己的資料。

> GitHub 線上預覽版：本檔由 Word 文件轉成 Markdown，方便直接在網頁閱讀。

## 使用原則

> **版本定位**　這份是考場照抄型版本。SQL 建表採 Final_Exam_DDL.sql 的寫法；題目 4 與查詢結果採 PPT 顯示的資料。

> **題庫差異**　提供的 Final_Exam.sql 內教授姓名與 PPT 不同，所以實際匯入後，教授姓名可能與 PPT 範例不同；只要筆數與關聯正確，查詢語法仍然正確。

> **MongoDB 第 16 題**　依題目提供的 aqi_simple.json，AQI 是字串。此簡化版照基本題型寫成 AQI: { $lt: '30' }；目前檔案會刪除 15 筆，PPT 的 19 筆是不同資料版本。

## 考場操作順序

題目 1-4 在 final_db_學號 操作。

題目 5 建立 nfu_學號，匯入 Final_Exam.sql；題目 6-12 在 nfu_學號 操作。

題目 13-16 先匯入 aqi_simple.json，再進入 mongosh 的 weather_db。

每題截圖都保留提示字元、完整指令、資料庫名稱與結果。

## 16 題索引

| 題號 | 主題 | 主要指令 |
| --- | --- | --- |
| 1 | 建立資料庫與管理員 | CREATE DATABASE / CREATE USER / GRANT |
| 2 | 建立 Professor、Transcript | CREATE TABLE / DESCRIBE |
| 3 | 教授與學生權限 | CREATE USER / GRANT / SHOW GRANTS |
| 4 | 新增兩張表資料 | INSERT INTO / SELECT |
| 5 | 資料庫匯出與匯入 | mariadb-dump / SOURCE |
| 6 | 更新成績 | UPDATE |
| 7 | 多表連接 | JOIN |
| 8 | 巢狀查詢 | IN |
| 9 | 相關子查詢 | EXISTS |
| 10 | 除法查詢 | NOT EXISTS |
| 11 | 分組統計 | COUNT / GROUP BY / HAVING |
| 12 | 建立與查詢 View | CREATE VIEW |
| 13 | 新增 MongoDB 文件 | insertOne |
| 14 | 查詢 MongoDB 文件 | find |
| 15 | 更新 MongoDB 文件 | updateMany |
| 16 | 刪除 MongoDB 文件 | deleteMany |

### 題目 1｜建立資料庫與管理員權限

> **題目要求**　建立 final_db_學號，新增 admin，並依 PPT 範例給予所有權限。

#### 通用語法

```sql
CREATE DATABASE 資料庫名稱;
USE 資料庫名稱;
CREATE USER '帳號'@'localhost' IDENTIFIED BY '密碼';
GRANT 權限 ON 資料庫或範圍 TO '帳號'@'localhost';
SHOW GRANTS FOR '帳號'@'localhost';
```

#### 操作步驟

使用 root 登入 MariaDB。

建立並切換到 final_db_學號。

建立 admin 帳號並授權。

使用 SHOW GRANTS 驗證。

**[系統終端機] 登入**

```powershell
mariadb -u root -p
```

**[MariaDB] 實際指令**

```sql
CREATE DATABASE final_db_學號;
USE final_db_學號;

CREATE USER 'admin'@'localhost' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost';

SHOW GRANTS FOR 'admin'@'localhost';
SELECT DATABASE();
```

> **照題庫寫法**　PPT 的 SHOW GRANTS 結果為 GRANT ALL PRIVILEGES ON *.*，因此本版照原圖使用 *.*。

### 題目 2｜建立 Professor 與 Transcript 資料表

> **題目要求**　依 Final_Exam_DDL.sql 建立兩張表，不加入 ENGINE、CHARSET、COLLATE 或自訂外鍵名稱。

> **建立前**　Department、Student、Course、Teaching 必須先存在，否則外鍵找不到參考表。若考場未預先建立，請先執行 DDL 檔中這四張表的 CREATE TABLE。

#### CREATE TABLE 通用語法

```sql
CREATE TABLE 資料表名稱 (
欄位名稱 資料型態 [限制],
PRIMARY KEY (主鍵欄位),
FOREIGN KEY (外鍵欄位) REFERENCES 參考表(參考欄位)
);
```

#### 依 DDL.sql 建立 Professor

```sql
CREATE TABLE Professor (
ProfId INTEGER,
Name CHAR(20) NOT NULL,
DeptId VARCHAR(2),
PRIMARY KEY (ProfId),
FOREIGN KEY (DeptId) REFERENCES Department(DeptId)
);
```

#### 依 DDL.sql 建立 Transcript

```sql
CREATE TABLE Transcript (
StudId INTEGER,
CrsCode VARCHAR(4),
Semester VARCHAR(5),
Grade CHAR(1),
PRIMARY KEY (StudId, CrsCode, Semester),
FOREIGN KEY (StudId) REFERENCES Student(StdId),
FOREIGN KEY (CrsCode) REFERENCES Course(CrsCode),
FOREIGN KEY (CrsCode, Semester)
REFERENCES Teaching(CrsCode, Semester)
);
```

#### 查詢詳細資料

```sql
DESCRIBE Professor;
DESCRIBE Transcript;

SHOW CREATE TABLE Professor;
SHOW CREATE TABLE Transcript;
```

> **截圖重點**　畫面要同時包含資料庫名稱、CREATE TABLE 或查詢語法，以及 DESCRIBE 結果。

### 題目 3｜其他角色權限設定

> **題目要求**　professor 可 SELECT、UPDATE Transcript；student 可 SELECT、INSERT Transcript。

#### 通用語法

```sql
CREATE USER '帳號'@'localhost' IDENTIFIED BY '密碼';
GRANT 權限1, 權限2 ON 資料庫.資料表
TO '帳號'@'localhost';
SHOW GRANTS FOR '帳號'@'localhost';
```

#### 實際指令

```sql
CREATE USER 'professor'@'localhost' IDENTIFIED BY '1234';
GRANT SELECT, UPDATE ON final_db_學號.Transcript
TO 'professor'@'localhost';
SHOW GRANTS FOR 'professor'@'localhost';

CREATE USER 'student'@'localhost' IDENTIFIED BY '1234';
GRANT SELECT, INSERT ON final_db_學號.Transcript
TO 'student'@'localhost';
SHOW GRANTS FOR 'student'@'localhost';
```

> **驗證**　SHOW GRANTS 應分別看到 SELECT, UPDATE 與 SELECT, INSERT。

### 題目 4｜新增 Professor 與 Transcript 資料

#### INSERT 通用語法

```sql
INSERT INTO 資料表名稱 VALUES (值1, 值2, ...);
SELECT * FROM 資料表名稱;
```

#### 依 PPT 新增 Professor

```sql
INSERT INTO Professor VALUES (401, '王一明', 43);
INSERT INTO Professor VALUES (402, '王二明', 43);
INSERT INTO Professor VALUES (403, '王三明', 40);
INSERT INTO Professor VALUES (404, '王四明', 26);
INSERT INTO Professor VALUES (405, '王五明', 26);
```

#### 依 PPT／DML 新增 Transcript

```sql
INSERT INTO Transcript VALUES (41026201, 1025, '2025B', '');
INSERT INTO Transcript VALUES (41026201, 1993, '2025B', '');
INSERT INTO Transcript VALUES (41040202, 1746, '2025B', '');
INSERT INTO Transcript VALUES (41040202, 1993, '2025B', '');
INSERT INTO Transcript VALUES (41043203, 1990, '2025A', '');
INSERT INTO Transcript VALUES (41043203, 1993, '2025B', '');
```

#### 查詢並截圖

```sql
SELECT * FROM Professor;
SELECT * FROM Transcript;
```

> **空白成績**　題庫 DML 使用空字串 ''，所以本版完全照原檔，不改成 NULL。

### 題目 5｜匯出與匯入考試資料庫

> **執行位置**　mariadb-dump 在 Windows CMD／PowerShell 執行；CREATE DATABASE、SOURCE 在 MariaDB 內執行。

#### 匯出通用語法

```powershell
mariadb-dump -u 帳號 -p 資料庫名稱 > 備份檔.sql
```

#### 匯出 final_db_學號

**[系統終端機]**

```powershell
mariadb-dump -u root -p final_db_學號 > final_db_學號.sql
```

#### 建立資料庫並匯入

**[MariaDB]**

```sql
CREATE DATABASE nfu_學號;
USE nfu_學號;
SOURCE ./Final_Exam.sql;
SHOW TABLES;
```

#### 在 nfu_學號重建三個角色

```sql
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost';

GRANT SELECT, UPDATE ON nfu_學號.Transcript
TO 'professor'@'localhost';
GRANT SELECT, INSERT ON nfu_學號.Transcript
TO 'student'@'localhost';
```

> **預期結果**　SHOW TABLES 應看到 course、department、professor、student、teaching、transcript 共 6 張表。

### 題目 6｜更新指定學生的成績

#### UPDATE 通用語法

```sql
UPDATE 資料表
SET 欄位 = 新值
WHERE 條件;
```

#### 先查、再改、再確認

```sql
SELECT * FROM Transcript
WHERE StudId = 41026201
AND CrsCode = '1993'
AND Semester = '2025B';

UPDATE Transcript
SET Grade = 'A'
WHERE StudId = 41026201
AND CrsCode = '1993'
AND Semester = '2025B';

SELECT * FROM Transcript
WHERE StudId = 41026201
AND CrsCode = '1993'
AND Semester = '2025B';
```

> **預期結果**　只更新 1 筆，Grade 顯示 A。

### 題目 7｜Join Queries：學生、課程與教授

#### JOIN 通用語法

```sql
SELECT 要顯示的欄位
FROM 表1
JOIN 表2 ON 表1.欄位 = 表2.欄位
JOIN 表3 ON 關聯條件;
```

#### 實際查詢

```sql
SELECT s.Name AS StudentName,
c.CrsName,
p.Name AS ProfessorName
FROM Transcript tr
JOIN Student s ON tr.StudId = s.StdId
JOIN Course c ON tr.CrsCode = c.CrsCode
JOIN Teaching t ON tr.CrsCode = t.CrsCode
AND tr.Semester = t.Semester
JOIN Professor p ON t.ProfId = p.ProfId;
```

| StudentName | CrsName | ProfessorName |
| --- | --- | --- |
| 王大明 | 真空與鍍膜技術 | 王五明 |
| 王大明 | 資料庫系統 | 王二明 |
| 林剛懷 | 模糊理論與應用 | 王三明 |
| 林剛懷 | 資料庫系統 | 王二明 |
| 賈克林 | 微處理機實習 | 王一明 |
| 賈克林 | 資料庫系統 | 王二明 |

> **關聯重點**　Transcript 連 Teaching 時，CrsCode 與 Semester 兩個欄位都要比對。

### 題目 8｜Nested Queries：修過資料庫系統的學生

#### IN 子查詢通用語法

```sql
SELECT 欄位 FROM 表
WHERE 欄位 IN (
SELECT 欄位 FROM 另一張表 WHERE 條件
);
```

#### 實際查詢

```sql
SELECT Name
FROM Student
WHERE StdId IN (
SELECT StudId
FROM Transcript
WHERE CrsCode IN (
SELECT CrsCode
FROM Course
WHERE CrsName = '資料庫系統'
)
);
```

| Name |
| --- |
| 王大明 |
| 林剛懷 |
| 賈克林 |

### 題目 9｜Correlated Nested Queries：教授曾授課的系所

#### EXISTS 通用語法

```sql
SELECT 外層欄位
FROM 外層資料表
WHERE EXISTS (
SELECT * FROM 內層資料表
WHERE 內層欄位 = 外層欄位
);
```

#### 實際查詢

```sql
SELECT p.Name AS ProfessorName,
d.Name AS DepartmentName
FROM Professor p, Department d
WHERE EXISTS (
SELECT *
FROM Teaching t, Course c
WHERE t.CrsCode = c.CrsCode
AND t.ProfId = p.ProfId
AND c.DeptId = d.DeptId
);
```

| ProfessorName | DepartmentName |
| --- | --- |
| 王四明 | 光電系 |
| 王五明 | 光電系 |
| 王三明 | 電子系 |
| 王一明 | 資工系 |
| 王二明 | 資工系 |

### 題目 10｜Division in SQL：修過資工系所有課程

> **題型重點**　這題本身就是雙層 NOT EXISTS，不能刪掉其中一層，否則不再代表『所有課程』。

#### NOT EXISTS 除法語法

```sql
SELECT 學生
FROM Student s
WHERE NOT EXISTS (
SELECT * FROM 必須全部完成的項目 c
WHERE NOT EXISTS (
SELECT * FROM 完成紀錄 tr
WHERE tr.學生 = s.學生
AND tr.項目 = c.項目
)
);
```

#### 實際查詢

```sql
SELECT s.Name
FROM Student s
WHERE NOT EXISTS (
SELECT *
FROM Course c
WHERE c.DeptId = '43'
AND NOT EXISTS (
SELECT *
FROM Transcript tr
WHERE tr.StudId = s.StdId
AND tr.CrsCode = c.CrsCode
)
);
```

| Name |
| --- |
| 賈克林 |

### 題目 11｜Count＋Grouping＋Having：授課超過一門

#### 分組統計通用語法

```sql
SELECT 分組欄位, COUNT(*)
FROM 資料表
GROUP BY 分組欄位
HAVING COUNT(*) > 數量;
```

#### 實際查詢

```sql
SELECT p.Name, COUNT(*) AS NumCourses
FROM Professor p
JOIN Teaching t ON p.ProfId = t.ProfId
GROUP BY p.ProfId, p.Name
HAVING COUNT(*) > 1;
```

| Name | NumCourses |
| --- | --- |
| 王三明 | 2 |

> **WHERE 與 HAVING**　WHERE 篩選原始資料；HAVING 篩選 COUNT 完成後的分組結果。

### 題目 12｜建立與查詢 View StudentCourses

#### CREATE VIEW 通用語法

```sql
CREATE VIEW View名稱 AS
SELECT 欄位
FROM 資料表
WHERE 或 JOIN 條件;
```

#### 建立 View

```sql
CREATE VIEW StudentCourses AS
SELECT s.Name AS StudentName,
c.CrsName,
tr.Semester
FROM Transcript tr
JOIN Student s ON tr.StudId = s.StdId
JOIN Course c ON tr.CrsCode = c.CrsCode;
```

#### 查詢 View

```sql
SELECT StudentName
FROM StudentCourses
WHERE CrsName = '模糊理論與應用';
```

| StudentName |
| --- |
| 林剛懷 |

## MongoDB 題目前置作業（題目 13-16）

> **資料庫與集合**　本版使用 weather_db 資料庫、weather 集合；JSON 是陣列，所以 mongoimport 加 --jsonArray。

#### mongoimport 通用語法

```powershell
mongoimport --db 資料庫 --collection 集合 --file 檔案路徑 --jsonArray
```

#### 實際匯入

**[系統終端機]**

```powershell
mongoimport --db weather_db --collection weather --file "./aqi_simple.json" --jsonArray
```

#### 進入 mongosh

```javascript
mongosh
use weather_db
show collections
db.weather.find()
```

> **欄位型態**　題目提供的 AQI 範例是字串，例如 AQI: '41'。後續新增與刪除也照此格式。

### 題目 13｜MongoDB 新增一筆測站資料

#### insertOne 通用語法

```javascript
db.集合.insertOne({
欄位1: 值1,
欄位2: 值2
})
```

#### 實際指令

```javascript
db.weather.insertOne({
SiteName: '虎尾科技大學',
County: '雲林縣',
AQI: '42',
Status: '良好'
})

db.weather.find({ SiteName: '虎尾科技大學' })
```

> **預期結果**　insertOne 回傳 acknowledged: true 與 insertedId；查詢顯示虎尾科技大學／雲林縣／42／良好。

### 題目 14｜MongoDB 查詢雲林縣良好測站

#### find 與投影通用語法

```javascript
db.集合.find(
{ 查詢欄位: 查詢值 },
{ _id: 0, 要顯示的欄位: 1 }
)
```

#### 實際指令

```javascript
db.weather.find(
{ County: '雲林縣', Status: '良好' },
{ _id: 0, SiteName: 1, County: 1, AQI: 1, Status: 1 }
)
```

| SiteName | County | AQI | Status |
| --- | --- | --- | --- |
| 虎尾科技大學 | 雲林縣 | 42 | 良好 |
| 斗六 | 雲林縣 | 30 | 良好 |
| 崙背 | 雲林縣 | 30 | 良好 |
| 麥寮 | 雲林縣 | 21 | 良好 |
| 臺西 | 雲林縣 | 20 | 良好 |

### 題目 15｜MongoDB 更新臺北市測站狀態

#### updateMany 通用語法

```javascript
db.集合.updateMany(
{ 查詢條件 },
{ $set: { 欄位: 新值 } }
)
```

#### 實際指令

```javascript
db.weather.updateMany(
{ County: '臺北市' },
{ $set: { Status: '觀察中' } }
)

db.weather.find(
{ County: '臺北市' },
{ _id: 0, SiteName: 1, County: 1, Status: 1 }
)
```

> **預期結果**　目前 JSON 有 7 筆臺北市資料；第一次執行通常 matchedCount: 7、modifiedCount: 7。

### 題目 16｜MongoDB 刪除 AQI 小於 30 的資料

#### deleteMany 通用語法

```javascript
db.集合.deleteMany({
欄位: { $lt: 比較值 }
})
```

#### 依題庫基本格式執行

```javascript
db.weather.deleteMany({
AQI: { $lt: '30' }
})
```

> **結果說明**　目前提供的 aqi_simple.json 會得到 deletedCount: 15；PPT 顯示 19 是資料版本不同。這份簡化版保留題庫的基本 $lt 寫法，不加入 $expr 或 $toInt。

## 附錄 A｜MariaDB 全部指令語法

### 1. 登入、建立與切換資料庫

```powershell
mariadb -u 帳號 -p

CREATE DATABASE 資料庫名稱;
USE 資料庫名稱;
SHOW DATABASES;
SELECT DATABASE();
```

### 2. 帳號與權限

```sql
CREATE USER '帳號'@'localhost' IDENTIFIED BY '密碼';
GRANT 權限 ON 資料庫.資料表 TO '帳號'@'localhost';
GRANT ALL PRIVILEGES ON *.* TO '帳號'@'localhost';
SHOW GRANTS FOR '帳號'@'localhost';
```

### 3. 建立與查看資料表

```sql
CREATE TABLE 表名 (
欄位 資料型態,
PRIMARY KEY (欄位),
FOREIGN KEY (欄位) REFERENCES 參考表(欄位)
);

SHOW TABLES;
DESCRIBE 表名;
SHOW CREATE TABLE 表名;
```

### 4. 新增、查詢與更新

```sql
INSERT INTO 表名 VALUES (值1, 值2, ...);
SELECT 欄位 FROM 表名 WHERE 條件;
UPDATE 表名 SET 欄位 = 新值 WHERE 條件;
```

### 5. 匯出與匯入

```powershell
mariadb-dump -u 帳號 -p 資料庫 > 備份檔.sql

SOURCE ./檔案.sql;
```

### 6. JOIN

```sql
SELECT 欄位
FROM 表1
JOIN 表2 ON 表1.欄位 = 表2.欄位;
```

### 7. IN 子查詢

```sql
SELECT 欄位 FROM 表1
WHERE 欄位 IN (
SELECT 欄位 FROM 表2 WHERE 條件
);
```

### 8. EXISTS 相關子查詢

```sql
SELECT 外層欄位 FROM 外層表
WHERE EXISTS (
SELECT * FROM 內層表
WHERE 內層欄位 = 外層欄位
);
```

### 9. 雙層 NOT EXISTS

```sql
SELECT 對象 FROM 外層表 a
WHERE NOT EXISTS (
SELECT * FROM 必須完成的項目 b
WHERE NOT EXISTS (
SELECT * FROM 完成紀錄 c
WHERE c.對象 = a.對象
AND c.項目 = b.項目
)
);
```

### 10. COUNT、GROUP BY、HAVING

```sql
SELECT 分組欄位, COUNT(*)
FROM 表名
GROUP BY 分組欄位
HAVING COUNT(*) > 數量;
```

### 11. View

```sql
CREATE VIEW View名稱 AS
SELECT 欄位 FROM 資料表 WHERE 或 JOIN 條件;

SELECT * FROM View名稱 WHERE 條件;
```

## 附錄 B｜MongoDB 全部指令語法

### 1. 匯入 JSON 與選擇資料庫

```powershell
mongoimport --db 資料庫 --collection 集合 --file 檔案 --jsonArray

mongosh
use 資料庫
show collections
```

### 2. 查詢全部文件

```javascript
db.集合.find()
```

### 3. 新增一筆

```javascript
db.集合.insertOne({ 欄位1: 值1, 欄位2: 值2 })
```

### 4. 條件查詢與投影

```javascript
db.集合.find(
{ 欄位: 查詢值 },
{ _id: 0, 顯示欄位: 1 }
)
```

### 5. 更新多筆

```javascript
db.集合.updateMany(
{ 查詢條件 },
{ $set: { 欄位: 新值 } }
)
```

### 6. 刪除多筆

```javascript
db.集合.deleteMany({
欄位: { $lt: 比較值 }
})
```

### 7. 本題使用的比較符號

```text
$lt  ：小於
$set ：設定欄位的新值
1    ：投影時顯示欄位
0    ：投影時隱藏欄位
```

## 考場最後檢查清單

題目 1-4 使用 final_db_學號；題目 5-12 使用 nfu_學號。

題目 2 的外鍵參考表必須先存在。

題目 4 的空白成績照 DML 寫成 ''。

題目 6 的 WHERE 同時指定 StudId、CrsCode、Semester。

題目 7 連 Teaching 時同時比對 CrsCode 與 Semester。

題目 10 保留雙層 NOT EXISTS。

題目 11 使用 HAVING 篩選分組結果。

MongoDB 題目先 use weather_db，並確認集合名稱是 weather。

每張截圖都要包含完整指令、資料庫名稱與結果。

## 資料來源

Database_finalExam.pdf：20 頁、16 題題目與範例結果。

Final_Exam_DDL.sql：資料表欄位、主鍵與外鍵的原始簡化寫法。

FinalExam _DML.sql：INSERT 資料與空白成績格式。

Final_Exam.sql：題目 5 匯入用資料庫備份。

aqi_simple.json：MongoDB 題目資料。
