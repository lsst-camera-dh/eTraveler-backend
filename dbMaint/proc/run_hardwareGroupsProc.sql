delimiter //

create procedure run_hardwareGroups(IN runId int)
  READS SQL DATA
  BEGIN
    select hardwareGroupId from RunNumber join Activity
    on RunNumber.rootActivityId=Activity.id
    join Process on Activity.processId=Process.id
    where RunNumber.id=runId;
  END //

delimiter ;
