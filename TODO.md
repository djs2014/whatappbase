1: what distance
2: temperature @@??@@

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


