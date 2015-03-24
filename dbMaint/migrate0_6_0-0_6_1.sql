alter table FilepathResultManual add catalogKey int COMMENT "key from Data Catalog" after virtualPath;
alter table FilepathResultHarnessed add catalogKey int COMMENT "key from Data Catalog" after virtualPath;

INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 6, 1, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'add catalogKey to FilepathResult.. tables');
