source process-traveler_drop.sql
## last fk:  210s
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

##CREATE TABLE IF NOT EXISTS Site
CREATE TABLE Site
( id int NOT NULL AUTO_INCREMENT,
  name varchar(20) NOT NULL,
  jhVirtualEnv varchar(200) NULL COMMENT "path to root of virtual env for job harmenss",
  jhOutputRoot  varchar(200) NULL COMMENT "path to root of job harness output directory, corresponds to environment variable LCATR_ROOT",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT UNIQUE (name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Keep site-specific information here';

#CREATE TABLE IF NOT EXISTS Location
CREATE TABLE Location
( id int NOT NULL AUTO_INCREMENT,
  name varchar(20) NOT NULL,
  siteId int NOT NULL COMMENT "responsible site, even if, e.g., in transit",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk190 FOREIGN KEY(siteId) REFERENCES Site(id),
  CONSTRAINT ix191 UNIQUE (siteId, name),
  INDEX fk190 (siteId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Identifies teststand, assembly station, etc.';
  
# May need to add additional table for subsystem (name, id and boilerplate)
# and add column to HardwareType: fk to subsystem
# Maybe do something similar for "component type"  ("part" or "assembly")
# or, if there are just those two, add flag column.
CREATE TABLE HardwareType 
( id int NOT NULL AUTO_INCREMENT, 
  name varchar(50) NOT NULL COMMENT "common name; same as drawing if drawing non-null", 
  drawing varchar(60) NULL COMMENT "drawing id without revision",
  autoSequenceWidth int DEFAULT 0 COMMENT "width of zero-filled sequence #",
  autoSequence int DEFAULT 0 COMMENT "used when autoSequenceWidth > 0",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT ix1 UNIQUE (drawing),
  CONSTRAINT ix2 UNIQUE (name) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE HardwareStatus
( id int NOT NULL AUTO_INCREMENT,
  name varchar(50) NOT NULL,
  description varchar(200) NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT ix3 UNIQUE (name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='just registered, ready for assembly, rejected, etc.';

CREATE TABLE Hardware 
( id int NOT NULL AUTO_INCREMENT, 
  lsstId varchar(50) NOT NULL,
  hardwareTypeId int NOT NULL, 
  manufacturer varchar(50) NOT NULL,
  model varchar(50) NULL,
  manufactureDate timestamp NULL,
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

CREATE TABLE HardwareStatusHistory
(id  int NOT NULL AUTO_INCREMENT,
  hardwareStatusId int NOT NULL COMMENT "fk for the new status",
  hardwareId int NOT NULL COMMENT "component whose status is being updated",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY(id),
  CONSTRAINT fk200 FOREIGN KEY(hardwareStatusId) REFERENCES HardwareStatus(id),
  CONSTRAINT fk201 FOREIGN KEY(hardwareId) REFERENCES Hardware(id),
  INDEX fk200 (hardwareStatusId),
  INDEX fk201 (hardwareId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Keep track of all hardware status updates';

CREATE TABLE HardwareLocationHistory
(id  int NOT NULL AUTO_INCREMENT,
  locationId int NOT NULL COMMENT "fk for the new location",
  hardwareId int NOT NULL COMMENT "component whose location is being updated",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY(id),
  CONSTRAINT fk210 FOREIGN KEY(locationId) REFERENCES Location(id),
  CONSTRAINT fk211 FOREIGN KEY(hardwareId) REFERENCES Hardware(id),
  INDEX fk200 (locationId),
  INDEX fk201 (hardwareId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Keep track of all hardware location updates';

CREATE TABLE HardwareIdentifierAuthority 
( id int NOT NULL AUTO_INCREMENT, 
  name varchar(100) NOT NULL, 
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
  identifier varchar(100) NOT NULL,
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

CREATE TABLE HardwareRelationshipType 
( id int NOT NULL AUTO_INCREMENT, 
  name varchar(50) NOT NULL,
  hardwareTypeId int NOT NULL,
  componentTypeId int NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  constraint fk8 FOREIGN KEY (hardwareTypeId) REFERENCES HardwareType(id),
  constraint fk9 FOREIGN KEY (componentTypeId) REFERENCES HardwareType(id),
  INDEX fk8 (hardwareTypeId),
  INDEX fk9 (componentTypeId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='describes relationship between two hardware types, one subsidiary to the other';


CREATE TABLE HardwareRelationship 
( id int NOT NULL AUTO_INCREMENT, 
  hardwareId int NOT NULL, 
  componentId int NOT NULL, 
  begin timestamp NULL, 
  end timestamp NULL, 
  hardwareRelationshipTypeId int NOT NULL, 
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk10 FOREIGN KEY (hardwareId) REFERENCES Hardware (id) , 
  CONSTRAINT fk11 FOREIGN KEY (componentId) REFERENCES Hardware (id) , 
  CONSTRAINT fk12 FOREIGN KEY (hardwareRelationshipTypeId) REFERENCES HardwareRelationshipType (id), 
  INDEX fk10 (hardwareId), 
  INDEX fk11 (componentId), 
  INDEX fk12 (hardwareRelationshipTypeId),
  INDEX ix10 (begin),
  INDEX ix11 (end),
  INDEX ix12 (creationTS)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Instance of HardwareRelationshipType between actual pieces of hardware';
CREATE TABLE InternalAction
( id int NOT NULL AUTO_INCREMENT,
  name varchar(50) NOT NULL,
  maskBit int unsigned NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  UNIQUE INDEX (maskBit),
  UNIQUE INDEX (name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Identify special actions eTraveler may have to perform assoc. with process';

CREATE TABLE Process 
( id int NOT NULL AUTO_INCREMENT, 
  originalId int NULL COMMENT "set equal to id of 1st version of this Process",
  name varchar(50) NOT NULL, 
  hardwareTypeId int NOT NULL, 
  hardwareRelationshipTypeId int NULL, 
  version int NOT NULL, 
  userVersionString varchar(64) NULL COMMENT 'e.g. git tag',
  description text, instructionsURL varchar(256), 
  substeps  ENUM('NONE', 'SEQUENCE', 'SELECTION') default 'NONE'
   COMMENT 'determines where we go next',
  maxIteration tinyint unsigned DEFAULT 1,
  travelerActionMask int unsigned DEFAULT 0,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk40 FOREIGN KEY (hardwareTypeId) REFERENCES HardwareType (id), 
  CONSTRAINT fk41 FOREIGN KEY (hardwareRelationshipTypeId) REFERENCES HardwareRelationshipType (id), 
  INDEX fk40 (hardwareTypeId),
  INDEX fk41 (hardwareRelationshipTypeId),
  CONSTRAINT ix42 UNIQUE INDEX (name, hardwareTypeId, version),
  CONSTRAINT ix43 UNIQUE INDEX (name, hardwareTypeId, userVersionString),
  CONSTRAINT ix44 UNIQUE INDEX (originalId, version),
  CONSTRAINT ix45 UNIQUE INDEX (originalId, userVersionString)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Describes procedure for a step within a traveler';

CREATE TABLE ProcessEdge 
( id int NOT NULL AUTO_INCREMENT, parent int NOT NULL, 
  child int NOT NULL, step int NOT NULL, 
  cond varchar(256) 
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

CREATE TABLE NCRcondition
( id int NOT NULL AUTO_INCREMENT, 
  conditionString varchar(80) NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT ix30 UNIQUE (conditionString) 
)  ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Describe condition under which one branches to NCR';

CREATE TABLE Exception
( id int NOT NULL AUTO_INCREMENT, 
  exitProcessId int NOT NULL, 
  returnProcessId int NOT NULL,
  NCRProcessId int NOT NULL,  
  conditionId int NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk80 FOREIGN KEY (exitProcessId) REFERENCES Process (id),  
  CONSTRAINT fk81 FOREIGN KEY (returnProcessId) REFERENCES Process (id),  
  CONSTRAINT fk82 FOREIGN KEY (NCRProcessId) REFERENCES Process (id),
  CONSTRAINT fk83 FOREIGN KEY (conditionId) REFERENCES NCRcondition (id),
  INDEX fk80 (exitProcessId), INDEX fk81 (returnProcessId),
  INDEX fk82 (NCRProcessId) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE JobHarnessStep
( id int NOT NULL AUTO_INCREMENT,
  name varchar(32) NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT ix35 UNIQUE (name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Steps within for job harness job';

CREATE TABLE ActivityFinalStatus
( id int NOT NULL AUTO_INCREMENT,
  name varchar(32) NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT ix36 UNIQUE (name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Final status';


CREATE TABLE Activity 
( id int NOT NULL AUTO_INCREMENT, 
  hardwareId int NOT NULL COMMENT "hardware in whose behalf activity occurred", 
  hardwareRelationshipId int NULL COMMENT "relationship pertinent to activity, if any", 
  processId int NOT NULL, 
  processEdgeId int NULL
   COMMENT "edge used to get to process; NULL for root",
  parentActivityId int NULL,
  activityFinalStatusId int NULL COMMENT "Set only when activity is closed out",
  iteration tinyint unsigned DEFAULT 1 COMMENT "Set to non-default for rework",
  begin timestamp NULL, 
  end timestamp NULL, 
  inNCR ENUM ('TRUE', 'FALSE')  default 'FALSE',
  createdBy varchar(50) NOT NULL,
  closedBy varchar(50) NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk70 FOREIGN KEY (hardwareId) REFERENCES Hardware (id), 
  CONSTRAINT fk71 FOREIGN KEY (hardwareRelationshipId) REFERENCES HardwareRelationship (id), 
  CONSTRAINT fk72 FOREIGN KEY (processId) REFERENCES Process (id) , 
  CONSTRAINT fk73 FOREIGN KEY (processEdgeId) REFERENCES ProcessEdge (id), 
  CONSTRAINT fk74 FOREIGN KEY (parentActivityId) REFERENCES Activity (id), 
  CONSTRAINT fk75 FOREIGN KEY (activityFinalStatusId) REFERENCES ActivityFinalStatus (id), 
  INDEX fk70 (hardwareId),
  INDEX fk71 (hardwareRelationshipId),
  INDEX fk72 (processId), 
  INDEX fk73 (processEdgeId),
  INDEX fk74 (parentActivityId),
  INDEX fk75 (activityFinalStatusId),
  INDEX ix70 (begin),
  INDEX ix71 (end),
  INDEX ix72 (parentActivityId, processEdgeId)
)   ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Instance of process step executed on a particular component';

CREATE TABLE Result 
( id int NOT NULL AUTO_INCREMENT, 
  activityId int NOT NULL, 
  status int NOT NULL, 
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk90 FOREIGN KEY (activityId) REFERENCES Activity (id), 
  INDEX fk90 (activityId) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


CREATE TABLE PrerequisiteType
( id int NOT NULL AUTO_INCREMENT,
  name varchar(50) COMMENT "e.g. PROCESS_STEP, COMPONENT, CONSUMABLE, etc.",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT ix99 UNIQUE INDEX (name)
) ENGINE=InooDB DEFAULT CHARSET=latin1;

CREATE TABLE PrerequisitePattern
( id int NOT NULL AUTO_INCREMENT,
  name varchar(50)  NOT NULL,
  description text COMMENT "describe in detail",
  prerequisiteTypeId int NOT NULL COMMENT "prerequisiteType determines which field below, if any, is non-null",
  processId int NOT NULL COMMENT "process step for which this is a prereq",
  prereqProcessId  int NULL COMMENT "Non-null if prereq is another proc. step",
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
  name varchar(32) NOT NULL,
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
  label   varchar(50) NOT NULL COMMENT "required label to appear on form", 
  units  varchar(5) DEFAULT "none",
  description varchar(256) NULL COMMENT "if label is not sufficient",
  minV float  NULL COMMENT "allowed minimum (optional)",  
  maxV float  NULL COMMENT "allowed maximum (optional)",  
  choiceField varchar(50) NULL COMMENT "may be set to table.field, e.g. HardwareStatus.name",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY(id),
  CONSTRAINT fk130 FOREIGN KEY(processId) REFERENCES Process(id),
  CONSTRAINT fk131 FOREIGN KEY(inputSemanticsId) REFERENCES InputSemantics(id),
  CONSTRAINT ix132 UNIQUE (processId, label),
  INDEX fk130 (processId),
  INDEX fk131 (inputSemanticsId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Describes required operator input assoc. with particular process step';

CREATE TABLE JobStepHistory
(id  int NOT NULL AUTO_INCREMENT,
  jobHarnessStepId int NOT NULL COMMENT "fk for the new status",
  activityId int NOT NULL COMMENT "activity whose status is being updated",
  errorString varchar(120) NULL,
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
 name varchar(50) COMMENT " use label field from inputPatternId",
 value  int,
 activityId int NOT NULL COMMENT "activity producing this result",
 createdBy varchar(50) NOT NULL,
 creationTS timestamp NULL,
 PRIMARY KEY(id),
 CONSTRAINT fk150 FOREIGN KEY(inputPatternId) REFERENCES InputPattern(id),
 CONSTRAINT fk151 FOREIGN KEY(activityId) REFERENCES Activity(id),
 CONSTRAINT ix152 UNIQUE (activityId, name),
 INDEX fk150 (inputPatternId),
 INDEX fk151 (activityId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Store scalar int results from manual activities';

CREATE TABLE IntResultHarnessed
(id int NOT NULL AUTO_INCREMENT,
 name varchar(50) COMMENT "comes from schema",
 value  int,
 schemaName varchar(50) NOT NULL,
 schemaVersion varchar(50) NOT NULL,
 schemaInstance int DEFAULT "0" COMMENT "Same schema may be used more than once in a result sumamry",
 activityId int NOT NULL COMMENT "activity producing this result",
 createdBy varchar(50) NOT NULL,
 creationTS timestamp NULL,
 PRIMARY KEY(id),
 CONSTRAINT fk155 FOREIGN KEY(activityId) REFERENCES Activity(id),
 CONSTRAINT ix156 UNIQUE (activityId, name, schemaName, schemaVersion, schemaInstance),
 INDEX fk155 (activityId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Store scalar int results from harnessed activities';

CREATE TABLE FloatResultManual
(id int NOT NULL AUTO_INCREMENT,
 inputPatternId int NOT NULL,
 name varchar(50) COMMENT "use label field from inputPatternId",
 value  float,
 activityId int NOT NULL COMMENT "activity producing this result",
 createdBy varchar(50) NOT NULL,
 creationTS timestamp NULL,
 PRIMARY KEY(id),
 CONSTRAINT fk160 FOREIGN KEY(inputPatternId) REFERENCES InputPattern(id),
 CONSTRAINT fk161 FOREIGN KEY(activityId) REFERENCES Activity(id),
 CONSTRAINT ix162 UNIQUE (activityId, name),
 INDEX fk160 (inputPatternId),
 INDEX fk161 (activityId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Store scalar float results from manual activities';

CREATE TABLE FloatResultHarnessed
(id int NOT NULL AUTO_INCREMENT,
 name varchar(50) COMMENT "comes from schema",
 value  float,
 schemaName varchar(50) NOT NULL,
 schemaVersion varchar(50) NOT NULL,
 schemaInstance int DEFAULT "0" COMMENT "Same schema may be used more than once in a result sumamry",
 activityId int NOT NULL COMMENT "activity producing this result",
 createdBy varchar(50) NOT NULL,
 creationTS timestamp NULL,
 PRIMARY KEY(id),
 CONSTRAINT fk165 FOREIGN KEY(activityId) REFERENCES Activity(id),
 CONSTRAINT ix166 UNIQUE (activityId, name, schemaName, schemaVersion, schemaInstance),
 INDEX fk165 (activityId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Store scalar float results from harnessed activities';

CREATE TABLE FilepathResultManual
(id int NOT NULL AUTO_INCREMENT,
 inputPatternId int NOT NULL,
 name varchar(50) COMMENT "use label field from inputPattern",
 value varchar(255) COMMENT "absolute path at creating site",
 virtualPath  varchar(255) COMMENT "virtual path from Data Catalog",
 size  int DEFAULT "0",
 sha1  char(40) NULL COMMENT "currently not required for manually-entered files",
 activityId int NOT NULL COMMENT "activity producing this result",
 createdBy varchar(50) NOT NULL,
 creationTS timestamp NULL,
 PRIMARY KEY(id),
 CONSTRAINT fk170 FOREIGN KEY(inputPatternId) REFERENCES InputPattern(id),
 CONSTRAINT fk171 FOREIGN KEY(activityId) REFERENCES Activity(id),
 CONSTRAINT ix172 UNIQUE (activityId, name),
 INDEX fk160 (inputPatternId),
 INDEX fk161 (activityId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Store filepath results from manual activities';

CREATE TABLE FilepathResultHarnessed
(id int NOT NULL AUTO_INCREMENT,
 name varchar(50) COMMENT "comes from schema; it is always 'path'",
 value  varchar(255) COMMENT "absolute file path at creating site",
 virtualPath  varchar(255) COMMENT "virtual path from Data Catalog",
 size   int DEFAULT "0" COMMENT "another field in fileref schema",
 sha1   char(40) NOT NULL COMMENT "still another field in fileref",
 schemaName varchar(50) NOT NULL,
 schemaVersion varchar(50) NOT NULL,
 schemaInstance int DEFAULT "0" COMMENT "Same schema may be used more than once in a result sumamry",
 activityId int NOT NULL COMMENT "activity producing this result",
 createdBy varchar(50) NOT NULL,
 creationTS timestamp NULL,
 PRIMARY KEY(id),
 CONSTRAINT fk175 FOREIGN KEY(activityId) REFERENCES Activity(id),
 CONSTRAINT ix176 UNIQUE (activityId, name, schemaName, schemaVersion, schemaInstance),
 INDEX fk175 (activityId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Store filepath results from harnessed activities';

CREATE TABLE StringResultManual
(id int NOT NULL AUTO_INCREMENT,
 inputPatternId int NOT NULL,
 name varchar(50) COMMENT "use label field from inputPattern",
 value varchar(255),
 activityId int NOT NULL COMMENT "activity producing this result",
 createdBy varchar(50) NOT NULL,
 creationTS timestamp NULL,
 PRIMARY KEY(id),
 CONSTRAINT fk180 FOREIGN KEY(inputPatternId) REFERENCES InputPattern(id),
 CONSTRAINT fk181 FOREIGN KEY(activityId) REFERENCES Activity(id),
 CONSTRAINT ix182 UNIQUE (activityId, name),
 INDEX fk180 (inputPatternId),
 INDEX fk181 (activityId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Store arbitrary non-filepath string results from manual activities';

CREATE TABLE StringResultHarnessed
(id int NOT NULL AUTO_INCREMENT,
 name varchar(50) COMMENT "comes from schema",
 value  varchar(255),
 schemaName varchar(50) NOT NULL,
 schemaVersion varchar(50) NOT NULL,
 schemaInstance int DEFAULT "0" COMMENT "Same schema may be used more than once in a result sumamry",
 activityId int NOT NULL COMMENT "activity producing this result",
 createdBy varchar(50) NOT NULL,
 creationTS timestamp NULL,
 PRIMARY KEY(id),
 CONSTRAINT fk185 FOREIGN KEY(activityId) REFERENCES Activity(id),
 CONSTRAINT ix186 UNIQUE (activityId, name, schemaName, schemaVersion, schemaInstance),
 INDEX fk185 (activityId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Store arbitary non-filepath string results from activities';

CREATE TABLE NextProcessVersion
(id int NOT NULL AUTO_INCREMENT,
 name varchar(50) NOT NULL COMMENT 'will match something in Process.name',
 nextVersion int DEFAULT 0,
 createdBy varchar(50) NOT NULL,
 creationTS timestamp NULL,
 PRIMARY KEY (id),
 UNIQUE INDEX(name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Serve up next available version number for NextProcessVersion.name';


