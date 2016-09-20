alter table FloatResultManual drop index ix162;
alter table FloatResultManual add unique key ix162 (activityId, inputPatternId);

alter table IntResultManual drop index ix152;
alter table IntResultManual add unique key ix152 (activityId, inputPatternId);

alter table StringResultManual drop index ix182;
alter table StringResultManual add unique key ix182 (activityId, inputPatternId);

alter table FilepathResultManual drop index ix172;
alter table FilepathResultManual add unique key ix172 (activityId, inputPatternId);
