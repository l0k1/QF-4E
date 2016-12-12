# turns a fg plane into a drone that can be controlled via mp-chat

# use getprop() and setprop() when possible.
# camelcase

# globals

var combat_bias_filename = getprop("/sim/fg-home") ~ "/Export/drone-ai/combat_bias.xml";
var 
var combat_bias_root = "/drone-ai/combat-bias/";


# get data about self

var self_data = {
	# create new instance
	new: func()	{
		var m = {parents: [self_data]};
		return m;
	},

	# queries
	
	alt_indicated: 0,	#indicated altitude
	alt_agl: 0, 		#cap it to simulate agl radar
	vsi: 0,				#vertical speed, feet per minute
	pitch_deg: 0,		#
	pitch_rate: 0,		#degrees per second
	roll_deg: 0,		#
	roll_rate: 0,		#degrees per second
	yaw_deg: 0,			#
	yaw_rate: 0,		#degrees per second
	heading: 0,			#
	turn_rate: 0,		#degrees per second
	speed-ias: 0,		#
	speed-gs: 0,		#ground speed
	accel-ias: 0,		#knots-per-hour (probably)
	accel-gs: 0,
	wow: 0,				#gears on the ground or not
	gear_pos: 0,		#gears up or down
	flaps_pos: 0,		#flaps position
	latitude: 0,		#
	longitude: 0,		#
	
	# commands and input params
	
	throttle: 0,
	elevator: 0,
	aileron: 0,
	rudder: 0,
	tiller: 0,
	gear: 0,
	flaps: 0,
	
	
	# mode
	
	# don't write to this, only read from it (if necessary)
	
	mode: {
		_flight_mode: "taxi",
	
		#the whole ai concept is going to be revolving around flight "modes".
	
		#return the current flight mode
		get: func() {
			return me.mode._flight_mode;
		},
		
		#set the flight mode
		
		#taxiing - between finishing the landing roll out and beginning the takeoff down the runway
		taxi: func() {
			me.mode._flight_mode = "taxi";
		},
		#taking off down the runway
		takeoff_roll: func() {
			me.mode._flight_mode = "takeoff_roll";
		},
		#immediately after the wheels come up of the ground until power and climb rate is good
		takeoff_ascent: func() {
			me.mode._flight_mode = "takeoff_ascent";
		},
		#navigating to waypoints, generic mid-to-high altitude with no threats
		navigation: func() {
			me.mode._flight_mode = "navigation";
		},
		#approaching the destination airfield
		landing_approach: func() {
			me.mode._flight_mode = "landing_approach";
		},
		#descending either by ils/gs or "visually", up to flare and wheels touching
		landing_final: func() {
			me.mode._flight_mode = "landing_final";
		},
		#immediately after wheels touch until can safely transition to taxiing
		landing_rollout: func() {
			me.mode._flight_mode = "landing_rollout";
		},
	},
			
	
	#waypoints
	wp: {},
	
	# functions
	pull: func() {
	},
	
	pull_lat_lon: func() {
	},
	
	pull_pos: func() {
	},
	
	pull_orientation: func() {
	},
	
	pull_speed: func() {
	},
	
	push: func() {
	}
};


# biases

var bias = {
	new: func(root = "", filename = "", path = "")	{
		var m = {parents: [bias]};
		m.bias_root: root;
		m.bias_filename: filename;
		if (path = "") {
			me.set_path();
		} else {
			m.bias_path = path;
		}
		
		return m;
	},
	
	set_path: func(model = "") {
		if ( me.bias_path != "" and me.bias_root != "" ) {
			if (model = "") {
				model = getprop("/sim/model");
			}
			me.bias_path = me.bias_root ~ model ~ "/";
			return 1;
		} else {
			return 0;
		}
	},
	
	import: func() {
		if ( me.bias_filename != "" ) {
			if ( call(io.readfile, [me.bias_filename], nil, nil, var err=[]) != nil ) {
				io.read_properties(path: me.bias_filename);
				me.bias_pull();
				return 1;
			} else {
				return 0;
			}
		} else {
			return 0;
		}
	},
	
	export: func() {
		io.write_properties(path: me.f_bias_filename, prop: me.bias_root);
		return 1;
	},
	
	#propogate bias variables from the property tree
	bias_pull: func() {
	}
	
	#mass push the hash back onto the property tree
	bias_push: func() {
	}
	
	#possible biases go here
	#a bias is a tidbit of recorded knowledge, and will be specific from plane to plane and combatant to combatant.
	
	#flight biases are to compensate for how a specific aircraft handles
	#things such as how much left/right aileron to apply, when v1/rotate/v2, how much AoA, etc.
	#combat biases are to record how other planes react to specific actions (e.g. evasion techniques)
	#and if we acheived our goals in a combat scenario (e.g. params to ideal missile hit)
	#these are seperate, as while a plane might handle differently, an ideal missile launch scenario should be universal
	
	#flight biases
	

};

var main = func(mai) {
	#main control loop - we need to determine if we are in the correct mode,
	#and then pass off handling to that mode
	if ( mai.wow = 1 and mai.gear = 1 ) {
		# we are on the ground, so either taxiing, taking off, or landing
		if ( mai.speed_gs < 23 ) {
			#speed is low se we are taxiing
		} elsif {
}

var mai = "";
var flight_bias = "";
var combat_bias = "";

var init = func() {
	#create our ai instance
	mai = self_data.new();
	#set up biases
	var flight_bias = bias.new("/drone-ai/flight-bias",getprop("/sim/fg-home") ~ /"Export/drone-ai/flight_bias.xml");
	var combat_bias = bias.new("/drone-ai/combat-bias",getprop("/sim/fg-home") ~ /"Export/drone-ai/combat_bias.xml");
	flight_bias.import();
	combat_bias.import();
	main();
}
