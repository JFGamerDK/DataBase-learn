// MongoDB 期末上機考：解答版
// 先執行 MongoDB_practice.js 建立練習資料。

db = db.getSiblingDB("finalexam_mongo_practice");

// A. Collection 與文件 CRUD
db.books.drop();
db.createCollection("books");
db.books.insertMany([
  { title: "Database Systems", price: 850, category: "Database" },
  { title: "MongoDB Basics", price: 620, category: "Database" },
  { title: "Python Practice", price: 500, category: "Programming" }
]);

db.books.find(
  { price: { $gte: 600 } },
  { _id: 0, title: 1, price: 1 }
).sort({ price: -1 });

db.books.updateOne(
  { title: "MongoDB Basics" },
  { $set: { price: 680, stock: 10 } }
);

db.books.updateMany({}, { $rename: { category: "subject" } });
db.books.find({ price: { $lt: 550 } });
db.books.deleteMany({ price: { $lt: 550 } });
db.books.find().sort({ price: -1 });
db.books.drop();

// B1. 審查自己論文：distinct 後在 shell 端排序。
db.comments.distinct("viewer_id", { $expr: { $eq: ["$author_id", "$viewer_id"] } }).sort();

// B2. 熱門實驗室；數字學號用範圍判斷最快。
db.students.aggregate([
  { $match: { id: { $gte: 202100000, $lte: 202199999 } } },
  { $group: { _id: "$lab_id", student_count: { $sum: 1 } } },
  { $match: { student_count: { $gte: 3 } } },
  { $lookup: { from: "labs", localField: "_id", foreignField: "lab_id", as: "lab" } },
  { $unwind: "$lab" },
  { $project: { _id: 0, popular_lab: "$lab.name", student_count: 1 } },
  { $sort: { popular_lab: 1 } }
]);

// B3. 櫥窗購物。
db.logs.aggregate([
  { $lookup: { from: "orders", localField: "entered_id", foreignField: "entered_id", as: "matched_orders" } },
  { $match: { "matched_orders.0": { $exists: false } } },
  { $group: { _id: "$shopper_id", count_no_buy: { $sum: 1 } } },
  { $project: { _id: 0, shopper_id: "$_id", count_no_buy: 1 } },
  { $sort: { shopper_id: 1 } }
]);

// B4. 退選的組員：自我 $lookup。
db.takes.aggregate([
  { $lookup: { from: "takes", localField: "partner_id", foreignField: "student_id", as: "partner" } },
  { $match: { "partner.0": { $exists: false } } },
  { $project: { _id: 0, student_id: 1 } },
  { $sort: { student_id: 1 } }
]);

// B5. 考試通過率；先從 tests 出發，才能保留零報名場次。
db.tests.aggregate([
  { $lookup: { from: "signups", localField: "test_id", foreignField: "test_id", as: "signups" } },
  { $project: {
      _id: 0,
      test_id: 1,
      pass_rate: {
        $cond: [
          { $eq: [{ $size: "$signups" }, 0] },
          0,
          { $divide: [
              { $size: { $filter: { input: "$signups", as: "s", cond: { $eq: ["$$s.result", true] } } } },
              { $size: "$signups" }
          ] }
        ]
      }
  } },
  { $sort: { test_id: 1 } }
]);

// C. View
db.student_lab_view.drop();
db.createView("student_lab_view", "students", [
  { $lookup: { from: "labs", localField: "lab_id", foreignField: "lab_id", as: "lab" } },
  { $unwind: { path: "$lab", preserveNullAndEmptyArrays: true } },
  { $project: { _id: 0, student_id: "$id", student_name: "$name", lab_name: "$lab.name" } }
]);

db.student_lab_view.find({ lab_name: "Cyber Security" }).sort({ student_id: 1 });

db.runCommand({
  collMod: "student_lab_view",
  viewOn: "students",
  pipeline: [
    { $match: { id: { $gte: 202100000, $lte: 202199999 } } },
    { $lookup: { from: "labs", localField: "lab_id", foreignField: "lab_id", as: "lab" } },
    { $unwind: { path: "$lab", preserveNullAndEmptyArrays: true } },
    { $project: { _id: 0, student_id: "$id", student_name: "$name", lab_name: "$lab.name" } }
  ]
});

db.student_lab_view.find().sort({ student_id: 1 });
db.student_lab_view.drop();

// D. 系統終端機命令（不要貼進 mongosh）：
// mongoimport --db finalexam_mongo_practice --collection imported_students --file MongoDB_import_students.json --jsonArray --drop
// mongoexport --db finalexam_mongo_practice --collection students --out students_export.json --jsonArray
// mongodump --db finalexam_mongo_practice --out mongodb_backup
// mongorestore --drop --db finalexam_mongo_practice mongodb_backup/finalexam_mongo_practice

