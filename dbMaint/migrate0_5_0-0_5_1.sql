alter table TravelerType drop foreign key fk192, drop index fk192;
alter table TravelerType add unique index fk192 (rootProcessId);
alter table TravelerType  add constraint fk192 foreign key (rootProcessId) REFERENCES Process(id);
 
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 5, 1, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Make TravelerType.rootProcessId unique index');

