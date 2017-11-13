CREATE TABLE LabelCurrent
( id int NOT NULL AUTO_INCREMENT,
  objectId int NOT NULL,
  labelableId int NOT NULL COMMENT "Convenience. Can be looked up from labelId",
  labelId  int NOT NULL,
  reason varchar(20000) default "" COMMENT "e.g. initialized, used, discarded..",
  adding tinyint NOT NULL default '1',
  activityId int NULL COMMENT 'activity (if any) associated with change',
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk430 FOREIGN KEY (labelId) REFERENCES Label(id),
  CONSTRAINT fk431 FOREIGN KEY (labelableId) REFERENCES Labelable(id),
  UNIQUE INDEX ix432 (objectId, labelId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

insert into InputSemantics set name="url", tableName='StringResultManual', createdBy='jrb', creationTS=UTC_TIMESTAMP();

update DbRelease set status='OLD' where major='0' and minor='15' and patch='4';
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '15', '5', 'CURRENT', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Add url semantic type; new table LabelCurrent');

