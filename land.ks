rcs on. //setup
sas off.
lights on.
gear off.
brakes off.
panels off.
clearscreen.
set g to  body:mu / (altitude + body:radius)^2.
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
lock ilat to addons:tr:impactpos:lat.
lock ilng to addons:tr:impactpos:lng.
lock dilat to ilat-trgt:lat.
lock dilng to abs(ilng-trgt:lng).
lock thrlng to (dilng/5).
lock lthr to abs((ship:verticalspeed/10)+0.10).
lock latms to (dilat*10).
lock sfx to round(ship:facing:vector:X,2).
lock sfy to round(ship:facing:vector:y,2).
lock sfz to round(ship:facing:vector:z,2).
lock sf to V(sfx,sfy,sfz).
lock msx to round(myst:vector:x,2).
lock msy to round(myst:vector:y,2).
lock msz to round(myst:vector:z,2).
lock ms to V(msx,msy,msz).
set runmode to 1.
set sfmode to 1.
lock tthrl to (addons:tr:timetillimpact)/10. //setup end
until runmode=0 { //ends when landed
    if runmode=1 { //boostback
        if sf = ms and sfmode=1 {
            set myst to Heading(90,90).
            set sfmode to 2.
        }
        if sf = ms and sfmode=2 {
            lock myst to Heading(270-latms,0).
            set sfmode to 3.
        }
        if sf = ms and sfmode=3 {
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
        if addons:tr:timetillimpact<60 and ship:verticalspeed<-60 {
            lock thrl to lthr * Ship:Mass * g / Ship:AvailableThrust.
        }
        if ship:verticalspeed>-50 and ship:altitude<3000 {
            lock myst to heading(90,90).
            set runmode to 5.
        }
    }
    if runmode=5 { //landing
        gear on.
        if ship:verticalspeed=0 {
            set runmode to 0.
        } 
    }
    print "ilat "+ilat + "        " at (5,15).
    print "ilng "+ilng + "        " at (5,16).
    print "dilat "+dilat + "        " at (5,17).
    print "dilng "+dilng + "        " at (5,18).
    print "tti "+ addons:tr:timetillimpact + "        " at (5,19).
    print "thrl " + thrl + "        " at (5,20).
    print "ms " + ms + "        " at (5,21).
    print "sf " + sf + "        " at (5,22).
}