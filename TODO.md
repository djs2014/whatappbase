# Todo:
- hitt: no, minimal, normal
  - setEnabled -> mode
    - no and normal, minimal -> no center timer/counter -> is located right bottom
- sound: no, start/stop, quiet, loud
- 

no sound when stopped / only start - or small sound
minimized mode -> not center screen counter/timer
    - show right bottom corner
    - option to show in bw (sunny day)
    - show for x seconds score when proper hit 
x setting enable sound
x hx (vo2 current) xx  xx  xx
x vo2 current gray
if no whatp use whatspeed

x - elapsed < 10 no sound
- display not visible width==0? no sound/ inactive
- #hits>=7 -> no sound
- array of vo2max per hit -> in paused show graph + width is relative duration
-x if paused -> stop hit
- hit label smaller 
- hit only line on small field
- calc vo2 score during/after hit / power graph?
- hide on small screen
- no vo2max display if <= 7
- no power use speed
- lat/lng - double ipv float
- calc avg power 
vo2max = ((6min power * 10.8) / weight) + 7 --> create what_power instance
    -> cycle hit for 6 min => then calculate vo2max

HIIT ipv HIT

SIT = 30-60  sec
- afzien => beep when power < % FTP
HITT = longer yust under anaerobe threshold.



loop 3 time bottom rectangle -> black on red or purple?
cleanup object if not shown ->whatinf..=null
watch air quality
cleanup whatdisplay code
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


# Resources:

https://forums.garmin.com/developer/connect-iq/f/discussion/250/feature-request-add-option-to-draw-a-polygon-at-a-certain-position

trainingEffect  https://www.firstbeat.com/en/blog/how-to-use-training-effect/
grade https://www.e-education.psu.edu/natureofgeoinfo/book/export/html/1837


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
