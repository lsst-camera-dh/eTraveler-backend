delimiter //

create procedure NCR_subsystem(IN exceptionId int)
  READS SQL DATA
  BEGIN
    select subsystemId from Exception join Activity
    on Exception.NCRActivityId=Activity.rootActivityId
    join TravelerType on Activity.processId=TravelerType.rootProcessId
    where Exception.id=exceptionId;
  END //

delimiter ;
