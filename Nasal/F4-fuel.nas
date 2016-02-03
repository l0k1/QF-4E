# Helper function
getfuel = func { if(arg[0] < arg[1]) { arg[0] } else { arg[1] } }

#procedure runs once per second
transferfuelschedule = func {
#    tank1_capacity = getprop("/consumables/fuel/tank[0]/capacity-gal_us");
    tank1_capacity = 1855;
    tank1_contents = getprop("/consumables/fuel/tank[0]/level-gal_us");
    ext_centerline_contents = getprop("/consumables/fuel/tank[1]/level-gal_us");
    ext_lwing_contents = getprop("/consumables/fuel/tank[2]/level-gal_us");
    ext_rwing_contents = getprop("/consumables/fuel/tank[3]/level-gal_us");
    
    delta=tank1_capacity - tank1_contents;
    delta2=delta/2;
    transfer=0;

#get fuel delta2 from ext lwing
    t = getfuel(delta2,ext_lwing_contents);
#if t<0.5 ext_lwing_tranfer=false;
#else  ext_lwing_tranfer=true;
    ext_lwing_contents = ext_lwing_contents - t;
    transfer = transfer + t;
    delta = delta - t;

#get fuel delta2 from ext rwing
    t = getfuel(delta2,ext_rwing_contents);
#if t<0.5 ext_rwing_tranfer=false;
#else  ext_rwing_tranfer=true;
    ext_rwing_contents = ext_rwing_contents - t;
    transfer = transfer + t;
    delta = delta - t;

#get fuel delta from ext centerline
    t = getfuel(delta,ext_centerline_contents);
#if t<0.5 ext_centerline_tranfer=false;
#else  ext_centerline_tranfer=true;
    ext_centerline_contents = ext_centerline_contents - t;
    transfer = transfer + t;
    delta = delta - t;

    tank1_contents = tank1_contents + transfer;

    setprop("/consumables/fuel/tank[0]/level-gal_us",tank1_contents);
    setprop("/consumables/fuel/tank[1]/level-gal_us",ext_centerline_contents);
    setprop("/consumables/fuel/tank[2]/level-gal_us",ext_lwing_contents);
    setprop("/consumables/fuel/tank[3]/level-gal_us",ext_rwing_contents);
}


