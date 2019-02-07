$fn=64;
e=0.01;

screw_head_dia=5.5;
screw_head_high=3.5;
screw_turn_contact=8;   // should be more than screw_head_high
screw_travel=3;

mesh_overlap=3;
inner_turn=screw_head_dia+5; // Should be large enough for washer support spring

spring_pin_dia=3.5;   // Diameter of the spring holding pin
spring_pin_len=3;   // Length of that pin.

outer_wall=1;

// We add 5mm for extra space
inner_hollow=screw_turn_contact + screw_travel + 5;

// The shoulder pokes through the acrylic cover, acting as bearing
shoulder_dia=20;   // Pokes through the acrylic cover
shoulder_high=3;   // thickness of the acrylic.
glue_plate_dia=35;
glue_plate_high=0.6;

// Meshing shape. Can be used as a positive for the screw turn head and as
// a negative for the inside of the knob.
module mesh(is_inner=true) {
     bar=0.3;
     foo=1;
     mesh_r=is_inner ? foo : foo + bar;
     h = is_inner ? screw_turn_contact : inner_hollow;
     cylinder(r=inner_turn/2+(is_inner ? 0 : bar), h=h);
     hull() {
	  translate([inner_turn/2+mesh_overlap-foo, 0, 0]) cylinder(r=mesh_r, h=h);
	  translate([-(inner_turn/2+mesh_overlap-foo), 0, 0]) cylinder(r=mesh_r, h=h);
     }
     hull() {
	  translate([0, inner_turn/2+mesh_overlap-foo, 0]) cylinder(r=mesh_r, h=h);
	  translate([0, -(inner_turn/2+mesh_overlap-foo), 0]) cylinder(r=mesh_r, h=h);
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
     difference() {
	  union() {
	       cylinder(r=inner_turn/2+mesh_overlap+outer_wall,
			h=inner_hollow+outer_wall);
	       cylinder(r=shoulder_dia/2, h=shoulder_high);
	       cylinder(r=glue_plate_dia/2, h=glue_plate_high);
	  }
	  translate([0, 0, -e]) mesh(is_inner=false);
     }
}

knob();
translate([glue_plate_dia-8, 0, 0]) screw_turn_head();
