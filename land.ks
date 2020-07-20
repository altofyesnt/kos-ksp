rcs on. //setup
sas off.
lights on.
gear off.
brakes off.
panels off.
clearscreen.
set g to  body:mu / body:radius)^2.
set STEERINGMANAGER:MAXSTOPPINGTIME to 10.
set STEERINGMANAGER:PITCHPID:KD to 2.
set STEERINGMANAGER:YAWPID:KD to 2.
set thrl to 0.
lock throttle to thrl.
set myst to heading(90,0).
lock steering to myst.
SET KUNIVERSE:DEFAULTLOADDISTANCE:FLYING:UNLOAD TO 80000.
SET KUNIVERSE:DEFAULTLOADDISTANCE:FLYING:LOAD TO 80750.
WAIT 0.01.
SET KUNIVERSE:DEFAULTLOADDISTANCE:FLYING:PACK TO 80250.
SET KUNIVERSE:DEFAULTLOADDISTANCE:FLYING:UNPACK TO 80500.
WAIT 0.01.
SET KUNIVERSE:DEFAULTLOADDISTANCE:orbit:UNLOAD TO 80000.
SET KUNIVERSE:DEFAULTLOADDISTANCE:orbit:LOAD TO 80750.
WAIT 0.01.
SET KUNIVERSE:DEFAULTLOADDISTANCE:orbit:PACK TO 80250.
SET KUNIVERSE:DEFAULTLOADDISTANCE:orbit:UNPACK TO 80500.
WAIT 0.01.
set trgt to latlng(-0.0973985310898393,-74.5576282397665).
set runmode to 1.
set sfmode to 1. //setup end
until runmode=0 { //ends when landed
    set ilat to addons:tr:impactpos:lat.
    set ilng to addons:tr:impactpos:lng.
    set dilat to ilat-trgt:lat.
    set dilng to abs(ilng-trgt:lng).
    set thrlng to (dilng/5).
    set lthr to abs((ship:verticalspeed/10)+0.10).
    set latms to (dilat*10).
    set tthrl to (addons:tr:timetillimpact)/10.
    if runmode=1 { //boostback
        if vang(myst,ship:facing:vector)<0.1 and sfmode=1 {
            set myst to Heading(90,90).
            set sfmode to 2.
        }
        if vang(myst,ship:facing:vector)<0.1 and sfmode=2 {
            lock myst to Heading(270-latms,0).
            set sfmode to 3.
        }
        if vang(myst,ship:facing:vector)<0.1 and sfmode=3 {
            lock thrl to thrlng.
            lock throttle to thrl.
            set runmode to 2.
        }
    }
    if runmode=2{ //reentry prepare
        if ilng<-74.5576 {
            unlock thrl.
            set thrl to 0.
            unlock myst.
            brakes on.
            set myst to heading(90,60).
            set runmode to 3.
            AG10 on. //disables all but 3 engines
        }
    }
    if runmode=3 { //landing burn
        if ilng>-74.5576282397665 {
            set myst to heading (90,50).
            if ship:altitude<10000 {
                set myst to heading (90,70).    
            }
        }
        if ilng<-74.5576282397665 {
            set myst to heading (90,70).
            if ship:altitude<10000 {
                set myst to heading (90,50).    
            }
        }
        if addons:tr:timetillimpact<60 {
            set runmode to 4.
        }
    }
    if runmode=4 {
        if ship:verticalspeed<-60 {
            set thrl to lthr * Ship:Mass * g / Ship:AvailableThrust.
        }
        if ship:verticalspeed>-50 and ship:altitude<3000 {
            lock myst to heading(90,90).
            set runmode to 5.  
        }
    }
    if runmode=5 { //landing
        gear on.
        if ship:status=landed {
            set runmode to 0.
        } 
    }
    print "ilat "+ilat + "        " at (5,15).
    print "ilng "+ilng + "        " at (5,16).
    print "dilat "+dilat + "        " at (5,17).
    print "dilng "+dilng + "        " at (5,18).
    print "tti "+ addons:tr:timetillimpact + "        " at (5,19).
    print "thrl " + thrl + "        " at (5,20).
    print "vang " + vang(myst,ship:facing:vector) + "             " at (5,21).
    wait 0.
}
