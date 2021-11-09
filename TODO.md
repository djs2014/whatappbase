<<<<<<< HEAD
rotations 
https://forums.garmin.com/developer/connect-iq/f/discussion/250/feature-request-add-option-to-draw-a-polygon-at-a-certain-position
=======
show max value
1 field layout : settings= order of fields abr1,abr2, etc.
2 timer
3 'hitt' - trigger on power level -> timer 5 min beep etc.. countdown.

Not working:
 - temperature
 - transparent font on edge 830 drawn on 2 color background

fix perc text -> + background rect 1 smaller red not visible
    - werkt niet op edge, wel op simulator?

    TEST app, met alleen simple transparant text met backcolor
    dc.setColor(Graphics.COLOR_TRANSPARENT, backColor);
      // dc.setColor(Graphics.COLOR_TRANSPARENT, backColor);
      dc.drawText(xRect, yRect, font, "test", Graphics.TEXT_JUSTIFY_LEFT);
??  setClip(x as Lang.Numeric, y as Lang.Numeric, width as Lang.Numeric, height as Lang.Numeric) as Void 
reorder settings

fix font size issue rpm in wide field ..
- wide field: units te laag
- energie exp -> geen label of ee
-> set LIFE
what power / what speed

docu screen shots
new what distance -> use as test app 
show version nr in name -> how to get

x TESTv - heading: ignore when value is 0.0 or null + check min elapseddistance
-> whatpower sync settings -> speed 
x- training effect -> verkeerde code? staat als energie exp

-drawPercentageText max arguments <10!
- units position + size - larger on wide fields?
- have unitfonts and labelfonts
- no middle -> left/right bigger?
- use font for icons heartrate/power etc.

- big/wide field: show bottom as square (vertical only "N" etc), top idem. 
    - show big field -> bottom and top small info if possible / like Heading (sep callback)
- show app name when paused / not started custom callback
- wide fields left/right only then larger
- refactor class callback names etc / getValue needed? -> because 1 class for 1 value
    - callback for: label, value, unit, color, percentage, average etc..
    - base has the default callbacks: 

info fields:
- watt/kg info field
- total asc/desc info field
- add property: label needed, heading not -> N is obvious or callback?
Show info
    - maxColor -> for perc text
show app name
organise todo's

nightmode - when not started or paused
- circle + line and black background not filled and filled rectangle around text on top of triangle

heading: only after x meters calc lat/lng heading / speed?
larger font in big fields
use custom font for icons: wingding oid 
>>>>>>> 5e8abac22a03d9587df7b0a682e5fe4f757a354a

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
