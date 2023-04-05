# Todo:
redesign only for edge 1040+
transparent color etc.
on device settings
git module base


top: large font calc with ex heading

altitude -> speed less than 15km/u -> show meters in perc circle
 - extra show total asc/desc

temp bg allow even if phone not connected.

diff callback for draw info data
    -- weak object?
    ex: l/r power balance with color
    
-- option to show top/bottom on small field (based on what_x field, like temp/pressure/heading/)

grade: activity paused -> stop calculating / reset 
activity started -> wait 2 seconds before calculating

x grade <0 colors
callback for display extra info in field
power / left/right balance
alt / total ascend/descend

-> option for Fallback power
-> show version info when paused
no power input == null of 10 seconds 0 value -> go to alt, when 
power > 0 reset and display power


pause text bigger/white box
reset max etc when start activity

docu for hitt/sit + screenshots
-> option layout -> circle / show bottom on small field
   (allow for some like time/distance/etc...)  
 
one screen: show stats when paused

air quality data?
Test app:
    - https://www.iqair.com/air-pollution-data-api

    - https://openweathermap.org/api/air-pollution <--
    - disable/enable background
    
2 timer datafield
    - central circle -> units to right?
    - target time?

Submodules define app/base
    Sep app: One field layout : settings= order of fields abr1,abr2, etc.

3 'hitt' - trigger on power level -> timer 5 min beep etc.. countdown.
option to auto adjust target (use %rule)
    -> if >0 -> set target to target +/- x% of end/avg value
    -> only enabled after x elapsed distance
nightmode - when not started or paused
- circle + line and black background not filled and filled rectangle around text on top of triangle
- icons using custom font for info / pressure 
- zones for altitude / 
- if target distance -> display estimated time?

- App name Show version 




## Not working:
 - temperature
 - transparent font on edge 830 drawn on 2 color background

    fix perc transparent text -> + background rect 1 smaller red not visible
    - werkt niet op edge, wel op simulator?
    Create test app, met alleen simple transparant text met backcolor
    
- history sensor data


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
