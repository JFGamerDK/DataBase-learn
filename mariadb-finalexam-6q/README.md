# MariaDB 期末上機六題：詳解與指令流程

本資料整理自 `MariaDB_finalExam.pptx` 與 `finalexam.sql`，可直接在 GitHub 預覽，也可下載 Word/PDF/ZIP 版本。

## 下載與來源檔

- [Word 下載版](mariadb-finalexam-6q-guide.docx)
- [PDF 下載版](mariadb-finalexam-6q-guide.pdf)
- [整包 ZIP 下載](mariadb-finalexam-6q-download.zip)
- [原始 PPT：MariaDB_finalExam.pptx](MariaDB_finalExam.pptx)
- [原始 SQL：finalexam.sql](finalexam.sql)

## 使用方式

1. 先啟動 MariaDB，並用 root 或具有權限的帳號登入。
2. 題目 1 建立 `nfu_學號` 資料庫，並匯入 `finalexam.sql`。
3. 題目 2–6 都在 `nfu_學號` 裡執行。
4. 截圖時要包含資料庫名稱、SQL 查詢語法與查詢結果。

## 資料表速查

| 資料表 | 用途 | 主要欄位 |
| --- | --- | --- |
| comments | 論文審查資料 | paper_id, author_id, viewer_id |
| labs | 實驗室資料 | lab_id, name |
| students | 學生與實驗室資料 | id, name, lab_id |
| logs | 顧客進店紀錄 | entered_id, shopper_id |
| orders | 消費紀錄 | order_id, entered_id, amount |
| takes | 修課學生與組員資料 | student_id, parner_id |
| tests | 考試場次資料 | test_id, place |
| signups | 考生報名與結果 | examinee_id, test_id, result |

## 六題索引

| 題號 | 題目 | 核心指令 |
| --- | --- | --- |
| 1 | 匯入考試資料庫 | CREATE DATABASE / SOURCE / CREATE USER / GRANT |
| 2 | 論文審查 | DISTINCT / WHERE / ORDER BY |
| 3 | 熱門實驗室 | JOIN / GROUP BY / HAVING |
| 4 | 櫥窗購物 | LEFT JOIN / IS NULL / COUNT |
| 5 | 退選的組員 | SELF LEFT JOIN / IS NULL |
| 6 | 考試通過率 | LEFT JOIN / AVG / ROUND / IFNULL |

## 題目 1｜匯入考試資料庫

> **難度與配分**：Required - 10%

**題目目標**：建立 nfu_學號 資料庫、匯入 finalexam.sql、建立 s學號末四碼 使用者，並授權可存取此資料庫全部權限。

### 解題重點

- 資料庫名稱要用 nfu_ 加上自己的學號，例如 nfu_40943199。
- 使用者名稱要用 s 加上學號末四碼，例如 s3199。
- 題目要求的是此資料庫全部權限，因此授權範圍建議寫成 nfu_學號.*。

### 指令

```sql
CREATE DATABASE nfu_學號;
USE nfu_學號;

SOURCE ./finalexam.sql;

CREATE USER 's末四碼'@'localhost' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON nfu_學號.* TO 's末四碼'@'localhost';

SHOW GRANTS FOR 's末四碼'@'localhost';
SHOW TABLES;
```

### 預期結果

| 檢查項目 | 預期結果 |
| --- | --- |
| SHOW GRANTS | 看到 GRANT ALL PRIVILEGES ON `nfu_學號`.* TO `s末四碼`@`localhost` |
| SHOW TABLES | 看到 comments、labs、students、logs、orders、takes、tests、signups |

> **注意**：若重複練習時帳號已存在，可先執行 DROP USER IF EXISTS 's末四碼'@'localhost'; 再重新 CREATE USER。


## 題目 2｜論文審查

> **難度與配分**：Easy - 20%

**題目目標**：找出所有審查過自己論文的作者，依 id 遞增排序。

**使用資料表**：

- `comments(paper_id, author_id, viewer_id)`

### 解題重點

- 作者也是審查人員時，author_id 會等於 viewer_id。
- 同一位作者可能出現多次，所以要使用 DISTINCT。
- 題目輸出欄位名稱是 id，因此把 author_id 取別名為 id。

### 指令

```sql
SELECT DISTINCT author_id AS id
FROM comments
WHERE author_id = viewer_id
ORDER BY id;
```

### 預期結果

| id |
| --- |
| 2 |
| 6 |


## 題目 3｜熱門實驗室

> **難度與配分**：Easy - 20%

**題目目標**：列出目前大三生人數至少三位的實驗室；本學年度大三生學號前四碼為 2021。

**使用資料表**：

- `labs(lab_id, name)`
- `students(id, name, lab_id)`

### 解題重點

- 先用 Students.id 判斷學號是否以 2021 開頭。
- 用 lab_id 連接 Labs 與 Students。
- 用 GROUP BY 分組，再用 HAVING COUNT(*) >= 3 篩選熱門實驗室。

### 指令

```sql
SELECT l.name AS popular_lab
FROM labs AS l
JOIN students AS s
  ON l.lab_id = s.lab_id
WHERE s.id LIKE '2021%'
GROUP BY l.lab_id, l.name
HAVING COUNT(*) >= 3
ORDER BY l.lab_id;
```

### 預期結果

| popular_lab |
| --- |
| Cyber Security |

> **注意**：students.id 是 INT，但 MariaDB 在 LIKE 比較時會自動轉成字串；也可改用 BETWEEN 202100000 AND 202199999。


## 題目 4｜櫥窗購物

> **難度與配分**：Easy - 20%

**題目目標**：列出所有進入超市卻未消費的會員，以及未消費次數。

**使用資料表**：

- `logs(entered_id, shopper_id)`
- `orders(order_id, entered_id, amount)`

### 解題重點

- Logs 記錄每次進入超市；Orders 記錄有消費的 entered_id。
- 使用 LEFT JOIN 從 Logs 保留所有進店紀錄。
- WHERE o.order_id IS NULL 代表該次進店沒有消費。
- 依 shopper_id 分組計算未消費次數。

### 指令

```sql
SELECT l.shopper_id,
       COUNT(*) AS count_no_buy
FROM logs AS l
LEFT JOIN orders AS o
  ON l.entered_id = o.entered_id
WHERE o.order_id IS NULL
GROUP BY l.shopper_id
ORDER BY l.shopper_id;
```

### 預期結果

| shopper_id | count_no_buy |
| --- | --- |
| 13 | 1 |
| 39 | 2 |
| 52 | 2 |


## 題目 5｜退選的組員

> **難度與配分**：Easy - 20%

**題目目標**：找出那些沒有組員的學生 ID。

**使用資料表**：

- `takes(student_id, parner_id)`

### 解題重點

- 這張表欄位名稱是 parner_id，SQL 要照原檔拼字使用。
- 若某學生的 parner_id 不存在於任何 student_id，代表他的組員已退選。
- 可用自我 LEFT JOIN 找出 partner 不存在的紀錄。

### 指令

```sql
SELECT t.student_id
FROM takes AS t
LEFT JOIN takes AS p
  ON t.parner_id = p.student_id
WHERE p.student_id IS NULL
ORDER BY t.student_id;
```

### 預期結果

| student_id |
| --- |
| 3 |
| 6 |

> **注意**：題目資料表欄位是 parner_id，不是 partner_id；打錯欄位名稱會查詢失敗。


## 題目 6｜考試通過率

> **難度與配分**：Medium - 30%

**題目目標**：列出每個考試場次的通過率；沒有考生報名的場次也要顯示，pass_rate 可為 0 或 NULL。

**使用資料表**：

- `tests(test_id, place)`
- `signups(examinee_id, test_id, result)`

### 解題重點

- Tests 是主表，要保留所有 test_id，所以使用 LEFT JOIN。
- Signups.result 是 0/1，AVG(result) 就是通過率。
- 沒有報名者時 AVG(result) 會是 NULL；若要顯示 0，可用 IFNULL 包起來。

### 指令

```sql
SELECT t.test_id,
       ROUND(AVG(s.result), 4) AS pass_rate
FROM tests AS t
LEFT JOIN signups AS s
  ON t.test_id = s.test_id
GROUP BY t.test_id
ORDER BY t.test_id;
```

### 補充寫法

```sql
-- 如果希望沒有考生報名的場次顯示 0
SELECT t.test_id,
       IFNULL(ROUND(AVG(s.result), 4), 0.0000) AS pass_rate
FROM tests AS t
LEFT JOIN signups AS s
  ON t.test_id = s.test_id
GROUP BY t.test_id
ORDER BY t.test_id;
```

### 預期結果

| test_id | pass_rate |
| --- | --- |
| 1 | 0.5000 |
| 2 | 0.3333 |
| 3 | NULL |
