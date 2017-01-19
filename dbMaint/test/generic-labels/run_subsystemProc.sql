delimiter //

create procedure run_subsystem(IN runId int)
  READS SQL DATA
  BEGIN
    select subsystemId from RunNumber join Activity
    on RunNumber.rootActivityId=Activity.id
    join TravelerType on Activity.processId=TravelerType.rootProcessId
    where RunNumber.id=runId;
  END //

delimiter ;
