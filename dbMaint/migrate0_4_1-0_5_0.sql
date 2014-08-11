

ALTER TABLE ExceptionType MODIFY exitProcessPath varchar(2000) NOT NULL COMMENT 'period separated list of ProcessEdge ids from traveler root to exit process';
ALTER TABLE ExceptionType MODIFY returnProcessPath varchar(2000) NOT NULL COMMENT 'period separated list of ProcessEdge ids from traveler root to return process';


CREATE TABLE ActivityStatusHistory
(id  int NOT NULL AUTO_INCREMENT,
  activityStatusId int NOT NULL COMMENT "fk for the new status",
  activityId int NOT NULL COMMENT "activity whose status is being updated",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY(id),
  CONSTRAINT fk230 FOREIGN KEY(activityStatusId) REFERENCES ActivityFinalStatus(id),
  CONSTRAINT fk231 FOREIGN KEY(ActivityId) REFERENCES Activity(id),
  INDEX fk230 (activityStatusId),
  INDEX fk231 (activityId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Keep track of all activity status updates';

insert into InternalAction set name='automatable', maskBit='64', createdBy='jrb', creationTS=UTC_TIMESTAMP();

INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 5, 0, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Add ActivityStatusHistory table; add automatable internal action');

