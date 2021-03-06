# What app base

Base for `what app` apps. Connect IQ datafield showing up to 4 data:

- Power data (watts)
- Power / body weight
- Heartrate
- Calories
- Training effect (HR must be active)
- Energy expenditure (calories/min)
- Speed
- Cadence
- Distance
- Heading
- Altitude
- Grade
- Ambient pressure (Sealevel / current)
- Time of day

For some data it is possible to set target values:

- Power using FTP value
- Speed
- Cadence
- Distance
- Calories
- Energy expenditure

When there is a target value, it is shown by color and % of field is filled. 
When paused, average values are shown (when available).

Disclaimer: Only tested with Edge 830.

:-( Sadly 
- not possible to use a barrel inside a barrel.
- not able to get the current temparture without a background process
- not able to draw background color with transparancy
- ..
- 
# Resources

https://forums.garmin.com/developer/connect-iq/f/discussion/250/feature-request-add-option-to-draw-a-polygon-at-a-certain-position

TrainingEffect:  https://www.firstbeat.com/en/blog/how-to-use-training-effect/
Grade: https://www.e-education.psu.edu/natureofgeoinfo/book/export/html/1837
Geo: https://www.mathopenref.com/coordintersection.html
Vo2Max: https://www.michael-konczer.com/en/training/calculators/calculate-vo2max
