CREATE DATABASE CompanyDB;
USE CompanyDB;

-- 1: Thiết kế Cơ sở dữ liệu (DDL)
CREATE TABLE Department(
	dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

CREATE TABLE Employee (
	emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(100) NOT NULL,
    gender INT DEFAULT 1,
	birth_date DATE,
    salary DECIMAL(18, 2) NOT NULL,
    dept_id INT NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id) ON UPDATE CASCADE
);

CREATE TABLE Project (
	project_id INT PRIMARY KEY AUTO_INCREMENT,
    project_name VARCHAR(150) NOT NULL,
    emp_id INT NOT NULL,
	start_date DATE DEFAULT(CURRENT_DATE),
    end_date DATE,
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id)
);

-- Câu 2: Thay đổi cấu trúc bảng (DDL)
-- Thêm cột: Thêm cột email (VARCHAR(100), UNIQUE) vào bảng Employee.
ALTER TABLE Employee 
ADD email VARCHAR(100) UNIQUE;

-- Sửa kiểu dữ liệu: Thay đổi cột project_name trong bảng Project thành VARCHAR(200).
ALTER TABLE Project 
MODIFY project_name VARCHAR(200) NOT NULL;

-- Thêm ràng buộc: Thêm ràng buộc CHECK cho bảng Project để đảm bảo end_date luôn lớn hơn hoặc bằng start_date.
ALTER TABLE Project ADD  CONSTRAINT check_end_date CHECK (end_date >= start_date);

-- Câu 3.Thao tác dữ liệu (DML)
-- 1. Thêm mới dữ liệu
-- Bảng Department
INSERT INTO Department (dept_id, dept_name, location)
VALUES
(1, 'IT', 'Ha Noi'),
(2, 'HR', 'HCM'),
(3, 'Marketing', 'Da Nang');

-- Bảng Employee
INSERT INTO Employee (emp_id, emp_name, gender, birth_date, salary, dept_id, email)
VALUES
(1, 'Nguyen Van A', 1, '1990-01-15', 1500, 1, 'a@gmail.com'),
(2, 'Tran Thi B', 0, '1995-05-20', 1200, 1, 'b@gmail.com'),
(3, 'Le Minh C', 1, '1988-10-10', 2000, 2, 'c@gmail.com'),
(4, 'Pham Thi D', 0, '1992-12-05', 1800, 3, 'd@gmail.com');

-- Bảng Project
INSERT INTO Project (project_id, project_name, emp_id, start_date, end_date)
VALUES
(101, 'Website Redesign', 1, '2024-01-01', '2024-06-01'),
(102, 'Recruitment System', 3, '2024-02-01', '2024-08-01'),
(103, 'Marketing Campaign', 4, '2024-03-01', NULL);

-- 2. Cập nhật dữ liệu 
-- Tăng salary thêm 200 cho tất cả nhân viên thuộc phòng ban 'IT' (dept_id = 1).
UPDATE Employee 
SET  salary = salary + 200
WHERE dept_id = 1;

-- Cập nhật end_date thành '2024-12-31' cho các dự án đang có giá trị NULL.
UPDATE Project
SET end_date = '2024-12-31'
WHERE end_date IS NULL;

-- 3. Xóa dữ liệu
DELETE FROM Project
WHERE start_date < '2024-02-01';

-- 4. Truy vấn dữ liệu nâng cao 
-- CASE & AS: Hiển thị emp_name, email và cột gender_name (Nếu gender = 1 là 'Nam', 0 là 'Nữ').
SELECT emp_name,
       email,
       CASE 
           WHEN gender = 1 THEN 'Nam'
           WHEN gender = 0 THEN 'Nữ'
       END AS gender_name
FROM Employee;

-- 
SELECT UPPER(emp_name) AS emp_name_upper,
       YEAR(CURDATE()) - YEAR(birth_date) AS age
FROM Employee;

-- 
SELECT e.emp_name, e.salary, d.dept_name
FROM Employee e
INNER JOIN Department d ON e.dept_id = d.dept_id;

-- 
SELECT emp_name, salary
FROM Employee
ORDER BY salary DESC
LIMIT 2;

-- 
SELECT d.dept_name, COUNT(e.emp_id) AS employee_count
FROM Employee e
JOIN Department d ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING COUNT(e.emp_id) >= 2;

--
SELECT emp_name, salary
FROM Employee
WHERE salary > (SELECT AVG(salary) FROM Employee);

--
SELECT emp_id, emp_name, email
FROM Employee
WHERE emp_id IN (SELECT emp_id FROM Project);

--
SELECT emp_name, salary, dept_id
FROM Employee e
WHERE salary = (
    SELECT MAX(salary)
    FROM Employee
    WHERE dept_id = e.dept_id
);
