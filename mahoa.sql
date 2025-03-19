--Tạo Master Key, Certificate và Symmetric Key
-- Tạo Database Master Key (DMK)
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'YourSecurePassword123!';

-- Tạo Certificate
CREATE CERTIFICATE CustomerEncryptCert 
WITH SUBJECT = 'Encrypt Customer Sensitive Data';

-- Tạo Symmetric Key dùng AES 256
CREATE SYMMETRIC KEY CustomerAESKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE CustomerEncryptCert;
--Thêm cột mới kiểu VARBINARY để lưu dữ liệu mã hóa
-- Thêm cột mới
ALTER TABLE Customer
ADD 
    Email_Encrypted VARBINARY(256),
    Phone_Encrypted VARBINARY(256),
    Address_Encrypted VARBINARY(256);
--Mã hóa dữ liệu hiện có
-- Mở Symmetric Key
OPEN SYMMETRIC KEY CustomerAESKey
DECRYPTION BY CERTIFICATE CustomerEncryptCert;

-- Cập nhật dữ liệu mã hóa
UPDATE Customer
SET 
    Email_Encrypted = ENCRYPTBYKEY(KEY_GUID('CustomerAESKey'), Email),
    Phone_Encrypted = ENCRYPTBYKEY(KEY_GUID('CustomerAESKey'), Phone),
    Address_Encrypted = ENCRYPTBYKEY(KEY_GUID('CustomerAESKey'), Address);

-- Đóng Symmetric Key
CLOSE SYMMETRIC KEY CustomerAESKey;
--Giải mã dữ liệu để xác nhận nội dung gốc

-- Mở Symmetric Key
OPEN SYMMETRIC KEY CustomerAESKey
DECRYPTION BY CERTIFICATE CustomerEncryptCert;

-- Truy vấn dữ liệu giải mã
SELECT 
    CustomerID,
    CustomerName,
    CONVERT(NVARCHAR, DECRYPTBYKEY(Email_Encrypted)) AS Email,
    CONVERT(VARCHAR(20), DECRYPTBYKEY(Phone_Encrypted)) AS Phone,
    CONVERT(NVARCHAR, DECRYPTBYKEY(Address_Encrypted)) AS Address
FROM Customer;

-- Đóng Symmetric Key
CLOSE SYMMETRIC KEY CustomerAESKey;


--Truy vấn dữ liệu đã mã hóa (dạng nhị phân)
-- Xem dữ liệu mã hóa (dạng VARBINARY)
SELECT 
    CustomerID,
    Email_Encrypted AS EncryptedEmail,
    Phone_Encrypted AS EncryptedPhone,
    Address_Encrypted AS EncryptedAddress
FROM Customer;
Backup Certificate và Private Key
BACKUP CERTIFICATE CustomerEncryptCert 
TO FILE = 'C:\Security\CustomerEncryptCert.cer'
WITH PRIVATE KEY (
    FILE = 'C:\Security\CustomerEncryptCert.pvk',
    ENCRYPTION BY PASSWORD = 'YourBackupPassword123!'
);
--Khôi phục khóa
CREATE CERTIFICATE CustomerEncryptCert 
FROM FILE = 'C:\Security\CustomerEncryptCert.cer'
WITH PRIVATE KEY (
    FILE = 'C:\Security\CustomerEncryptCert.pvk',
    DECRYPTION BY PASSWORD = 'YourBackupPassword123!'
);
