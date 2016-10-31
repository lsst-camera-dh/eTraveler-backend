alter table SignatureResultManual add signerComment text NOT NULL DEFAULT '' after signerValue;

-- For TextResultManual only, need to drop and reconstitute foreign
-- key for activityId, first column in uniqueness constraint
alter table TextResultManual drop foreign key fk381;
alter table TextResultManual drop index ix382;
alter table TextResultManual add constraint fk381 foreign key (activityId) references Activity(id);
alter table TextResultManual add index ix382(activityId, inputPatternId);
alter table StringResultManual drop index ix182;
alter table StringResultManual add index ix182(activityId, inputPatternId);
alter table FilepathResultManual drop index ix172;
alter table FilepathResultManual add index ix172(activityId, inputPatternId);
alter table IntResultManual drop index ix152;
alter table IntResultManual add index ix152(activityId, inputPatternId);
alter table FloatResultManual drop index ix162;
alter table FloatResultManual add index ix162(activityId, inputPatternId);

insert into InternalAction set name='repeatable',maskBit='512',createdBy='jrb',creationTS=UTC_TIMESTAMP();

update DbRelease set status='OLD' where major='0' and minor='13' and patch='0';
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '14', '0', 'CURRENT', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Add SignatureResultManual.signerComment, add new internal action "repeatable" ');
