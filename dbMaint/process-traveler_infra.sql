#  Do some inserts related to infrastructure (e.g. allowed status values)
#  to get us started off
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 1, 0, 'TEST', 'jrb', NOW(), NOW(), 'Adding prerequisite tables');
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 2, 0, 'TEST', 'jrb', NOW(), NOW(), 'Adding history, result tables');
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 3, 0, 'TEST', 'jrb', NOW(), NOW(), 'Adding stop/resume history, traveler type directory tables');
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 4, 0, 'TEST', 'jrb', NOW(), NOW(), 'Merge Exception and NCRcondition; rename to ExceptionType. Add new table Exception for exception instances. Beef up TravelerType');
insert into PrerequisiteType set name='PROCESS_STEP', createdBy='jrb', creationTS=NOW();
insert into PrerequisiteType set name='COMPONENT', createdBy='jrb', creationTS=NOW();
insert into PrerequisiteType set name='TEST_EQUIPMENT', createdBy='jrb', creationTS=NOW();
insert into PrerequisiteType set name='CONSUMABLE', createdBy='jrb', creationTS=NOW();
insert into HardwareStatus set name='NEW', description='Available for preparation and testing', createdBy='jrb', creationTS=NOW();
insert into HardwareStatus set name='IN_PROGRESS', description='At least one traveler begun; at least one applicable traveler not complete', createdBy='jrb', creationTS=NOW();
insert into HardwareStatus set name='REJECTED', description='Beyond hope', createdBy='jrb', creationTS=NOW();
insert into HardwareStatus set name='READY', description='Testing/preparation complete; ready for integration', createdBy='jrb', creationTS=NOW();
insert into HardwareStatus set name='USED', description='Fully tested component has been integrated', createdBy='jrb', creationTS=NOW();
insert into HardwareStatus set name='PENDING', description='Component has irregularities; acceptance under review', createdBy='jrb', creationTS=NOW();
insert into InputSemantics set name="int", createdBy='jrb', creationTS=NOW();
insert into InputSemantics set name="float", createdBy='jrb', creationTS=NOW();
insert into InputSemantics set name="boolean", createdBy='jrb', creationTS=NOW();
insert into InputSemantics set name="checkbox", createdBy='jrb', creationTS=NOW();
insert into InputSemantics set name="filepath", createdBy='jrb', creationTS=NOW();
insert into InputSemantics set name="timestamp", createdBy='jrb', creationTS=NOW();
insert into InputSemantics set name="string", createdBy='jrb', creationTS=NOW();

insert into JobHarnessStep set name="registered", createdBy='jrb', creationTS=NOW();
insert into JobHarnessStep set name="configured", createdBy='jrb', creationTS=NOW();
insert into JobHarnessStep set name="staged", createdBy='jrb', creationTS=NOW();
insert into JobHarnessStep set name="produced", createdBy='jrb', creationTS=NOW();
insert into JobHarnessStep set name="validated", createdBy='jrb', creationTS=NOW();
insert into JobHarnessStep set name="archived", createdBy='jrb', creationTS=NOW();
insert into JobHarnessStep set name="purged", createdBy='jrb', creationTS=NOW();
insert into JobHarnessStep set name="ingested", createdBy='jrb', creationTS=NOW();
insert into ActivityFinalStatus set name="success", createdBy='jrb', creationTS=NOW();
insert into ActivityFinalStatus set name="failure", createdBy='jrb', creationTS=NOW();
insert into ActivityFinalStatus set name="superseded", createdBy='jrb', creationTS=NOW();
insert into InternalAction set name='harnessedJob', maskBit='1', createdBy='jrb', creationTS=NOW();
insert into InternalAction set name='makeHardwareRelationship', maskBit='2', createdBy='jrb', creationTS=NOW();
insert into InternalAction set name='breakHardwareRelationship', maskBit='4', createdBy='jrb', creationTS=NOW();
insert into InternalAction set name='setHardwareStatus', maskBit='8', createdBy='jrb', creationTS=NOW();
insert into InternalAction set name='setHardwareLocation', maskBit='16', createdBy='jrb', creationTS=NOW();
insert into InternalAction set name='async', maskBit='32', createdBy='jrb', creationTS=NOW();
insert into PermissionGroup set name='operator', maskBit='1', createdBy='jrb', creationTS=NOW();
insert into PermissionGroup set name='supervisor', maskBit='2', createdBy='jrb', creationTS=NOW();
insert into PermissionGroup set name='approver', maskBit='4', createdBy='jrb', creationTS=NOW();
insert into PermissionGroup set name='admin', maskBit='8', createdBy='jrb', creationTS=NOW();


