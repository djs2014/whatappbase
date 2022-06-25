import Toybox.Application;
import Toybox.Lang;
import Toybox.Time;
import Toybox.System;
import Toybox.Background;
import Toybox.Sensor;
import Toybox.Application.Storage;

module WhatAppBase {
    (:background)
    class BackgroundServiceDelegate extends System.ServiceDelegate {
        
        function initialize() {
            System.println("BackgroundServiceDelegate initialize");
            ServiceDelegate.initialize();        
        }

        public function onTemporalEvent() as Void {
            System.println("BackgroundServiceDelegate onTemporalEvent");

            var info = {};
            var sensorInfo = Sensor.getInfo();
            if (sensorInfo has :temperature && sensorInfo.temperature != null) {
                //Storage.setValue("Temperature", sensorInfo.temperature);            
                info.put("Temperature", sensorInfo.temperature);
            }    


            Background.exit(info as PropertyValueType);
        }

    }
}