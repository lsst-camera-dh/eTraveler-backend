CREATE TABLE Labelable
( id int NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL COMMENT "Kind of thing to which labels are applied",
  tableName varchar(255) NOT NULL COMMENT "table where a row represents the thing to be labeled",
  hardwareGroupExpr varchar(255) NULL COMMENT "expression to find hardware group id(s) associated with an object in tableName",
  subsystemExpr varchar(255) NULL COMMENT "expression to find subsystem id associated with an object in tableName",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT uix399 UNIQUE INDEX(name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE LabelGroup
( id int NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  mutuallyExclusive tinyint NOT NULL default '0',
  defaultLabelId int NULL COMMENT "if non-null group has must-be-present property",
  subsystemId int NULL,
  hardwareGroupId int NULL,
  labelableId int NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk400 FOREIGN KEY (subsystemId) REFERENCES Subsystem(id),
  CONSTRAINT fk401 FOREIGN KEY (hardwareGroupId) REFERENCES HardwareGroup(id),
  CONSTRAINT fk402 FOREIGN KEY (labelableId) REFERENCES Labelable(id),
  CONSTRAINT fk403 FOREIGN KEY (defaultLabelId) REFERENCES Label(id),
  CONSTRAINT uix403  UNIQUE INDEX(name, labelableId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Label
( id int NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  labelGroupId int NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk410 FOREIGN KEY (labelGroupId) REFERENCES LabelGroup(id),
  CONSTRAINT uix411 UNIQUE INDEX (labelGroupId, name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE LabelHistory
( id int NOT NULL AUTO_INCREMENT,
  objectId int NOT NULL,
  labelableId int NOT NULL COMMENT "Convenience. Can be looked up from labelId",
  labelId  int NOT NULL,
  reason text default "" COMMENT "e.g. initialized, used, discarded..",
  adding tinyint NOT NULL default '1',
  activityId int NULL COMMENT 'activity (if any) associated with change',
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk420 FOREIGN KEY (labelId) REFERENCES Label(id),
  CONSTRAINT fk421 FOREIGN KEY (labelableId) REFERENCES Labelable(id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
