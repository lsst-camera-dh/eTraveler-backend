# Delete all entries created by traveler execution or by 
# certain optionally manual operations like changing location 
delete from Result;
delete from FilepathResultHarnessed;
delete from FilepathResultManual;
delete from FloatResultHarnessed;
delete from FloatResultManual;
delete from IntResultHarnessed;
delete from IntResultManual;
delete from StringResultHarnessed;
delete from StringResultManual;
delete from Prerequisite;
delete from JobStepHistory;
delete from StopWorkHistory;
delete from MultiRelationshipHistory;
delete from MultiRelationshipSlot;
delete from Exception;
delete from ActivityStatusHistory;
delete from HardwareStatusHistory where hardwareStatusId != (select id from HardwareStatus where name="NEW");
# ideally should save first entry in HardwareLocationHistory for each
# hardwareId and delete the rest, but I don't know how to do that
# in any neat way
##delete from HardwareLocationHistory;
delete from Activity order by id desc;
delete from HardwareRelationship;

