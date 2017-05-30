alter table Label add column description varchar(5120) default '' after name;
alter table LabelGroup add column description varchar(5120) default '' after name;

alter table FloatResultManual add column valueString varchar(60)  COMMENT 'save value just as operator entered it' after value;
alter table InputPattern add column name varchar(255) NULL COMMENT 'one-word identifier for field' after label;

alter table InputPattern add constraint  unique key ix135 (processId,name);

update DbRelease set status='OLD' where major='0' and minor='15' and patch='1';
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '15', '2', 'CURRENT', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Add generic label descriptions, InputPattern.name, FloatResultManual.valueString');
