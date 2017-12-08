#  Do some inserts related to infrastructure (e.g. allowed status values)
#  to get us started off
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 1, 0, 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Adding prerequisite tables');
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 2, 0, 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Adding history, result tables');
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 3, 0, 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Adding stop/resume history, traveler type directory tables');
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 4, 0, 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Merge Exception and NCRcondition; rename to ExceptionType. Add new table Exception for exception instances. Beef up TravelerType');
INSERT into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 4, 1, 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'bug fix: add column ExceptionType.returnProcessId');
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 5, 0, 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Add ActivityStatusHistory table; add automatable internal action');
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 5, 1, 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Make TravelerType.rootProcessId unique index');
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 5, 2, 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Eliminate harmful uniqueness constraints in Process; add PrequisitePattern.prereqUserVersionString');
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 5, 3, 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Set most varchar lengths to 255; add HardwareRelationshipType.slot and unique key');
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 5, 4, 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'support set status, location from traveler; add Hardware.manufacturerId ');
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 6, 0, 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'support hw groups');
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 6, 1, 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'add catalogKey to FilepathResult.. tables');
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 6, 2, 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Add InputPattern.datatype; TravelerTypeState and TravelerTypeStateHistory tables; insert into TravelerTypeState, ActivityFinalStatus ');
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 6, 3, 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Upgrades for setting new location in traveler step; addition of JobHarness table');
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 6, 4, 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Add NON-COMPLIANT hardware status; PREPARATION prereq type, tweaks to JobHarness table');
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 6, 5, 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'delete obsolete stuff; add validated trav type state');
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 6, 6, 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'add a couple columns');
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 6, 8, 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Support labels: non-status attributes of hardware components. Also optional operator inputs, new PermissionGroup for QA and approved entry in TravelerTypeState');
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 7, 0, 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Begin to support batched hardware, Process.shortDescription');
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 8, 0, 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Complete support of batched hardware; generalize handling of hardware relationships');
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '9', '0', 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Support for subsystems');
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '10', '0', 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Support for signatures');
INSERT into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '11', '0', 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Support for uninstall batches; clean up obsolete stuff');
INSERT into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '11', '1', 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Increase input description size; minor clean-up of relationship support');
INSERT into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '12', '0', 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Run numbers. Better searching of harnessed job file output');
INSERT into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '12', '1', 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Patch to RunNumber for better searching');
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '13', '0', 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Text result type; single-slot actions');
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '14', '0', 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Add SignatureResultManual.signerComment, add new internal action "repeatable" ');
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '14', '1', 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Change float to double in results tables; clean up');
update DbRelease set status='OLD' where major='0' and minor='14' and patch='1';
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '15', '0', 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Generic label support; add Process.jobname');
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '15', '1', 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Generic label addendum: manipulation from travelers');
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '15', '2', 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Add generic label descriptions, InputPattern.name, FloatResultManual.valueString');
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '15', '3', 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Add final status "closed"; minor clean-up in manual results tables');
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '15', '4', 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Add a couple fields to Process; reinstate ActivityFinalStatusId');
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '15', '5', 'OLD', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Add url semantic type; new table LabelCurrent');
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '15', '6', 'CURRENT', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Support branch by hardware type');

insert into PrerequisiteType set name='PROCESS_STEP', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into PrerequisiteType set name='COMPONENT', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into PrerequisiteType set name='TEST_EQUIPMENT', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into PrerequisiteType set name='CONSUMABLE', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into PrerequisiteType set name='PREPARATION', createdBy='jrb', creationTS=UTC_TIMESTAMP();

insert into HardwareStatus set name='NEW', description='Available for preparation and testing', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into HardwareStatus set name='IN_PROGRESS', description='At least one traveler begun; at least one applicable traveler not complete', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into HardwareStatus set name='REJECTED', description='Beyond hope', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into HardwareStatus set name='READY', description='Testing/preparation complete; ready for integration', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into HardwareStatus set name='USED', description='Fully tested component has been integrated', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into HardwareStatus set name='PENDING', description='Component has irregularities; acceptance under review', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into HardwareStatus (name, isStatusValue, systemEntry, description, createdBy, creationTS) values ("non-compliant", 0, 1, 'mark a part as suspect', 'jrb', UTC_TIMESTAMP());

insert into InputSemantics set name="int", tableName='IntResultManual', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InputSemantics set name="float", tableName='FloatResultManual', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InputSemantics set name="boolean", tableName='IntResultManual', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InputSemantics set name="checkbox", tableName='IntResultManual', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InputSemantics set name="filepath", tableName='FilepathResultManual', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InputSemantics set name="timestamp", tableName='StringResultManual', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InputSemantics set name="string", tableName='StringResultManual', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InputSemantics set name="signature", tableName='SignatureResultManual', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InputSemantics set name="text", tableName='TextResultManual', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InputSemantics set name="url", tableName='StringResultManual', createdBy='jrb', creationTS=UTC_TIMESTAMP();


insert into JobHarnessStep set name="registered", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into JobHarnessStep set name="configured", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into JobHarnessStep set name="staged", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into JobHarnessStep set name="produced", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into JobHarnessStep set name="validated", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into JobHarnessStep set name="archived", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into JobHarnessStep set name="purged", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into JobHarnessStep set name="ingested", createdBy='jrb', creationTS=UTC_TIMESTAMP();

insert into ActivityFinalStatus set name="success", isFinal='1', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into ActivityFinalStatus set name="failure", isFinal='1', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into ActivityFinalStatus set name="superseded", isFinal='1', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into ActivityFinalStatus set name="ncrExit", isFinal='1', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into ActivityFinalStatus set name="stopped", isFinal='0', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into ActivityFinalStatus set name="new", isFinal='0', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into ActivityFinalStatus set name="skipped", isFinal='1', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into ActivityFinalStatus set name="paused", isFinal='0', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into ActivityFinalStatus set name="inProgress", isFinal='0', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into ActivityFinalStatus set name="closed", isFinal='1', createdBy='jrb', creationTS=UTC_TIMESTAMP();

insert into TravelerTypeState set name="new", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into TravelerTypeState set name="active", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into TravelerTypeState set name="deactivated", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into TravelerTypeState set name="superseded", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into TravelerTypeState set name="validated", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into TravelerTypeState set name="approved", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into TravelerTypeState set name="subsystemApproved", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into TravelerTypeState set name="softwareApproved", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into TravelerTypeState set name="subjectApproved", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into TravelerTypeState set name="workflowApproved", createdBy='jrb', creationTS=UTC_TIMESTAMP();

insert into InternalAction set name='harnessedJob', maskBit='1', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InternalAction set name='makeHardwareRelationship', maskBit='2', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InternalAction set name='breakHardwareRelationship', maskBit='4', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InternalAction set name='setHardwareStatus', maskBit='8', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InternalAction set name='setHardwareLocation', maskBit='16', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InternalAction set name='async', maskBit='32', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InternalAction set name='automatable', maskBit='64', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InternalAction (name, maskBit,createdBy, creationTS) values ('removeLabel', '128', 'jrb', UTC_TIMESTAMP());
insert into InternalAction (name, maskBit,createdBy, creationTS) values ('addLabel', '256', 'jrb', UTC_TIMESTAMP());
insert into InternalAction (name, maskBit,createdBy, creationTS) values ('repeatable', '512', 'jrb', UTC_TIMESTAMP());
insert into InternalAction (name, maskBit, createdBy, creationTS) values ('genericLabel', '1024', 'jrb', UTC_TIMESTAMP());


insert into PermissionGroup set name='operator', maskBit='1', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into PermissionGroup set name='supervisor', maskBit='2', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into PermissionGroup set name='approver', maskBit='4', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into PermissionGroup set name='admin', maskBit='8', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into PermissionGroup set name='qualityAssurance', maskBit='16', createdBy='jrb', creationTS=UTC_TIMESTAMP();


insert into MultiRelationshipAction (name, createdBy, creationTS) values ('assign', 'jrb', UTC_TIMESTAMP());
insert into MultiRelationshipAction (name, createdBy, creationTS) values ('install', 'jrb', UTC_TIMESTAMP());
insert into MultiRelationshipAction (name, createdBy, creationTS) values ('uninstall', 'jrb', UTC_TIMESTAMP());
insert into MultiRelationshipAction (name, createdBy, creationTS) values ('deassign', 'jrb', UTC_TIMESTAMP());


insert into Subsystem (name, shortName, description, generic, createdBy, creationTS) values ("Legacy", "Legacy", "Used for traveler types predating Subsystem table", '1', 'jrb', UTC_TIMESTAMP());

insert into Subsystem (name, shortName, description, generic, createdBy, creationTS) values ("Default", "Default", "Used for traveler types not associated with any particular subsystem", '1', 'jrb', UTC_TIMESTAMP());

insert into HardwareGroup(name, description, createdBy, creationTS) values ('Anything', 'Anything', 'jrb', UTC_TIMESTAMP());

-- First enumerate labelable objects
insert into Labelable (name, tableName, createdBy, creationTS) values ('run', 'RunNumber', 'jrb', UTC_TIMESTAMP());
insert into Labelable (name, tableName, createdBy, creationTS) values ('hardware', 'Hardware', 'jrb', UTC_TIMESTAMP());
insert into Labelable (name, tableName, createdBy, creationTS) values ('hardwareType', 'HardwareType', 'jrb', UTC_TIMESTAMP());
insert into Labelable (name, tableName, createdBy, creationTS) values ('NCR', 'Exception', 'jrb', UTC_TIMESTAMP());
insert into Labelable (name, tableName, createdBy, creationTS) values ('travelerType', 'TravelerType', 'jrb', UTC_TIMESTAMP());
insert into Labelable (name, tableName, createdBy, creationTS) values ('label', 'Label', 'jrb', UTC_TIMESTAMP());

-- Create stored procedures to get subsystem, hardware group(s) associated
-- with a label, one of each for each labelable type
source proc/NCR_subsystemProc.sql;
source proc/NCR_hardwareGroupsProc.sql;
source proc/hardwareType_subsystemProc.sql;
source proc/hardwareType_hardwareGroupsProc.sql;
source proc/hardware_subsystemProc.sql;
source proc/hardware_hardwareGroupsProc.sql;
source proc/label_subsystemProc.sql;
source proc/label_hardwareGroupsProc.sql;
source proc/run_subsystemProc.sql;
source proc/run_hardwareGroupsProc.sql;
source proc/travelerType_subsystemProc.sql;
source proc/travelerType_hardwareGroupsProc.sql;

-- and create the generic procedures which case on object type
source proc/generic_subsystemProc.sql;
source proc/generic_hardwareGroupsProc.sql;

