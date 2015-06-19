# Add table
 
# Alter table: new columns
alter table HardwareStatus add isStatusValue tinyint default 1 NOT NULL  COMMENT "set to 0 for labels"  after name;
alter table HardwareStatus add systemEntry tinyint default 1 NOT NULL  COMMENT "set to 0 for user entry"  after isStatusValue;

alter table HardwareStatusHistory add reason varchar(1024) NOT NULL default "" COMMENT "why change was made" after activityId;
alter table HardwareStatusHistory add adding tinyint default 1 NOT NULL COMMENT "set to 0 for removal of label. Regular status cannot be explicitly removed" after reason;

alter table InputPattern add isOptional tinyint default 0 NOT NULL COMMENT "operator need not supply an optional input" after choiceField;

# New entries
insert into HardwareStatus (name, isStatusValue, systemEntry, description, createdBy, creationTS) values ("non-compliant", 0, 1, 'mark a part as suspect', 'jrb', UTC_TIMESTAMP());
insert into InternalAction (name, maskBit,createdBy, creationTS) values ('removeLabel', '128', 'jrb', UTC_TIMESTAMP());
insert into InternalAction (name, maskBit,createdBy, creationTS) values ('addLabel', '256', 'jrb', UTC_TIMESTAMP());

insert into PermissionGroup set name='qualityAssurance', maskBit='16', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into TravelerTypeState set name="approved", createdBy='jrb', creationTS=UTC_TIMESTAMP();

INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 6, 8, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Support labels: non-status attributes of hardware components. Also optional operator inputs, new PermissionGroup for QA and approved entry in TravelerTypeState');
