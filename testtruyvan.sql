USE [QLDatGiaoHang];
GO

 --Truy vấn cơ bản
-- Lấy tất cả đơn hàng của NCC A
SELECT * FROM PurchaseOrder WHERE SupplierID = 1;

--thêm xóa sử dụng mô phỏng
-- Bắt đầu transaction để mô phỏng
BEGIN TRANSACTION;

-- Kiểm tra dữ liệu trước khi thêm
SELECT * FROM Product WHERE ProductID = 118; -- Không có kết quả

-- Thêm sản phẩm mới
INSERT INTO Product (ProductID, ProductName, Unit, Specification, Inventory)
VALUES (118, 'Giấy vệ sinh', 'Cuộn', '2 lớp', 300);

-- Kiểm tra dữ liệu sau khi thêm
SELECT * FROM Product WHERE ProductID = 118; -- Hiển thị sản phẩm mới

-- Hủy thay đổi (không lưu vào database)
ROLLBACK TRANSACTION;

-- Kiểm tra lại sau khi rollback
SELECT * FROM Product WHERE ProductID = 118; -- Không có kết quả



--update kho hang
-- Bắt đầu transaction
BEGIN TRANSACTION;

-- Kiểm tra dữ liệu trước khi cập nhật
SELECT ProductID, ProductName, Inventory FROM Product WHERE ProductID = 102; -- Inventory = 200

-- Cập nhật tồn kho
UPDATE Product 
SET Inventory = 300 
WHERE ProductID = 102;

-- Kiểm tra dữ liệu sau khi cập nhật
SELECT ProductID, ProductName, Inventory FROM Product WHERE ProductID = 102; -- Inventory = 300

-- Hủy thay đổi
ROLLBACK TRANSACTION;

-- Kiểm tra lại sau khi rollback
SELECT ProductID, ProductName, Inventory FROM Product WHERE ProductID = 102; -- Trở về giá trị ban đầu (200)



--delete phieu dao hang
-- Bắt đầu transaction để đảm bảo an toàn
BEGIN TRANSACTION;

-- Xóa các bản ghi liên quan trong DeliveryDetail
DELETE FROM DeliveryDetail 
WHERE DeliveryID = 503; 

-- Xóa bản ghi trong DeliverySlip
DELETE FROM DeliverySlip 
WHERE DeliveryID = 503;

-- Kiểm tra kết quả
SELECT * FROM DeliveryDetail WHERE DeliveryID = 503; -- Không có kết quả
SELECT * FROM DeliverySlip WHERE DeliveryID = 503;   -- Không có kết quả

ROLLBACK TRANSACTION;




--truy van nang cao
-- Truy vấn sửa lỗi
SELECT 
    od.OrderID, 
    od.ProductID,
    od.OrderQuantity - SUM(COALESCE(dd.DeliveredQuantity, 0)) AS Remaining
FROM OrderDetail od
LEFT JOIN DeliveryDetail dd ON od.ProductID = dd.ProductID
GROUP BY od.OrderID, od.ProductID, od.OrderQuantity
HAVING od.OrderQuantity - SUM(COALESCE(dd.DeliveredQuantity, 0)) > 0;

-- Tổng giá trị đơn hàng của từng NCC
SELECT 
    s.Name,
    SUM(od.OrderQuantity * od.UnitPrice) AS TotalValue
FROM PurchaseOrder po
JOIN Supplier s ON po.SupplierID = s.SupplierID
JOIN OrderDetail od ON po.OrderID = od.OrderID
GROUP BY s.Name;

-- Sản phẩm được giao nhiều nhất
SELECT TOP 1 
    p.ProductName,
    SUM(dd.DeliveredQuantity) AS TotalDelivered
FROM Product p
JOIN DeliveryDetail dd ON p.ProductID = dd.ProductID
GROUP BY p.ProductName
ORDER BY TotalDelivered DESC;


--Kiểm tra số lượng đã giao
SELECT 
    od.OrderID, 
    od.ProductID,
    od.OrderQuantity,
    SUM(COALESCE(dd.DeliveredQuantity, 0)) AS DeliveredQuantity
FROM OrderDetail od
LEFT JOIN DeliveryDetail dd ON od.ProductID = dd.ProductID
GROUP BY od.OrderID, od.ProductID, od.OrderQuantity;


--Kiểm tra số lượng còn lại
SELECT 
    od.OrderID, 
    od.ProductID,
    od.OrderQuantity - SUM(COALESCE(dd.DeliveredQuantity, 0)) AS Remaining
FROM OrderDetail od
LEFT JOIN DeliveryDetail dd ON od.ProductID = dd.ProductID
GROUP BY od.OrderID, od.ProductID, od.OrderQuantity;

--Lọc các đơn hàng chưa giao đủ
SELECT 
    od.OrderID, 
    od.ProductID,
    od.OrderQuantity - SUM(COALESCE(dd.DeliveredQuantity, 0)) AS Remaining
FROM OrderDetail od
LEFT JOIN DeliveryDetail dd ON od.ProductID = dd.ProductID
GROUP BY od.OrderID, od.ProductID, od.OrderQuantity
HAVING od.OrderQuantity - SUM(COALESCE(dd.DeliveredQuantity, 0)) > 0;