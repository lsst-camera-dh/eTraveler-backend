alter table Process add column labelGroupId int NULL COMMENT 'restrict drop-down menu to a label group' after genericLabelId;
alter table Process add column siteId int NULL COMMENT 'restrict change-location drop-down menu to a site' after newLocation;
alter table Process add CONSTRAINT fk47 FOREIGN KEY (labelGroupId) REFERENCES LabelGroup(id);
alter table Process add CONSTRAINT fk48 FOREIGN KEY (siteId) REFERENCES Site(id);

alter table Activity add column activityFinalStatusId int NULL COMMENT 'cached value; see also ActivityStatusHistory' after jobHarnessId;
alter table Activity add CONSTRAINT fk75 FOREIGN KEY (activityFinalStatusId) REFERENCES ActivityFinalStatus(id);

alter table Hardware add column locationId int NULL COMMENT 'cached value; see also HardwareLocationHistory' after hardwareStatusId;
alter table Hardware add CONSTRAINT fk6 FOREIGN KEY (locationId) REFERENCES Location(id);

update DbRelease set status='OLD' where major='0' and minor='15' and patch='3';
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '15', '4', 'CURRENT', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Add a couple fields to Process; reinstate ActivityFinalStatusId');

