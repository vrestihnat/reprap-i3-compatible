// M8 Bolt length = 30mm
// Bearing width = 7mm (2x)
// Locknut width = 8mm
// leftover for plastic = 8mm (max)
// 3mm wide belt shields

difference() {
 union () {
  difference() {
   // main body
   union() {
    cube([30,33,17]);
    translate([0,0,8.5]) rotate([0,90,0]) cylinder(h=30,r=8.5,$fn=100);
    translate([-1.5,33,8.5]) rotate([0,90,0]) cylinder(h=33,r=8.5,$fn=100);
    translate([0,-8.5,0]) cube([30,8.5,8.5]);
    translate([-1.5,33,0]) cube([33,8.5,8.5]);
   }
   // long inside hole
   translate([-0.5,2.5,4.5]) {
    cube([31,10,8]);
    translate([0,0,4]) rotate([0,90,0]) cylinder(h=31,r=4,$fn=50);
    translate([0,10,4]) rotate([0,90,0]) cylinder(h=31,r=4,$fn=50);
   }
   // bearing cavity
   translate([7,21,-0.5]) cube([16,21,18]);
   // bearing cavity inner curve
   translate([7,27.5,8.5]) rotate([0,90,0]) cylinder(h=16,r=11,$fn=100);
  }
  translate([6,33,8.5]) rotate([0,90,0]) cylinder(h=2,r=6,$fn=50);
  translate([22,33,8.5]) rotate([0,90,0]) cylinder(h=2,r=6,$fn=50);
 }
 // M8 bearing bolt hole
 translate([-0.5,33,8.5]) rotate([0,90,0]) cylinder(h=31,r=4.2,$fn=50);
 // M8 cap screw head recess
 translate([26,33,8.5]) rotate([0,90,0]) cylinder(h=6,r=6.7,$fn=50);
 // M8 hex for bearing bolt recess
 translate([1,33,8.5]) union() {
  cube([6,13,7.43], true);
  rotate([-60,0,0]) cube([6,13,7.43], true);
  rotate([60,0,0]) cube([6,13,7.43], true);
 }
 // tightner bolt holes
 translate([7.5,0,8.5]) rotate([90,0,0]) cylinder(h=10,r=2.2,$fn=30);
 translate([22.5,0,8.5]) rotate([90,0,0]) cylinder(h=10,r=2.2,$fn=30);
 
 // tightner nut holes
 union() {
  translate([3.9,-6,8.5]) cube([7.2,3.4,10]);
  translate([7.5,-4.3,8.5]) union() {
   cube([7.2,3.4,4.11], true);
   rotate([0,-60,0]) cube([7.2,3.4,4.11], true);
   rotate([0,60,0]) cube([7.2,3.4,4.11], true);
  }
 }
union() {
  translate([18.9,-6,8.5]) cube([7.2,3.4,10]);
  translate([22.5,-4.3,8.5]) union() {
   cube([7.2,3.4,4.11], true);
   rotate([0,-60,0]) cube([7.2,3.4,4.11], true);
   rotate([0,60,0]) cube([7.2,3.4,4.11], true);
  }
 }
}