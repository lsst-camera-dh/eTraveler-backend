alter table FloatResultHarnessed modify column value double after name;
alter table FloatResultManual modify column value double after name;
-- alter table Hardware add column remark varchar(255) NOT NULL default "" after manufacturerId;


alter table Process drop foreign key fk40;
alter table Process drop key fk40;
alter table Process drop hardwareTypeId;
drop table Result;
drop table NextProcessVersion;

alter table IntResultHarnessed drop key ix156;
alter table IntResultHarnessed add constraint ix156 unique (schemaName, name, schemaInstance, activityId, schemaVersion);

alter table FloatResultHarnessed drop key ix166;
alter table FloatResultHarnessed add constraint ix166 unique (schemaName, name, schemaInstance, activityId, schemaVersion);

alter table StringResultHarnessed drop key ix186;
alter table StringResultHarnessed add constraint ix186 unique (schemaName, name, schemaInstance, activityId, schemaVersion);

update DbRelease set status='OLD' where major='0' and minor='14' and patch='0';
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '14', '1', 'CURRENT', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Change float to double in results tables; clean up');
