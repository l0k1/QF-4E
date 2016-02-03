# EXPORT : functions ending with export are called from xml
# CRON : functions ending with cron are called from settimer()
# SCHEDULE : functions ending with schedule are called from cron
# LISTEN : functions ending with listen are called from setlistener()

# current nasal version doesn't accept :
# - more than multiplication on 1 line.
# - variable with hyphen or underscore.
# - boolean (can only test IF TRUE); replaced by strings.
# - object oriented classes.

gearInTransit = nil;

# ==============
# INITIALIZATION
# ==============

# 0.0 second cron
sec00cron = func {
   altitudeschedule();

   # schedule the next call
   settimer(sec00cron,0.0);
}

# 1 seconds cron
sec1cron = func {
   transferfuelschedule();
   dmeschedule();
   gearInTransit.update();
#   feedengineschedule();
#   hydraulicschedule();

   # schedule the next call
   settimer(sec1cron,1);
}

# 3 seconds cron
sec3cron = func {
   tasschedule();
#   autopilotschedule();
#   tcasschedule();

   # schedule the next call
   settimer(sec3cron,3);
}

# 5 seconds cron
#sec5cron = func {
#   vmoktschedule();
#   inslightschedule();
#   airbleedschedule();

   # schedule the next call
#   settimer(sec5cron,PRESSURIZESEC);
#}

# 15 seconds cron
#sec15cron = func {
#   tmodegcschedule();
#   insfuelschedule();
#
   # schedule the next call
#   settimer(sec15cron,15);
#}

# 30 seconds cron
#sec30cron = func {
#   bucketdegschedule();
#   tankpressureschedule();

   # schedule the next call
#   settimer(sec30cron,30);
#}

# 60 seconds cron
#sec60cron = func {
   # delay to call ground power
#   groundserviceschedule();

   # schedule the next call
#   settimer(sec60cron,60);
#}

# general initialization
init = func {
#   initfuel();
#   presetfuel();
#   initautopilot();
dragChuteInit();
gearInTransit = GearInTransit.new();
   # schedule the 1st call
#   settimer(flashinglightcron,1);
   settimer(sec00cron,1);
   settimer(sec1cron,1);
   settimer(sec3cron,1);
#   settimer(sec5cron,1);
#   settimer(sec15cron,1);
#   settimer(sec30cron,1);
#   settimer(sec60cron,1);
}

init();

