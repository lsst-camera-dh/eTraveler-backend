
insert into ActivityFinalStatus set name='closed', isFinal='1', createdBy='jrb', creationTS=UTC_TIMESTAMP();

alter table FloatResultManual drop name;
alter table IntResultManual drop name;
alter table StringResultManual drop name;

alter table Process modify description varchar(40000) after shortDescription;
alter table PrerequisitePattern modify description varchar(20000) after name;
alter table InputPattern modify description varchar(20000) after units;
alter table TravelerType modify reason varchar(20000) COMMENT 'purpose of traveler or of this version' after owner;
alter table SignatureResultManual modify signerComment varchar(20000) NOT NULL DEFAULT '' after signerValue;
alter table LabelHistory modify reason varchar(20000) default "" COMMENT "e.g. initialized, used, discarded..." after labelId;

update DbRelease set status='OLD' where major='0' and minor='15' and patch='2';
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '15', '3', 'CURRENT', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Add final status "closed"; minor clean-up in manual results tables');

