#  Do some inserts related to infrastructure (e.g. allowed status values)
#  to get us started off
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 1, 0, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Adding prerequisite tables');
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 2, 0, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Adding history, result tables');
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 3, 0, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Adding stop/resume history, traveler type directory tables');
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 4, 0, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Merge Exception and NCRcondition; rename to ExceptionType. Add new table Exception for exception instances. Beef up TravelerType');
INSERT into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 4, 1, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'bug fix: add column ExceptionType.returnProcessId');
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 5, 0, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Add ActivityStatusHistory table; add automatable internal action');
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 5, 1, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Make TravelerType.rootProcessId unique index');
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 5, 2, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Eliminate harmful uniqueness constraints in Process; add PrequisitePattern.prereqUserVersionString');
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 5, 3, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Set most varchar lengths to 255; add HardwareRelationshipType.slot and unique key');
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 5, 4, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'support set status, location from traveler; add Hardware.manufacturerId ');
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 6, 0, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'support hw groups');

insert into PrerequisiteType set name='PROCESS_STEP', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into PrerequisiteType set name='COMPONENT', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into PrerequisiteType set name='TEST_EQUIPMENT', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into PrerequisiteType set name='CONSUMABLE', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into HardwareStatus set name='NEW', description='Available for preparation and testing', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into HardwareStatus set name='IN_PROGRESS', description='At least one traveler begun; at least one applicable traveler not complete', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into HardwareStatus set name='REJECTED', description='Beyond hope', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into HardwareStatus set name='READY', description='Testing/preparation complete; ready for integration', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into HardwareStatus set name='USED', description='Fully tested component has been integrated', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into HardwareStatus set name='PENDING', description='Component has irregularities; acceptance under review', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InputSemantics set name="int", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InputSemantics set name="float", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InputSemantics set name="boolean", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InputSemantics set name="checkbox", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InputSemantics set name="filepath", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InputSemantics set name="timestamp", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InputSemantics set name="string", createdBy='jrb', creationTS=UTC_TIMESTAMP();

insert into JobHarnessStep set name="registered", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into JobHarnessStep set name="configured", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into JobHarnessStep set name="staged", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into JobHarnessStep set name="produced", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into JobHarnessStep set name="validated", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into JobHarnessStep set name="archived", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into JobHarnessStep set name="purged", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into JobHarnessStep set name="ingested", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into ActivityFinalStatus set name="success", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into ActivityFinalStatus set name="failure", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into ActivityFinalStatus set name="superseded", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into ActivityFinalStatus set name="ncrExit", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into ActivityFinalStatus set name="stopped", createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InternalAction set name='harnessedJob', maskBit='1', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InternalAction set name='makeHardwareRelationship', maskBit='2', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InternalAction set name='breakHardwareRelationship', maskBit='4', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InternalAction set name='setHardwareStatus', maskBit='8', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InternalAction set name='setHardwareLocation', maskBit='16', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InternalAction set name='async', maskBit='32', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into InternalAction set name='automatable', maskBit='64', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into PermissionGroup set name='operator', maskBit='1', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into PermissionGroup set name='supervisor', maskBit='2', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into PermissionGroup set name='approver', maskBit='4', createdBy='jrb', creationTS=UTC_TIMESTAMP();
insert into PermissionGroup set name='admin', maskBit='8', createdBy='jrb', creationTS=UTC_TIMESTAMP();


