# A short explanation of the `what xxx datafield`

Available data to show:
 - Power per (x seconds)
   - x is configurable
 - Power per body weight (Based on Garmin user profile)
 - Heartrate
 - Calories burned
 - Training effect
 - Energy expenditure (calories burned per minute)
 - Speed
 - Cadence
 - Distance
 - Heading
 - Altitude
 - Grade
 - Pressure (Ambient or at sealevel)
 - Time of day
 - Elapsed time/timer

For some data a target can be specified. If so, then the background of that field will show the percentage (and color).

### Datafield layout

![Layout](/documents/screenshots/3137.png "Large field layout")

### Example Datafield `What speed`:

- Current speed and percentage to target speed (in this example 30 km/h)
- Calories burned per minute and percentage to target (in this example 15 kcal/min)
- Top info: Heading (Northwest)
- Bottom info: Elapsed distance
 
### Example Datafield `What power`:

- Current power (watt) per kilogram and percentage to target (in this example FTP is 250 watt)
- Current heartrate and percentage to maximum heartrate (based on your Gramin profile)
- Top info: Training effect
- Bottom info: Calories burned

### Example Datafield `What distance`:

- @@TODO

![Layout](/documents/screenshots/9653.png "Activity paused")

When activity is paused, some data will show the average value. Ex. `Speed` and `Power`.

### Color scheme

![Percentage colors](/documents/percentagecolors.png "Color scheme")

### HITT

This option needs a powermeter.
If enabled, when for 5 seconds (configuration) the power is above a threshold (x% of FTP) the HITT is started and a timer is shown.
If power drops below (x% of FTP) for longer than 10 seconds (configuration) the HITT session is stopped.
If the duration was longer than 30 seconds a 'vo2Max'-score is shown.
VO2Max formula used `vo2max = ((6min pow er * 10.8) / weight) + 7`.
(https://www.michael-konczer.com/en/training/calculators/calculate-vo2max)
If the duration is 6 minutes, then the score is close to a 'real' vo2max.


