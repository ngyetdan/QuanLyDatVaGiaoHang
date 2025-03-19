													--Testtrigger--

USE [QLDatGiaoHang];
GO
--Trigger CheckMaxDelivery
-- Test thêm phiếu giao hàng thứ 4 cho đơn 1001 (sẽ gây lỗi)
BEGIN TRANSACTION; -- Bắt đầu transaction để rollback
    INSERT INTO DeliverySlip (DeliveryID, DeliveryDate, OrderID)
    VALUES (1, '2023-11-01', 1001); -- Thêm lần giao thứ 4 (OrderID 1001 đã có 3 phiếu giao)
    -- Trigger sẽ RAISERROR và ROLLBACK TRANSACTION tự động
ROLLBACK TRANSACTION; -- Hủy thay đổi

 --Trigger UpdateInventory_Insert
-- Test cập nhật tồn kho khi giao sản phẩm 101 (Inventory ban đầu: 150)
BEGIN TRANSACTION;
    -- Kiểm tra tồn kho trước khi test
    SELECT Inventory FROM Product WHERE ProductID = 101; 
    
    -- Thêm chi tiết giao hàng (số lượng giao: 10)
    INSERT INTO DeliveryDetail (DeliveryID, ProductID, DeliveredQuantity)
    VALUES (999, 101, 10); -- Sử dụng DeliveryID giả
    
    -- Kiểm tra tồn kho sau khi thêm
    SELECT Inventory FROM Product WHERE ProductID = 101; -- Kết quả: 150 + 10 = 170
ROLLBACK TRANSACTION; -- Hủy thay đổi


--Trigger PreventSupplierDelete
-- Test xóa NCC có ID = 1 (đã có đơn hàng)
BEGIN TRANSACTION;
    DELETE FROM Supplier WHERE SupplierID = 1; -- Sẽ gây lỗi
ROLLBACK TRANSACTION;

-- Test xóa NCC không có liên quan (ví dụ: SupplierID = 999)
BEGIN TRANSACTION;
    -- Thêm NCC test
    INSERT INTO Supplier (SupplierID, Name, Address, Phone)
    VALUES (999, 'NCC Test', 'Test Address', '0000000000');
    
    -- Xóa NCC test (không có liên quan)
    DELETE FROM Supplier WHERE SupplierID = 999; -- Thành công
ROLLBACK TRANSACTION; -- Khôi phục dữ liệu



--Trigger trg_CheckDeliveryQuantity
-- Test giao 200 sản phẩm 101 (OrderDetail chỉ đặt 50)
BEGIN TRANSACTION;
    -- Thêm phiếu giao hàng test
    INSERT INTO DeliverySlip (DeliveryID, DeliveryDate, OrderID)
    VALUES (999, '2023-11-01', 1001); -- OrderID 1001 có ProductID 101 đặt 50
    
    -- Thêm chi tiết giao vượt quá
    INSERT INTO DeliveryDetail (DeliveryID, ProductID, DeliveredQuantity)
    VALUES (999, 101, 200); -- Số lượng giao 200 > 50 → Lỗi
ROLLBACK TRANSACTION;

--Trigger trg_LogOrderDeletion
-- Test xóa đơn hàng và kiểm tra log
BEGIN TRANSACTION;
    -- Thêm đơn hàng test
    INSERT INTO PurchaseOrder (OrderID, OrderDate, SupplierID, Note)
    VALUES (9999, '2023-11-01', 1, 'Test Order');
    
    -- Xóa đơn hàng test
    DELETE FROM PurchaseOrder WHERE OrderID = 9999;
    
    -- Kiểm tra log
    SELECT * FROM OrderDeleteLog WHERE OrderID = 9999; -- Có 1 bản ghi
ROLLBACK TRANSACTION; -- Hủy thay đổi


--phương án dự phòng nếu chạy mà chưa rollback lại(tránh ảnh hưởng đến dữ liệu gốc)
DELETE FROM DeliverySlip WHERE DeliveryID = 999;
DELETE FROM Supplier WHERE SupplierID = 999;