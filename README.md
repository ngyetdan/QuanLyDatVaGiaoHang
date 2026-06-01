# 📦 QLDatGiaoHang — Hệ Thống Quản Lý Đặt & Giao Hàng

> Đồ án môn Cơ sở dữ liệu — Nhóm 2 | Thành viên: Đỗ Khánh Hưng

---

## 📋 Giới Thiệu

**QLDatGiaoHang** là hệ thống cơ sở dữ liệu SQL Server quản lý toàn bộ quy trình đặt hàng và giao hàng, bao gồm:

- Quản lý nhà cung cấp và mặt hàng
- Lập đơn đặt hàng và theo dõi chi tiết
- Quản lý phiếu giao hàng
- Quản lý khách hàng và thanh toán
- Bảo mật dữ liệu nhạy cảm bằng mã hóa AES-256

---

## 🗂️ Cấu Trúc Database

### Các bảng chính

| Bảng | Mô tả |
|------|-------|
| `Supplier` | Nhà cung cấp |
| `Product` | Mặt hàng |
| `Supply` | Quan hệ NCC — Mặt hàng |
| `PurchaseOrder` | Đơn đặt hàng |
| `OrderDetail` | Chi tiết đơn hàng |
| `DeliverySlip` | Phiếu giao hàng |
| `DeliveryDetail` | Chi tiết giao hàng |
| `Customer` | Khách hàng |
| `Payment` | Đơn thanh toán |

### Sơ đồ quan hệ (ERD tóm tắt)

```
Supplier ──< Supply >── Product
    │
    └──< PurchaseOrder >── OrderDetail
              │
              └──< DeliverySlip >── DeliveryDetail
              │
              └──< Payment ── Customer
```

---

## 📁 Cấu Trúc File

| File | Mô tả |
|------|-------|
| `DataBase.sql` | Tạo database, bảng và dữ liệu mẫu |
| `mahoa.sql` | Mã hóa dữ liệu nhạy cảm (AES-256) |
| `view.sql` | Test các View đã tạo |
| `functiontest.sql` | Test các Function |
| `proceduretest.sql` | Test các Stored Procedure |
| `Triggertest.sql` | Test các Trigger |
| `indextest.sql` | Test hiệu năng Index |
| `testtruyvan.sql` | Các truy vấn cơ bản và nâng cao |
| `detail.sql` | Xem metadata (functions, procedures, triggers, indexes) |
| `Backup+user.sql` | Backup dữ liệu và quản lý user |

---

## ⚙️ Các Đối Tượng Database

### 🔍 Views

| View | Mô tả |
|------|-------|
| `vw_OrderSupplierInfo` | Thông tin đơn hàng kèm nhà cung cấp |
| `vw_OrderProductDetails` | Chi tiết sản phẩm trong đơn hàng |
| `vw_TotalOrderBySupplier` | Tổng đơn hàng theo NCC |
| `vw_DeliveryCountPerOrder` | Số lần giao theo đơn hàng |
| `vw_DeliveryDetails` | Chi tiết giao hàng |
| `vw_LowInventoryProducts` | Sản phẩm tồn kho thấp |
| `vw_IncompleteOrders` | Đơn hàng chưa giao đủ |

### ⚡ Functions

| Function | Loại | Mô tả |
|----------|------|-------|
| `fn_GetTotalOrderedQuantity` | Scalar | Tổng số lượng đặt theo sản phẩm |
| `fn_SupplierExists` | Scalar | Kiểm tra NCC có tồn tại |
| `fn_CheckInventory` | Scalar | Kiểm tra tồn kho |
| `fn_GetProductsBySupplier` | Table-valued | Danh sách sản phẩm theo NCC |
| `fn_GetOrdersByDateRange` | Table-valued | Đơn hàng theo khoảng thời gian |
| `fn_GetTopProducts` | Table-valued | Top sản phẩm bán chạy |
| `fn_GetDeliveryDetails` | Table-valued | Chi tiết phiếu giao hàng |
| `fn_GetSupplierRevenue` | Table-valued | Doanh thu theo NCC |

### 🛠️ Stored Procedures

| Procedure | Mô tả |
|-----------|-------|
| `sp_GetAllOrders` | Lấy tất cả đơn hàng |
| `sp_GetOrdersBySupplier` | Đơn hàng theo NCC |
| `sp_UpdateInventory` | Cập nhật tồn kho |
| `sp_DeleteOrder` | Xóa đơn hàng (có kiểm tra) |
| `sp_CalculateOrderTotal` | Tính tổng giá trị đơn hàng |
| `sp_GetProductsByInventoryRange` | Sản phẩm theo khoảng tồn kho |
| `sp_AddOrder` | Thêm đơn hàng mới |
| `sp_BackupSuppliers` | Backup bảng nhà cung cấp |
| `sp_GetProductSummary` | Tóm tắt thông tin sản phẩm |

### 🔔 Triggers

| Trigger | Bảng | Mô tả |
|---------|------|-------|
| `CheckMaxDelivery` | `DeliverySlip` | Giới hạn tối đa 3 phiếu giao / đơn hàng |
| `UpdateInventory_Insert` | `DeliveryDetail` | Cập nhật tồn kho khi giao hàng |
| `PreventSupplierDelete` | `Supplier` | Ngăn xóa NCC đang có đơn hàng |
| `trg_CheckDeliveryQuantity` | `DeliveryDetail` | Kiểm tra số lượng giao không vượt đặt |
| `trg_LogOrderDeletion` | `PurchaseOrder` | Ghi log khi xóa đơn hàng |

### 📊 Indexes

| Index | Bảng | Cột |
|-------|------|-----|
| `idx_OrderDetail_OrderID_ProductID` | `OrderDetail` | `OrderID`, `ProductID` |
| `idx_DeliverySlip_OrderID` | `DeliverySlip` | `OrderID` |
| `idx_Product_ProductName` | `Product` | `ProductName` |
| `idx_Supplier_Name` | `Supplier` | `Name` |
| `idx_DeliveryDetail_DeliveryID_ProductID` | `DeliveryDetail` | `DeliveryID`, `ProductID` |
| `idx_Product_Inventory` | `Product` | `Inventory` |

---

## 🔐 Bảo Mật Dữ Liệu

Dữ liệu nhạy cảm của khách hàng (`Email`, `Phone`, `Address`) được mã hóa bằng **AES-256** sử dụng SQL Server's Transparent Data Encryption:

- **Master Key** → **Certificate** (`CustomerEncryptCert`) → **Symmetric Key** (`CustomerAESKey`)
- Dữ liệu mã hóa lưu trong các cột `*_Encrypted` kiểu `VARBINARY(256)`
- Certificate được backup ra file `.cer` + `.pvk` để khôi phục khi cần

---

## 🚀 Hướng Dẫn Chạy

### Yêu cầu
- SQL Server 2016 trở lên
- SQL Server Management Studio (SSMS)

### Các bước thực hiện

1. **Tạo database và dữ liệu mẫu**
   ```sql
   -- Chạy file DataBase.sql
   ```

2. **Thiết lập mã hóa** *(tùy chọn)*
   ```sql
   -- Chạy file mahoa.sql
   -- Lưu ý: thay đổi password trong file trước khi chạy
   ```

3. **Kiểm tra các đối tượng**
   ```sql
   -- Chạy các file test theo thứ tự:
   -- functiontest.sql → proceduretest.sql → Triggertest.sql → indextest.sql → view.sql
   ```

4. **Xem metadata**
   ```sql
   -- Chạy detail.sql để liệt kê tất cả functions, procedures, triggers, indexes
   ```

---

## 📊 Dữ Liệu Mẫu

| Bảng | Số bản ghi |
|------|-----------|
| Supplier | 15 |
| Product | 17 |
| PurchaseOrder | 16 |
| Customer | 15 |
| Payment | 15 |
| DeliverySlip | 18 |

---

## 👥 Thông Tin Nhóm

- **Nhóm:** NHOM2
- **Thành viên:** Đỗ Khánh Hưng
- **Tài liệu báo cáo:** `NHOM2_DoKhanhHung.docx`
