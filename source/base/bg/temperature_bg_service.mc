using Toybox.Background;
using Toybox.System;
using Toybox.Sensor;
import Toybox.Application.Storage;
module WhatAppBase {
    (:background) 
    class TemperatureBackgroundService extends Toybox.System.ServiceDelegate {
        function initialize() {
            System.ServiceDelegate.initialize();
        }
        
        function onTemporalEvent() as Void {
            var si=Sensor.getInfo();
            System.println(si.temperature);
            Background.exit(si.temperature);    
        }
    }
}