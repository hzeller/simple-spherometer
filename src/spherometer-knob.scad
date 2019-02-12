use <knurled-knob.scad>

$fn=64;
e=0.01;

screw_head_dia=5.5;               // head diameter of an M3 screw
screw_head_high=4;                // Enough space to entirely glue it into there
screw_travel=2;

// The shoulder pokes through the acrylic cover, acting as bearing
shoulder_dia=15;                  // Pokes through the acrylic cover
shoulder_high=3 + screw_travel;   // based on thickness of the acrylic.

glue_plate_dia=25;                // Where the scale is glued onto
glue_plate_high=0.6;

knob_radius=screw_head_dia/2;  // We want it fairly small to 'feel' resistance.

difference() {
     union() {
	  knurl_knob(r=knob_radius, h=20, depth=0.3,
		     segments=12, roundness=knob_radius/2);
	  // shoulder to poke through the acrylic
	  cylinder(r=shoulder_dia/2, h=shoulder_high+glue_plate_high);
	  cylinder(r=glue_plate_dia/2, h=glue_plate_high);  // glue pad

     }
     // Where the screw-head fits into.
     translate([0, 0, -e]) cylinder(r=screw_head_dia/2, h=screw_head_high);
}
