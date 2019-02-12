$fs=0.2;
$fa=1;

knob_dia=71;
knob_height=19;
knob_cut_angle=46.5;
knob_knurl_depth=2;
knob_dividers=52;  // Should be the number of detents in rotatry encoder
knob_top_roundness=3;

module base_knob(r=knob_dia/2, h=knob_height, roundness=knob_top_roundness) {
    hull() {
	cylinder(r=r,h=1);
	translate([0,0,h - roundness])
	   rotate_extrude(convexity=10) translate([r - roundness,0,0]) circle(r=roundness);
    }
}

function polar_x(r, angle) = r * cos(angle);
function polar_y(r, angle) = r * sin(angle);
function knurl(fraction, knurl_dia=knob_knurl_depth/2) = sin(fraction * 360) * knurl_dia - knurl_dia;

module knob_slice(r=knob_dia/2,segments=knob_dividers, depth=knob_knurl_depth) {
    a = 360 / segments / 15;
    d = depth/2;
    poly = [[0,0],
	[polar_x(r + knurl(0,d),   0*0), polar_y(r + knurl(0,d),0*a)],
	[polar_x(r + knurl(1/15,d),1*a), polar_y(r + knurl(1/15,d),1*a)],
	[polar_x(r + knurl(2/15,d),2*a), polar_y(r + knurl(2/15,d),2*a)],
	[polar_x(r + knurl(3/15,d),3*a), polar_y(r + knurl(3/15,d),3*a)],
	[polar_x(r + knurl(4/15,d),4*a), polar_y(r + knurl(4/15,d),4*a)],
	[polar_x(r + knurl(5/15,d),5*a), polar_y(r + knurl(5/15,d),5*a)],
	[polar_x(r + knurl(6/15,d),6*a), polar_y(r + knurl(6/15,d),6*a)],
	[polar_x(r + knurl(7/15,d),7*a), polar_y(r + knurl(7/15,d),7*a)],
	[polar_x(r + knurl(8/15,d),8*a), polar_y(r + knurl(8/15,d),8*a)],
	[polar_x(r + knurl(9/15,d),9*a), polar_y(r + knurl(9/15,d),9*a)],
	[polar_x(r + knurl(10/15,d),10*a), polar_y(r + knurl(10/15,d),10*a)],
	[polar_x(r + knurl(11/15,d),11*a), polar_y(r + knurl(11/15,d),11*a)],
	[polar_x(r + knurl(12/15,d),12*a), polar_y(r + knurl(12/15,d),12*a)],
	[polar_x(r + knurl(13/15,d),13*a), polar_y(r + knurl(13/15,d),13*a)],
	[polar_x(r + knurl(14/15,d),14*a), polar_y(r + knurl(14/15,d),14*a)],
	[polar_x(r + knurl(15/15,d),15*a), polar_y(r + knurl(15/15,d),15*a)],
	// Add a little bit of overlap to the next slice:
	[polar_x(r + knurl(16/15,d),16*a), polar_y(r + knurl(16/15,d),16*a)],
        [0,0]];
    polygon(points=poly, convexity=2);
}

module knurls(r=knob_dia/2, h=knob_height, depth=knob_knurl_depth,
	      segments = knob_dividers,
	      angle_offset=90 / knob_dividers) {
    linear_extrude(height=h) for (i=[0:360/segments:359]) {
	rotate([0,0,i+angle_offset]) knob_slice(r=r, segments=segments, depth=depth);
    }
}

module knurl_knob(r=knob_dia/2, h=knob_height, depth=knob_knurl_depth, segments=10, roundness=3) {
    intersection() {
	knurls(r=r, h=h, depth=depth, segments=segments);
	base_knob(r=r, h=h, roundness=roundness);
    }
}
