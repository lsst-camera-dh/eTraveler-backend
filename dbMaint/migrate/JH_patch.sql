# new tables:  none
# alter existing tables: add columns
ALTER TABLE JobHarness add column name varchar(255) AFTER id;
ALTER TABLE JobHarness add column description varchar(255) AFTER name;
ALTER TABLE JobHarness add UNIQUE ix261 (name, siteId);

### Need insert into DbRelease
##INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (??, ??, ??, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Refine JobHarness table');
