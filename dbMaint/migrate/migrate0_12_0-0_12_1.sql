alter table RunNumber add runInt int NOT NULL DEFAULT '0' COMMENT "runNumber without alpha characters" after runNumber;
alter table RunNumber add index ix373 (runInt);

insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '12', '1', 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Patch to RunNumber table for better searching');

