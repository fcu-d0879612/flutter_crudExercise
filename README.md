# Flutter crud 練習
主頁面：
![image](doc/Main.png)

Get One :   使用下拉式選單選擇指定資料
![image](doc/GetOne.png)
Get All :   顯示所有資料
![image](doc/Add.png)
Add:        以表單方式新增資料
![image](doc/Add.png)
Edit :    修改項目
！[image](doc/Edit.png)
Delect ： 刪除選擇項目
![image](doc/Delected.png)

 +-------------------------------------------------------------+
|                         Flutter App                          |
|                                                             |
|  +-------------------------------------------------------+  |
|  |                       UI Layer                         |  |
|  |  - Home Widget                                        |  |
|  |  - Add Widget                                         |  |
|  +-------------------------------------------------------+  |
|                                                             |
|  +-------------------------------------------------------+  |
|  |                   State Management                     |  |
|  |  - HomeState                                           |  |
|  |  - AddState                                            |  |
|  +-------------------------------------------------------+  |
|                                                             |
|  +-------------------------------------------------------+  |
|  |                   Data Access Layer                    |  |
|  |  - Database Helper                                     |  |
|  |    - Open/Close Database                               |  |
|  |    - CRUD Operations                                   |  |
|  |      - createHero                                      |  |
|  |      - readHero                                        |  |
|  |      - updateHero                                      |  |
|  |      - deleteHero                                      |  |
|  +-------------------------------------------------------+  |
|                                                             |
+-------------------------------------------------------------+
                               |
                               |
                        +-------------+
                        |   SQLite    |
                        |  Database   |
                        +-------------+
