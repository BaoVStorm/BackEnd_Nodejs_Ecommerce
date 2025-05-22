-- 1. USERS TABLE
Create TABLE Users (
	user_id INT IDENTITY(1, 1) PRIMARY KEY,
	full_name NVARCHAR(100),
	email NVARCHAR(100) UNIQUE,
	password_hash VARCHAR(255),
	phone_number NVARCHAR(20),
	gender VARCHAR(10) CHECK (gender in ('Male', 'Female', 'Other'))
);

/*
Chứa thông tin người dùng đã đăng ký tài khoản:
- user_id: Khóa chính (ID tự động tăng).
- full_name, email, phone_number, gender: Thông tin cá nhân.
- password_hash: Mã hóa mật khẩu.
- Ràng buộc gender để đảm bảo dữ liệu hợp lệ.
*/

-- 2. ADDRESSES
CREATE TABLE Addresses (
    address_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    province NVARCHAR(100),
    district NVARCHAR(100),
    commune NVARCHAR(100),
    address NVARCHAR(255),
    is_company BIT -- 1: Công ty, 0: Nhà riêng
);

/*
Các địa chỉ giao hàng / nhận hàng của người dùng đã tạo từ trước:
- address_id: Khóa chính (ID tự động tăng).
- user_id: Liên kết với bảng Users.
- province, district, ward, street_address: Địa chỉ chi tiết.
- is_company: Phân biệt giữa địa chỉ cá nhân và công ty.
*/

-- 3. CUSTOMER INFO TABLE
CREATE TABLE Customer_Info (
    customer_info_id INT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(100),
    email NVARCHAR(100),
    phone_number NVARCHAR(20),
	gender VARCHAR(10) CHECK (gender in ('Male', 'Female', 'Other')),
    
	province NVARCHAR(100),
    district NVARCHAR(100),
    commune NVARCHAR(100),
    address NVARCHAR(255),
    is_company BIT -- 1: Công ty, 0: Nhà riêng
);
/*
Dành cho khách hàng không đăng ký tài khoản (khách vãng lai) vẫn có thể mua hàng:
- Có cấu trúc giống bảng Users + Addresses.
- Được sử dụng khi tạo đơn hàng mà không cần tài khoản.
*/

-- 4. CATEGORIES TABLE
CREATE TABLE Categories(
	category_id INT IDENTITY(1, 1) PRIMARY KEY,
	category_name NVARCHAR(100)
)
/*
Lưu danh mục sản phẩm:
- Ví dụ: Giày, Dép, Phụ kiện...
*/

-- 5. BRAND TABLE
CREATE TABLE Brand(
	brand_name NVARCHAR(50) PRIMARY KEY,
	description NVARCHAR(200)
)
/*
Lưu thông tin các thương hiệu sản phẩm:
- brand_name: Là khóa chính đùng để lưu trữ tên nhãn hàng.
- description: Mô tả thương hiệu.
*/

-- 6. PRODUCTS TABLE
CREATE TABLE Products (
	product_id INT IDENTITY(1, 1) PRIMARY KEY,
	name NVARCHAR(200),
	model_code NVARCHAR(50),
	description_product NVARCHAR(MAX),
	price DECIMAL(10, 2) CHECK (price >= 0),
	discount_percentage DECIMAL(5, 2) CHECK (discount_percentage >= 0 AND discount_percentage <= 100),
	gender_product VARCHAR(10) CHECK (gender_product IN ('Male', 'Female', 'Unisex')),
	brand_name NVARCHAR(50),
	category_id INT,

	FOREIGN KEY (brand_name) REFERENCES Brand(brand_name),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);	
/*
Lưu thông tin cơ bản về sản phẩm:
- product_id: Là khoá chính tăng tự động
- Các thuộc tính cơ bản như: tên, mô tả, giá, mã sản phẩm
- discount_percentage (0 <= value <= 100): mô tả mức độ giảm giá theo đơn vị %
- gender_product thuộc các giá trị ('Male', 'Female', 'Unisex'): mô tả sản phẩm dành cho các đối tượng nào
- brand_name: khoá ngoại mô tả sản phẩm thuộc thương hiệu nào
- category_id: khoá ngoại mô tả sản phẩm thuộc loại nào
*/

-- 7. PRODUCTS COLOR TABLE
CREATE TABLE Products_Color (
	product_color_id INT IDENTITY(1, 1) PRIMARY KEY,
	product_id INT,
	color NVARCHAR(50),

	FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
/*
Mỗi sản phẩm có thể có nhiều màu:
- product_color_id: Khóa chính tăng tự động.
- product_id: mã sản phẩm (khoá ngoại)
- color: Màu sắc cụ thể của sản phẩm đó
*/

-- 8. PRODUCT IMAGES
CREATE TABLE Product_Images (
	image_id INT IDENTITY(1, 1) PRIMARY KEY,
	product_color_id INT,
	image_url NVARCHAR(MAX),

	FOREIGN KEY (product_color_id) REFERENCES Products_Color(product_color_id)
);
/*
Lưu trữ ảnh của sản phẩm tương ứng với từng màu:
- product_color_id: mã sản phẩm ứng với một màu (khoá ngoại).
- image_url: Đường dẫn ảnh đó.
*/

-- 9. PRODUCT SIZES
CREATE TABLE Product_Size (
    product_size_id INT IDENTITY(1, 1) PRIMARY KEY,
    product_id INT,
    size INT,

    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
/*
Lưu các kích thước của sản phẩm:
- product_size_id: khoá chính tăng tự động
- product_id: mã sản phẩm (khoá ngoại)
- size: Kích thước (ví dụ: 38, 39, 40).
*/

-- 10. STORES TABLE
CREATE TABLE Stores (
    store_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100),
    address NVARCHAR(255),
    city NVARCHAR(100)
);
/*
Danh sách các cửa hàng trong hệ thống:
- store_id: Khóa chính.
- name, address, city: Thông tin địa điểm.
*/

-- 11. INVENTORY TABLE
CREATE TABLE Inventory (
    inventory_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    product_color_id INT NOT NULL,
    product_size_id INT NOT NULL,
    store_id INT NOT NULL,
    quantity INT CHECK (quantity >= 0),

    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (product_color_id) REFERENCES Products_Color(product_color_id),
    FOREIGN KEY (product_size_id) REFERENCES Product_Size(product_size_id),
    FOREIGN KEY (store_id) REFERENCES Stores(store_id),

    -- Đảm bảo không trùng thông tin tồn kho cùng loại
    UNIQUE (product_id, product_color_id, product_size_id, store_id)
);
/*
Thông tin tồn kho theo từng biến thể sản phẩm tại từng cửa hàng:
- Kết hợp product_id, product_color_id, product_size_id, store_id.
- quantity: Số lượng tồn.
- Ràng buộc UNIQUE đảm bảo không bị trùng biến thể trong cùng một cửa hàng.
*/


-- 12. ORDERS TABLE
CREATE TABLE Orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_info_id INT NULL,
    user_id INT NULL,
    total_amount DECIMAL(13, 2),
    shipping_fee DECIMAL(13, 2),
	status NVARCHAR(50) DEFAULT 'chưa thanh toán' CHECK (status IN ('đã thanh toán', 'chưa thanh toán')),
    order_date DATETIME DEFAULT GETDATE(),
    delivery_type NVARCHAR(50), -- Giao tận nơi / Nhận tại cửa hàng
    payment_method NVARCHAR(50), -- Online / COD

	FOREIGN KEY (customer_info_id) REFERENCES Customer_Info(customer_info_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
/*
Lưu trữ thông tin các Đơn hàng đã được đặt:
- Liên kết được với user_id (user có tài khoản) hoặc customer_info_id (khách vãng lai).
- Có thông tin tổng tiền, phí ship, loại giao hàng, phương thức thanh toán.
- total_amount: tổng tiền của các chi tiết hoá đơn (có thể voucher)
- status: thanh toán hay chưa
- shipping_fee: hệ thống tính toán dựa vào vị trí (có thể voucher)
- order_date: Mặc định lấy ngày hiện tại.
*/

-- 13. ORDER ITEMS TABLE
CREATE TABLE Order_Items (
    order_item_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT FOREIGN KEY REFERENCES Orders(order_id),
    product_id INT FOREIGN KEY REFERENCES Products(product_id),
	product_color_id INT FOREIGN KEY REFERENCES Products_Color(product_color_id),
    product_size_id INT FOREIGN KEY REFERENCES Product_Size(product_size_id),
    quantity INT,
    unit_price DECIMAL(13, 2)
);
/*
Lưu các sản phẩm chi tiết trong một đơn hàng:
- order_id: Tham chiếu đến đơn hàng cha (Orders).
- product_id, product_color_id, product_size_id: Thông tin biến thể sản phẩm.
- quantity: Số lượng sản phẩm trong đơn hàng.
- unit_price: Giá của 1 sản phẩm (có thể đã được giảm qua voucher)

Mỗi đơn hàng có thể gồm nhiều dòng, mỗi dòng là một biến thể sản phẩm.
*/

-- 14. VOUCHERS TABLE
CREATE TABLE Vouchers (
    voucher_id INT IDENTITY(1,1) PRIMARY KEY,
	name NVARCHAR(100),
    code NVARCHAR(50) UNIQUE,
	min_order_amount DECIMAL(10, 2),
    discount_value DECIMAL(10, 2),
	type_discount VARCHAR(20) CHECK (type_discount IN ('percentage', 'direct')),
    type VARCHAR(20) CHECK (type IN ('Shipping', 'Product', 'Total')),
    expiry_date DATE
);
/*
Thông tin phiếu giảm giá:
- code: Mã giảm giá duy nhất (dùng khi nhập ở bước thanh toán).
- min_order_amount: Số tiền tối thiểu của đơn hàng để dùng được mã.
- discount_value: Giá trị giảm (tùy loại là phần trăm hoặc tiền mặt).
- type_discount: Loại chiết khấu (percentage hoặc direct).
- type: Áp dụng cho phí giao hàng, sản phẩm cụ thể hay toàn đơn.
- expiry_date: Hạn sử dụng của mã giảm giá.
*/

-- 15. ORDER VOUCHER TABLE
CREATE TABLE Order_Vouchers (
    order_id INT FOREIGN KEY REFERENCES Orders(order_id),
    voucher_id INT FOREIGN KEY REFERENCES Vouchers(voucher_id),
    applied_value DECIMAL(10, 2),
    PRIMARY KEY (order_id, voucher_id)
);
/*
Bảng liên kết giữa đơn hàng và voucher đã áp dụng:
- Cho phép một đơn hàng dùng nhiều mã giảm giá.
- applied_value: Số tiền được giảm ứng với mã đã dùng.
- Khóa chính là tổ hợp (order_id, voucher_id).
*/

-- 16. CART TABLE
CREATE TABLE Cart (
    cart_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    product_id INT FOREIGN KEY REFERENCES Products(product_id),
    product_color_id INT FOREIGN KEY REFERENCES Products_Color(product_color_id),
    product_size_id INT FOREIGN KEY REFERENCES Product_Size(product_size_id),
    quantity INT CHECK (quantity > 0),
    
    -- Đảm bảo không trùng sản phẩm cùng biến thể trong giỏ hàng 1 user
    UNIQUE (user_id, product_id, product_color_id, product_size_id)
);
/*
Thông tin giỏ hàng của người dùng:
- Mỗi dòng là một sản phẩm (có thể gồm biến thể màu/số size).
- quantity: Số lượng mà người dùng thêm vào giỏ.
- Ràng buộc UNIQUE đảm bảo mỗi biến thể chỉ có một dòng duy nhất trong giỏ hàng mỗi user.
- Dữ liệu trong bảng này sẽ bị xóa sau khi người dùng đặt hàng.
*/

-- 17. REVIEWS TABLE
CREATE TABLE Reviews (
    review_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    product_id INT FOREIGN KEY REFERENCES Products(product_id),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment NVARCHAR(MAX),
    review_date DATETIME DEFAULT GETDATE(),

    -- Mỗi user chỉ được đánh giá 1 lần cho mỗi sản phẩm
    UNIQUE (user_id, product_id)
);
/*
Người dùng đánh giá sản phẩm:
- rating: Số sao từ 1 đến 5.
- comment: Nội dung đánh giá.
- review_date: Ngày viết đánh giá.
*/

-- 18. FAVOURITE TABLE
CREATE TABLE Favourite (
    user_id INT FOREIGN KEY REFERENCES Users(user_id),
    product_id INT FOREIGN KEY REFERENCES Products(product_id),
   
	PRIMARY KEY (user_id, product_id)
);
/*
Danh sách sản phẩm yêu thích của người dùng:
- Mỗi bản ghi biểu thị rằng một người dùng đã thêm một sản phẩm vào mục yêu thích.
- Dùng để hiển thị "danh sách yêu thích" trong tài khoản người dùng.
*/

-- https://dbdiagram.io/d/Ecommerce-6828cea41227bdcb4ec469f2


--------------------------------------- Bài 2
/* giả sử dữ liệu đã có trước thông tin sau

-- Table Product
product_id: 1
name: 'KAPPA Women's Sneakers'
model_code: KAPPAWS
price: 980000
discount_percentage: 0
gender_product: 'Female'
brand_name: 'KAPPA'
category_id: 1

-- Table Product_Size
product_size_id: 36
product_id: 1
size: 36

-- Table Products_Color
product_color_id: 5
product_id: 1
color: 'yellow'

----------------

-- Table Users
user_id: 2
full_name: 'assessment'
email: 'gu@gmail.com'
password_hash: 'aa'
phone_number: '328355333'
gender: 'Other'

-- Table Addresses
address_id: 2
user_id: 2
province: 'Bắc Kạn'
district: 'Ba Bể'
commune: 'Phúc Lộc'
address: '73 tân hoà 2'
is_company: 0 
*/

------ thêm vào bảng khi người dùng order

DECLARE @OrderId INT;
INSERT INTO Orders(customer_info_id, user_id, total_amount, shipping_fee, delivery_type, payment_method)
VALUES (null, 2, 4900000, 0, N'Giao tận nơi', N'Online')
SET @OrderId = SCOPE_IDENTITY();

INSERT INTO Order_Items (
    order_id, product_id, product_color_id, product_size_id, 
    quantity, unit_price
)
VALUES (
    @OrderId, 1, 5, 36,
    5, 980000
);

/*
CREATE TABLE Orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_info_id INT NULL FOREIGN KEY REFERENCES Customer_Info(customer_info_id),
    user_id INT NULL FOREIGN KEY REFERENCES Users(user_id),
    total_amount DECIMAL(13, 2),
    shipping_fee DECIMAL(13, 2),
    order_date DATETIME DEFAULT GETDATE(),
    delivery_type NVARCHAR(50), -- Giao tận nơi / Nhận tại cửa hàng
    payment_method NVARCHAR(50) -- Online / COD
);

CREATE TABLE Order_Items (
    order_item_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT FOREIGN KEY REFERENCES Orders(order_id),
    product_id INT FOREIGN KEY REFERENCES Products(product_id),
	product_color_id INT FOREIGN KEY REFERENCES Products_Color(product_color_id),
    product_size_id INT FOREIGN KEY REFERENCES Product_Size(product_size_id),
    quantity INT,
    unit_price DECIMAL(13, 2)
);
*/

------------------------ Bài 3

SELECT 
	MONTH(order_date) AS OrderMonth, 
	AVG(total_amount) AS AverageOrderValue 
FROM Orders
WHERE YEAR(GETDATE()) = YEAR(order_date) 
GROUP BY MONTH(order_date)
ORDER BY OrderMonth;

------------------------ Bài 4

/*
Create TABLE Users (
	user_id INT IDENTITY(1, 1) PRIMARY KEY,
	full_name NVARCHAR(100),
	email NVARCHAR(100) UNIQUE,
	password_hash VARCHAR(255),
	phone_number NVARCHAR(20),
	gender VARCHAR(10) CHECK (gender in ('Male', 'Female', 'Other'))
);
*/

-- Get total active customers in the 6-12 months ago window
WITH Customers_6_to_12_Months_Ago AS (
    SELECT DISTINCT user_id
    FROM Orders
    WHERE order_date BETWEEN DATEADD(MONTH, -12, GETDATE()) AND DATEADD(MONTH, -6, GETDATE())
),
Customers_Last_6_Months AS (
    SELECT DISTINCT user_id
    FROM Orders
    WHERE order_date > DATEADD(MONTH, -6, GETDATE())
)

-- Final query to calculate churn rate
SELECT 
    CAST(COUNT(*) AS FLOAT) / NULLIF((SELECT COUNT(*) FROM Customers_6_to_12_Months_Ago), 1) AS ChurnRate
FROM Customers_6_to_12_Months_Ago AS c
WHERE c.user_id NOT IN (
    SELECT user_id FROM Customers_Last_6_Months
);

