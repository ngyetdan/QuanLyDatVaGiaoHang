												--TestFunction--
USE [QLDatGiaoHang];
GO

--fn_GetTotalOrderedQuantity
SELECT dbo.fn_GetTotalOrderedQuantity(101) AS TotalOrdered;

--fn_SupplierExists
IF dbo.fn_SupplierExists(2) = 1
    PRINT 'Nhà cung cấp tồn tại.';
ELSE
    PRINT 'Nhà cung cấp không tồn tại.';


--fn_CheckInventory
SELECT dbo.fn_CheckInventory(101) AS Inventory;


--fn_GetProductsBySupplier
SELECT * FROM dbo.fn_GetProductsBySupplier(1);

--fn_GetOrdersByDateRange
SELECT * FROM dbo.fn_GetOrdersByDateRange('2023-10-01', '2023-10-10');


--fn_GetTopProducts
SELECT * FROM dbo.fn_GetTopProducts(4);


--fn_GetDeliveryDetails
SELECT * FROM dbo.fn_GetDeliveryDetails(501);


--fn_GetSupplierRevenue
SELECT * FROM dbo.fn_GetSupplierRevenue();

--sp_GetProductSummary
EXEC sp_GetProductSummary @ProductID = 101;


--fn_SupplierExists
-- Kiểm tra nhà cung cấp có SupplierID = 1(có tồn tại)
SELECT dbo.fn_SupplierExists(1) AS SupplierExists;
-- Kiểm tra nhà cung cấp có SupplierID = 999(ko tồn tại)
SELECT dbo.fn_SupplierExists(999) AS SupplierExists;
