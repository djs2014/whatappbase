import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Position;
module WhatAppBase {
  (:Utils) 
  module Utils {
    class CurrentLocation {
      var lat = 0;
      var lon = 0;

      function initialize() {}

      function hasLocation() { return self.lat != 0 && self.lon != 0; }

      function infoLocation() {
        return Lang.format("current($1$,$2$)",
                           [ lat.format("%.4f"), lon.format("%.4f") ]);
      }

      function onCompute(info as Activity.Info) {
        try {
          var location = null;
          if (info has : currentLocation && info.currentLocation != null) {
            location = getNewLocation(info.currentLocation);
          }
          if (location == null) {
            var posnInfo = Position.getInfo();
            if (posnInfo has : position && posnInfo.position != null) {
              location = getNewLocation(posnInfo.position);
            }
          }
          if (location != null) {
            self.lat = location[0];
            self.lon = location[1];
          }
        } catch (ex) {
          ex.printStackTrace();
        }
      }

      hidden function getNewLocation(position as Position.Location) {
        if (position == null) {
          return null;
        }
        var location = position.toDegrees();
        var lat = location[0];
        var lon = location[1];
        if (lat.toNumber() != 0 && lon.toNumber() != 0 && self.lat != lat &&
            self.lon != lon) {
          return location;
        }
        return null;
      }

      function getRelativeToObservation(lat, lon) as Lang.String {
        if (!hasLocation()) {
          return "";
        }

        var distanceMetric = "km";
        var distance =
            Utils.getDistanceFromLatLonInKm(self.lat, self.lon, lat, lon);

        var deviceSettings = System.getDeviceSettings();
        if (deviceSettings.distanceUnits == System.UNIT_STATUTE) {
          distance = Utils.kilometerToMile(distance);
          distanceMetric = "m";
        }
        var bearing = Utils.getRhumbLineBearing(self.lat, self.lon, lat, lon);
        var compassDirection = Utils.getCompassDirection(bearing);

        return Lang.format(
            "$1$ $2$ ($3$)",
            [ distance.format("%.2f"), distanceMetric, compassDirection ]);
      }
    }
  }
}
