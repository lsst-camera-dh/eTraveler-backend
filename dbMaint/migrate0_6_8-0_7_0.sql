#  Batched hardware, first stage.  Stage 2 will support relationships.
#  Begin work to restrict Process.name characters; start by adding 
#    Process.shortDescriptin
#  Add more traveler definition states for approval process
#
#  Tables to be added
CREATE TABLE BatchedInventoryHistory 
( id int NOT NULL AUTO_INCREMENT,
  hardwareId int NOT NULL COMMENT 'batch being adjusted',
  adjustment int NOT NULL COMMENT '# of items used, discarded, or returned. Negative for used, discarded; positive for returned, initialized',
  reason varchar(255) default "" COMMENT "e.g. initialized, used, discarded..",
  activityId int NULL COMMENT 'activity (if any) associated with change',
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk270 FOREIGN KEY (hardwareId) REFERENCES Hardware(id),
  CONSTRAINT fk271 FOREIGN KEY (activityId) REFERENCES Activity(id),
  INDEX ix270 (hardwareId),
  INDEX ix271 (activityId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='track use of batched items';


#  Tables to be altered (add columns)
#    need to add fk field to Process referencing batched relationship type
alter table HardwareType add column isBatched tinyint NOT NULL default "0" after trackingType;
alter table Process add column shortDescription varchar(255) NOT NULL default "" after userVersionString;

#  Inserts
#    need to add rows to InternalAction to define bits for making/breaking
#    batched relationship
#  New traveler states

insert into TravelerTypeState set name="subsystemApproved", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into TravelerTypeState set name="softwareApproved", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into TravelerTypeState set name="subjectApproved", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into TravelerTypeState set name="workflowApproved", createdBy='jrb', creationTS=UTC_TIMESTAMP();

INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 7, 0, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Begin to support batched hardware, Process.shortDescription');
