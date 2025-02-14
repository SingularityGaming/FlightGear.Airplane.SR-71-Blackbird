var sr71 = func {
  var IAS = getprop("/velocities/airspeed-kt");
  var mach = getprop("/velocities/mach");
  var alt = getprop("/position/altitude-ft");
  var t0=getprop("/controls/engines/engine[0]/throttle");
  var t1=getprop("/controls/engines/engine[1]/throttle");
  var spoilers = 0;
  var a0=t0*t0;
  var a1=t1*t1;
  var a = getprop("/orientation/alpha-deg");
  var slats = 0;
  var a_stall = 0;

  if (getprop("/controls/gear/gear-down")) {
    spoilers = 0;
  }

  if ((mach > 3.40) and (mach < 3.50)) {
    a0 = 0;
    a1 = 0;
  }

  if ((alt > 90000) and (alt < 95000)) {
    a0 = 0;
    a1 = 0;
  }

  if ((mach >= 3.50) or (alt >= 95000)) {
    a0 = 0;
    a1 = 0;
  }

  if (IAS > 550) {
    spoilers = 0;
    #spoilers+(IAS-550)/100;
  }
  if ((mach > 0.9) and (mach <= 1.0)) {
    spoilers = 0;
  }
  if ((mach > 1.0) and (mach < 1.15)) {
    spoilers = 0;
  }
  if (spoilers > 1) {
    spoilers = 0;
  }

  if (a_stall < 6) {
    a_stall = 0;
  }
  if (a > a_stall) {
    slats=0;
  }
  if (slats > 1) {
    slats = 0;
  }

  setprop("/controls/flight/slats",slats);
  setprop("/controls/engines/engine[0]/afterburner", a0);
  setprop("/controls/engines/engine[1]/afterburner", a1);
  setprop("/controls/flight/spoilers",spoilers);
  settimer(sr71, 0.1);

}

setlistener("sim/signals/fdm-initialized",sr71);
