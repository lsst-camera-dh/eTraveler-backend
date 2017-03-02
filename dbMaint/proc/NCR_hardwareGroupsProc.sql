delimiter //

create procedure NCR_hardwareGroups(IN exceptionId int)
  READS SQL DATA
  BEGIN
    select hardwareGroupId from Exception join Activity
    on Exception.NCRActivityId=Activity.id
    join Process on Activity.processId=Process.id
    where Exception.id=exceptionId;
  END //

delimiter ;
