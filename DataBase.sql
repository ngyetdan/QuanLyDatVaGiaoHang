CREATE DATABASE QLDatGiaoHang;
USE QLDatGiaoHang;

-- Tạo bảng Nhà cung cấp
CREATE TABLE Supplier (
    SupplierID INT PRIMARY KEY,
    Name NVARCHAR(100),
    Address NVARCHAR(200),
    Phone VARCHAR(20)
);

-- Tạo bảng Mặt hàng
CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Unit NVARCHAR(50),
    Specification NVARCHAR(200),
    Inventory INT
);

-- Bảng trung gian NCC cung cấp MH
CREATE TABLE Supply (
    SupplierID INT,
    ProductID INT,
    PRIMARY KEY (SupplierID, ProductID),
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- Tạo bảng Đơn đặt hàng
CREATE TABLE PurchaseOrder (
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    SupplierID INT,
    Note NVARCHAR(500),
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);

-- Chi tiết đơn hàng
CREATE TABLE OrderDetail (
    OrderID INT,
    ProductID INT,
    OrderQuantity INT,
    UnitPrice DECIMAL(10,2),
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES PurchaseOrder(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- Phiếu giao hàng
CREATE TABLE DeliverySlip (
    DeliveryID INT PRIMARY KEY,
    DeliveryDate DATE,
    OrderID INT,
    FOREIGN KEY (OrderID) REFERENCES PurchaseOrder(OrderID)
);

-- Chi tiết giao hàng
CREATE TABLE DeliveryDetail (
    DeliveryID INT,
    ProductID INT,
    DeliveredQuantity INT,
    PRIMARY KEY (DeliveryID, ProductID),
    FOREIGN KEY (DeliveryID) REFERENCES DeliverySlip(DeliveryID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

--KhachHang
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,        
    CustomerName NVARCHAR(100) NOT NULL,
    Phone VARCHAR(20),       
    Email NVARCHAR(100),           
    Address NVARCHAR(200)   
);

--DonThanhToan
CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY,            
    OrderID INT,                         
    CustomerID INT,                    
    PaymentDate DATE,                    
    Amount DECIMAL(10, 2),             
    PaymentMethod NVARCHAR(50),          
    FOREIGN KEY (OrderID) REFERENCES PurchaseOrder(OrderID), 
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) 
);
--Cập nhật bảng PurchaseOrder

ALTER TABLE PurchaseOrder
ADD CustomerID INT,
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID);




--dữ liệu mẫu
--1. Nhà cung cấp (Supplier)
INSERT INTO Supplier VALUES 
(1, 'NCC A', 'Hà Nội', '0987654321'),
(2, 'NCC B', 'TP.HCM', '0912345678'),
(3, 'NCC C', 'Đà Nẵng', '0978123456'),
(4, 'NCC D', 'Cần Thơ', '0933123456'),
(5, 'NCC E', 'Hải Phòng', '0988999888'),
(6, 'NCC F', 'Bình Dương', '0911111111'),
(7, 'NCC G', 'Nha Trang', '0922222222'),
(8, 'NCC H', 'Vũng Tàu', '0933333333'),
(9, 'NCC I', 'Huế', '0944444444'),
(10, 'NCC J', 'Quảng Ninh', '0955555555'),
(11, 'NCC K', 'Long An', '0966666666'),
(12, 'NCC L', 'Bắc Ninh', '0977777777'),
(13, 'NCC M', 'Hải Dương', '0988888888'),
(14, 'NCC N', 'Thái Nguyên', '0999999999'),
(15, 'NCC O', 'Lâm Đồng', '0900000000');
--2. Mặt hàng (Product)
INSERT INTO Product VALUES 
(101, 'Gạo', 'Bao', 'Loại 1', 100),
(102, 'Đường', 'Kg', 'Hạt trắng', 200),
(103, 'Sữa', 'Thùng', 'Nguyên kem', 50),
(104, 'Dầu ăn', 'Chai', '1000ml', 150),
(105, 'Dầu ăn', 'Chai', '500ml', 80),
(106, 'Nước ngọt', 'Thùng', '24 lon', 200),
(107, 'Bánh mì', 'Cái', 'Nhân thịt', 150),
(108, 'Trứng gà', 'Chục', 'Tươi', 200),
(109, 'Cà phê', 'Túi', 'Hạt rang', 150),
(110, 'Bia', 'Thùng', '330ml', 300),
(111, 'Nước mắm', 'Chai', 'Đặc biệt', 100),
(112, 'Mì tôm', 'Thùng', 'Vị tôm chua cay', 500),
(113, 'Kẹo', 'Gói', 'Vị trái cây', 400),
(114, 'Tã giấy', 'Hộp', 'Size M', 250),
(115, 'Khẩu trang', 'Hộp', '3 lớp', 1000),
(116, 'Bút bi', 'Cây', 'Mực xanh', 600),
(117, 'Vở', 'Quyển', '96 trang', 800);
--3. NCC cung cấp MH (Supply)
INSERT INTO Supply VALUES 
(1, 101), (1, 102), (2, 102), (2, 103), (3, 101), (3, 103),
(4, 105), (4, 106), (5, 107), (5, 101), (6, 108), (6, 109),
(7, 110), (7, 111), (8, 112), (8, 113), (9, 114), (9, 115),
(10, 116), (10, 117), (11, 108), (11, 110), (12, 109), (12, 112),
(13, 111), (13, 113), (14, 114), (14, 116), (15, 115), (15, 117);
--4. Đơn đặt hàng (PurchaseOrder)
INSERT INTO PurchaseOrder VALUES 
(1001, '2023-10-01', 1, 'Gấp'),
(1002, '2023-10-02', 2, 'Kiểm tra kỹ'),
(1003, '2023-10-03', 3, 'Giao vào buổi sáng'),
(1004, '2023-10-10', 4, 'Giao trước 15/10'),
(1005, '2023-10-11', 5, 'Kiểm tra hạn sử dụng'),
(1006, '2023-10-16', 2, 'Giao nhanh'),
(1007, '2023-10-17', 6, 'Giao sáng'),
(1008, '2023-10-18', 7, 'Kiểm tra kỹ'),
(1009, '2023-10-19', 8, 'Hàng dễ vỡ'),
(1010, '2023-10-20', 9, 'Giao trước 22/10'),
(1011, '2023-10-21', 10, 'Yêu cầu hóa đơn'),
(1012, '2023-10-22', 11, 'Không giao trễ'),
(1013, '2023-10-23', 12, 'Liên hệ trước'),
(1014, '2023-10-24', 13, 'Giao buổi chiều'),
(1015, '2023-10-25', 14, 'Đóng gói cẩn thận'),
(1016, '2023-10-26', 15, 'Hàng khuyến mãi');
--5. Chi tiết đơn hàng (OrderDetail)
INSERT INTO OrderDetail VALUES 
(1001, 101, 50, 200000), (1001, 102, 100, 15000),
(1002, 103, 30, 250000), (1003, 101, 20, 210000),
(1004, 105, 100, 45000), (1004, 106, 50, 120000),
(1005, 107, 200, 10000), (1005, 101, 30, 220000),
(1006, 102, 80, 16000), (1007, 108, 50, 30000),
(1007, 109, 100, 50000), (1008, 110, 30, 120000),
(1008, 111, 80, 25000), (1009, 112, 200, 15000),
(1009, 113, 150, 10000), (1010, 114, 100, 45000),
(1010, 115, 300, 5000), (1011, 116, 500, 8000),
(1011, 117, 400, 10000), (1012, 108, 60, 32000),
(1012, 110, 40, 130000), (1013, 109, 120, 48000),
(1013, 112, 180, 16000), (1014, 111, 90, 27000),
(1014, 113, 130, 11000), (1015, 114, 110, 46000),
(1015, 116, 450, 8200), (1016, 115, 320, 5200),
(1016, 117, 420, 10500);
--6. Phiếu giao hàng (DeliverySlip)
INSERT INTO DeliverySlip VALUES 
(501, '2023-10-05', 1001), (502, '2023-10-06', 1001),
(503, '2023-10-07', 1002), (504, '2023-10-12', 1004),
(505, '2023-10-13', 1004), (506, '2023-10-14', 1005),
(507, '2023-10-15', 1005), (508, '2023-10-17', 1004),
(509, '2023-10-18', 1007), (510, '2023-10-19', 1007),
(511, '2023-10-20', 1008), (512, '2023-10-21', 1009),
(513, '2023-10-22', 1010), (514, '2023-10-23', 1011),
(515, '2023-10-24', 1012), (516, '2023-10-25', 1013),
(517, '2023-10-26', 1014), (518, '2023-10-27', 1015);
--7. Chi tiết giao hàng (DeliveryDetail)
INSERT INTO DeliveryDetail VALUES 
(501, 101, 30), (501, 102, 50),
(502, 101, 20), (502, 102, 30),
(503, 103, 10), (504, 105, 50),
(504, 106, 20), (505, 105, 30),
(505, 106, 10), (506, 107, 100),
(506, 101, 15), (507, 107, 50),
(508, 105, 10), (509, 108, 20),
(509, 109, 50), (510, 108, 30),
(510, 109, 50), (511, 110, 15),
(511, 111, 40), (512, 112, 100),
(512, 113, 80), (513, 114, 50),
(513, 115, 150), (514, 116, 250),
(514, 117, 200), (515, 108, 30),
(515, 110, 20), (516, 109, 60),
(516, 112, 90), (517, 111, 45),
(517, 113, 65), (518, 114, 60),
(518, 116, 200);
-- Chèn dữ liệu vào bảng Customer
INSERT INTO Customer (CustomerID, CustomerName, Phone, Email, Address) VALUES
(1, 'Nguyễn Văn A', '0912345678', 'nguyenvana@gmail.com', 'Hà Nội'),
(2, 'Trần Thị B', '0987654321', 'tranthib@gmail.com', 'TP.HCM'),
(3, 'Lê Văn C', '0978123456', 'levanc@gmail.com', 'Đà Nẵng'),
(4, 'Phạm Thị D', '0966666666', 'phamthid@gmail.com', 'Cần Thơ'),
(5, 'Hoàng Văn E', '0955555555', 'hoangve@gmail.com', 'Hải Phòng'),
(6, 'Vũ Thị F', '0944444444', 'vuthif@gmail.com', 'Bình Dương'),
(7, 'Đặng Văn G', '0933333333', 'dangvangg@gmail.com', 'Nha Trang'),
(8, 'Bùi Thị H', '0922222222', 'buithih@gmail.com', 'Vũng Tàu'),
(9, 'Ngô Văn I', '0911111111', 'ngovani@gmail.com', 'Huế'),
(10, 'Đỗ Thị K', '0900000000', 'dothik@gmail.com', 'Quảng Ninh'),
(11, 'Lý Văn L', '0899999999', 'lyvanl@gmail.com', 'Long An'),
(12, 'Trịnh Thị M', '0888888888', 'trinhthim@gmail.com', 'Bắc Ninh'),
(13, 'Mai Văn N', '0877777777', 'maivann@gmail.com', 'Hải Dương'),
(14, 'Hồ Thị O', '0866666666', 'hothio@gmail.com', 'Thái Nguyên'),
(15, 'Phan Văn P', '0855555555', 'phanvanp@gmail.com', 'Lâm Đồng');
-- Chèn dữ liệu vào bảng Payment
INSERT INTO Payment (PaymentID, OrderID, CustomerID, PaymentDate, Amount, PaymentMethod) VALUES
(1, 1001, 1, '2023-10-05', 5000000, 'Chuyển khoản'),
(2, 1002, 2, '2023-10-06', 3000000, 'Tiền mặt'),
(3, 1003, 3, '2023-10-07', 2000000, 'Thẻ tín dụng'),
(4, 1004, 4, '2023-10-08', 1500000, 'Chuyển khoản'),
(5, 1005, 5, '2023-10-09', 2500000, 'Tiền mặt'),
(6, 1006, 6, '2023-10-10', 1000000, 'Thẻ tín dụng'),
(7, 1007, 7, '2023-10-11', 3500000, 'Chuyển khoản'),
(8, 1008, 8, '2023-10-12', 4000000, 'Tiền mặt'),
(9, 1009, 9, '2023-10-13', 4500000, 'Thẻ tín dụng'),
(10, 1010, 10, '2023-10-14', 500000, 'Chuyển khoản'),
(11, 1011, 11, '2023-10-15', 600000, 'Tiền mặt'),
(12, 1012, 12, '2023-10-16', 700000, 'Thẻ tín dụng'),
(13, 1013, 13, '2023-10-17', 800000, 'Chuyển khoản'),
(14, 1014, 14, '2023-10-18', 900000, 'Tiền mặt'),
(15, 1015, 15, '2023-10-19', 1000000, 'Thẻ tín dụng');
