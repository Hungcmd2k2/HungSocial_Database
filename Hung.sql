create database HungSocial

CREATE TABLE users (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    username NVARCHAR(255) NOT NULL UNIQUE,
	name_public NVARCHAR(255) NOT NULL,
    email NVARCHAR(255) NOT NULL UNIQUE,
    password_hash NVARCHAR(255) NOT NULL,
    profile_picture NVARCHAR(255),
	profile_background NVARCHAR(255),
    date_of_birth DATE,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);
ALTER TABLE users
ADD  profile_background NVARCHAR(255) ;

INSERT INTO users (username, email, password_hash) 
VALUES ('exampleUser', 'user@example.com', 'hashedPassword');

select * from users

SELECT CONVERT(VARCHAR(16), GETDATE(), 120) AS CurrentDateTime;

UPDATE users
SET email = 'new_doe@example.com', profile_picture = 'path/to/new/profile/picture.jpg'
WHERE username = 'hung3';


CREATE TRIGGER trg_Update_UpdatedAt
ON users
AFTER UPDATE
AS
BEGIN
    UPDATE users
    SET updated_at = GETDATE()
    WHERE id IN (SELECT id FROM inserted);
END;
