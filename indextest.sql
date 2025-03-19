								--Testindex--
--Index idx_OrderDetail_OrderID_ProductID
-- Bật execution plan
SET STATISTICS XML ON;

-- Thực thi truy vấn
SELECT * FROM PurchaseOrder 
WHERE OrderDate BETWEEN '2023-10-01' AND '2023-10-10';

-- Tắt execution plan
SET STATISTICS XML OFF;

--Index idx_DeliverySlip_OrderID
-- Bật execution plan
SET STATISTICS XML ON;

-- Truy vấn tìm phiếu giao hàng theo OrderID
SELECT * FROM DeliverySlip 
WHERE OrderID = 1001;

-- Tắt execution plan
SET STATISTICS XML OFF;


--Index idx_Product_ProductName--
-- Bật execution plan
SET STATISTICS XML ON;

-- Truy vấn tìm sản phẩm theo tên
SELECT * FROM Product 
WHERE ProductName = 'Gạo';

-- Tắt execution plan
SET STATISTICS XML OFF;

--Index idx_Supplier_Name
-- Bật execution plan
SET STATISTICS XML ON;

-- Truy vấn tìm NCC theo tên
SELECT * FROM Supplier 
WHERE Name = 'NCC A';

-- Tắt execution plan
SET STATISTICS XML OFF;



--Index idx_DeliveryDetail_DeliveryID_ProductID
-- Bật execution plan
SET STATISTICS XML ON;

-- Truy vấn tìm chi tiết giao hàng theo DeliveryID và ProductID
SELECT * FROM DeliveryDetail 
WHERE DeliveryID = 501 AND ProductID = 101;

-- Tắt execution plan
SET STATISTICS XML OFF;



--Index idx_Product_Inventory
-- Bật execution plan
SET STATISTICS XML ON;

-- Truy vấn tìm sản phẩm có tồn kho dưới 100
SELECT * FROM Product 
WHERE Inventory < 100;

-- Tắt execution plan
SET STATISTICS XML OFF;


--check index theo ten bảng
SELECT 
    name AS IndexName,
    type_desc AS IndexType
FROM 
    sys.indexes
WHERE 
    object_id = OBJECT_ID('name?');