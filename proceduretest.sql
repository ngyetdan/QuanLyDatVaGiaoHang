													--TestProcedure--
USE [QLDatGiaoHang];
GO
--sp_GetAllOrders
EXEC sp_GetAllOrders;

--sp_GetOrdersBySupplier
EXEC sp_GetOrdersBySupplier @SupplierID = 1;

SELECT * FROM PurchaseOrder WHERE OrderID = SCOPE_IDENTITY();

--sp_UpdateInventory
EXEC sp_UpdateInventory 
  @ProductID = 101,
  @Quantity = 50; -- Tăng tồn kho thêm 50
  --check
  SELECT * FROM Product WHERE ProductID = 101;

--sp_DeleteOrder
-- Thử xóa đơn hàng (đã có phiếu giao)
EXEC sp_DeleteOrder @OrderID = 1001;


--sp_CalculateOrderTotal
DECLARE @Total DECIMAL(10,2);
EXEC sp_CalculateOrderTotal 
  @OrderID = 1001,
  @Total = @Total OUTPUT;
SELECT @Total AS TotalAmount;


--sp_GetProductsByInventoryRange
EXEC sp_GetProductsByInventoryRange 
  @MinInventory = 50,
  @MaxInventory = 200;

--sp_AddOrder
EXEC sp_AddOrder 
    @OrderDate = '2023-11-01',
    @SupplierID = 1,
    @Note = 'Giao hàng trước 10h sáng';
	--check
	SELECT * FROM PurchaseOrder WHERE OrderID = 1017;

--sp_BackupSuppliers
EXEC sp_BackupSuppliers;
SELECT * FROM SupplierBackup;