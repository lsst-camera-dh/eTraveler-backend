alter table FilepathResultHarnessed alter column sha1 drop default,
        alter column schemaName drop default,
        alter column schemaVersion drop default,
	alter column createdBy drop default;

delete from DbRelease where major=0 and minor=15 and patch=7;
update DbRelease set status='CURRENT' where major=0 and minor=15 and patch=6;

