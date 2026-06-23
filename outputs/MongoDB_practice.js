// MongoDB 期末上機考：題目版（可在 mongosh 執行）
// 本檔只建立 finalexam_mongo_practice 練習資料庫，不會碰其他資料庫。
// 完成題目後，再對照 MongoDB_answers.js。

db = db.getSiblingDB("finalexam_mongo_practice");
db.dropDatabase();

db.labs.insertMany([
  { lab_id: 101, name: "Communicaton" },
  { lab_id: 102, name: "AI" },
  { lab_id: 103, name: "Software" },
  { lab_id: 104, name: "Cyber Security" }
]);

db.students.insertMany([
  { id: 202043192, name: "Hannes", lab_id: 103 },
  { id: 202043197, name: "Erwin", lab_id: 101 },
  { id: 202143187, name: "Sasha", lab_id: 104 },
  { id: 202143188, name: "Pieck", lab_id: 103 },
  { id: 202143189, name: "Gabi", lab_id: 103 },
  { id: 202143190, name: "Connie", lab_id: 104 },
  { id: 202143191, name: "Jean", lab_id: 104 },
  { id: 202143193, name: "Hange", lab_id: 102 },
  { id: 202143194, name: "Armin", lab_id: 104 },
  { id: 202143195, name: "Annie", lab_id: 102 },
  { id: 202143196, name: "Levi", lab_id: 101 },
  { id: 202143198, name: "Mikasa", lab_id: 104 },
  { id: 202143199, name: "Eren", lab_id: 104 }
]);

db.comments.insertMany([
  { paper_id: 1, author_id: 9, viewer_id: 1 },
  { paper_id: 1, author_id: 9, viewer_id: 2 },
  { paper_id: 1, author_id: 9, viewer_id: 7 },
  { paper_id: 2, author_id: 7, viewer_id: 8 },
  { paper_id: 3, author_id: 6, viewer_id: 6 },
  { paper_id: 3, author_id: 6, viewer_id: 10 },
  { paper_id: 4, author_id: 2, viewer_id: 2 },
  { paper_id: 4, author_id: 2, viewer_id: 7 },
  { paper_id: 5, author_id: 2, viewer_id: 2 }
]);

db.logs.insertMany([
  { entered_id: 1, shopper_id: 26 }, { entered_id: 2, shopper_id: 39 },
  { entered_id: 3, shopper_id: 52 }, { entered_id: 4, shopper_id: 13 },
  { entered_id: 5, shopper_id: 13 }, { entered_id: 6, shopper_id: 52 },
  { entered_id: 7, shopper_id: 65 }, { entered_id: 8, shopper_id: 13 },
  { entered_id: 9, shopper_id: 39 }
]);

db.orders.insertMany([
  { order_id: 1, entered_id: 1, amount: 599 },
  { order_id: 2, entered_id: 5, amount: 1399 },
  { order_id: 3, entered_id: 7, amount: 10900 },
  { order_id: 4, entered_id: 8, amount: 1450 }
]);

db.takes.insertMany([
  { student_id: 1, partner_id: 7 }, { student_id: 3, partner_id: 2 },
  { student_id: 4, partner_id: 8 }, { student_id: 5, partner_id: 9 },
  { student_id: 6, partner_id: 11 }, { student_id: 7, partner_id: 1 },
  { student_id: 8, partner_id: 4 }, { student_id: 9, partner_id: 5 }
]);

db.tests.insertMany([
  { test_id: 1, place: "Taipei" },
  { test_id: 2, place: "Taichung" },
  { test_id: 3, place: "Kaohsiung" }
]);

db.signups.insertMany([
  { examinee_id: 987654321, test_id: 1, result: true },
  { examinee_id: 987655555, test_id: 2, result: false },
  { examinee_id: 987666666, test_id: 2, result: false },
  { examinee_id: 987777777, test_id: 1, result: false },
  { examinee_id: 987777777, test_id: 2, result: true }
]);

print("Seed complete: " + db.getName());

// ============================================================
// A. Collection 與文件 CRUD
// ============================================================
// A1. 建立 books collection，新增三本書（內容同 MariaDB 題目）。
// A2. 查詢 price >= 600，只顯示 title、price，不顯示 _id，價格由高到低。
// A3. 將 MongoDB Basics 的 price 改為 680，並新增 stock: 10。
// A4. 對所有 books 將 category 欄位改名為 subject。
// A5. 刪除 price < 550 的書。刪除前先 find() 確認。
// A6. 刪除 books collection。

// ============================================================
// B. 查詢與 Aggregation
// ============================================================
// B1. 找出審查自己論文的 reviewer ID，去重複並排序。預期 2、6。
// B2. 統計 2021 開頭學號的學生，各 lab_id 人數；只保留至少 3 人。
// B3. 用 $lookup 找出沒有對應 order 的進店紀錄，再依 shopper_id 統計次數。
// B4. 找出 partner_id 不存在於 takes.student_id 的學生。預期 3、6。
// B5. 列出每個考場通過率，沒有報名的 test_id=3 也要顯示。

// ============================================================
// C. View
// ============================================================
// C1. 建立 student_lab_view，以 students 為來源，用 $lookup 連接 labs。
// C2. 查詢此 View，只顯示 Cyber Security 學生。
// C3. 修改 View，使其只保留 2021 開頭學號。
// C4. 刪除 View。

// ============================================================
// D. 匯入／匯出（在系統終端機執行，不是在 mongosh）
// ============================================================
// D1. 用 mongoimport 匯入 MongoDB_import_students.json（JSON array）。
// D2. 用 mongoexport 匯出 students collection 為 JSON array。
// D3. 用 mongodump 備份整個 finalexam_mongo_practice。
// D4. 用 mongorestore --drop 還原。

