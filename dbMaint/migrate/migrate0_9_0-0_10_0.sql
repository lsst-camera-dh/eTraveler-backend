# New results table for signatures
CREATE TABLE SignatureResultManual
(id int NOT NULL AUTO_INCREMENT,
 activityId int NOT NULL,
 inputPatternId int NOT NULL,
 signerRequest varchar(255) NOT NULL,
 signerValue   varchar(255),
 signatureTS   timestamp NULL,
 createdBy     varchar(50) NOT NULL,
 creationTS    timestamp NULL,
 PRIMARY KEY (id),
 CONSTRAINT fk360 FOREIGN KEY(activityId) REFERENCES Activity(id),
 CONSTRAINT fk361 FOREIGN KEY(inputPatternId) REFERENCES InputPattern(id),
 CONSTRAINT ix360 UNIQUE (activityId, signerRequest)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='an entry for each signature at execution time';

# alter existing tables: add columns
ALTER TABLE InputPattern add column permissionGroupId int NULL after isOptional;
ALTER TABLE InputPattern add CONSTRAINT fk133 FOREIGN KEY(permissionGroupId) REFERENCES PermissionGroup(id);

# Add information to InputSemantics about table to stuff results into
ALTER TABLE InputSemantics add column tableName varchar(255) NOT NULL default '' COMMENT 'where the result should go' after name;

ALTER TABLE PermissionGroup add column stepPermission tinyint NOT NULL  default '1' COMMENT 'If 1 this group is used for step execute permission' after maskBit;

ALTER TABLE Activity add column rootActivityId int NULL after parentActivityId;
ALTER TABLE Activity add CONSTRAINT fk77 FOREIGN KEY(rootActivityId) REFERENCES Activity (id);

# Make constraints in xxResultManual tables reasonable
ALTER TABLE FloatResultManual drop index ix162;
ALTER TABLE FloatResultManual add unique key ix162 (activityId, inputPatternId);

ALTER TABLE IntResultManual drop index ix152;
ALTER TABLE IntResultManual add unique key ix152 (activityId, inputPatternId);

ALTER TABLE StringResultManual drop index ix182;
ALTER TABLE StringResultManual add unique key ix182 (activityId, inputPatternId);

ALTER TABLE FilepathResultManual drop index ix172;
ALTER TABLE FilepathResultManual add unique key ix172 (activityId, inputPatternId);


# insert new data into existing tables
INSERT into MultiRelationshipAction (name, createdBy, creationTS) values ('deassign', 'jrb', UTC_TIMESTAMP());
INSERT into InputSemantics (name, tableName, createdBy, creationTS) values ('signature', 'SignatureResultManual', 'jrb', UTC_TIMESTAMP());

# update InputSemantics.tableName for existing entries
UPDATE InputSemantics set tableName='IntResultManual' where name='int';
UPDATE InputSemantics set tableName='IntResultManual' where name='boolean';
UPDATE InputSemantics set tableName='IntResultManual' where name='checkbox';
UPDATE InputSemantics set tableName='FloatResultManual' where name='float';
UPDATE InputSemantics set tableName='FilepathResultManual' where name='filepath';
UPDATE InputSemantics set tableName='StringResultManual' where name='string';
UPDATE InputSemantics set tableName='StringResultManual' where name='timestamp';

# Mark this release
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '10', '0', 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Support for signatures');


