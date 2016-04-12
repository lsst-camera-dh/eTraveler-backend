# New results table for signatures
CREATE TABLE SignatureResultManual
(id int NOT NULL AUTO_INCREMENT,
 activityId int NOT NULL,
 inputPatternId int NOT NULL,
 signerRequest varchar(255) NOT NULL COMMENT 'name or bitmask, e.g. 0x00001010',
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
# Input pattern may now have associated permission group bit mask if it's
# of signature type
ALTER TABLE InputPattern add column roleBitmask int unsigned DEFAULT 0 COMMENT 'For signature type only. 0 means dynamically determined; else use bits from PermissionGroup' after isOptional;

# Add information to InputSemantics about table to stuff results into
ALTER TABLE InputSemantics add column tableName varchar(255) NOT NULL default '' COMMENT 'where the result should go' after name;

# insert new data into existing tables
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
##INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '10', '0', 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Support for signatures');


