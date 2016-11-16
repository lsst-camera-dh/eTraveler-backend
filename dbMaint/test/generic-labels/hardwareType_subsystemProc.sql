delimiter //

create procedure hardwareType_subsystem(IN htypeId int)
  READS SQL DATA
  BEGIN
    select subsystemId from HardwareType 
    where HardwareType.id=htypeId;
  END //

delimiter ;
