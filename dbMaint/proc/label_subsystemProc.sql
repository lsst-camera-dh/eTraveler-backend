delimiter //

create procedure label_subsystem(IN labelId int)
  READS SQL DATA
  BEGIN
    select subsystemId from Label join LabelGroup
    on Label.labelGroupId = LabelGroup.id
    where Label.id=labelId;
  END //

delimiter ;
