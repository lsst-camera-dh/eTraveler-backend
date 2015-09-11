CREATE TABLE Subsystem
(id int NOT NULL AUTO_INCREMENT,
 name varchar(255) NOT NULL,
 WBS  varchar(255) NULL,
 description varchar(255),
 parentId int NULL,
 createdBy varchar(50) NOT NULL,
 creationTS timestamp NULL,
 PRIMARY KEY(id),
 CONSTRAINT fk350 FOREIGN KEY(parentId) REFERENCES Subsystem(id),
 CONSTRAINT ix351 UNIQUE (parentId, name),
 INDEX ix350 (parentId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='';

ALTER TABLE TravelerType add column subsystemId int after reason;
ALTER TABLE TravelerType add CONSTRAINT fk193 FOREIGN KEY (subsystemId) REFERENCES Subsystem(id);
ALTER TABLE TravelerType add INDEX ix193 (subsystemId);

ALTER TABLE HardwareType add column subsystemId int after description;
ALTER TABLE HardwareType add CONSTRAINT fkk2 FOREIGN KEY (subsystemId) REFERENCES Subsystem(id);
ALTER TABLE HardwareType add INDEX ixx2 (subsystemId);

### Need insert into DbRelease
##INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (??, ??, ??, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Support for subsystems');

