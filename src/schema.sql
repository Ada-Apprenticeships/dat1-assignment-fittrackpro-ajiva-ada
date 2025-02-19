-- FitTrack Pro Database Schema

-- Initial SQLite setup
.open fittrackpro.db
.mode column
--.read data/sample_data.sql

-- Enable foreign key support
PRAGMA foreign_keys = ON;
-- Create your tables here
-- Example:
-- CREATE TABLE table_name (
--     column1 datatype,
--     column2 datatype,
--     ...
-- );
DROP TABLE IF EXISTS locations;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS class_schedule;
DROP TABLE IF EXISTS memberships;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS class_attendance;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS personal_training_sessions;
DROP TABLE IF EXISTS member_health_metrics;
DROP TABLE IF EXISTS equipment_maintenance_log;

-- TODO: Create the following tables:
-- 1. locations
CREATE TABLE locations (
    location_id   INTEGER PRIMARY KEY AUTOINCREMENT ,
    name          TEXT NOT NULL,
    address       TEXT NOT NULL,
    phone_number  TEXT NOT NULL,
    email         TEXT NOT NULL,
    opening_hours TEXT NOT NULL
    );

-- 2. members
CREATE TABLE members (
    member_id               INTEGER PRIMARY KEY, 
    first_name              TEXT NOT NULL,
    last_name               TEXT NOT NULL,
    email                   TEXT NOT NULL,
    phone_number            TEXT NOT NULL,
    date_of_birth           DATE NOT NULL,
    join_date               DATE NOT NULL,
    emergency_contact_name  TEXT NOT NULL, 
    emergency_contact_phone TEXT NOT NULL
);

-- 3. staff
CREATE TABLE staff (
    staff_id	 INTEGER PRIMARY KEY,
    first_name	 TEXT NOT NULL, 
    last_name	 TEXT NOT NULL, 
    email	     TEXT NOT NULL, 
    phone_number TEXT NOT NULL,   
    position	 TEXT NOT NULL CHECK (position IN ('Trainer', 'Manager', 'Receptionist', 'Maintenance')),
    hire_date	 DATE NOT NULL,
    location_id  INTEGER NOT NULL,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);
-- 4. equipment
CREATE TABLE equipment (
    equipment_id           INTEGER PRIMARY KEY,
    name                   TEXT NOT NULL, 
    type	               TEXT NOT NULL CHECK (type IN ('Cardio', 'Strength')), -- means options are only Cardio or Strength 
    purchase_date	       DATE NOT NULL,
    last_maintenance_date  DATE NOT NULL,
    next_maintenance_date  DATE NOT NULL,
    location_id            INTEGER NOT NULL, 
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
    );
-- 5. classes
CREATE TABLE classes (
    class_id    INTEGER PRIMARY KEY,
    name        TEXT NOT NULL,
    description TEXT,
    capacity    INTEGER NOT NULL,
    duration    INTEGER NOT NULL,
    location_id INTEGER NOT NULL,
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);
-- 6. class_schedule
CREATE TABLE class_schedule (
    schedule_id INTEGER PRIMARY KEY,
    class_id    INTEGER NOT NULL,
    staff_id    INTEGER NOT NULL,
    start_time  TIME NOT NULL,
    end_time    TIME NOT NULL,
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);
-- 7. memberships
CREATE TABLE memberships (
    membership_id	INTEGER PRIMARY KEY, 
    member_id	    INTEGER NOT NULL,
    type	        TEXT NOT NULL,
    start_date	    DATE NOT NULL, 
    end_date	    DATE NOT NULL,
    status	        TEXT NOT NULL CHECK (status IN ('Active', 'Inactive')),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
-- 8. attendance
CREATE TABLE attendance ( 
    attendance_id  INTEGER PRIMARY KEY, 
    member_id      INTEGER NOT NULL,
    location_id    INTEGER NOT NULL,
    check_in_time  DATETIME NOT NULL,
    check_out_time DATETIME NOT NULL,
    FOREIGN KEY (member_id) REFERENCES members(member_id), 
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);
-- 9. class_attendance
CREATE TABLE class_attendance (
    class_attendance_id	INTEGER PRIMARY KEY,
    schedule_id	        INTEGER NOT NULL,
    member_id	        INTEGER NOT NULL,
    attendance_status	TEXT NOT NULL CHECK (attendance_status IN ('Registered', 'Attended', 'Unattended')),
    FOREIGN KEY (schedule_id) REFERENCES class_schedule(schedule_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
-- 10. payments
CREATE TABLE payments (
    payment_id	    INTEGER PRIMARY KEY,
    member_id	    INTEGER NOT NULL, 
    amount	        INTEGER NOT NULL,
    payment_date	DATE NOT NULL,
    payment_method	TEXT NOT NULL CHECK (payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash')),
    payment_type	TEXT NOT NULL CHECK (payment_type IN ('Monthly membership fee', 'Day pass')),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
-- 11. personal_training_sessions
CREATE TABLE personal_training_sessions (
    session_id   INTEGER PRIMARY KEY,
    member_id    INTEGER NOT NULL, 
    staff_id     INTEGER NOT NULL, 
    session_date DATE NOT NULL,
    start_time   TIME NOT NULL,
    end_time     TIME NOT NULL,
    notes        TEXT NOT NULL,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);
-- 12. member_health_metrics
CREATE TABLE member_health_metrics(
    metric_id           INTEGER PRIMARY KEY,
    member_id           INTEGER NOT NULL, 
    measurement_date    DATE,
    weight              INTEGER NOT NULL,
    body_fat_percentage INTEGER NOT NULL,
    muscle_mass         INTEGER NOT NULL,
    bmi                 INTEGER NOT NULL, 
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
-- 13. equipment_maintenance_log
CREATE TABLE equipment_maintenance_log (
    log_id           INTEGER PRIMARY KEY,
    equipment_id     INTEGER NOT NULL, 
    maintenance_date DATE NOT NULL,
    description      TEXT NOT NULL,
    staff_id         INTEGER NOT NULL,  
    FOREIGN KEY (equipment_id) REFERENCES equipment(equipment_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);
-- After creating the tables, you can import the sample data using:
-- `.read data/sample_data.sql` in a sql file or `npm run import` in the terminal



