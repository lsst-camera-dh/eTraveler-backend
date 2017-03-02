delimiter //

create procedure hardwareType_hardwareGroups(IN htypeId int)
  READS SQL DATA
  BEGIN
    select HTGM.hardwareGroupId from HardwareTypeGroupMapping HTGM
         join HardwareType on HardwareType.id=HTGM.hardwareTypeId
	 where HardwareType.id=htypeId;
  END //

delimiter ;

