# squatswitch.nas by Ron Jensen (GLP 2.0)
# Implement a squat switch 

original_gearDown = controls.gearDown;
    svc    = 1;		# assume the best for now

gearFncy = func {
    if ( svc == 0 ) {return};
    
    handle = getprop("/controls/gear/gear-handle-down");
    wow     = (getprop("/gear/gear[0]/compression-norm") > 0.001);

    if(handle==1 or !wow){
      original_gearDown( (handle == 1 ? 1 : -1) );
    } else {
      settimer(gearFncy, 0.2);
    }
}

controls.gearDown = func {
    if (arg[0] < 0) {
	setprop("/controls/gear/gear-handle-down", 0);
    } elsif (arg[0] > 0) {
	setprop("/controls/gear/gear-handle-down", 1);
    }
    gearFncy();
}

controls.gearToggle = func { controls.gearDown(getprop("/controls/gear/gear-handle-down") > 0 ? -1 : 1); }
