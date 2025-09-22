--2.1
DROP TABLE IF EXISTS students;
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    date_of_birth DATE,
    enrollment_date DATE,
    gpa DECIMAL(4,2),
    is_active BOOLEAN,
    graduation_year SMALLINT
);

DROP TABLE IF EXISTS professors;
CREATE TABLE professors (
    professor_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    office_number VARCHAR(20),
    hire_date DATE,
    salary DECIMAL(12,2),
    is_tenured BOOLEAN,
    years_experience INT
);

DROP TABLE IF EXISTS courses;
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_code VARCHAR(10),
    course_title VARCHAR(100),
    description TEXT,
    credits SMALLINT,
    max_enrollment INT,
    course_fee DECIMAL(10,2),
    is_online BOOLEAN,
    created_at TIMESTAMP
);

--2.2
DROP TABLE IF EXISTS class_schedule;
CREATE TABLE class_schedule (
    schedule_id SERIAL PRIMARY KEY,
    course_id INT,
    professor_id INT,
    classroom VARCHAR(30),
    class_date DATE,
    start_time TIME,
    end_time TIME
);

DROP TABLE IF EXISTS student_records;
CREATE TABLE student_records (
    record_id SERIAL PRIMARY KEY,
    student_id INT,
    course_id INT,
    semester VARCHAR(20),
    year INT,
    grade VARCHAR(5),
    attendance_percentage DECIMAL(5,1),
    submission_timestamp TIMESTAMP WITH TIME ZONE
);

--3.1
ALTER TABLE students
    ADD COLUMN middle_name VARCHAR(30),
    ADD COLUMN student_status VARCHAR(20),
    ALTER COLUMN gpa SET DEFAULT 0.00;

ALTER TABLE professors
    ADD COLUMN department_code CHAR(5),
    ADD COLUMN research_area TEXT,
    ALTER COLUMN years_experience TYPE SMALLINT,
    ALTER COLUMN is_tenured SET DEFAULT FALSE,
    ADD COLUMN last_promotion_date DATE;

ALTER TABLE courses
    ADD COLUMN prerequisite_course_id INT,
    ADD COLUMN difficulty_level INT,
    ADD COLUMN lab_required BOOLEAN DEFAULT FALSE,
    ALTER COLUMN credits SET DEFAULT 3;

--3.2
ALTER TABLE class_schedule
    ADD COLUMN room_capacity INT,
    ADD COLUMN session_type VARCHAR(15),
    ADD COLUMN equipment_needed TEXT;

ALTER TABLE student_records
    ADD COLUMN extra_credit_points DECIMAL(5,1),
    ADD COLUMN final_exam_date DATE;

--4.1
DROP TABLE IF EXISTS departments;
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100),
    department_code CHAR(5),
    building VARCHAR(50),
    phone VARCHAR(15),
    budget DECIMAL(15,2),
    established_year INT
);

DROP TABLE IF EXISTS library_books;
CREATE TABLE library_books (
    book_id SERIAL PRIMARY KEY,
    isbn CHAR(13),
    title VARCHAR(200),
    author VARCHAR(100),
    publisher VARCHAR(100),
    publication_date DATE,
    price DECIMAL(10,2),
    is_available BOOLEAN,
    acquisition_timestamp TIMESTAMP
);

DROP TABLE IF EXISTS student_book_loans;
CREATE TABLE student_book_loans (
    loan_id SERIAL PRIMARY KEY,
    student_id INT,
    book_id INT,
    loan_date DATE,
    due_date DATE,
    return_date DATE,
    fine_amount DECIMAL(10,2),
    loan_status VARCHAR(20)
);

--4.2
ALTER TABLE professors ADD COLUMN department_id INT;
ALTER TABLE students ADD COLUMN advisor_id INT;
ALTER TABLE courses ADD COLUMN department_id INT;

DROP TABLE IF EXISTS grade_scale;
CREATE TABLE grade_scale (
    grade_id SERIAL PRIMARY KEY,
    letter_grade CHAR(2),
    min_percentage DECIMAL(4,1),
    max_percentage DECIMAL(4,1),
    gpa_points DECIMAL(3,2),
    description TEXT
);

DROP TABLE IF EXISTS semester_calendar CASCADE;
CREATE TABLE semester_calendar (
    semester_id SERIAL PRIMARY KEY,
    semester_name VARCHAR(20),
    academic_year INT,
    start_date DATE,
    end_date DATE,
    registration_deadline TIMESTAMP,
    is_current BOOLEAN
);
