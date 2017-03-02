delimiter //

create procedure label_hardwareGroups(IN labelId int)
  READS SQL DATA
  BEGIN
    select hardwareGroupId from Label join LabelGroup
    on Label.labelGroupId = LabelGroup.id
    where Label.id=labelId;
  END //

delimiter ;
