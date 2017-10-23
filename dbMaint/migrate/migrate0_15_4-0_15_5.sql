insert into InputSemantics set name="url", tableName='StringResultManual', createdBy='jrb', creationTS=UTC_TIMESTAMP();

update DbRelease set status='OLD' where major='0' and minor='15' and patch='4';
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '15', '5', 'CURRENT', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Add url semantic type');

