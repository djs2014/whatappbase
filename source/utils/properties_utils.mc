module WhatAppBase {
import Toybox.Lang;
import Toybox.Test;
import Toybox.Application;
import Toybox.System;

  //typedef Numeric as Number or Float or Long or Double;

  function getStringProperty(key, dflt) {
    // Test.assert(dflt instanceof Lang.String);
    try {
      var val = Application.Properties.getValue(key);
      if (val != null && val instanceof Lang.String && !"".equals(val)) {
        return val;
      }
    } catch (e) {
      return dflt;
    }
    return dflt;
  }

  function getBooleanProperty(key, dflt) {
    return getTypedProperty(key, dflt, Lang.Boolean);
  }

  function getNumberProperty(key, dflt) {
    return getTypedProperty(key, dflt, Lang.Number);
  }

  function getFloatProperty(key, dflt) {
    return getTypedProperty(key, dflt, Lang.Float);
  }

  function getLongProperty(key, dflt) {
    return getTypedProperty(key, dflt, Lang.Long);
  }

  function getDoubleProperty(key, dflt) {
    return getTypedProperty(key, dflt, Lang.Double);
  }

  function getTypedProperty(key, dflt, valueType) {
    // Test.assert(dflt instanceof type);

    try {
      var val = Application.Properties.getValue(key);
      if (val != null && val instanceof valueType) {
        return val;
      }
    } catch (e) {
      return dflt;
    }
    return dflt;
  }

  function setProperty(key, value) {
    Application.Properties.setValue(key, value);
  }
}