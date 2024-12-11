CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,  -- Khóa chính, tự động tăng
    email NVARCHAR(255) NOT NULL UNIQUE,  -- Email, không trùng lặp
	username NVARCHAR(255) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL  -- Mật khẩu
);


CREATE TABLE userdetails (
    id INT IDENTITY(1,1) PRIMARY KEY,  -- Khóa chính, tự động tăng
    userid INT NOT NULL UNIQUE,  -- Khóa ngoại tham chiếu bảng Users
	fullname NVARCHAR(255),
    avatar NVARCHAR(255),
    coverphoto NVARCHAR(255),
    dob Date,
    linksocial NVARCHAR(255),
    lovesong NVARCHAR(255),
    education NVARCHAR(255),
    address NVARCHAR(500),
    CONSTRAINT FK_userdetails_users FOREIGN KEY (userid) 
        REFERENCES users(id) 
        ON DELETE CASCADE  -- Khi xóa một user, xóa luôn tất cả dữ liệu liên quan trong bảng userdetails
);

CREATE TRIGGER trg_AfterInsert_Users
ON users
AFTER INSERT
AS
BEGIN
    -- Chèn vào bảng userdetails với userid và avatar mặc định
    INSERT INTO userdetails (userid, avatar ,coverphoto)
    SELECT id, 'https://secure.gravatar.com/avatar/033951faa739d4d0a35de0c35ce94fb6?s=256&d=mm&r=r','https://via.placeholder.com/550x250'
    FROM inserted;
END;
--bảng folow
CREATE TABLE follows (
    follower_id INT NOT NULL,       
    following_id INT NOT NULL,       
    PRIMARY KEY (follower_id, following_id), 
    FOREIGN KEY (follower_id) REFERENCES users(id) ,
    FOREIGN KEY (following_id) REFERENCES users(id) 
);
CREATE TABLE invalidtoken(
	id INT IDENTITY(1,1) PRIMARY KEY,
	tokenid NVARCHAR(255) NOT NULL UNIQUE,
	expirytime Date,
	email NVARCHAR(255)
);
delete from likes

	   select * from files
	   select * from userdetails
	   select * from follows
	   	TRUNCATE TABLE follows
		delete from follows Where follower_id =1 And following_id=1 
INSERT INTO follows (follower_id, following_id) 
VALUES (1, 3);  -- User ID 1 theo dõi User ID 2


--tìm danh sách đang folow những ai
SELECT u.*
FROM follows f
JOIN users u ON f.following_id = u.id
WHERE f.follower_id = 1;  -- User ID 1
-- được những ai folow
SELECT u.*
FROM follows f
JOIN users u ON f.follower_id = u.id
WHERE f.following_id = 2;  -- User ID 2
--unfolow
DELETE FROM follows 
WHERE follower_id = 1 AND following_id = 2;  -- User ID 1 hủy theo dõi User ID 2
--Đếm số người theo dõi
SELECT COUNT(*) AS total_followers 
FROM follows 
WHERE following_id = 2;  -- User ID 2
--Đếm số người mình theo dõi
SELECT COUNT(*) AS total_following 
FROM follows 
WHERE follower_id = 1;  -- User ID 1
--Kiểm tra xem mình có folow họ không
SELECT 1 
FROM follows
WHERE follower_id = 1 AND following_id = 2;

--Bảng post
CREATE TABLE posts (
    id INT IDENTITY(1,1) PRIMARY KEY,  -- Khóa chính, tự động tăng
    user_id INT,  -- Khóa ngoại trỏ đến bảng users (người dùng đăng bài)
    content NVARCHAR(255) NOT NULL,  -- Nội dung bài viết
    privacy NVARCHAR(255) NOT NULL,  -- Quyền riêng tư, mặc định là công khai
    tags NVARCHAR(255),  -- Thẻ bài viết (tags)
    created_at DATETIME ,  -- Thời gian tạo bài viết
    updated_at DATETIME ,  -- Thời gian cập nhật bài viết
    FOREIGN KEY (user_id) REFERENCES users(id)  -- Khóa ngoại liên kết với bảng users
);
--Bảng file ảnh
CREATE TABLE files (
    id INT IDENTITY(1,1) PRIMARY KEY,  -- Khóa chính, tự động tăng
    post_id INT,  -- Khóa ngoại trỏ đến bảng posts (bài viết liên quan)
    file_name NVARCHAR(255) NOT NULL,  -- Tên file
    file_path NVARCHAR(255) NOT NULL,  -- Đường dẫn tới file
    uploaded_at DATETIME,  -- Thời gian tải lên
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE  -- Khóa ngoại liên kết với bảng posts
);
--Bảng lượt likes
CREATE TABLE likes (
    user_id INT NOT NULL,        -- ID của người thích
    post_id INT NOT NULL,        -- ID của bài viết được thích
    PRIMARY KEY (user_id, post_id),   -- Mỗi người chỉ có thể thích mỗi bài viết một lần
    FOREIGN KEY (user_id) REFERENCES users(id),    -- Liên kết với bảng users
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE     -- Liên kết với bảng posts
);


--Bảng lượt comment
CREATE TABLE comments (
    id INT IDENTITY(1,1) PRIMARY KEY,          -- ID của bình luận
    post_id INT NOT NULL,                       -- ID bài đăng liên quan
    user_id INT NOT NULL,                       -- ID người dùng đã bình luận
    content NVARCHAR(255) NOT NULL,                      -- Nội dung bình luận
    created_at DATETIME , -- Thời gian bình luận
    parent_id INT DEFAULT NULL,                 -- ID của bình luận cha (nếu là trả lời)
    FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE, -- Liên kết tới bảng bài đăng
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE, -- Liên kết tới bảng người dùng
    FOREIGN KEY (parent_id) REFERENCES comments(id)  -- Liên kết tới bình luận cha
);
select * from comments
SELECT COUNT(*) 
FROM comments
WHERE post_id = 26
select * from posts
select * from files

select * from comments where post_id=26

TRUNCATE TABLE files;
TRUNCATE TABLE posts
Delete from posts

--Bảng lưu tin nhắn
CREATE TABLE messages (
    id INT IDENTITY(1,1) PRIMARY KEY,          -- Khóa chính, tự động tăng
    sender_id INT NOT NULL,                    -- ID của người gửi
    receiver_id INT NOT NULL,                  -- ID của người nhận
    content NVARCHAR(MAX) NOT NULL,            -- Nội dung tin nhắn
    timestamp DATETIME DEFAULT GETDATE(),      -- Thời gian gửi tin nhắn (mặc định là thời gian hiện tại)
    chat_id NVARCHAR(255) NOT NULL,                      -- ID phòng chat
    FOREIGN KEY (sender_id) REFERENCES users(id),
    FOREIGN KEY (receiver_id) REFERENCES users(id),
    FOREIGN KEY (chat_id) REFERENCES chat_rooms(id) -- Khóa ngoại tham chiếu tới bảng chat_rooms
);
INSERT INTO chat_rooms (user1_id, user2_id)
VALUES (1, 2);
SELECT name, collation_name 
FROM sys.tables
WHERE name = 'messages';

INSERT INTO messages (sender_id, receiver_id, content, chat_id)
VALUES (1008, 2008, N'Nội dung tin nhắn thử nghiệm', '62a478fb-000b-4a46-be60-2e3e9831c39d');
SELECT name, collation_name 
FROM sys.columns
WHERE object_id = OBJECT_ID('messages') AND name = 'content';

ALTER TABLE messages 
ALTER COLUMN content NVARCHAR(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS;



--Phòng chát
CREATE TABLE chat_rooms (
    id NVARCHAR(255) PRIMARY KEY DEFAULT NEWID(),      -- Khóa chính, tự động tăng
    userone_id INT NOT NULL,                 -- ID người dùng 1
    usertwo_id INT NOT NULL,                 -- ID người dùng 2
    created_at DATETIME DEFAULT GETDATE(), -- Thời gian tạo phòng chat

    -- Thêm cột tính toán để đảm bảo thứ tự
    user_min AS (CASE WHEN userone_id < usertwo_id THEN userone_id ELSE usertwo_id END) PERSISTED,
    user_max AS (CASE WHEN userone_id > usertwo_id THEN userone_id ELSE usertwo_id END) PERSISTED,

    -- Khóa ngoại liên kết với bảng users
    FOREIGN KEY (userone_id) REFERENCES users(id),
    FOREIGN KEY (usertwo_id) REFERENCES users(id),

    -- Ràng buộc tính duy nhất trên cột tính toán
    CONSTRAINT unique_chat UNIQUE (user_min, user_max)
);
--Bảng Notification
CREATE TABLE notifications (
   id INT IDENTITY(1,1) PRIMARY KEY,
   userid INT NOT NULL,
   avatar_notifi NVARCHAR(255),
   username_notifi NVARCHAR(255),
   content NVARCHAR(255),
   created_at DATETIME DEFAULT GETDATE(), -- Sử dụng DEFAULT đúng cú pháp
   CONSTRAINT FK_notifications_users FOREIGN KEY (userid) 
        REFERENCES users(id) 
        ON DELETE CASCADE
);

select * from notifications where userid =3010

select *  from files
select * from posts

delete  from posts where id =3032

ALTER TABLE files DROP CONSTRAINT FK__files__post_id__1699586C;
ALTER TABLE files
ADD CONSTRAINT FK__files__post_id__1699586C
FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE;

delete from files
delete from likes
delete from posts
delete from messages
delete from chat_rooms
delete from follows
delete from users





	



