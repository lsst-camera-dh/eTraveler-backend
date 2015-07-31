# Alter table: new columns
alter table StopWorkHistory add closingComment varchar(1024) NULL  COMMENT "explain chosen resolution of stop work" after reason;
alter table HardwareRelationshipType add slotname varchar(255) COMMENT "identify slot in user friendly fashion" after slot;
# New entries
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 6, 6, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'add a couple columns');
