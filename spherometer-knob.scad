use <knob.scad>

$fn=64;
e=0.01;

is_test=false;  // For faster test-prints
screw_head_dia=5.5;
screw_head_high=3.5;
screw_turn_contact=is_test ? 4 : 8;   // should be more than screw_head_high
screw_travel=3;

mesh_overlap=5;
inner_turn=screw_head_dia+5; // Should be large enough for washer support spring

spring_pin_dia=3.5;   // Diameter of the spring holding pin
spring_pin_len=3;   // Length of that pin.

outer_wall=1;

// We add 5mm for extra space
inner_hollow=screw_turn_contact + screw_travel + (is_test ? 0 : 5);

// The shoulder pokes through the acrylic cover, acting as bearing
shoulder_dia=25;   // Pokes through the acrylic cover
shoulder_high=3;   // thickness of the acrylic.

glue_plate_dia=35;
glue_plate_high=0.6;

module lobe(from_center=4, lobe_len=3, h=10, r=1, flare=0.5, filled=false) {
     lobe_thick=0.5;
     lobe_curl=1;
     translate([-from_center, 0, 0]) difference() {
	  union() {
	       hull() {
		    translate([-lobe_len+r, 0, 0]) cylinder(r=r, h=h);
		    translate([0, -r, 0]) cube([r, r, h]);
	       }
	       hull() {
		    translate([-lobe_len+r, 0, 0]) cylinder(r=r, h=h);
		    if (filled) {
			 translate([0, 0, 0]) cube([r, r, h]);
		    } else {
			 translate([-lobe_curl, flare+r-lobe_curl, 0]) cylinder(r=lobe_curl, h=h);
		    }
	       }
	  }
	  if (!filled) color("red") union() {
	       hull() {
		    translate([-lobe_len+r, 0, -e]) cylinder(r=r-lobe_thick, h=h+2*e);
		    translate([-lobe_curl, flare+r-lobe_curl, -e]) cylinder(r=lobe_curl-lobe_thick, h=h+2*e);
	       }
	       translate([-lobe_len+r, -(r-lobe_thick), -e]) cube([lobe_len, 2*(r-lobe_thick), h+2*e]);
	  }
	  //cube([1, 1, h]);
     }
}

// Meshing shape. Can be used as a positive for the screw turn head and as
// a negative for the inside of the knob.
module mesh(is_inner=true) {
     clearance=is_inner ? 0 : 0.2;
     lobe_radius=2.5;
     mesh_r=is_inner ? lobe_radius : lobe_radius + clearance;
     h = is_inner ? screw_turn_contact : inner_hollow;
     inner_r=inner_turn/2 + clearance;
     flare = is_inner ? 0.2 : 0;
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
     knurl_depth=0.5;
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

intersection() {
     cube([100, 100, 10], center=true);
     union() {
	  knob();
	  translate([30, 0, 0]) screw_turn_head();
     }
}
//translate([0, 5, 0]) lobe(from_center=0);
//color("yellow") translate([0, 0, 0]) lobe(from_center=0);
//lobe2(from_center=0, lobe_len=8, h=15, flare=0.5, filled=true);
