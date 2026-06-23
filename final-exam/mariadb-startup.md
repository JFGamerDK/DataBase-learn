# MariaDB 啟動教學

這份教學的指令不使用個人電腦的絕對路徑。  
請先把終端機開在 MariaDB 的安裝資料夾，或確認 MariaDB 指令已經加入系統 PATH。

## 方法一：MariaDB 已安裝成 Windows 服務

如果是用安裝精靈安裝 MariaDB，通常可以用服務方式啟動。

```powershell
net start MariaDB
```

登入 MariaDB：

```powershell
mariadb -u root -p
```

停止 MariaDB：

```powershell
net stop MariaDB
```

如果出現「存取被拒」，請用系統管理員身分開啟終端機。

## 方法二：解壓縮版或免安裝版 MariaDB

請先把終端機開在 MariaDB 的安裝資料夾。  
資料夾裡通常會看到 `bin`、`data`、`lib`、`share` 等資料夾。

啟動伺服器：

```powershell
.\bin\mysqld --console
```

啟動後這個視窗不要關掉。  
另外再開一個終端機，同樣切到 MariaDB 的安裝資料夾，然後登入：

```powershell
.\bin\mariadb -u root -p
```

如果 root 還沒有密碼，可以先直接按 Enter。

## 如果沒有 data 資料夾

第一次使用解壓縮版時，可能需要先建立資料庫資料夾：

```powershell
.\bin\mariadb-install-db --datadir=.\data
```

建立完成後，再啟動 MariaDB：

```powershell
.\bin\mysqld --console --datadir=.\data
```

## 確認是否成功登入

登入後可以輸入：

```sql
SELECT VERSION();
SHOW DATABASES;
```

如果有看到版本號與資料庫清單，就代表 MariaDB 已經可以使用。

離開 MariaDB：

```sql
exit;
```

## 常見問題

### 1. 出現「找不到指令」

通常代表目前終端機不在 MariaDB 安裝資料夾，或 MariaDB 沒有加入 PATH。

解法：

- 如果是解壓縮版，請把終端機開在 MariaDB 安裝資料夾後再執行指令。
- 如果是安裝版，可以重新開啟終端機，或確認安裝時是否有加入 PATH。

### 2. 連線失敗

請先確認 MariaDB 伺服器是否已經啟動。

服務版可以檢查：

```powershell
net start MariaDB
```

解壓縮版請確認執行 `mysqld --console` 的視窗仍然開著。

### 3. 想停止解壓縮版 MariaDB

在執行 `mysqld --console` 的視窗按：

```text
Ctrl + C
```

或登入 MariaDB 後執行：

```sql
SHUTDOWN;
```

## 考試前快速流程

```powershell
.\bin\mysqld --console
```

另一個終端機：

```powershell
.\bin\mariadb -u root -p
```

登入後：

```sql
SELECT VERSION();
SHOW DATABASES;
```
