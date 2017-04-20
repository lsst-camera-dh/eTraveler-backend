insert into InternalAction (name, maskBit, createdBy, creationTS) values ('genericLabel', '1024', 'jrb', UTC_TIMESTAMP());

alter table Process add column genericLabelId int NULL COMMENT 'used if generic label is to be added or removed' after newHardwareStatusId;
alter table Process add CONSTRAINT fk46 FOREIGN KEY (genericLabelId) REFERENCES Label(id);

update DbRelease set status='OLD' where major='0' and minor='15' and patch='0';
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '15', '1', 'CURRENT', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Generic label addendum: manipulation from travelers');
