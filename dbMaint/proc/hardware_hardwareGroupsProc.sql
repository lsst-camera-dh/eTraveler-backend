delimiter //

create procedure hardware_hardwareGroups(IN cmpId int)
  READS SQL DATA
  BEGIN
    select HTGM.hardwareGroupId from HardwareTypeGroupMapping HTGM
         join HardwareType on HardwareType.id=HTGM.hardwareTypeId
	 join Hardware on Hardware.hardwareTypeId=HardwareType.id
	 where Hardware.id=cmpId;
  END //

delimiter ;

