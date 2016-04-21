
/*
import("prusa_Y-Carriage_v2_middle_final_fixed.stl");
*/
union(){
translate([14.1,64.3-2.5-5,0])
cube([2.2,123.2-64.3+2.5+5,8]);

translate([14.1,64.3+5,0])
cylinder(8,2.2,2.2,$fn=16);

translate([14.1,64.3-2.5-5,0])
cylinder(8,2.2,2.2,$fn=16);

translate([0,-41,67])
rotate([0,90,0])
translate([0,0,12])
mirror([0,0,1]){
difference(){
difference(){
union(){
translate([59,41,-2.2])
cube([8,64.3+5,2.2]);																															translate([59,43.1,-0.1])							
rotate([0,0,7.5])
cube([8.5,2.2,14.5]);


translate([58.7,71.7,-0.1])							
rotate([0,0,-7.5])
cube([8.5,2.2,14.5]);

translate([59,103.1,-0.1])							
cube([8.5,2.2,14.5]);

translate([59.3,41.2,12.2])
rotate([0,0,7.5])
cube([8.5,2.5,2.2]);

translate([58.8,73,12.2])
rotate([0,0,-7.5])
cube([8.5,2.5,2.2]);

translate([59,104.2,12.2])
cube([8.5,2.5,2.2]);
}
translate([49,40,-4])
cube([10,140,20]);
}

translate([67,40,-4])
cube([10,140,20]);
}
}
}