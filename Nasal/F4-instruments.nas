# EXPORT : functions ending with export are called from xml
# CRON : functions ending with cron are called from settimer()
# SCHEDULE : functions ending with schedule are called from cron
# LISTEN : functions ending with listen are called from setlistener()



# ==============
# TRUE AIR SPEED
# ==============

# true air speed
tasschedule = func {
   taskt = getprop("fdm/jsbsim/velocities/vt-fps") * FPSTOKT;
   setprop("/instrumentation/navcomputer/indicated-tas-kt",taskt);
}

# ==============
# DME Selector
# ==============

# DME

dmeschedule = func{
   brgmode=getprop("/instrumentation/navcomputer/brg-switch-position");
   inrange=0;
   distance=999.9;
   heading=getprop("/orientation/heading-magnetic-deg[0]");
   bearing=heading+90;

   if(brgmode == 1){
       inrange=getprop("/instrumentation/dme/in-range");
       if(inrange){
         distance=getprop("/instrumentation/dme/indicated-distance-nm");
         bearing=getprop("/instrumentation/nav/radials/reciprocal-radial-deg");
       }
   }
   if(brgmode == 2){
       inrange=getprop("/instrumentation/tacan/in-range");
       if(inrange){
         distance=getprop("/instrumentation/tacan/indicated-distance-nm");
         bearing=getprop("/instrumentation/tacan/indicated-bearing-true-deg")-getprop("/environment/magnetic-variation-deg");
       }
   }
   if(brgmode == 3){
       inrange=getprop("/instrumentation/tacan/in-range");
       if(inrange){
         distance=getprop("/instrumentation/tacan/indicated-distance-nm");
       }
       bearing=getprop("/instrumentation/adf/indicated-bearing-deg");
       bearing=bearing+heading;
   }
   if(brgmode == 4){
       inrange=getprop("/instrumentation/tacan/in-range");
       if(inrange){distance=getprop("/instrumentation/tacan/indicated-distance-nm");};
       bearing=getprop("/instrumentation/nav/radials/reciprocal-radial-deg");
   }
   setprop("/instrumentation/navcomputer/in-range", inrange);
   setprop("/instrumentation/navcomputer/indicated-bearing", bearing);
   setprop("/instrumentation/navcomputer/indicated-distance-nm", distance);

}


# ==============
# Altitude Indicator
# ==============


altitudeschedule = func{
   altmode=getprop("instrumentation/altimeter/mode");
   myaltitude=getprop("position/altitude-ft");
   if(altmode == 0){
       myaltitude=getprop("position/altitude-ft");
   }
   if(altmode == 1){
       myaltitude=getprop("instrumentation/altimeter/indicated-altitude-ft");
   }
   setprop("/instrumentation/navcomputer/indicated-altitude-ft", myaltitude);

}
   
# ==============
# 8 Day Clock
# ==============

mylistener=nil;
mytime=0;

clockResetexport = func{
    running=getprop("instrumentation/clock/stopwatch-running");
    time=getprop("instrumentation/clock/stopwatch-seconds");
#print("clockReset Called: time=", time, " Running=", running, " Listener=", mylistener);
# running -> stop    
    if(running == 1){
#print("clockReset: stop!");
        setprop("instrumentation/clock/stopwatch-running", 0);
        if( mylistener )
        {
        	removelistener( mylistener );
        	mylistener = nil;
        }
    }
    if(running == 0)
    {
#print("clockReset:running is false!");
# !running & seconds -> reset
        if(time > 0)
        {
#print("clockReset: reset!");
            setprop("instrumentation/clock/stopwatch-seconds", 0);
            mytime=0;
        }
# !running & !seconds ->start
        if(time == 0)
        {
#print("clockReset: start!");
            setprop("instrumentation/clock/stopwatch-running", 1);
            mytime=getprop("/sim/time/utc/day-seconds");
            mylistener = setlistener("/sim/time/utc/day-seconds", clockUpdatelisten); 
        }
    }
}

clockUpdatelisten = func
{
    running=getprop("instrumentation/clock/stopwatch-running");
    time=getprop("/sim/time/utc/day-seconds");
    setprop("instrumentation/clock/stopwatch-seconds", time-mytime);
}

# ==============
# TACAN Controller
# ==============


tacanXY_toggle_export = func {
  xy_sign = getprop( "instrumentation/tacan/frequencies/selected-channel[4]" );
  if ( xy_sign == "X" ) {
    setprop( "instrumentation/tacan/frequencies/selected-channel[4]", "Y" );
  } else {
    setprop( "instrumentation/tacan/frequencies/selected-channel[4]", "X" );
  }
}

tacan_tenth_adjust_export = func {
  tenths = getprop( "instrumentation/tacan/frequencies/selected-channel[2]" );
  hundreds = getprop( "instrumentation/tacan/frequencies/selected-channel[1]" );
  value = (10 * tenths) + (100 * hundreds);
  adjust = arg[0];
  new_value = value + adjust;
  new_hundreds = int(new_value/100);
  new_tenths = (new_value - (new_hundreds*100))/10;
#  if ( new_hundreds > 1 ) new_hundreds = 0;
  setprop( "instrumentation/tacan/frequencies/selected-channel[1]", new_hundreds );
  setprop( "instrumentation/tacan/frequencies/selected-channel[2]", new_tenths );
}


##################################################
# Gear in Transit 
##################################################
# input properties
# /gear/gear[n]/position-norm
# output properties
# /gear/in-transit if any position-norm not 0 and not 1
##################################################
GearInTransit = {};
GearInTransit.new = func {
  obj = {};
  obj.parents = [GearInTransit];
  obj.gearNode = props.globals.getNode( "/gear" );
  obj.gearNodes = obj.gearNode.getChildren( "gear" );
  obj.inTransitNode = obj.gearNode.getNode( "in-transit", 1 );
  obj.inTransitNode.setBoolValue( 0 );
  return obj;
}

GearInTransit.update = func {
  inTransit = 0;

  if ( getprop("/controls/gear/gear-handle-down") != getprop("/controls/gear/gear-down")) {
    inTransit = 1;
  }else{
    for( i = 0; i < size(me.gearNodes); i = i+1 ) {
      position_norm = me.gearNodes[i].getNode("position-norm").getValue();
      if( position_norm != nil and position_norm > 0.0 and position_norm < 1.0 ) {
        inTransit = 1;
        break;
      }
    }
  }
  
  if( inTransit == 0 ) {
    me.inTransitNode.setBoolValue( 0 );
  } else {
    me.inTransitNode.setBoolValue( 1 );
  }
}



dragChuteExport = func {
  chute=getprop("controls/flight/drag-chute-deployed");
  if (chute==0){
print("Deploying drag-chute");
    setprop("controls/flight/drag-chute", 1);
    setprop("controls/flight/drag-chute-deployed", "true");
  } else {
print("Jettisoning drag-chute", chute);
    setprop("controls/flight/drag-chute", "false");
    setprop("controls/flight/drag-chute-jettison", "true");
  }  
}

dragChuteInit = func {
print("Initializing drag-chute");
    setprop("controls/flight/drag-chute", 0);
    setprop("controls/flight/drag-chute-deployed", "false");
    setprop("controls/flight/drag-chute-jettison", "false");
}



