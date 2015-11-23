CREATE TABLE Subsystem
(id int NOT NULL AUTO_INCREMENT,
 name varchar(255) NOT NULL,
 shortName varchar(16) NOT NULL default "" COMMENT "Prefix for perm. groups and traveler names",
 description varchar(255) default "",
 generic tinyint NOT NULL default "0" COMMENT "if True permission group name = role name",
 parentId int NULL,
 createdBy varchar(50) NOT NULL,
 creationTS timestamp NULL,
 PRIMARY KEY(id),
 CONSTRAINT fk350 FOREIGN KEY(parentId) REFERENCES Subsystem(id),
 CONSTRAINT ix351 UNIQUE (parentId, name),
 UNIQUE INDEX ix352 (shortName),
 INDEX ix350 (parentId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='';

ALTER TABLE TravelerType add column subsystemId int after reason;
ALTER TABLE TravelerType add CONSTRAINT fk193 FOREIGN KEY (subsystemId) REFERENCES Subsystem(id);
ALTER TABLE TravelerType add INDEX ix193 (subsystemId);

ALTER TABLE HardwareType add column subsystemId int after description;
ALTER TABLE HardwareType add CONSTRAINT fkk2 FOREIGN KEY (subsystemId) REFERENCES Subsystem(id);
ALTER TABLE HardwareType add INDEX ixx2 (subsystemId);

ALTER TABLE HardwareLocationHistory add column reason varchar(1024) NOT NULL DEFAULT '' after activityId;

insert into Subsystem (name, shortName, description, parentId, createdBy, creationTS) values ("Camera", "Cam", "Full camera", NULL, 'jrb', UTC_TIMESTAMP());


insert into Subsystem (name, shortName, description, generic, createdBy, creationTS) values ("Legacy", "Legacy", "Used for traveler types predating Subsystem table", '1', 'jrb', UTC_TIMESTAMP());

insert into Subsystem (name, shortName, description, generic, createdBy, creationTS) values ("Default", "Default", "Used for traveler types not associated with any particular subsystem", '1', 'jrb', UTC_TIMESTAMP());

### Need insert into DbRelease
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '9', '0', 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Support for subsystems');

