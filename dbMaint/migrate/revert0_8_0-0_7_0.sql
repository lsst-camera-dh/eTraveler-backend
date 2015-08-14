DROP TABLE ProcessRelationshipTag;
DROP TABLE MultiRelationshipHistory;
DROP TABLE MultiRelationshipAction;
DROP TABLE MultiRelationshipSlot;
DROP TABLE MultiRelationshipSlotType;
DROP TABLE MultiRelationshipType;
ALTER TABLE Process add constraint fk41 foreign key (hardwareRelationshipTypeId) references HardwareRelationshipType(id);
ALTER TABLE Process add index fk41 (hardwareRelationshipTypeId);
ALTER TABLE Activity add constraint fk71 foreign key (hardwareRelationshipId) references hardwareRelationship(id);
ALTER TABLE Activity add index fk71 (hardwareRelationshipId);

UPDATE DbRelease set status="NO_GOOD" where major="0" and minor="8" and patch="0";
