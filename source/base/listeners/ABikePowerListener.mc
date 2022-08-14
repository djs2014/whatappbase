import Toybox.AntPlus;
import Toybox.System;
import Toybox.Lang;
module WhatAppBase {
    class ABikePowerListener extends AntPlus.BikePowerListener {
        private var _instance as Lang.WeakReference;
        private var _onPedalPowerBalanceUpdate as Lang.Method;

        function initialize(instance as Lang.WeakReference, cbOnPedalPowerBalanceUpdate as Symbol) {    
            BikePowerListener.initialize(); 
            _instance = instance;  
            _onPedalPowerBalanceUpdate = new Lang.Method(_instance.get(), cbOnPedalPowerBalanceUpdate);    
        }
        
        function  onPedalPowerBalanceUpdate(data as AntPlus.PedalPowerBalance) as Void {
            if (data == null) { return; }
            if (data.rightPedalIndicator == null) { return; }
            if (data.pedalPowerPercent == null) { return; }
            _onPedalPowerBalanceUpdate.invoke(data.pedalPowerPercent as Lang.Number, data.rightPedalIndicator as Lang.Boolean);
        }    
    }
}
