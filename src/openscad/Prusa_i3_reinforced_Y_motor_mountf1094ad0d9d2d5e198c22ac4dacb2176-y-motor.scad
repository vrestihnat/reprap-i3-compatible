// PRUSA iteration3
// Y motor mount
// GNU GPL v3
// Josef Průša <iam@josefprusa.cz> and contributors
// http://www.reprap.org/wiki/Prusa_Mendel
// http://prusamendel.org

//-- mods by Xoan Sampaiño - A Coruña, May 2013
//--	- added 3rd motor mount point.

//-- further mods by AndrewBCN - Barcelona, November 2014
//--	- added a couple of reinforcements, some code cleanup

$fn=32;


//-- Solid part
module y_motor_base() {
  // Motor holding part
  translate([29,-21+50,0]) {
    translate([-21+4.5,0,5]) cube([9,31,10], center=true);
    translate([-21+4.5+31/2+1,0-31/2-1,5]) cube([31,9,10], center=true);
    translate([-15.5,-15.5,0]) cube([15.5,15.5,10], center=false);
    translate([-15.5,+15.5,0]) cylinder(h = 10, r=5.5);
    translate([+15.5,-15.5,0]) cylinder(h = 10, r=5.5);
    // Joins motor holder and rod plate
    translate([-29,-21,0]) cube(size = [14,30,10]);
  }
  // Front holding part
  translate([-2,20,5]) cube([16,20,10], center=true);	
  translate([0,10,0]) cylinder(h = 10, r=10);
  translate([0,30,0]) cylinder(h = 10, r=10);
  // Reinforcements and smoothing out
  hull() {
    translate([0,30,0]) cylinder(h = 10, r=10);
    translate([29,-21+50,0]) translate([-15.5,+15.5,0]) cylinder(h = 10, r=5.5);
  }
  hull() {
    translate([0,10,0]) cylinder(h = 10, r=10);
    translate([29,-21+50,0]) translate([15.5,-15.5,0]) cylinder(h = 10, r=5.5);
  }
  translate([17,38,5]) rotate([0,0,-10]) cube([2,11.5,10], center=true);
}

//-- Holes
module y_motor_holes() {
  translate([29,-21+50,0]){
    // Screw head holes
    translate([-15.5,-15.5,-1]) cylinder(h = 10, r=1.7);
    translate([-15.5,+15.5,-1]) cylinder(h = 10, r=1.7);
    translate([+15.5,-15.5,-1]) cylinder(h = 10, r=1.7);
    // Screw holes
    translate([-15.5,-15.5,5]) cylinder(h = 7, r=3.5);
    translate([-15.5,+15.5,5]) cylinder(h = 7, r=3.5);
    translate([+15.5,-15.5,5]) cylinder(h = 7, r=3.5);
    // Shaft hole
    translate([0,0,5]) cylinder(h = 11, r = 12, center = true);
  }
  translate([0,10,-1]) cylinder(h = 12, r=4.5);	
  translate([0,30,-1]) cylinder(h = 12, r=4.5);
  // Smooth out
  translate([36.5,20.1,5]) rotate([0,0,8.5]) cube([16,4,20], center=true);
}

// Final assembly
module y_motor() {
  difference() {
    y_motor_base();
    y_motor_holes();
  }
}

y_motor();
