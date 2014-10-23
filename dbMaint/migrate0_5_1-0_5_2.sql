alter table Process drop index ix44;
alter table Process drop index ix46;
alter table PrerequisitePattern add prereqUserVersionString varchar(64) NULL COMMENT "optional cut on PROCESS_STEP candidates" after prereqProcessId;
 
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 5, 2, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Eliminate harmful uniqueness constraints in Process; add PrequisitePattern.prereqUserVersionString');
