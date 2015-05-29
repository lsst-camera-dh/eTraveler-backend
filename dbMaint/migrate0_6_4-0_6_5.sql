# Alter table: new columns
# alter table: delete columns
alter table Activity drop foreign key fk75;
alter table Activity drop key fk75;
alter table Activity drop activityFinalStatusId;
# alter table Process drop hardwareTypeId;

# delete entries
delete from HardwareStatus where name='NON-COMPLIANT';

# New entries
insert into TravelerTypeState set name="validated", createdBy='jrb', creationTS=UTC_TIMESTAMP();
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 6, 5, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'delete obsolete stuff; add validated trav type state');
