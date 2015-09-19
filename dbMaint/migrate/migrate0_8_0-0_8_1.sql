# new tables:  none
# alter existing tables: add columns
ALTER TABLE JobHarness add column name varchar(255) NOT NULL AFTER id;
ALTER TABLE JobHarness add column description varchar(255) NOT NULL DEFAULT "" AFTER name;
ALTER TABLE JobHarness add UNIQUE ix261 (name, siteId);

INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 8, 1, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Refine JobHarness table');
