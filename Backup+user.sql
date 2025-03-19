--Tạo Người Dùng và Phân Quyền
--Tạo Login (Tài khoản đăng nhập vào Server)
USE master;
GO

-- Tạo Login cho Quản trị viên
CREATE LOGIN AdminLogin WITH PASSWORD = 'Admin@123';

-- Tạo Login cho Nhân viên bán hàng
CREATE LOGIN SalesLogin WITH PASSWORD = 'Sales@123';

-- Tạo Login cho Nhân viên kho
CREATE LOGIN WarehouseLogin WITH PASSWORD = 'Warehouse@123';
 --Tạo User (Tài khoản trong Database)
USE QLDatGiaoHang; -- Thay tên database của bạn
GO

-- User cho Quản trị viên
CREATE USER AdminUser FOR LOGIN AdminLogin;

-- User cho Nhân viên bán hàng
CREATE USER SalesUser FOR LOGIN SalesLogin;

-- User cho Nhân viên kho
CREATE USER WarehouseUser FOR LOGIN WarehouseLogin;
 --Phân Quyền Truy Cập
 --Quyền cho AdminUser (Toàn quyền)
-- Cấp quyền db_owner (toàn quyền trên database)
ALTER ROLE db_owner ADD MEMBER AdminUser;
 --Quyền cho SalesUser (Truy cập đơn hàng và sản phẩm)
-- Quyền SELECT, INSERT, UPDATE trên bảng PurchaseOrder và OrderDetail
GRANT SELECT, INSERT, UPDATE ON PurchaseOrder TO SalesUser;
GRANT SELECT, INSERT, UPDATE ON OrderDetail TO SalesUser;

-- Quyền SELECT trên bảng Product và Supplier
GRANT SELECT ON Product TO SalesUser;
GRANT SELECT ON Supplier TO SalesUser;

-- Từ chối quyền DELETE
DENY DELETE ON PurchaseOrder TO SalesUser;
--Quyền cho WarehouseUser (Quản lý giao hàng và tồn kho)
-- Quyền SELECT, INSERT, UPDATE trên DeliverySlip và DeliveryDetail
GRANT SELECT, INSERT, UPDATE ON DeliverySlip TO WarehouseUser;
GRANT SELECT, INSERT, UPDATE ON DeliveryDetail TO WarehouseUser;

-- Quyền UPDATE trên cột Inventory của bảng Product
GRANT UPDATE ON Product(Inventory) TO WarehouseUser;

-- Từ chối quyền DELETE
DENY DELETE ON DeliverySlip TO WarehouseUser;
DENY DELETE ON DeliveryDetail TO WarehouseUser;

--Quản Lý Sao Lưu và Phục Hồi
 --Sao Lưu Database
 --Sao lưu toàn bộ (Full Backup)
USE master;
GO

BACKUP DATABASE QLDatGiaoHang
TO DISK = 'C:\Backup\QLDatGiaoHang_Full.bak'
WITH INIT, NAME = 'Full Backup of QLDatGiaoHang';
 --Sao lưu chênh lệch (Differential Backup)
BACKUP DATABASE QLDatGiaoHang
TO DISK = 'C:\Backup\QLDatGiaoHang_Diff.bak'
WITH DIFFERENTIAL, NAME = 'Differential Backup of QLDatGiaoHang';
 --Sao lưu nhật ký giao dịch (Transaction Log Backup)
BACKUP LOG QLDatGiaoHang
TO DISK = 'C:\Backup\QLDatGiaoHang_Log.trn'
WITH NAME = 'Transaction Log Backup of QLDatGiaoHang';
 --Phục Hồi Database
 --Phục hồi từ Full Backup
RESTORE DATABASE QLDatGiaoHang
FROM DISK = 'C:\Backup\QLDatGiaoHang_Full.bak'
WITH REPLACE;
 --Phục hồi kết hợp Full + Differential Backup
RESTORE DATABASE QLDatGiaoHang
FROM DISK = 'C:\Backup\QLDatGiaoHang_Full.bak'
WITH NORECOVERY;

RESTORE DATABASE QLDatGiaoHang
FROM DISK = 'C:\Backup\QLDatGiaoHang_Diff.bak'
WITH RECOVERY;
 --Phục hồi đến thời điểm cụ thể (Point-in-Time Recovery)
RESTORE DATABASE QLDatGiaoHang
FROM DISK = 'C:\Backup\QLDatGiaoHang_Full.bak'
WITH NORECOVERY;

RESTORE LOG QLDatGiaoHang
FROM DISK = 'C:\Backup\QLDatGiaoHang_Log.trn'
WITH STOPAT = '2023-10-30T12:00:00', RECOVERY;

 --Kiểm Tra Phân Quyền
 --Kiểm tra quyền của SalesUser
-- Xem quyền trên bảng PurchaseOrder
EXEC sp_helprotect @username = 'SalesUser', @name = 'PurchaseOrder';
 --Kiểm tra quyền của WarehouseUser
-- Xem quyền trên bảng DeliverySlip
EXEC sp_helprotect @username = 'WarehouseUser', @name = 'DeliverySlip';
