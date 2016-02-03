# ==================================== timer stuff =========================================

# set the update period

UPDATE_PERIOD = 0.2;

# set the timer for the selected function

registerTimer = func {

    settimer(gmeterUpdate, UPDATE_PERIOD);

}

# =============================== end timer stuff ===========================================

# =============================== G-Meter stuff =============================================

gmeterUpdate = func {

    if (flag and !done) {done = 1};
    #if (flag and !done) {print("gmeter_running"); done = 1};

    GCurrent = props.globals.getNode("/accelerations/pilot-g[0]").getValue();

    # Unfortunately, FDM initialization hasn't happened when we start
    # running.  Wait for the FDM to start running before we set any output
    # properties.  This also prevents us from mucking with FDMs that
    # don't support this scheme.
    if(GCurrent == 1 and !flag) {  # this relies on 'GCurrent'
        return registerTimer(); #  not being quite 0 at startup,
        }else{                  # and therefore keeps the function running,
        flag = 1;               # once it has run once.
    }

    if(!initialized) { initialize(); }

    if (props.globals.getNode("/velocities/airspeed-kt").getValue() < 10) {
           GCurrent = 1.0;
    } else {
           GCurrent = props.globals.getNode("/accelerations/pilot/z-accel-fps_sec").getValue() /          -32.16534;
    }
    props.globals.getNode("accelerations/pilot-g[0]", 1).setDoubleValue(GCurrent);
    GMin = props.globals.getNode("/accelerations/pilot-gmin[0]").getValue();
    GMax = props.globals.getNode("/accelerations/pilot-gmax[0]").getValue();

    if(GCurrent < 1 and GCurrent < GMin){setprop("/accelerations/pilot-gmin[0]", GCurrent);}
    else {if(GCurrent > GMax){setprop("/accelerations/pilot-gmax[0]", GCurrent);}}

    if(props.globals.getNode("/controls/gmeter/reset").getValue() == 0) {
        setprop("/accelerations/pilot-gmin", 1.0);
        setprop("/accelerations/pilot-gmax", 1.0);
        setprop("/controls/gmeter/reset", 1);
    }
    
    registerTimer();

}


####################### Initialise ##############################################
done = 0;
flag = 0;
initialized = 0;

initialize = func {

    ### Initialise gmeter stuff ###
    props.globals.getNode("accelerations/pilot-g[0]", 1).setDoubleValue(1.01);
    props.globals.getNode("accelerations/pilot-gmin[0]", 1).setDoubleValue(1);
    props.globals.getNode("accelerations/pilot-gmax[0]", 1).setDoubleValue(1);
  
	# Finished Initialising
    initialized = 1;

} #end func

######################### Fire it up ############################################

registerTimer();
