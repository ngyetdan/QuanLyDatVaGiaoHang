USE [QLDatGiaoHang];
GO
--xem các function đã tạo 
SELECT 
    name AS FunctionName,
    type_desc AS FunctionType,
    create_date AS CreatedDate
FROM sys.objects
WHERE type IN ('FN', 'IF', 'TF')
ORDER BY FunctionName;
-- Xem định nghĩa của function
EXEC sp_helptext 'fn_GetTotalOrderedQuantity';




-- Liệt kê tất cả stored procedure
SELECT 
    name AS ProcedureName,
    type_desc AS ProcedureType,
    create_date AS CreatedDate
FROM sys.objects
WHERE type = 'P'
ORDER BY ProcedureName;
-- Xem định nghĩa của stored procedure
EXEC sp_helptext 'sp_GetOrdersBySupplier';




--xem các trigger
SELECT 
    name AS TriggerName,
    type_desc AS TriggerType,
    create_date AS CreatedDate,
    OBJECT_NAME(parent_id) AS TableName
FROM sys.triggers
ORDER BY TriggerName;
-- Xem định nghĩa của PreventSupplierDelete
EXEC sp_helptext 'PreventSupplierDelete';




--xem các index
SELECT 
    t.name AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    c.name AS ColumnName,
    i.is_unique AS IsUnique,
    i.is_primary_key AS IsPrimaryKey
FROM 
    sys.tables t
INNER JOIN 
    sys.indexes i ON t.object_id = i.object_id
INNER JOIN 
    sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
INNER JOIN 
    sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
ORDER BY 
    TableName, IndexName;

	-- Xem index trên bảng PurchaseOrder
EXEC sp_helpindex 'Supply';