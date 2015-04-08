# New columns
alter table InputPattern add datatype varchar(255) NULL DEFAULT "LSST_TEST_TYPE" COMMENT 'used in cataloging when type is filepath' after maxV;

alter table ActivityFinalStatus add isFinal bool DEFAULT '1' COMMENT 'default is final' after name;

alter table TravelerType modify state ENUM('NEW', 'ACTIVE', 'DEACTIVATED', 'SUPERSEDED') NULL;

alter table TravelerType modify reason text COMMENT 'purpose of travleler or of this version';

# New tables
CREATE TABLE TravelerTypeState
( id int NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT ix36 UNIQUE (name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Possible states for process traveler type';

CREATE TABLE TravelerTypeStateHistory
( id int NOT NULL AUTO_INCREMENT,
  reason varchar(255) COMMENT "why the state change",
  travelerTypeId int NOT NULL,
  travelerTypeStateId int NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY(id),
  CONSTRAINT  fk250 FOREIGN KEY(travelerTypeId) REFERENCES TravelerType(id),
  CONSTRAINT  fk251 FOREIGN KEY(travelerTypeStateId) REFERENCES TravelerTypeState(id),
  INDEX ix250 (travelerTypeId),
  INDEX ix251 (travelerTypeStateId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Keep track of all traveler type state updates';


# to be copied to process-traveler_infra.sql
insert into ActivityFinalStatus set name="new", isFinal=0, createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into ActivityFinalStatus set name="skipped", isFinal=1, createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into ActivityFinalStatus set name="paused",isFinal=0, createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into ActivityFinalStatus set name="inProgress", isFinal=0, createdBy='jrb', creationTS=UTC_TIMESTAMP();
update ActivityFinalStatus set isFinal='0' where name='stopped';

insert into TravelerTypeState set name="new", createdBy='jrb', creationTS=UTC_TIMESTAMP();

insert into TravelerTypeState set name="active", createdBy='jrb', creationTS=UTC_TIMESTAMP();

insert into TravelerTypeState set name="deactivated", createdBy='jrb', creationTS=UTC_TIMESTAMP();

insert into TravelerTypeState set name="superseded", createdBy='jrb', creationTS=UTC_TIMESTAMP();

INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 6, 2, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Add InputPattern.datatype; TravelerTypeState and TravelerTypeStateHistory tables; insert into TravelerTypeState, ActivityFinalStatus ');

update DbRelease set remarks='Add InputPattern.datatype; TravelerTypeState and TravelerTypeStateHistory tables; insert into TravelerTypeState, ActivityFinalStatus ' where major=0 and minor=6 and patch=2;

