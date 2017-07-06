delete from ActivityFinalStatus where name='closed';
alter table FloatResultManual add name varchar(255) DEFAULT NULL COMMENT 'deprecated' after inputPatternId;
alter table IntResultManual add name varchar(255) DEFAULT NULL COMMENT 'deprecated' after inputPatternId;
alter table StringResultManual add name varchar(255) DEFAULT NULL COMMENT 'deprecated' after inputPatternId;

alter table Process modify description text after shortDescription;
alter table PrerequisitePattern modify description text after name;
alter table InputPattern modify description text after units;
alter table TravelerType modify reason text COMMENT 'purpose of traveler or of this version' after owner;
alter table SignatureResultManual modify signerComment text NOT NULL DEFAULT '' after signerValue;
alter table LabelHistory modify reason text default "" COMMENT "e.g. initialized, used, discarded..." after labelId;

update DbRelease set status='CURRENT' where major='0' and minor='15' and patch='2';
delete DbRelease where major='0' and minor='15' and patch='3';

