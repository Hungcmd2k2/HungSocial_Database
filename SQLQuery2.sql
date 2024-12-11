





select * from Images

CREATE TABLE Images (
    imageID INT PRIMARY KEY,
    imageName NVARCHAR(100),
    imageData NVARCHAR(MAX)
);
INSERT INTO Images (imageID, imageName, imageData)
VALUES (1, 'HungBong', 'C:\Users\Admin\Desktop\bong_cau.jpg');