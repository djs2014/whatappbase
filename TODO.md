rotations 
https://forums.garmin.com/developer/connect-iq/f/discussion/250/feature-request-add-option-to-draw-a-polygon-at-a-certain-position

when no movement -> use heading compass not gps data (should move 1 meter?)
icons for heartrate etc.
activity pause -> show avg ex. calories/elapsed time
    power
    speed
    cadence
    -> show label or icon on left/right if paused
altitude show arrows up/down instead of ++--    

heading using lat lon
heading using lat/lng a and b 
bigger fonts left right
hide Top ==> left/right then bigger
option hide left/right values on small field

teffect fall back hr+te == 0
distance label
label Top / bottom

x Display % of target in graphic way @@?? circle part? in front of label
= part of zone info check all classes -> color black/font  
targetTrainingEffect test
    bottom label, if too long show no units

? units in color_4 big font on small field

x no bottom info in small field

large Top -> perc/other info under value
option: show target/perc (auto calc for ftp / hr)
    or show target bar? 0 - 100%


x set target rpm
x set target speed -> percof colors
set target altitude 
    -> 300 == colors 0 - 300
    -> 1000 == 0 - 1000
    -> etc
x set target calories = bmr ?
total ascent -> diff label total descent -> diff label combined
energyExpenditure 
heading -> test it
x time of day
cal/min focus instead of calories
grade colors etc 
x speed colors
calories colors + label is cal/min or vice versa?
- grade / max (last x distance)
symbols bpm / rpm etc

First: create barrel with basecode!
nice?: show only columns/bar with percentage(+color) to value on bottom 
spd/pwr/rpm/cal/dis/ or symbols
-> show info has als actual value, perc, small label
-> drawXX (zoneinfo as parameter?)
==> app "what target" 

for targets:
show percentage arcs - circles
show percentage bar - bottom

x power / avg / max
x hr / avg / max
x speed / avg / max
x cadence / avg / max
x calories 

trainingEffect  https://www.firstbeat.com/en/blog/how-to-use-training-effect/

@@ history sensor data ??


- altitude 
- distance %target?

- heading ? correct for null values
- pressure / trend? /  meanSeaLevelPressure as Lang.Float or Null 
- show sealevel pressure
- time of day

- fallback value (hr not connecte3d == 0)
- format km/h == km and h below
- show average as option? avg power/hr/speed/cadence
 -----


- barrel + name
    - whatutilsbarrel

diff apps using same barrel, focus on diff Top field
- currentpower x sec
- heartrate
- speed

what power w
what heart bpm
what cadence rpm
what speed km/h mi/h

grade
distance
time
speed / avg / max 
bearing

zoneinfo
if 0 -> no --- but `power 3sec`


optional left/right/under (upper left, upper right if large/wide field)
- cadence
- heartrate

- grade https://www.e-education.psu.edu/natureofgeoinfo/book/export/html/1837
- distance

- speed
- heading

config: 
    left==<list>
    Top is fixed
    right==<list>


toon w (wattage)

----------------
3s power /1s 2s 5s avg
xx w
(zone info)

bg = average color/power
bar = current power


cadence 
90 
85 - 105

grade
avg values of heartr / cadence  in circle (line/lower part)


additional data bigger on wide field
if color only -> symbol in circle power / hr/ cadence etc

1: create barrel for generic code
- power 
- heartrate
- zoneinfo -> colors power / heartrate
- colors
- display
    draw Top info
    draw addcircle info (position left, right, etc) + avg?
    draw sub info (below Top)


https://www.mathopenref.com/coordintersection.html

var p1 = {
	x: 20,
	y: 20
};

var p2 = {
	x: 40,
	y: 40
};

// angle in radians angle between x-axis and line 1
var angleRadians = Math.atan2(p2.y - p1.y, p2.x - p1.x);

// angle in degrees
var angleDeg = Math.atan2(p2.y - p1.y, p2.x - p1.x) * 180 / Math.PI;

Angle between line 1 and line 2 = A - B
