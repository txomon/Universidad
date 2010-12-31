%ZOOMEDSV

ve_name = get(finduitx(gcf,'Answer'),'UserData');
ve_y = get(findmenu(gcf,'Edit','Cut'),'Userdata');
eval([ ve_name '= ve_y;']);

clear ve_name ve_y
