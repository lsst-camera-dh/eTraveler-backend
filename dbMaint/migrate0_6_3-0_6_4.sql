# Alter table: new columns
alter table JobHarness add jhStageRoot varchar(255) NOT NULL after jhOutputRoot;

# New entries
insert into PrerequisiteType set name='PREPARATION', createdBy='jrb', creationTS=UTC_TIMESTAMP();

insert into HardwareStatus set name='NON-COMPLIANT', description='part is not fully compliant', createdBy='jrb', creationTS=UTC_TIMESTAMP();
