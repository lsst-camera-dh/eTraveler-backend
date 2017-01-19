delimiter //

create procedure travelerType_hardwareGroups(IN ttId int)
  READS SQL DATA
  BEGIN
    select hardwareGroupId from TravelerType join Process
    on TravelerType.rootProcessId=Process.id
    where TravelerType.id=ttId;
  END //

delimiter ;
