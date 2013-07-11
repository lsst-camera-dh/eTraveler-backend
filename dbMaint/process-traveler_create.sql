source process-traveler_drop.sql

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

CREATE TABLE IF NOT EXISTS SiteInfo
( id int NOT NULL AUTO_INCREMENT,
  siteName varchar(20) NOT NULL,
  jhVirtualEnv varchar(200) NULL COMMENT "path to root of virtual env for job harmenss",
  jhOutputRoot  varchar(200) NULL COMMENT "path to root of job harness output directory, corresponds to environment variable LCATR_ROOT",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT UNIQUE (siteName)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Keep site-specific information here';
  
# May need to add additional table for subsystem (name, id and boilerplate)
# and add column to HardwareType: fk to subsystem
# Maybe do something similar for "component type"  ("part" or "assembly")
# or, if there are just those two, add flag column.
CREATE TABLE HardwareType 
( id int NOT NULL AUTO_INCREMENT, 
  name varchar(50) NOT NULL COMMENT "common name; defaults to drawing", 
  drawing varchar(60) NOT NULL COMMENT "drawing id without revision",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT ix1 UNIQUE (drawing) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE HardwareStatus
( id int NOT NULL AUTO_INCREMENT,
  name varchar(50) NOT NULL,
  description varchar(200) NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT ix2 UNIQUE (name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='just registered, ready for assembly, rejected, etc.';

CREATE TABLE Hardware 
( id int NOT NULL AUTO_INCREMENT, 
  lsstId varchar(50) NOT NULL,
  hardwareTypeId int NOT NULL, 
  manufacturer varchar(50) NOT NULL,
  model varchar(50) NULL,
  manufactureDate timestamp NULL,
  hardwareStatusId int NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk1 FOREIGN KEY (hardwareTypeId) REFERENCES HardwareType (id), 
  CONSTRAINT fk2 FOREIGN KEY (hardwareStatusId) REFERENCES HardwareStatus (id), 
  CONSTRAINT ix3 UNIQUE INDEX (hardwareTypeId, lsstId),
  INDEX fk1 (hardwareTypeId),
  INDEX fk2 (hardwareStatusId) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Create a row here to register new component';

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

CREATE TABLE Process 
( id int NOT NULL AUTO_INCREMENT, 
  name varchar(50) NOT NULL, 
  hardwareTypeId int NOT NULL, 
  hardwareRelationshipTypeId int NULL, 
  version int NOT NULL, 
  userVersionString varchar(64) NULL COMMENT 'e.g. git tag',
  description text, instructionsURL varchar(256), 
  substeps  ENUM('NONE', 'SEQUENCE', 'SELECTION') default 'NONE'
   COMMENT 'determines where we go next',
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk40 FOREIGN KEY (hardwareTypeId) REFERENCES HardwareType (id), 
  CONSTRAINT fk41 FOREIGN KEY (hardwareRelationshipTypeId) REFERENCES HardwareRelationshipType (id), 
  INDEX fk40 (hardwareTypeId),
  INDEX fk41 (hardwareRelationshipTypeId),
  CONSTRAINT ix42 UNIQUE INDEX (name, hardwareTypeId, version),
  CONSTRAINT ix43 UNIQUE INDEX (name, hardwareTypeId, userVersionString)
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

CREATE TABLE Activity 
( id int NOT NULL AUTO_INCREMENT, 
  hardwareId int NOT NULL COMMENT "hardware in whose behalf activity occurred", 
  hardwareRelationshipId int NULL COMMENT "relationship pertinent to activity, if any", 
  processId int NOT NULL, 
  processEdgeId int NULL
   COMMENT "edge used to get to process; NULL for root",
  parentActivityId int NULL,
  jobHarnessStepId int NULL COMMENT "last completed step for job harness activities; null otherwise",
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
  CONSTRAINT fk75 FOREIGN KEY (JobHarnessStepId) REFERENCES JobHarnessStep (id), 
  INDEX fk70 (hardwareId),
  INDEX fk71 (hardwareRelationshipId),
  INDEX fk72 (processId), 
  INDEX fk73 (processEdgeId),
  INDEX fk74 (parentActivityId),
  INDEX fk75 (jobHarnessStepId),
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
  quantity int DEFAULT 1,
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
