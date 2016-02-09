# QF-4E Drone for flightgear!
Control it with mp-chat! WOO!

The base model and FDM work used was that of Ronald Jensen, found here: (https://github.com/FGMEMBERS/F4E)

-------------

Current todo/wishlist:

Strip out more of the cockpit.

Strip out unused components (drag chute, as an example).

Check if callsign exists when using *[drone] change owner*.

Report - have report return bearing and distance relative to controller.

Report - clean up reporting to not send 18 million lines.

Autopilot - ILS landing.

Autopilot - better takeoff.

Autopilot - expose things like bank angle and climb rate to the controller.

Autopilot - Add in a "follow that guy" command.

Have drone send out stall warnings and AGL warnings.

Add an "attack that guy" AI system.

--------------

### Drone commands

*The drone responds to every command it understands. If you don't see the drone respond over mp-chat, you probably did something wrong.*
The commands follow this pattern: drone-callsign some-command

For example, to make the speed set to 500, and the drone's callsign is drone_1 send: drone_1 speed 500

To make drone_1 fly in a square, send: drone_1 pattern square

To return the drone to the airport it took off from, send: drone_1 return

#### Command List:

[drone] control request

This is the only command that anyone can use. Use this to request control of the drone. If the drone hasn't heard from the prior owner in 15 minutes, or if it doesn't have an owner, congrats! You now have control of the drone.


[drone] change owner

If your the current owner, you can hand over control to another pilot. **WARNING:** This currently does NOT check if that pilot exists before handing over control (todo). Be careful to spell callsigns *correctly*.


[drone] enable

Enables the drone. Necessary for all following commands. This command is useful in that if you wish to takeoff the drone yourself, instead of letting the drone AI do it's own (terrible) job, you can enable the drone controls after the plane is airborne and stable.


[drone] disable

Disables the drone. Useful for manual landings.


[drone] takeoff

The drone takes off. Retracts gears at 100' AGL; the takeoff sequence is complete after 500' AGL.


[drone] gear deploy

Deploy landing gears.


[drone] gear retract

Retract landing gears.


[drone] brakes on | off

Turn on or off the parking brakes.


[drone] fly to [ICAO]

Flies the drone to the specified airport. When reached, the drone will fly in a circle pattern.


[drone] return

Return the drone to the airport it took off from.


[drone] report

The drone reports its heading, speed, altitude, and destination airport (if any).


[drone] heading [heading]

Set the heading.


[drone] speed [speed]

Set the speed.


[drone] altitude [altitude]

Set the altitude.


[drone] pattern [pattern | pattern-speed]

Set either the pattern to fly, or how quickly to fly the pattern. Valid patterns are: oval, circle, triangle, square, pentagon, and hexagon. Valid speeds are: slow, normal, quick, very quick.


[drone] pattern turn [left | right]

Have the drone fly patterns turning to the left or the right.


[drone] evade

Randomly (within reason) set heading, altitude, and speed every 15-45 seconds, to badly simulate "evading".


[drone] damage [on | off]

Turn the damage model on or off.


[drone] repair

If the drone has taken damage, use this to repair that damage.
