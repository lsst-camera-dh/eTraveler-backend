alter table SignatureResultManual drop signerComment;
alter table TextResultManual drop foreign key fk381;
alter table TextResultManual drop index ix382;
alter table TextResultManual add unique index ix382(activityId, inputPatternId);
alter table TextResultManual add constraint fk381 foreign key (activityId) references Activity(id); 
alter table FilepathResultManual drop index ix172;
alter table FilepathResultManual add unique index ix172(activityId, inputPatternId);

alter table IntResultManual drop index ix152;
alter table IntResultManual add unique index ix152(activityId, inputPatternId);

alter table FloatResultManual drop index ix162;
alter table FloatResultManual add unique index ix162(activityId, inputPatternId);

alter table StringResultManual drop index ix182;
alter table StringResultManual add unique index ix182(activityId, inputPatternId);

delete from InternalAction where name='repeatable';
update DbRelease set status='CURRENT' where major='0' and minor='13' and patch='0';
delete from DbRelease where major='0' and minor='14' and patch='0';


