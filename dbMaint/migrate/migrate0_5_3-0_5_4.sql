# deprecate unnecessary name fields in *ResultManual tables
alter table IntResultManual modify name varchar(255) NULL COMMENT 'deprecated';
alter table FloatResultManual modify name varchar(255) NULL COMMENT 'deprecated';
alter table FilepathResultManual modify name varchar(255) NULL COMMENT 'deprecated';
alter table StringResultManual modify name varchar(255) NULL COMMENT 'deprecated';
alter table Hardware add manufacturerId varchar(255) NOT NULL default "" after manufacturer;


alter table Process add newLocationId int NULL COMMENT "set new location at completion" after newHardwareStatusId;

insert into InternalAction set name='componentStatus', maskBit='128', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InternalAction set name='componentLocation', maskBit='256', createdBy='jrb', creationTS=UTC_TIMESTAMP();

INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 5, 4, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'support set status, location from traveler; add Hardware.manufacturerId ');
