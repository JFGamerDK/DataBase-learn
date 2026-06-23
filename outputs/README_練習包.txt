資料庫系統期末上機考練習包

1. MariaDB
   - 先匯入老師提供的 finalexam.sql。
   - 開啟 MariaDB_practice.sql 作答。
   - 完成後對照 MariaDB_answers.sql。

2. MongoDB
   - 在 mongosh 執行 MongoDB_practice.js；它只會重建 finalexam_mongo_practice。
   - 完成題目後對照 MongoDB_answers.js。
   - MongoDB_import_students.json 用於 mongoimport / mongoexport 練習。

3. 安全提醒
   - UPDATE / DELETE 前先用相同 WHERE 執行 SELECT 或 find()。
   - 匯入、還原前先確認目標資料庫名稱。
   - mongorestore --drop、mongoimport --drop 會刪除目標集合的既有資料，只能用在練習庫。

4. PowerShell 提醒
   - MariaDB 的「< 檔名.sql」輸入重導向在 PowerShell 不適用。
   - 可進 MariaDB 後使用 SOURCE C:/完整路徑/finalexam.sql;
   - 或用 cmd /c "mariadb -u root -p finalexam < finalexam.sql"

