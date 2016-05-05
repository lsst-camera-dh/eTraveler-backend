# Remove added values
DELETE from MultiRelationshipAction where name='deassign';
DELETE from InputSemantics where name='signature';

DELETE from DbRelease where major='0' and minor='10' and patch='0';

# Remove columns and constraints on them
ALTER TABLE PermissionGroup drop stepPermission;
ALTER TABLE InputSemantics drop tableName;

ALTER TABLE InputPattern drop foreign key fk133;
ALTER TABLE InputPattern drop permissionGroupId;

ALTER TABLE Activity drop foreign key fk77;
ALTER TABLE Activity drop rootActivityId;

#Remove tables
DROP TABLE SignatureResultManual;

