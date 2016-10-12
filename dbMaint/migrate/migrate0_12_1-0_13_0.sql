CREATE TABLE TextResultManual
(id int NOT NULL AUTO_INCREMENT,
 inputPatternId int NOT NULL,
 value text,
 activityId int NOT NULL COMMENT "activity producing this result",
 createdBy varchar(50) NOT NULL,
 creationTS timestamp NULL,
 PRIMARY KEY(id),
 CONSTRAINT fk380 FOREIGN KEY(inputPatternId) REFERENCES InputPattern(id),
 CONSTRAINT fk381 FOREIGN KEY(activityId) REFERENCES Activity(id),
 CONSTRAINT ix382 UNIQUE (activityId, inputPatternId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Store arbitrary long non-filepath string results from manual activities';
insert into InputSemantics set name="text", tableName='TextResultManual', createdBy='jrb', creationTS=UTC_TIMESTAMP();

alter table ProcessRelationshipTag add multiRelationshipSlotTypeId int NULL after multiRelationshipActionId;

alter table ProcessRelationshipTag add slotForm enum('ALL', 'SPECIFIED', 'QUERY') DEFAULT 'ALL' after multiRelationshipSlotTypeId;
alter table ProcessRelationshipTag add CONSTRAINT fk323 FOREIGN KEY (multiRelationshipSlotTypeId) REFERENCES MultiRelationshipSlotType(id);

insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '13', '0', 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Text result type; single-slot actions');


