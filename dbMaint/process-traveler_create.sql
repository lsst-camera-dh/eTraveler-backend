-- last fk:  380s
CREATE TABLE IF NOT EXISTS DbRelease
( id int NOT NULL AUTO_INCREMENT,
  major int NOT NULL COMMENT "major release number",
  minor int NOT NULL COMMENT "minor release number",
  patch int NOT NULL COMMENT "patch release number",
  status enum ('NO_GOOD', 'OLD', 'CURRENT', 'TEST') NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  lastModTS  timestamp NULL,
  remarks varchar(200) NULL,
  PRIMARY KEY (id),
  UNIQUE INDEX (major, minor, patch)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Site
( id int NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  jhVirtualEnv varchar(255) NULL COMMENT "path to root of virtual env for job harmenss",
  jhOutputRoot  varchar(255) NULL COMMENT "path to root of job harness output directory, corresponds to environment variable LCATR_ROOT",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT UNIQUE (name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Keep site-specific information here';

CREATE TABLE Location
( id int NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  siteId int NOT NULL COMMENT "responsible site, even if, e.g., in transit",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk190 FOREIGN KEY(siteId) REFERENCES Site(id),
  CONSTRAINT ix191 UNIQUE (siteId, name),
  INDEX fk190 (siteId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Identifies teststand, assembly station, etc.';

CREATE TABLE JobHarness
( id int NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  description varchar(255) NOT NULL DEFAULT "",
  jhVirtualEnv varchar(255) NOT NULL,
  jhOutputRoot varchar(255) NOT NULL,
  jhStageRoot varchar(255) NOT NULL,
  jhCfg varchar(255) NULL COMMENT "path to installation-wide cfg (if any) relative to jhVirtualEnv",
  siteId    int NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk260 FOREIGN KEY(siteId) REFERENCES Site(id),
  INDEX ix260 (siteId),
  UNIQUE INDEX ix261 (name, siteId) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Information pertaining to a job harness installation';
  
CREATE TABLE Subsystem
(id int NOT NULL AUTO_INCREMENT,
 name varchar(255) NOT NULL,
 shortName varchar(16) NOT NULL default "" COMMENT "Prefix for perm. groups and traveler names",
 description varchar(255) default "",
 generic tinyint NOT NULL default "0" COMMENT "if True permission group name = role name",
 parentId int NULL,
 createdBy varchar(50) NOT NULL,
 creationTS timestamp NULL,
 PRIMARY KEY(id),
 CONSTRAINT fk350 FOREIGN KEY(parentId) REFERENCES Subsystem(id),
 CONSTRAINT ix351 UNIQUE (parentId, name),
 UNIQUE INDEX ix352 (shortName),
 INDEX ix350 (parentId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='';

# May need to add additional table for subsystem (name, id and boilerplate)
# and add column to HardwareType: fk to subsystem
# Maybe do something similar for "component type"  ("part" or "assembly")
# or, if there are just those two, add flag column.
CREATE TABLE HardwareType 
( id int NOT NULL AUTO_INCREMENT, 
  name varchar(255) NOT NULL COMMENT "drawing number without revision if available",
  autoSequenceWidth int DEFAULT 0 COMMENT "width of zero-filled sequence #",
  autoSequence int DEFAULT 0 COMMENT "used when autoSequenceWidth > 0",
  trackingType enum('COMPONENT', 'TEST_EQUIPMENT') DEFAULT 'COMPONENT',
  isBatched tinyint NOT NULL default "0",
  description varchar(255) DEFAULT "",
  subsystemId int NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT ix2 UNIQUE (name),
  CONSTRAINT fkk2 FOREIGN KEY (subsystemId) REFERENCES Subsystem(id),
  INDEX ixx2(subsystemId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE HardwareGroup
( id int NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  description varchar(255) DEFAULT "",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY(id),
  CONSTRAINT cui10 UNIQUE (name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Allows grouping of hardware types';

CREATE TABLE HardwareStatus
( id int NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  isStatusValue tinyint default 1 NOT NULL COMMENT "set to 0 for labels",
  systemEntry tinyint default 1 NOT NULL COMMENT "set to 0 for user entry",
  description varchar(255) NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT ix3 UNIQUE (name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='just registered, ready for assembly, rejected, etc.';

CREATE TABLE Hardware 
( id int NOT NULL AUTO_INCREMENT, 
  lsstId varchar(255) NOT NULL,
  hardwareTypeId int NOT NULL, 
  manufacturer varchar(255) NOT NULL,
  manufacturerId varchar(255) NOT NULL default "",
  model varchar(255) NULL,
  manufactureDate timestamp NULL,
  remarks varchar(255) NOT NULL default "" COMMENT "primarily for use during registration",
  hardwareStatusId int NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk1 FOREIGN KEY (hardwareTypeId) REFERENCES HardwareType (id), 
  CONSTRAINT fk2 FOREIGN KEY (hardwareStatusId) REFERENCES HardwareStatus (id), 
  CONSTRAINT ix4 UNIQUE INDEX (hardwareTypeId, lsstId),
  INDEX fk1 (hardwareTypeId),
  INDEX fk2 (hardwareStatusId) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Create a row here to register new component';


CREATE TABLE HardwareIdentifierAuthority 
( id int NOT NULL AUTO_INCREMENT, 
  name varchar(255) NOT NULL, 
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT ix4 UNIQUE (name) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE HardwareIdentifier 
( id int NOT NULL AUTO_INCREMENT, 
  authorityId int NOT NULL COMMENT "site or other authority for assigning this identifier", 
  hardwareId int NOT NULL    COMMENT "reference to hardware instance getting identifier", 
  hardwareTypeId int NOT NULL COMMENT "references type of hardware instance getting identifier",
  identifier varchar(255) NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk3 FOREIGN KEY (authorityId) REFERENCES HardwareIdentifierAuthority (id) , 
  CONSTRAINT fk4 FOREIGN KEY (hardwareId) REFERENCES Hardware (id), 
  CONSTRAINT fk5 FOREIGN KEY (hardwareTypeId) REFERENCES HardwareType (id), 
  INDEX fk3 (authorityId), 
  INDEX fk4 (hardwareId),
  INDEX fk5 (hardwareTypeId),
  CONSTRAINT ix6 UNIQUE INDEX (identifier, authorityId, hardwareTypeId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE MultiRelationshipType 
( id int NOT NULL AUTO_INCREMENT, 
  name varchar(255) NOT NULL,
  hardwareTypeId int NOT NULL,
  minorTypeId int NOT NULL,
  description varchar(255) DEFAULT NULL,
  singleBatch tinyint NOT NULL default "1" COMMENT "By default batched relationship is satisfied with a single batch",
  nMinorItems int NOT NULL default "1" COMMENT "By default use just one subordinate item in a relationship but may be more",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk280 FOREIGN KEY (hardwareTypeId) REFERENCES HardwareType(id),
  CONSTRAINT fk281 FOREIGN KEY (minorTypeId) REFERENCES HardwareType(id),
  INDEX ix280 (hardwareTypeId),
  INDEX ix281 (minorTypeId),
  CONSTRAINT ix282 UNIQUE INDEX (name, hardwareTypeId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='describes relationship between two hardware types, one (which may be batched) subsidiary to the other';

CREATE TABLE MultiRelationshipSlotType
( id int NOT NULL AUTO_INCREMENT,
  multiRelationshipTypeId int NOT NULL,
  slotname varchar(255) NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk286 FOREIGN KEY (multiRelationshipTypeId) REFERENCES MultiRelationshipType(id),
  INDEX ix286 (multiRelationshipTypeId),
  CONSTRAINT ix287 UNIQUE (multiRelationshipTypeId, slotname)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='names for slots for each subsidiary item';

CREATE TABLE MultiRelationshipSlot
( id int NOT NULL AUTO_INCREMENT,
  multiRelationshipSlotTypeId int NOT NULL,
  minorId int NULL COMMENT "obsolete; moved to MultiRelationshipHistory",
  hardwareId int NOT NULL COMMENT "parent component in assembly",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk300 FOREIGN KEY (multiRelationshipSlotTypeId) REFERENCES MultiRelationshipSlotType(id),
  CONSTRAINT fk301 FOREIGN KEY (hardwareId) REFERENCES Hardware(id),
  INDEX ix300 (multiRelationshipSlotTypeId),
  INDEX ix301 (hardwareId),
  UNIQUE INDEX ix303 (hardwareId, multiRelationshipSlotTypeId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='batched (or not) slot instance. May represent 1 or several items';

CREATE TABLE MultiRelationshipAction
( id int NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  UNIQUE INDEX ix305 (name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='values assign, install, uninstall...';


CREATE TABLE InternalAction
( id int NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  maskBit int unsigned NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  UNIQUE INDEX (maskBit),
  UNIQUE INDEX (name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Identify special actions eTraveler may have to perform assoc. with process';

CREATE TABLE PermissionGroup
( id int NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  maskBit int unsigned NOT NULL,
  stepPermission tinyint NOT NULL default '1' COMMENT 'If 1 this group is used for step execute permission',
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  UNIQUE INDEX (maskBit),
  UNIQUE INDEX (name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Associate mask bit with each permission group';

-- Next three tables are remaining needed for generic labels
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='object types to which a generic label may be applied';


CREATE TABLE LabelGroup
( id int NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  mutuallyExclusive tinyint NOT NULL default '0',
  defaultLabelId int NULL,
  subsystemId int NULL,
  hardwareGroupId int NULL,
  labelableId int NOT NULL  COMMENT "if non-null group has must-be-present property",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk400 FOREIGN KEY (subsystemId) REFERENCES Subsystem(id),
  CONSTRAINT fk401 FOREIGN KEY (hardwareGroupId) REFERENCES HardwareGroup(id),
  CONSTRAINT fk402 FOREIGN KEY (labelableId) REFERENCES Labelable(id),
  CONSTRAINT uix403  UNIQUE INDEX(name, labelableId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='generic label must belong to a group specifying at least object type';

CREATE TABLE Label
( id int NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  labelGroupId int NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk410 FOREIGN KEY (labelGroupId) REFERENCES LabelGroup(id),
  CONSTRAINT uix411 UNIQUE INDEX (labelGroupId, name),
  INDEX ix410 (name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE Process 
( id int NOT NULL AUTO_INCREMENT, 
  originalId int NULL COMMENT "set equal to id of 1st version of this Process",
  name varchar(255) NOT NULL, 
  version int NOT NULL,
  jobname varchar(255) NULL,
  userVersionString varchar(255) NULL COMMENT 'e.g. git tag',
  shortDescription varchar(255) NOT NULL default "",
  description text, 
  instructionsURL varchar(255), 
  substeps  ENUM('NONE', 'SEQUENCE', 'SELECTION') default 'NONE'
   COMMENT 'determines where we go next',
  maxIteration tinyint unsigned DEFAULT 1,
  travelerActionMask int unsigned DEFAULT 0,
  permissionMask int unsigned DEFAULT 127 COMMENT 'Set bit for each group authorized to execute this process',
  newHardwareStatusId int NULL COMMENT 'used if step is to change hw status',
  genericLabelId int NULL COMMENT 'used if generic label is to be added or removed',
  newLocation varchar(255) NULL COMMENT "set new location in this step",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  hardwareGroupId int NOT NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk42 FOREIGN KEY (newHardwareStatusId) REFERENCES HardwareStatus (id),
  CONSTRAINT fk45 FOREIGN KEY (hardwareGroupId) REFERENCES HardwareGroup (id),
  CONSTRAINT fk46 FOREIGN KEY (genericLabelId) REFERENCES Label(id),
  INDEX fk42 (newHardwareStatusId),
  INDEX fk45 (hardwareGroupId),
  CONSTRAINT ix44 UNIQUE INDEX (name, hardwareGroupId, version),
  CONSTRAINT ix45 UNIQUE INDEX (originalId, version)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Describes procedure for a step within a traveler';

CREATE TABLE ProcessEdge 
( id int NOT NULL AUTO_INCREMENT, parent int NOT NULL, 
  child int NOT NULL, step int NOT NULL, 
  cond varchar(255) 
   COMMENT 'condition under which edge is traversed; used only if parent process has navigation type SELECTION',
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT ix32 UNIQUE INDEX (parent, step),
  CONSTRAINT fk31 FOREIGN KEY (child) REFERENCES Process (id) , 
  CONSTRAINT fk30 FOREIGN KEY (parent) REFERENCES Process (id), 
  INDEX fk30 (parent), INDEX fk31 (child) 
)  ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Encapsulates information on how to traverse hierarchy of process steps';


CREATE TABLE ExceptionType
( id int NOT NULL AUTO_INCREMENT, 
  conditionString varchar(255) NOT NULL,  
  exitProcessPath varchar(2000)  NULL COMMENT 'period separated list of processEdge ids from traveler root to exit process', 
  returnProcessPath varchar(2000) NULL COMMENT 'period separated list of processEdge ids from traveler root to return process', 
  exitProcessId int NOT NULL,
  returnProcessId int NOT NULL,
  rootProcessId int NOT NULL COMMENT 'id of root process for traveler exception is assoc. with',
  NCRProcessId int NOT NULL,  
  status ENUM('ENABLED', 'DISABLED') default 'ENABLED',
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk80 FOREIGN KEY (exitProcessId) REFERENCES Process (id),
  CONSTRAINT fk81 FOREIGN KEY (rootProcessId) REFERENCES Process (id),
  CONSTRAINT fk82 FOREIGN KEY (NCRProcessId) REFERENCES Process (id),
  CONSTRAINT fk83 FOREIGN KEY (returnProcessId) REFERENCES Process (id),
  INDEX fk80 (exitProcessId),
  INDEX fk81 (rootProcessId),
  INDEX fk82 (NCRProcessId),
  INDEX fk83 (returnProcessId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE JobHarnessStep
( id int NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT ix35 UNIQUE (name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Steps within for job harness job';

CREATE TABLE ActivityFinalStatus
( id int NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  isFinal bool DEFAULT '0',
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT ix36 UNIQUE (name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Final status';


CREATE TABLE Activity 
( id int NOT NULL AUTO_INCREMENT, 
  hardwareId int NOT NULL COMMENT "hardware in whose behalf activity occurred", 
  processId int NOT NULL, 
  processEdgeId int NULL
   COMMENT "edge used to get to process; NULL for root",
  parentActivityId int NULL,
  rootActivityId int NULL,
  jobHarnessId int NULL,
  iteration tinyint unsigned DEFAULT 1 COMMENT "Set to non-default for rework",
  begin timestamp NULL, 
  end timestamp NULL, 
  inNCR ENUM ('TRUE', 'FALSE')  default 'FALSE',
  createdBy varchar(50) NOT NULL,
  closedBy varchar(50) NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk70 FOREIGN KEY (hardwareId) REFERENCES Hardware (id), 
  CONSTRAINT fk72 FOREIGN KEY (processId) REFERENCES Process (id) , 
  CONSTRAINT fk73 FOREIGN KEY (processEdgeId) REFERENCES ProcessEdge (id), 
  CONSTRAINT fk74 FOREIGN KEY (parentActivityId) REFERENCES Activity (id), 
  CONSTRAINT fk76 FOREIGN KEY (jobHarnessId) REFERENCES JobHarness (id), 
  CONSTRAINT fk77 FOREIGN KEY (rootActivityId) REFERENCES Activity (id), 
  INDEX fk70 (hardwareId),
  INDEX fk72 (processId), 
  INDEX fk73 (processEdgeId),
  INDEX fk74 (parentActivityId),
  INDEX ix76 (jobHarnessId),
  INDEX ix70 (begin),
  INDEX ix71 (end),
  INDEX ix72 (parentActivityId, processEdgeId)
)   ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Instance of process step executed on a particular component';

CREATE TABLE PrerequisiteType
( id int NOT NULL AUTO_INCREMENT,
  name varchar(255) COMMENT "e.g. PROCESS_STEP, COMPONENT, CONSUMABLE, etc.",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT ix99 UNIQUE INDEX (name)
) ENGINE=InooDB DEFAULT CHARSET=latin1;

CREATE TABLE PrerequisitePattern
( id int NOT NULL AUTO_INCREMENT,
  name varchar(255)  NOT NULL,
  description text COMMENT "describe in detail",
  prerequisiteTypeId int NOT NULL COMMENT "prerequisiteType determines which field below, if any, is non-null",
  processId int NOT NULL COMMENT "process step for which this is a prereq",
  prereqProcessId  int NULL COMMENT "Non-null if prereq is another proc. step",
  prereqUserVersionString varchar(255) NULL COMMENT "optional cut on PROCESS_STEP candidates",
  hardwareTypeId    int NULL COMMENT "non-null if prereq is tracked hardware",
  quantity         int NOT NULL DEFAULT 1,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk100 FOREIGN KEY(processId) REFERENCES Process(id),
  CONSTRAINT fk101 FOREIGN KEY(prerequisiteTypeId) REFERENCES PrerequisiteType(id),
  CONSTRAINT fk102 FOREIGN KEY(prereqProcessId) REFERENCES Process(id),
  CONSTRAINT fk103 FOREIGN KEY(hardwareTypeId) REFERENCES HardwareType(id),
  CONSTRAINT ix100 UNIQUE(processId, name),
  INDEX fk100 (processId),
  INDEX fk101 (prerequisiteTypeId),
  INDEX fk102 (prereqProcessId),
  INDEX fk103 (hardwareTypeId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Describe prerequisite for specified process step';

CREATE TABLE Prerequisite
( id int NOT NULL AUTO_INCREMENT,
  prerequisitePatternId int NOT NULL COMMENT "template for this prerequisite",
  activityId int NOT NULL COMMENT "Activity for which prereq is to be satisfied",
  prerequisiteActivityId int NULL COMMENT "Used if prereq was completion of another process step",
  hardwareId int NULL COMMENT "Used if prereq was a tracked component",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY(id),
  CONSTRAINT fk111 FOREIGN KEY(prerequisitePatternId) REFERENCES PrerequisitePattern(id),
  CONSTRAINT fk112 FOREIGN KEY(activityId) REFERENCES Activity(id),
  CONSTRAINT fk113 FOREIGN KEY(prerequisiteActivityId) REFERENCES Activity(id),
  CONSTRAINT fk114 FOREIGN KEY(hardwareId) REFERENCES Hardware(id),
  INDEX fk111 (prerequisitePatternId),
  INDEX fk112 (activityId),
  INDEX fk113 (prerequisiteActivityId),
  INDEX fk114 (hardwareId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Describes item satisfying a prereq. for a specific activity';

# Maybe should add another field for base type?  Or table name for 
# corresponding results table?
CREATE TABLE InputSemantics
( id int NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  tableName varchar(255) NOT NULL default '' COMMENT 'where the result should go',
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY(id),
  UNIQUE INDEX ix120 (name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Names possible types of operator input';

CREATE TABLE InputPattern
(id int NOT NULL AUTO_INCREMENT,
  processId int NOT NULL COMMENT "process step this input belongs to",
  inputSemanticsId int NOT NULL,
  label   varchar(255) NOT NULL COMMENT "required label to appear on form", 
  units  varchar(255) DEFAULT "none",
  description text NULL COMMENT "if label is not sufficient",
  minV float  NULL COMMENT "allowed minimum (optional)",  
  maxV float  NULL COMMENT "allowed maximum (optional)",  
  datatype varchar(255) NULL DEFAULT "LSST_TEST_TYPE" COMMENT 'used in cataloging when type is filepath',
  choiceField varchar(255) NULL COMMENT "may be set to table.field, e.g. HardwareStatus.name",
  isOptional tinyint default 0 NOT NULL COMMENT "operator need not supply optional input",
  permissionGroupId int NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY(id),
  CONSTRAINT fk130 FOREIGN KEY(processId) REFERENCES Process(id),
  CONSTRAINT fk131 FOREIGN KEY(inputSemanticsId) REFERENCES InputSemantics(id),
  CONSTRAINT ix132 UNIQUE (processId, label),
  CONSTRAINT fk133 FOREIGN KEY(permissionGroupId) REFERENCES PermissionGroup(id),
  INDEX fk130 (processId),
  INDEX fk131 (inputSemanticsId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Describes required operator input assoc. with particular process step';

CREATE TABLE JobStepHistory
(id  int NOT NULL AUTO_INCREMENT,
  jobHarnessStepId int NOT NULL COMMENT "fk for the new status",
  activityId int NOT NULL COMMENT "activity whose status is being updated",
  errorString varchar(255) NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY(id),
  CONSTRAINT fk140 FOREIGN KEY(jobHarnessStepId) REFERENCES JobHarnessStep(id),
  CONSTRAINT fk141 FOREIGN KEY(activityId) REFERENCES Activity(id),
  INDEX fk140 (jobHarnessStepId),
  INDEX fk141 (activityId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Keep track of all job harness status updates';

CREATE TABLE IntResultManual
(id int NOT NULL AUTO_INCREMENT,
 inputPatternId int NOT NULL,
 name varchar(255) NULL COMMENT "deprecated",
 value  int,
 activityId int NOT NULL COMMENT "activity producing this result",
 createdBy varchar(50) NOT NULL,
 creationTS timestamp NULL,
 PRIMARY KEY(id),
 CONSTRAINT fk150 FOREIGN KEY(inputPatternId) REFERENCES InputPattern(id),
 CONSTRAINT fk151 FOREIGN KEY(activityId) REFERENCES Activity(id),
 INDEX ix152 (activityId, inputPatternId),
 INDEX fk150 (inputPatternId),
 INDEX fk151 (activityId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Store scalar int results from manual activities';

CREATE TABLE IntResultHarnessed
(id int NOT NULL AUTO_INCREMENT,
 name varchar(255) COMMENT "comes from schema",
 value  int,
 schemaName varchar(255) NOT NULL,
 schemaVersion varchar(50) NOT NULL,
 schemaInstance int DEFAULT "0" COMMENT "Same schema may be used more than once in a result summary",
 activityId int NOT NULL COMMENT "activity producing this result",
 createdBy varchar(50) NOT NULL,
 creationTS timestamp NULL,
 PRIMARY KEY(id),
 CONSTRAINT fk155 FOREIGN KEY(activityId) REFERENCES Activity(id),
 CONSTRAINT ix156 UNIQUE (schemaName, name, schemaInstance, activityId, schemaVersion),
 INDEX fk155 (activityId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Store scalar int results from harnessed activities';

CREATE TABLE FloatResultManual
(id int NOT NULL AUTO_INCREMENT,
 inputPatternId int NOT NULL,
 name varchar(255) NULL COMMENT "deprecated",
 value  double,
 activityId int NOT NULL COMMENT "activity producing this result",
 createdBy varchar(50) NOT NULL,
 creationTS timestamp NULL,
 PRIMARY KEY(id),
 CONSTRAINT fk160 FOREIGN KEY(inputPatternId) REFERENCES InputPattern(id),
 CONSTRAINT fk161 FOREIGN KEY(activityId) REFERENCES Activity(id),
 INDEX ix162 (activityId, inputPatternId),
 INDEX fk160 (inputPatternId),
 INDEX fk161 (activityId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Store scalar float results from manual activities';

CREATE TABLE FloatResultHarnessed
(id int NOT NULL AUTO_INCREMENT,
 name varchar(255) COMMENT "comes from schema",
 value  double,
 schemaName varchar(255) NOT NULL,
 schemaVersion varchar(50) NOT NULL,
 schemaInstance int DEFAULT "0" COMMENT "Same schema may be used more than once in a result summary",
 activityId int NOT NULL COMMENT "activity producing this result",
 createdBy varchar(50) NOT NULL,
 creationTS timestamp NULL,
 PRIMARY KEY(id),
 CONSTRAINT fk165 FOREIGN KEY(activityId) REFERENCES Activity(id),
 CONSTRAINT ix166 UNIQUE (schemaName, name, schemaInstance, activityId, schemaVersion),
 INDEX fk165 (activityId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Store scalar float results from harnessed activities';

CREATE TABLE FilepathResultManual
(id int NOT NULL AUTO_INCREMENT,
 inputPatternId int NOT NULL,
 name varchar(255) NULL COMMENT "deprecated",
 value varchar(255) COMMENT "absolute path at creating site",
 virtualPath  varchar(255) COMMENT "virtual path from Data Catalog",
 catalogKey int COMMENT "key from Data Catalog",
 size  int DEFAULT "0",
 sha1  char(40) NULL COMMENT "currently not required for manually-entered files",
 activityId int NOT NULL COMMENT "activity producing this result",
 createdBy varchar(50) NOT NULL,
 creationTS timestamp NULL,
 PRIMARY KEY(id),
 CONSTRAINT fk170 FOREIGN KEY(inputPatternId) REFERENCES InputPattern(id),
 CONSTRAINT fk171 FOREIGN KEY(activityId) REFERENCES Activity(id),
 INDEX ix172 (activityId, inputPatternId),
 INDEX fk160 (inputPatternId),
 INDEX fk161 (activityId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Store filepath results from manual activities';

CREATE TABLE FilepathResultHarnessed
(id int NOT NULL AUTO_INCREMENT,
 name varchar(255) COMMENT "comes from schema; it is always 'path'",
 value  varchar(255) COMMENT "absolute file path at creating site",
 basename varchar(255) COMMENT "extracted from full filepath stored in value",
 virtualPath  varchar(255) COMMENT "virtual path from Data Catalog",
 catalogKey int COMMENT "key from Data Catalog",
 datatype varchar(255) COMMENT "datatype used to register in Data Catalog",
 size   int DEFAULT "0" COMMENT "another field in fileref schema",
 sha1   char(40) NOT NULL COMMENT "still another field in fileref",
 schemaName varchar(255) NOT NULL,
 schemaVersion varchar(50) NOT NULL,
 schemaInstance int DEFAULT "0" COMMENT "Same schema may be used more than once in a result summary",
 activityId int NOT NULL COMMENT "activity producing this result",
 createdBy varchar(50) NOT NULL,
 creationTS timestamp NULL,
 PRIMARY KEY(id),
 CONSTRAINT fk175 FOREIGN KEY(activityId) REFERENCES Activity(id),
 CONSTRAINT ix176 UNIQUE (activityId, name, schemaName, schemaVersion, schemaInstance),
 INDEX fk175 (activityId),
 INDEX ix177 (datatype),
 INDEX ix178 (basename)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Store filepath results from harnessed activities';

CREATE TABLE StringResultManual
(id int NOT NULL AUTO_INCREMENT,
 inputPatternId int NOT NULL,
 name varchar(255) NULL COMMENT "deprecated",
 value varchar(255),
 activityId int NOT NULL COMMENT "activity producing this result",
 createdBy varchar(50) NOT NULL,
 creationTS timestamp NULL,
 PRIMARY KEY(id),
 CONSTRAINT fk180 FOREIGN KEY(inputPatternId) REFERENCES InputPattern(id),
 CONSTRAINT fk181 FOREIGN KEY(activityId) REFERENCES Activity(id),
 INDEX ix182 (activityId, inputPatternId),
 INDEX fk180 (inputPatternId),
 INDEX fk181 (activityId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Store arbitrary non-filepath string results from manual activities';

CREATE TABLE StringResultHarnessed
(id int NOT NULL AUTO_INCREMENT,
 name varchar(255) COMMENT "comes from schema",
 value  varchar(255),
 schemaName varchar(255) NOT NULL,
 schemaVersion varchar(50) NOT NULL,
 schemaInstance int DEFAULT "0" COMMENT "Same schema may be used more than once in a result summary",
 activityId int NOT NULL COMMENT "activity producing this result",
 createdBy varchar(50) NOT NULL,
 creationTS timestamp NULL,
 PRIMARY KEY(id),
 CONSTRAINT fk185 FOREIGN KEY(activityId) REFERENCES Activity(id),
 CONSTRAINT ix186 UNIQUE (schemaName, name, schemaInstance, activityId, schemaVersion),
 INDEX fk185 (activityId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Store arbitary non-filepath string results from activities';

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
 INDEX ix382 (activityId, inputPatternId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Store arbitrary long non-filepath string results from manual activities';

CREATE TABLE TravelerType
( id int NOT NULL AUTO_INCREMENT,
  rootProcessId int NOT NULL,
  state ENUM('NEW', 'ACTIVE', 'DEACTIVATED', 'SUPERSEDED') NULL,
  standaloneNCR tinyint NOT NULL default '0',
  owner varchar(50) COMMENT 'responsible party',
  reason text COMMENT 'purpose of traveler or of this version',
  subsystemId int NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY(id),
  CONSTRAINT  fk192 FOREIGN KEY(rootProcessId) REFERENCES Process(id),
  UNIQUE INDEX fk192 (rootProcessId),
  CONSTRAINT fk193 FOREIGN KEY(subsystemId) REFERENCES Subsystem(id),
  INDEX ix193 (subsystemId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='List of traveler types';

CREATE TABLE StopWorkHistory
( id  int NOT NULL AUTO_INCREMENT,
  activityId int NOT NULL COMMENT "current activity being stopped or resumed",
  rootActivityId int NOT NULL COMMENT "root activity of this traveler instance",
  reason varchar(1024) NOT NULL COMMENT "why stop work is necessary",
  closingComment varchar(1024) NULL COMMENT "explain chosen resolution of stop work",
  approvalGroup  int NOT NULL COMMENT "bitmask using PermissionGroup.maskBit",
  creationTS timestamp NULL COMMENT "when stop work occurred",
  createdBy varchar(50) NOT NULL,
  resolution ENUM('NONE', 'RESUMED', 'QUIT') DEFAULT 'NONE',
  resolutionTS timestamp NULL COMMENT "when activity was resumed or killed",
  resolvedBy varchar(50) NULL,  
  PRIMARY KEY(id),
  CONSTRAINT fk195 FOREIGN KEY(activityId) REFERENCES Activity(id),
  CONSTRAINT fk196 FOREIGN KEY(rootActivityId) REFERENCES Activity(id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='an entry for each STOP WORK event';

CREATE TABLE Exception
( id int NOT NULL AUTO_INCREMENT,
  exceptionTypeId int NOT NULL COMMENT "ref. to exception definition",
  exitActivityId int NOT NULL COMMENT "normal activity in which exception occurs",
  NCRActivityId int NOT NULL COMMENT "first activity in NCR procedure",
  returnActivityId int NULL COMMENT "first normal activity after NCR",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY(id),
  CONSTRAINT fk220 FOREIGN KEY(exceptionTypeId) REFERENCES ExceptionType(id),
  CONSTRAINT fk221 FOREIGN KEY(exitActivityId) REFERENCES Activity(id),
  CONSTRAINT fk222 FOREIGN KEY(NCRActivityId) REFERENCES Activity(id),
  CONSTRAINT fk223 FOREIGN KEY(returnActivityId) REFERENCES Activity(id),
  INDEX fk220 (exceptionTypeId),
  INDEX fk221 (exitActivityId),
  INDEX fk222 (NCRActivityId),
  INDEX fk223 (returnActivityId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='describes exception instance';

CREATE TABLE ActivityStatusHistory
(id  int NOT NULL AUTO_INCREMENT,
  activityStatusId int NOT NULL COMMENT "fk for the new status",
  activityId int NOT NULL COMMENT "activity whose status is being updated",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY(id),
  CONSTRAINT fk230 FOREIGN KEY(activityStatusId) REFERENCES ActivityFinalStatus(id),
  CONSTRAINT fk231 FOREIGN KEY(ActivityId) REFERENCES Activity(id),
  INDEX fk230 (activityStatusId),
  INDEX fk231 (activityId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Keep track of all activity status updates';

CREATE TABLE MultiRelationshipHistory
( id int NOT NULL AUTO_INCREMENT,
  multiRelationshipSlotId int NOT NULL,
  minorId int NOT NULL COMMENT 'batch from which 1 or nBatchedItems come or regular tracked hardware instance',
  multiRelationshipActionId int NOT NULL,
  activityId int  NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk310 FOREIGN KEY (multiRelationshipSlotId) REFERENCES MultiRelationshipSlot(id),
  CONSTRAINT fk311 FOREIGN KEY (multiRelationshipActionId) REFERENCES MultiRelationshipAction(id),
  CONSTRAINT fk312 FOREIGN KEY (activityId) REFERENCES Activity(id),
  CONSTRAINT fk313 FOREIGN KEY (minorId) REFERENCES Hardware(id),
  INDEX ix310 (multiRelationshipSlotId),
  INDEX ix311 (multiRelationshipActionId),
  INDEX ix312 (activityId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE ProcessRelationshipTag
( id int NOT NULL AUTO_INCREMENT,
  processId int NOT NULL,
  multiRelationshipTypeId int NOT NULL,
  multiRelationshipActionId int NOT NULL,
  multiRelationshipSlotTypeId int NULL,
  slotForm enum('ALL', 'SPECIFIED', 'QUERY') DEFAULT 'ALL',
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk320 FOREIGN KEY (processId) REFERENCES Process(id),
  CONSTRAINT fk321 FOREIGN KEY (multiRelationshipTypeId) REFERENCES MultiRelationshipType(id),
  CONSTRAINT fk322 FOREIGN KEY (multiRelationshipActionId) REFERENCES MultiRelationshipAction(id),
  CONSTRAINT fk323 FOREIGN KEY (multiRelationshipSlotTypeId) REFERENCES MultiRelationshipSlotType(id),
  INDEX ix320 (processId),
  INDEX ix321 (multiRelationshipTypeId),
  INDEX ix322 (multiRelationshipActionId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE BatchedInventoryHistory 
( id int NOT NULL AUTO_INCREMENT,
  hardwareId int NOT NULL COMMENT 'batch being adjusted',
  sourceBatchId int NULL COMMENT 'batch items came from, if any',
  adjustment int NOT NULL COMMENT '# of items used, discarded, or returned. Negative for used, discarded; positive for returned, initialized',
  reason varchar(255) default "" COMMENT "e.g. initialized, used, discarded..",
  activityId int NULL COMMENT 'activity (if any) associated with change',
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk270 FOREIGN KEY (hardwareId) REFERENCES Hardware(id),
  CONSTRAINT fk271 FOREIGN KEY (activityId) REFERENCES Activity(id),
  CONSTRAINT fk272 FOREIGN KEY (sourceBatchId) REFERENCES Hardware(id),
  INDEX ix270 (hardwareId),
  INDEX ix271 (activityId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='track use of batched items';

CREATE TABLE HardwareStatusHistory
(id  int NOT NULL AUTO_INCREMENT,
  hardwareStatusId int NOT NULL COMMENT "fk for the new status",
  hardwareId int NOT NULL COMMENT "component whose status is being updated",
  activityId int NULL,
  reason varchar(1024) NOT NULL default "" COMMENT "why change was made",
  adding tinyint default 1 NOT NULL COMMENT "set to 0 for removal of label. Regular status cannot be explicitly removed",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY(id),
  CONSTRAINT fk200 FOREIGN KEY(hardwareStatusId) REFERENCES HardwareStatus(id),
  CONSTRAINT fk201 FOREIGN KEY(hardwareId) REFERENCES Hardware(id),
  CONSTRAINT fk202 FOREIGN KEY(activityId) REFERENCES Activity(id),
  INDEX fk200 (hardwareStatusId),
  INDEX fk201 (hardwareId),
  INDEX ix202 (activityId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Keep track of all hardware status updates';

CREATE TABLE HardwareLocationHistory
(id  int NOT NULL AUTO_INCREMENT,
  locationId int NOT NULL COMMENT "fk for the new location",
  hardwareId int NOT NULL COMMENT "component whose location is being updated",
  activityId int NULL,
  reason varchar(1024) NOT NULL DEFAULT '',
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY(id),
  CONSTRAINT fk210 FOREIGN KEY(locationId) REFERENCES Location(id),
  CONSTRAINT fk211 FOREIGN KEY(hardwareId) REFERENCES Hardware(id),
  CONSTRAINT fk212 FOREIGN KEY(activityId) REFERENCES Activity(id),
  INDEX fk210 (locationId),
  INDEX fk211 (hardwareId),
  INDEX ix212 (activityId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Keep track of all hardware location updates';


CREATE TABLE HardwareTypeGroupMapping
( id int NOT NULL AUTO_INCREMENT,
  hardwareTypeId int NOT NULL,
  hardwareGroupId int NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk240 FOREIGN KEY (hardwareTypeId) REFERENCES HardwareType (id), 
  CONSTRAINT fk241 FOREIGN KEY (hardwareGroupId) REFERENCES HardwareGroup (id),
  CONSTRAINT cui20 UNIQUE(hardwareTypeId, hardwareGroupId)
) ENGINE =InnoDB DEFAULT CHARSET=latin1
COMMENT='Many-to-many mapping of hardware types, groups';

CREATE TABLE TravelerTypeState
( id int NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT ix36 UNIQUE (name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Possible states for process traveler type';

CREATE TABLE TravelerTypeStateHistory
( id int NOT NULL AUTO_INCREMENT,
  reason varchar(255) COMMENT "why the state change",
  travelerTypeId int NOT NULL,
  travelerTypeStateId int NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY(id),
  CONSTRAINT  fk250 FOREIGN KEY(travelerTypeId) REFERENCES TravelerType(id),
  CONSTRAINT  fk251 FOREIGN KEY(travelerTypeStateId) REFERENCES TravelerTypeState(id),
  INDEX ix250 (travelerTypeId),
  INDEX ix251 (travelerTypeStateId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Keep track of all traveler type state updates';

CREATE TABLE SignatureResultManual
(id int NOT NULL AUTO_INCREMENT,
 activityId int NOT NULL,
 inputPatternId int NOT NULL,
 signerRequest varchar(255) NOT NULL,
 signerValue   varchar(255),
 signerComment text NOT NULL DEFAULT '',
 signatureTS   timestamp NULL,
 createdBy     varchar(50) NOT NULL,
 creationTS    timestamp NULL,
 PRIMARY KEY (id),
 CONSTRAINT fk360 FOREIGN KEY(activityId) REFERENCES Activity(id),
 CONSTRAINT fk361 FOREIGN KEY(inputPatternId) REFERENCES InputPattern(id),
 CONSTRAINT ix360 UNIQUE (activityId, signerRequest)
 ) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='an entry for each signature at execution time';

-- Create a table associating a root activity id with a run number
CREATE TABLE RunNumber
( id int NOT NULL AUTO_INCREMENT,
  runNumber varchar(15) COMMENT "Digits optionally followed by 1 alpha char",
  runInt int NOT NULL DEFAULT '0' COMMENT "runNumber without alpha characters",
  rootActivityId int NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  CONSTRAINT fk370 FOREIGN KEY(rootActivityId) REFERENCES Activity(id),
  PRIMARY KEY(id),
  INDEX ix371 (runNumber),
  UNIQUE INDEX ix372 (rootActivityId),
  INDEX ix373 (runInt)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Associate run number with traveler execution';

-- Final table needed for generic labels
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
  CONSTRAINT fk421 FOREIGN KEY (labelableId) REFERENCES Labelable(id),
  INDEX ix422 (objectId, labelableId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
