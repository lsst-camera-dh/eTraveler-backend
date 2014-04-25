CREATE TABLE TravelerType
( id int NOT NULL AUTO_INCREMENT,
  rootProcessId int NOT NULL,
  state ENUM('NEW', 'ACTIVE', 'DEACTIVATED', 'SUPERSEDED') DEFAULT 'NEW',
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY(id),
  CONSTRAINT  fk192 FOREIGN KEY(rootProcessId) REFERENCES Process(id),
  INDEX fk192 (rootProcessId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='List of traveler types';

CREATE TABLE StopWorkHistory
( id  int NOT NULL AUTO_INCREMENT,
  activityId int NOT NULL COMMENT "current activity being stopped or resumed",
  rootActivityId int NOT NULL COMMENT "root activity of this traveler instance",
  reason varchar(1024) NOT NULL COMMENT "why stop work is necessary",
  approvalGroup  int NOT NULL COMMENT "bitmask using PermissionGroup.maskBit",
  creationTS timestamp NULL COMMENT "when stop work occurred",
  createdBy varchar(50) NOT NULL,
  resolution ENUM('NONE', 'RESUMED', 'QUIT') DEFAULT 'NONE',
  resolutionTS timestamp NULL COMMENT "when activity was resumed or killed",
  resolvedBy varchar(50) NULL,  
  PRIMARY KEY(id),
  CONSTRAINT fk195 FOREIGN KEY(activityId) REFERENCES Activity(id),
  CONSTRAINT fk196 FOREIGN KEY(rootActivityId) REFERENCES Activity(id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='an entry for each STOP WORK event';

insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 3, 0, 'TEST', 'jrb', NOW(), NOW(), 'Adding stop/resume history, traveler type directory tables');
