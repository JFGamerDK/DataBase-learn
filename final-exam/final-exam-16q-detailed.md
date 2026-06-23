# 資料庫系統期末上機考：16 題完整詳解

*MariaDB × MongoDB*

題意拆解・操作步驟・完整指令・預期結果・截圖要點

依據 Database_finalExam.pdf、Final_Exam.sql、DDL／DML 與 aqi_simple.json 整理

使用前請把「學號」「密碼」「檔案路徑」替換成自己的資料。

> GitHub 線上預覽版：本檔由 Word 文件轉成 Markdown，方便直接在網頁閱讀。

## 使用方式與重要勘誤

> **三種提示字元**　[系統終端機] 用於 mariadb-dump、mariadb、mongoimport；[MariaDB>] 執行 SQL；[mongosh] 執行 MongoDB 查詢。不要把三種指令混在同一個視窗。

> **檔名不一致**　PPT 寫 FinalExam_DDL.sql／FinalExam_DML.sql；資料夾實際是 Final_Exam_DDL.sql 與 FinalExam _DML.sql（DML 檔名含空格）。最穩定的方法是先改成簡單檔名，或使用完整路徑。

> **Professor 名稱不一致**　PPT 第 4 題使用王一明至王五明；實際 DML／dump 使用另一組教授姓名。本講義第 4 題以 PPT 表格為準；第 5 題之後若匯入原始 dump，姓名可能不同，但查詢列數與邏輯相同。

> **MongoDB AQI 型別**　aqi_simple.json 的 AQI 是字串，例如 "41"。第 16 題不能直接用 {AQI: {$lt: 30}}；必須轉成整數比較。目前檔案實際小於 30 的資料是 15 筆，PPT 的 deletedCount: 19 與檔案不一致。

## 16 題索引

| 題號 | 主題 | 工具／核心語法 |
| --- | --- | --- |
| 1 | 建立資料庫與管理員 | CREATE DATABASE／CREATE USER／GRANT |
| 2 | 建立 Professor、Transcript | CREATE TABLE／PK／FK／DESCRIBE |
| 3 | 教授與學生權限 | GRANT／SHOW GRANTS |
| 4 | 新增資料 | INSERT INTO／SELECT |
| 5 | 匯出與匯入 | mariadb-dump／SOURCE |
| 6 | 更新成績 | UPDATE／WHERE |
| 7 | 多表連接 | JOIN 5 張表 |
| 8 | 巢狀查詢 | IN 子查詢 |
| 9 | 相關子查詢 | EXISTS |
| 10 | 關聯除法 | 雙重 NOT EXISTS |
| 11 | 分組與篩選 | COUNT／GROUP BY／HAVING |
| 12 | 建立與查詢 View | CREATE VIEW |
| 13 | MongoDB 新增 | insertOne |
| 14 | MongoDB 查詢 | find＋projection |
| 15 | MongoDB 更新 | updateMany |
| 16 | MongoDB 刪除 | deleteMany＋$expr＋$toInt |

## 考前共通檢查

每題先確認目前資料庫：MariaDB 用 SELECT DATABASE();，MongoDB 用 db.getName()。

UPDATE／DELETE 前先以相同條件 SELECT／find／countDocuments 預覽範圍。

截圖同時包含資料庫名稱、完整語法與完整結果；密碼不要入鏡。

SQL 字串與帳號使用半形單引號 '，不要使用 Word 的彎引號。

### 題目 1｜建立資料庫與管理員權限

> **核心考點**　建立 final_db_學號，建立 admin 帳號，並只授予該資料庫的完整權限。

#### 操作流程

以 root 登入 MariaDB。

建立 final_db_學號並切換進去。

建立 admin@localhost，授予 final_db_學號.* 的全部權限。

用 SHOW GRANTS 與 SELECT DATABASE() 驗證。

**[PowerShell] 登入**

```powershell
mariadb -u root -p
```

**[MariaDB>] 建庫、帳號與授權**

```sql
CREATE DATABASE final_db_學號
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE final_db_學號;

CREATE USER 'admin'@'localhost' IDENTIFIED BY '你的密碼';
GRANT ALL PRIVILEGES ON final_db_學號.*
TO 'admin'@'localhost';

SHOW GRANTS FOR 'admin'@'localhost';
SELECT DATABASE();
```

> **為什麼不是 ON \*.\***　題目只要求管理此資料庫。ON final_db_學號.* 符合最小權限原則；ON *.* 會給全伺服器權限，範圍過大。

> **截圖要點**　畫面應看到 MariaDB [final_db_學號]>、CREATE／GRANT 指令與 SHOW GRANTS 結果。

### 題目 2｜建立 Professor 與 Transcript 資料表

> **核心考點**　正確選用 INT、CHAR、VARCHAR，設定主鍵、複合主鍵與外鍵。外鍵參考的資料表必須先存在。

建表順序必須符合依賴關係：Department → Professor → Student → Course → Teaching → Transcript。若其他四張表已由考試環境建立，可直接執行以下兩段。

**[MariaDB>] 建立 Professor**

```sql
CREATE TABLE Professor (
ProfId INT NOT NULL,
Name CHAR(20) NOT NULL,
DeptId VARCHAR(2),
PRIMARY KEY (ProfId),
CONSTRAINT fk_professor_department
FOREIGN KEY (DeptId) REFERENCES Department(DeptId)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**[MariaDB>] 建立 Transcript**

```sql
CREATE TABLE Transcript (
StudId INT NOT NULL,
CrsCode VARCHAR(4) NOT NULL,
Semester VARCHAR(5) NOT NULL,
Grade CHAR(1) DEFAULT NULL,
PRIMARY KEY (StudId, CrsCode, Semester),
CONSTRAINT fk_transcript_student
FOREIGN KEY (StudId) REFERENCES Student(StdId),
CONSTRAINT fk_transcript_course
FOREIGN KEY (CrsCode) REFERENCES Course(CrsCode),
CONSTRAINT fk_transcript_teaching
FOREIGN KEY (CrsCode, Semester)
REFERENCES Teaching(CrsCode, Semester)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

**[MariaDB>] 驗證結構**

```sql
DESCRIBE Professor;
SHOW CREATE TABLE Professor\G
DESCRIBE Transcript;
SHOW CREATE TABLE Transcript\G
```

> **常見錯誤 1215／1005**　通常是父表尚未建立、欄位型別／長度不同、父欄位沒有索引，或儲存引擎不同。DeptId、CrsCode、Semester 的型別必須與父表完全相容。

> **截圖要點**　包含資料庫名稱、CREATE TABLE 語法，以及兩張表的 DESCRIBE 或 SHOW CREATE TABLE 結果。

### 題目 3｜教授與學生角色權限

> **核心考點**　professor 可 SELECT、UPDATE Transcript；student 可 SELECT、INSERT Transcript。

**[MariaDB>] 建立帳號並授權**

```sql
CREATE USER 'professor'@'localhost' IDENTIFIED BY '教授密碼';
CREATE USER 'student'@'localhost' IDENTIFIED BY '學生密碼';

GRANT SELECT, UPDATE
ON final_db_學號.Transcript
TO 'professor'@'localhost';

GRANT SELECT, INSERT
ON final_db_學號.Transcript
TO 'student'@'localhost';

SHOW GRANTS FOR 'professor'@'localhost';
SHOW GRANTS FOR 'student'@'localhost';
```

> **帳號已存在**　若重做時出現 ERROR 1396，使用 ALTER USER ... IDENTIFIED BY ... 更新密碼；不要一直重複 CREATE USER。

> **截圖要點**　兩個 SHOW GRANTS 結果都要入鏡，並確認授權物件是 final_db_學號.Transcript。

### 題目 4｜新增 Professor 與 Transcript 資料

> **前置條件**　Department、Student、Course、Teaching 的對應資料必須已存在，否則 Transcript 會因外鍵失敗。若已執行整份 DML，不要重複插入相同主鍵。

**[MariaDB>] 新增資料**

```sql
INSERT INTO Professor (ProfId, Name, DeptId) VALUES
(401, '王一明', '43'),
(402, '王二明', '43'),
(403, '王三明', '40'),
(404, '王四明', '26'),
(405, '王五明', '26');

INSERT INTO Transcript (StudId, CrsCode, Semester, Grade) VALUES
(41026201, '1025', '2025B', NULL),
(41026201, '1993', '2025B', NULL),
(41040202, '1746', '2025B', NULL),
(41040202, '1993', '2025B', NULL),
(41043203, '1990', '2025A', NULL),
(41043203, '1993', '2025B', NULL);
```

**[MariaDB>] 查詢全部資料**

```sql
SELECT * FROM Professor ORDER BY ProfId;
SELECT * FROM Transcript ORDER BY StudId, CrsCode, Semester;
```

> **Grade 為何用 NULL**　題目畫面是尚未有成績。NULL 代表未知／尚未輸入；空字串 '' 是一個已存在但長度為零的值，語意不同。

> **資料不一致**　PPT 要求王一明至王五明；提供的 DML 檔是另一組名字。要符合本題結果圖時，以 PPT 表格為準。

### 題目 5｜匯出 final_db 並匯入 Final_Exam.sql

> **核心考點**　匯出在系統終端機執行；匯入前先建立 nfu_學號。PowerShell 不支援 cmd 式的輸入重導向 <，最穩定是使用 MariaDB 的 SOURCE。

#### A. 匯出 final_db_學號

**[CMD] 匯出**

```powershell
mariadb-dump -u root -p --default-character-set=utf8mb4 final_db_學號 > final_db_學號.sql
```

#### B. 建立 nfu_學號並匯入

**[MariaDB>] 建庫並匯入**

```sql
CREATE DATABASE nfu_學號
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE nfu_學號;
SOURCE ./Final_Exam.sql;
```

**[MariaDB>] 驗證匯入**

```sql
SELECT DATABASE();
SHOW TABLES;
SELECT COUNT(*) AS NumDepartments FROM Department;
SELECT COUNT(*) AS NumTranscripts FROM Transcript;
```

#### C. 在 nfu_學號重建三個角色

**[MariaDB>] 重新授權**

```sql
GRANT ALL PRIVILEGES ON nfu_學號.* TO 'admin'@'localhost';
GRANT SELECT, UPDATE ON nfu_學號.Transcript TO 'professor'@'localhost';
GRANT SELECT, INSERT ON nfu_學號.Transcript TO 'student'@'localhost';
```

> **預期結果**　SHOW TABLES 應顯示 course、department、professor、student、teaching、transcript 共 6 張表。

> **截圖要點**　CMD 匯出指令、nfu_學號資料庫名稱、SOURCE 指令與 SHOW TABLES 結果。備份 SQL 檔需另外上傳。

### 題目 6｜更新指定學生的成績

> **核心考點**　UPDATE 必須同時鎖定 StudId、CrsCode、Semester，避免更新同學生其他課程。

**[MariaDB>] 先查、再改、再驗證**

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

> **預期結果**　只更新 1 row；最後 Grade 顯示 A。若 affected rows 為 0，先檢查三個鍵值與目前資料庫。

### 題目 7｜Join Queries：學生、課程與教授

> **關聯路徑**　Transcript → Student；Transcript → Course；Transcript 的 (CrsCode, Semester) → Teaching；Teaching → Professor。

**[MariaDB>] 五表 JOIN**

```text
SELECT
s.Name AS StudentName,
c.CrsName,
p.Name AS ProfessorName
FROM Transcript AS tr
JOIN Student AS s
ON s.StdId = tr.StudId
JOIN Course AS c
ON c.CrsCode = tr.CrsCode
JOIN Teaching AS t
ON t.CrsCode = tr.CrsCode
AND t.Semester = tr.Semester
JOIN Professor AS p
ON p.ProfId = t.ProfId
ORDER BY s.StdId, c.CrsCode;
```

| StudentName | CrsName | ProfessorName |
| --- | --- | --- |
| 王大明 | 真空與鍍膜技術 | 王五明 |
| 王大明 | 資料庫系統 | 王二明 |
| 林剛懷 | 模糊理論與應用 | 王三明 |
| 林剛懷 | 資料庫系統 | 王二明 |
| 賈克林 | 微處理機實習 | 王一明 |
| 賈克林 | 資料庫系統 | 王二明 |

> **常見錯誤**　只用 CrsCode 連 Teaching 可能把不同學期的教授接錯；必須同時連 CrsCode 與 Semester。

### 題目 8｜Nested Queries：修過資料庫系統的學生

> **核心考點**　外層查 Student，內層先找課程代碼，再找修課學生 ID。DISTINCT 避免同一學生重複。

**[MariaDB>] 巢狀 IN 查詢**

```sql
SELECT DISTINCT s.Name
FROM Student AS s
WHERE s.StdId IN (
SELECT tr.StudId
FROM Transcript AS tr
WHERE tr.CrsCode IN (
SELECT c.CrsCode
FROM Course AS c
WHERE c.CrsName = '資料庫系統'
)
)
ORDER BY s.StdId;
```

| Name |
| --- |
| 王大明 |
| 林剛懷 |
| 賈克林 |

> **截圖要點**　完整子查詢與 3 位學生結果都要入鏡。

### 題目 9｜Correlated Nested Queries：教授曾授課的系所

> **核心考點**　外層列舉 Professor × Department；相關子查詢用外層的 ProfId、DeptId 檢查是否存在授課紀錄。

**[MariaDB>] 相關 EXISTS**

```sql
SELECT
p.Name AS ProfessorName,
d.Name AS DepartmentName
FROM Professor AS p
CROSS JOIN Department AS d
WHERE EXISTS (
SELECT 1
FROM Teaching AS t
JOIN Course AS c ON c.CrsCode = t.CrsCode
WHERE t.ProfId = p.ProfId
AND c.DeptId = d.DeptId
)
ORDER BY p.ProfId, d.DeptId;
```

| ProfessorName | DepartmentName |
| --- | --- |
| 王一明 | 資工系 |
| 王二明 | 資工系 |
| 王三明 | 電子系 |
| 王四明 | 光電系 |
| 王五明 | 光電系 |

> **為何不用 Professor.DeptId 直接連**　題目問的是『曾在哪個系所授課』，應以 Teaching 所對應 Course 的 DeptId 判斷，而不是只看教授的所屬系所。

### 題目 10｜Division in SQL：修過資工系所有課程

> **讀法**　找出不存在任何一門資工系課程，是該學生沒有修過的。這就是雙重 NOT EXISTS。

**[MariaDB>] 關聯除法**

```sql
SELECT s.Name
FROM Student AS s
WHERE NOT EXISTS (
SELECT 1
FROM Course AS c
WHERE c.DeptId = '43'
AND NOT EXISTS (
SELECT 1
FROM Transcript AS tr
WHERE tr.StudId = s.StdId
AND tr.CrsCode = c.CrsCode
)
)
ORDER BY s.StdId;
```

| Name |
| --- |
| 賈克林 |

> **驗證思路**　資工系課程為 1990、1993；只有賈克林兩門皆修過。

### 題目 11｜Count＋Grouping＋Having：授課超過一門

> **核心考點**　WHERE 篩資料列；HAVING 篩分組結果。使用 COUNT(DISTINCT CrsCode) 避免同一課不同學期被重複計算。

**[MariaDB>] GROUP BY＋HAVING**

```text
SELECT
p.Name,
COUNT(DISTINCT t.CrsCode) AS NumCourses
FROM Professor AS p
JOIN Teaching AS t ON t.ProfId = p.ProfId
GROUP BY p.ProfId, p.Name
HAVING COUNT(DISTINCT t.CrsCode) > 1
ORDER BY p.ProfId;
```

| Name | NumCourses |
| --- | --- |
| 王三明 | 2 |

### 題目 12｜建立與查詢 View StudentCourses

> **核心考點**　View 儲存查詢定義。先建立包含學生姓名、課程名稱、授課學期的 View，再查指定課程。

**[MariaDB>] 建立與查詢 View**

```sql
CREATE OR REPLACE VIEW StudentCourses AS
SELECT
s.Name AS StudentName,
c.CrsName,
tr.Semester
FROM Transcript AS tr
JOIN Student AS s ON s.StdId = tr.StudId
JOIN Course AS c ON c.CrsCode = tr.CrsCode;

SHOW CREATE VIEW StudentCourses\G

SELECT DISTINCT StudentName
FROM StudentCourses
WHERE CrsName = '模糊理論與應用'
ORDER BY StudentName;
```

| StudentName |
| --- |
| 林剛懷 |

> **截圖要點**　CREATE VIEW 指令、Query OK、查詢 View 的 SELECT 與結果都要包含。

## MongoDB 共通前置作業（題目 13–16）

> **資料模型**　本題使用 weather_db 資料庫與 weather collection。aqi_simple.json 是 JSON array，因此 mongoimport 必須加 --jsonArray。

**[系統終端機] 匯入 JSON**

```powershell
mongoimport --db weather_db --collection weather --drop --jsonArray --file "./aqi_simple.json"
```

**[mongosh] 驗證**

```javascript
use weather_db
db.getName()
db.weather.countDocuments()
db.weather.findOne()
```

> **預期**　原始檔共有 85 筆；AQI 欄位型別是 string。

### 題目 13｜MongoDB 新增一筆測站資料

> **核心考點**　使用 insertOne；為了與既有資料一致，AQI 使用字串。

**[mongosh] 新增並驗證**

```javascript
db.weather.insertOne({
SiteName: '虎尾科技大學',
County: '雲林縣',
AQI: '42',
Status: '良好'
})

db.weather.find(
{ SiteName: '虎尾科技大學' },
{ _id: 0, SiteName: 1, County: 1, AQI: 1, Status: 1 }
)
```

> **預期結果**　insertOne 回傳 acknowledged: true 與 insertedId；查詢顯示虎尾科技大學／雲林縣／42／良好。

### 題目 14｜MongoDB 查詢雲林縣良好測站

> **核心考點**　filter 同時指定 County 與 Status；projection 隱藏 _id，只保留題目欄位。

**[mongosh] 查詢＋投影**

```javascript
db.weather.find(
{ County: '雲林縣', Status: '良好' },
{ _id: 0, SiteName: 1, County: 1, AQI: 1, Status: 1 }
).sort({ SiteName: 1 })
```

| SiteName | County | AQI | Status |
| --- | --- | --- | --- |
| 虎尾科技大學 | 雲林縣 | 42 | 良好 |
| 斗六 | 雲林縣 | 30 | 良好 |
| 崙背 | 雲林縣 | 30 | 良好 |
| 麥寮 | 雲林縣 | 21 | 良好 |
| 臺西 | 雲林縣 | 20 | 良好 |

> **結果數量**　原始 JSON 有 4 筆雲林縣良好測站；完成第 13 題後會變成 5 筆。

### 題目 15｜MongoDB 更新臺北市測站狀態

> **核心考點**　使用 updateMany 更新所有 County = 臺北市的文件；先 countDocuments 確認範圍。

**[mongosh] 預覽、更新、驗證**

```javascript
db.weather.countDocuments({ County: '臺北市' })

db.weather.updateMany(
{ County: '臺北市' },
{ $set: { Status: '觀察中' } }
)

db.weather.find(
{ County: '臺北市' },
{ _id: 0, SiteName: 1, County: 1, Status: 1 }
).sort({ SiteName: 1 })
```

> **預期結果**　目前 JSON 有 7 筆臺北市資料；第一次執行通常 matchedCount: 7、modifiedCount: 7。重做時 modifiedCount 可能為 0，因為值已是觀察中。

### 題目 16｜MongoDB 刪除 AQI 小於 30 的資料

> **關鍵陷阱**　AQI 是字串。{AQI: {$lt: 30}} 不會正確比對；要在 $expr 中用 $toInt 轉型。

**[mongosh] 先計數、刪除、再確認為 0**

```javascript
db.weather.countDocuments({
$expr: { $lt: [ { $toInt: '$AQI' }, 30 ] }
})

db.weather.deleteMany({
$expr: { $lt: [ { $toInt: '$AQI' }, 30 ] }
})

db.weather.countDocuments({
$expr: { $lt: [ { $toInt: '$AQI' }, 30 ] }
})
```

> **正確預期**　依目前 aqi_simple.json，刪除前應為 15 筆，因此 deletedCount 應為 15。PPT 顯示 19，是範例資料版本不同或範例不一致，不要為了湊 19 改錯查詢。

> **另一種做法**　也可先用 updateMany 的 aggregation pipeline 把 AQI 全部轉成 int，再使用 {AQI: {$lt: 30}}；但這會改變整個欄位型別與輸出外觀。

## 考場最後檢查清單

題目 1–4 使用 final_db_學號；題目 5–12 使用匯入後的 nfu_學號，切錯資料庫會讓結果完全不同。

題目 7 必須用 CrsCode＋Semester 連 Teaching。

題目 10 是雙重 NOT EXISTS，不是只用 IN 找任一門課。

題目 11 的分組條件寫 HAVING，不寫 WHERE。

題目 13–16 先 use weather_db；所有修改與刪除前先預覽範圍。

每張截圖都要有完整語法、資料庫／collection 名稱與完整結果。

## 資料來源與驗證說明

Database_finalExam.pdf：20 頁，包含 16 題題目與範例結果。

Final_Exam_DDL.sql、FinalExam _DML.sql、Final_Exam.sql：MariaDB schema 與資料。

aqi_simple.json：85 筆測站資料；AQI 為字串。

114資料庫上機練習(1).pdf：MariaDB 基本操作、權限、DDL、備份與 CRUD 參考。

SQL 第 7–12 題已用相同 schema／資料驗證列數與結果；MongoDB 第 14–16 題已依 JSON 實際筆數核對。
