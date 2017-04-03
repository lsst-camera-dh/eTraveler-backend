delimiter //

create procedure travelerType_subsystem(IN ttId int)
  READS SQL DATA
  BEGIN
    select subsystemId from TravelerType 
    where TravelerType.id=ttId;
  END //

delimiter ;
