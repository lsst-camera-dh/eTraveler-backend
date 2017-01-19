delimiter //

create procedure hardware_subsystem(IN cmpId int)
  READS SQL DATA
  BEGIN
    select subsystemId from HardwareType join Hardware
    on HardwareType.id=Hardware.hardwareTypeId
    where Hardware.id=cmpId;
  END //

delimiter ;
