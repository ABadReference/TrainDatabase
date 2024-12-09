-- Updated Table structure for `trains`
DROP TABLE IF EXISTS `trains`;
CREATE TABLE `trains` (
  `TrainID` char(10) NOT NULL,
  `TransitLineName` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`TrainID`)
) ENGINE=InnoDB;

-- Updated Table structure for `customers`
DROP TABLE IF EXISTS `customers`;
CREATE TABLE `customers` (
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `fname` varchar(255) DEFAULT NULL,
  `lname` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB;

-- Updated Table structure for `employees`
DROP TABLE IF EXISTS `employees`;
CREATE TABLE `employees` (
  `ssn` char(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `isAdmin` tinyint(1) DEFAULT '0',
  `isRep` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`ssn`),
  FOREIGN KEY (`username`) REFERENCES `customers`(`username`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Updated Table structure for `stations`
DROP TABLE IF EXISTS `stations`;
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

-- Updated Table structure for `schedule`
DROP TABLE IF EXISTS `schedule`;
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

-- Updated Table structure for `reservations`
DROP TABLE IF EXISTS `reservations`;
CREATE TABLE `reservations` (
  `reservation_id` int NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  `passenger_id` varchar(255) NOT NULL,
  `total_fare` decimal(10,2) NOT NULL,
  PRIMARY KEY (`reservation_id`),
  FOREIGN KEY (`passenger_id`) REFERENCES `customers`(`username`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CHECK (`total_fare` >= 0)
) ENGINE=InnoDB;

-- Updated Table structure for `books`
DROP TABLE IF EXISTS `books`;
CREATE TABLE `books` (
  `reservation_id` int NOT NULL,
  `username` varchar(255) NOT NULL,
  PRIMARY KEY (`reservation_id`, `username`),
  FOREIGN KEY (`reservation_id`) REFERENCES `reservations`(`reservation_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`username`) REFERENCES `customers`(`username`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Updated Table structure for `manages`
DROP TABLE IF EXISTS `manages`;
CREATE TABLE `manages` (
  `schedule_id` int NOT NULL,
  `ssn` char(11) NOT NULL,
  PRIMARY KEY (`schedule_id`, `ssn`),
  FOREIGN KEY (`schedule_id`) REFERENCES `schedule`(`schedule_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`ssn`) REFERENCES `employees`(`ssn`)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Updated Table structure for `goes`
DROP TABLE IF EXISTS `goes`;
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

-- Indexes for performance
CREATE INDEX idx_train_id ON schedule (`train_id`);
CREATE INDEX idx_station_id ON goes (`station_id`);
CREATE INDEX idx_schedule_id ON goes (`schedule_id`);