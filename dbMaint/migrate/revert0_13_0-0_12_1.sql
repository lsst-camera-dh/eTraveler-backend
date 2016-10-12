delete from DbRelease where major='0' and minor='13' and patch='0';
delete from InputSemantics where name="text";
drop table TextResultManual;
alter table ProcessRelationshipTag drop foreign key fk323;
alter table ProcessRelationshipTag drop multiRelationshipSlotTypeId;
alter table ProcessRelationshipTag drop slotForm;
