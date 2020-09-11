alter table FilepathResultHarnessed alter column sha1 set default '0',
        alter column schemaName set default 'fileref',
        alter column schemaVersion set default '0',
	alter column createdBy set default 'ghost';

update DbRelease set status='OLD' where major='0' and minor='15' and patch='6';
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '15', '7', 'CURRENT', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Add default values to FilepathResultHarnessed');
