-- Disable foreign key checks
SET FOREIGN_KEY_CHECKS = 0;

-- Drop existing tables if they exist
DROP TABLE IF EXISTS `questions_answers`;
DROP TABLE IF EXISTS `goes`;
DROP TABLE IF EXISTS `manages`;
DROP TABLE IF EXISTS `books`;
DROP TABLE IF EXISTS `reservations`;
DROP TABLE IF EXISTS `schedule`;
DROP TABLE IF EXISTS `stations`;
DROP TABLE IF EXISTS `employees`;
DROP TABLE IF EXISTS `customers`;
DROP TABLE IF EXISTS `trains`;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Create `trains` table
CREATE TABLE `trains` (
  `TrainID` char(10) NOT NULL,
  `TransitLineName` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`TrainID`)
) ENGINE=InnoDB;

-- Create `customers` table
CREATE TABLE `customers` (
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `fname` varchar(255) DEFAULT NULL,
  `lname` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB;

-- Create `employees` table
CREATE TABLE `employees` (
  `ssn` char(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `isAdmin` tinyint(1) DEFAULT '0',
  `isRep` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`ssn`),
  FOREIGN KEY (`username`) REFERENCES `customers`(`username`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Create `stations` table
CREATE TABLE `stations` (
  `stationID` char(10) NOT NULL,
  `stationName` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL,
  `stopNumber` int DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`stationID`),
  CHECK (`stopNumber` >= 0)
) ENGINE=InnoDB;

-- Create `schedule` table
CREATE TABLE `schedule` (
  `schedule_id` int NOT NULL AUTO_INCREMENT,
  `train_id` char(10) NOT NULL,
  `origin` varchar(256) NOT NULL,
  `destination` varchar(256) NOT NULL,
  `stop_number` int DEFAULT NULL,
  `departure_time` datetime NOT NULL,
  `arrival_time` datetime NOT NULL,
  `fare` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`schedule_id`),
  FOREIGN KEY (`train_id`) REFERENCES `trains`(`TrainID`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CHECK (`fare` >= 0),
  CHECK (`stop_number` >= 0)
) ENGINE=InnoDB;

-- Create `reservations` table
CREATE TABLE `reservations` (
  `reservation_id` int NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  `passenger_id` varchar(255) NOT NULL,
  `total_fare` decimal(10,2) NOT NULL,
  `trip_type` ENUM('one-way', 'round-trip') DEFAULT 'one-way',
  `discount_type` ENUM('child', 'senior', 'disabled', 'none') DEFAULT 'none',
  PRIMARY KEY (`reservation_id`),
  FOREIGN KEY (`passenger_id`) REFERENCES `customers`(`username`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CHECK (`total_fare` >= 0)
) ENGINE=InnoDB;

-- Create `books` table
CREATE TABLE `books` (
  `reservation_id` int NOT NULL,
  `username` varchar(255) NOT NULL,
  PRIMARY KEY (`reservation_id`, `username`),
  FOREIGN KEY (`reservation_id`) REFERENCES `reservations`(`reservation_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`username`) REFERENCES `customers`(`username`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Create `manages` table
CREATE TABLE `manages` (
  `schedule_id` int NOT NULL,
  `ssn` char(11) NOT NULL,
  PRIMARY KEY (`schedule_id`, `ssn`),
  FOREIGN KEY (`schedule_id`) REFERENCES `schedule`(`schedule_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`ssn`) REFERENCES `employees`(`ssn`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Create `goes` table
CREATE TABLE `goes` (
  `schedule_id` int NOT NULL,
  `station_id` char(10) NOT NULL,
  `train_id` char(10) NOT NULL,
  PRIMARY KEY (`schedule_id`, `station_id`, `train_id`),
  FOREIGN KEY (`schedule_id`) REFERENCES `schedule`(`schedule_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`station_id`) REFERENCES `stations`(`stationID`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`train_id`) REFERENCES `trains`(`TrainID`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Create `questions_answers` table
CREATE TABLE `questions_answers` (
  `question_id` INT NOT NULL AUTO_INCREMENT,
  `customer_username` VARCHAR(255) NOT NULL,
  `question` TEXT NOT NULL,
  `answer` TEXT DEFAULT NULL,
  `response_date` DATETIME DEFAULT NULL,
  PRIMARY KEY (`question_id`),
  FOREIGN KEY (`customer_username`) REFERENCES `customers`(`username`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Indexes for performance
CREATE INDEX idx_train_id ON schedule (`train_id`);
CREATE INDEX idx_station_id ON goes (`station_id`);
CREATE INDEX idx_schedule_id ON goes (`schedule_id`);
CREATE INDEX idx_customer_username ON questions_answers (`customer_username`);

-- Insert initial data
INSERT INTO trains (TrainID, TransitLineName)
VALUES ('T001', 'Northeast Corridor'), ('T002', 'Coast Line'), ('T003', 'Hudson Line');

INSERT INTO customers (username, password, fname, lname)
VALUES ('user1', 'pass1', 'John', 'Doe'), ('admin1', 'pass2', 'Jane', 'Smith'), ('rep1', 'pass3', 'Mike', 'Brown');

INSERT INTO employees (ssn, username, isAdmin, isRep)
VALUES ('123-45-6789', 'admin1', 1, 0), ('987-65-4321', 'rep1', 0, 1);

INSERT INTO stations (stationID, stationName, state, location, stopNumber, city)
VALUES ('ST001', 'New Brunswick', 'NJ', '123 Main St', 1, 'New Brunswick'),
       ('ST002', 'Trenton', 'NJ', '456 State St', 2, 'Trenton');

INSERT INTO schedule (train_id, origin, destination, stop_number, departure_time, arrival_time, fare)
VALUES ('T001', 'New Brunswick', 'Trenton', 1, '2024-12-10 08:00:00', '2024-12-10 08:45:00', 10.50),
       ('T002', 'Trenton', 'New York', 2, '2024-12-10 09:00:00', '2024-12-10 10:30:00', 20.75);

INSERT INTO reservations (date, passenger_id, total_fare)
VALUES ('2024-12-09 14:00:00', 'user1', 15.00);

INSERT INTO books (reservation_id, username)
VALUES (1, 'user1');

INSERT INTO manages (schedule_id, ssn)
VALUES (1, '987-65-4321');

INSERT INTO goes (schedule_id, station_id, train_id)
VALUES (1, 'ST001', 'T001'), (1, 'ST002', 'T001');