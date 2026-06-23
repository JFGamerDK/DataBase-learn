# Department資料內容
INSERT INTO Department VALUES (26, '光電系');
INSERT INTO Department VALUES (40, '電子系');
INSERT INTO Department VALUES (43, '資工系');

# Professor資料內容
INSERT INTO Professor VALUES (401, '麥黨烙', 43);
INSERT INTO Professor VALUES (402, '梁詠珊', 43);
INSERT INTO Professor VALUES (403, '王小花', 40);
INSERT INTO Professor VALUES (404, '黃大頭', 26);
INSERT INTO Professor VALUES (405, '張懷賢', 26);

# Student資料內容
INSERT INTO Student VALUES (41026201, '王大明', '雲林縣西螺鎮建興路319號', 'A');
INSERT INTO Student VALUES (41040202, '林剛懷', '新北市土城區員林街64巷2弄18號', 'B');
INSERT INTO Student VALUES (41043203, '賈克林', '桃園市八德區大智路55號1樓', 'C');

# Course資料內容
INSERT INTO Course VALUES (1025, '真空與鍍膜技術', 26, '本課程介紹真空原理、設備運作與鍍膜技術，涵蓋PVD與CVD等應用，培養學生在半導體與光電產業中的實務技能。');
INSERT INTO Course VALUES (1037, '光電元件製程實習', 26, '本課程實作光電元件製程流程，涵蓋光罩設計、光蝕刻、薄膜沉積與封裝等，強化學生光電製造的實務能力。');
INSERT INTO Course VALUES (0433, '半導體元件', 40, '本課程介紹半導體元件的物理原理、結構與特性，涵蓋二極體、電晶體等元件，培養學生分析與應用能力。');
INSERT INTO Course VALUES (1746, '模糊理論與應用', 40, '本課程介紹模糊理論基本概念與推理方法，並探討其在控制、決策與人工智慧等領域的實際應用。');
INSERT INTO Course VALUES (1993, '資料庫系統', 43, '本課程重視理論與實務，培養學生具備資料庫系統設計、開發與管理能力，熟悉實務操作與應用。');
INSERT INTO Course VALUES (1990, '微處理機實習', 43, '本課程透過實作訓練學生操作微處理機，學習指令編寫、硬體控制與周邊介面應用，強化系統整合能力。');

# Teaching資料內容
INSERT INTO Teaching VALUES (405, 1025,'2025B');
INSERT INTO Teaching VALUES (404, 1037,'2024A');
INSERT INTO Teaching VALUES (403, 1746,'2025B');
INSERT INTO Teaching VALUES (403, 0433,'2024B');
INSERT INTO Teaching VALUES (402, 1993,'2025B');
INSERT INTO Teaching VALUES (401, 1990,'2025A');

# Transcript資料內容
INSERT INTO Transcript VALUES (41026201, 1025, '2025B', '');
INSERT INTO Transcript VALUES (41026201, 1993, '2025B', '');
INSERT INTO Transcript VALUES (41040202, 1746, '2025B', '');
INSERT INTO Transcript VALUES (41040202, 1993, '2025B', '');
INSERT INTO Transcript VALUES (41043203, 1990, '2025A', '');
INSERT INTO Transcript VALUES (41043203, 1993, '2025B', '');
