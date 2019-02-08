use <knob.scad>

$fn=64;
e=0.01;

screw_head_dia=5.5;
screw_head_high=3.5;
screw_turn_contact=8;   // should be more than screw_head_high
screw_travel=3;

mesh_overlap=5;
inner_turn=screw_head_dia+5; // Should be large enough for washer support spring

spring_pin_dia=3.5;   // Diameter of the spring holding pin
spring_pin_len=3;   // Length of that pin.

outer_wall=1;

// We add 5mm for extra space
inner_hollow=screw_turn_contact + screw_travel + 5;

// The shoulder pokes through the acrylic cover, acting as bearing
shoulder_dia=25;   // Pokes through the acrylic cover
shoulder_high=3;   // thickness of the acrylic.

glue_plate_dia=35;
glue_plate_high=0.6;

module m(r=1, h=10, flare=0.3, lobe_len=4, extra=0) {
     hull() {
	  translate([0, flare, 0]) cylinder(r=r+flare, h=h+extra);
	  translate([-lobe_len+r, 0, 0]) cylinder(r=r, h=h+extra);
     }
}

module lobe(from_center=4, lobe_len=3, h=10, r=1, flare=0.5, filled=false) {
     lobe_thick=0.5;
     translate([-from_center, 0, 0]) difference() {
	  minkowski() {
	       m(extra=-1, r=r-lobe_thick, h=h, lobe_len=lobe_len-lobe_thick,
		 flare=flare);
	       cylinder(r=lobe_thick, h=1);
	  }
	  if (!filled) translate([0, 0, -e]) {
	       m(extra=1, r=r-lobe_thick, h=h, lobe_len=lobe_len-lobe_thick,
		 flare=flare);
	       cube([4, 4, 15]);
	  }
     }
}

// Meshing shape. Can be used as a positive for the screw turn head and as
// a negative for the inside of the knob.
module mesh(is_inner=true) {
     clearance=is_inner ? 0 : 0.3;
     lobe_radius=2.5;
     mesh_r=is_inner ? lobe_radius : lobe_radius + clearance;
     h = is_inner ? screw_turn_contact : inner_hollow;
     inner_r=inner_turn/2 + clearance;
     flare = is_inner ? 0.3 : 0;
     cylinder(r=inner_r, h=h);
     for (a = [0, 120, 240]) {
	  rotate([0, 0, a]) lobe(from_center=inner_r, r=lobe_radius+clearance, lobe_len=mesh_overlap, h=h, flare=flare, filled=!is_inner);
     }
}

// A device sitting on top of the screw head, that meshes with the knob to be
// turned. Also provides a pin to have a spring sitting on.
module screw_turn_head() {
     difference() {
	  union() {
	       mesh(is_inner=true);
	       cylinder(r=spring_pin_dia/2,
			h=screw_turn_contact+spring_pin_len);
	  }
	  translate([0, 0, -e]) cylinder(r=screw_head_dia/2, h=screw_head_high);
     }
}

// The outside knob, turning the screw turning head
module knob() {
     knurl_depth=0.3;
     difference() {
	  union() {
	       knurl_knob(r=inner_turn/2+mesh_overlap+outer_wall+knurl_depth,
			h=inner_hollow+outer_wall+1,depth=knurl_depth,
			  segments=20);
	       // shoulder to poke through the acrylic
	       cylinder(r=shoulder_dia/2, h=shoulder_high+glue_plate_high);
	       cylinder(r=glue_plate_dia/2, h=glue_plate_high);  // glue pad
	  }
	  translate([0, 0, -e]) mesh(is_inner=false);
     }
}

knob();
translate([30, 0, 0]) screw_turn_head();
