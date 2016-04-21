//Settings

layer_thickness=0.3;

//parameters

hole_1=4.2;
hole_2=3.2;
hole_3=1.7;

size_1=7.5;
size_2=20;
size_3=8;
size_4=9.8;
size_5=10;
size_6=9;

hight_1=15;
hight_2=5;
hight_3=10;
hight_4=7*layer_thickness;



resolution=50;

module body(){
	cube(size = [2*size_1,size_2,hight_1]);
	translate([size_1,0,0])
		cylinder(h=hight_1,r=size_1, $fn=resolution);
	translate([size_1,size_2,0])
		cylinder(h=hight_1,r=size_1, $fn=resolution);
	translate([2*size_1+size_3,-size_1,0])
		cube(size = [size_4,size_2+2*size_1,hight_3]);
	translate([2*size_1,-size_1+size_6,0])
		cube(size = [size_3,2*size_1+size_2-2*size_6,hight_2]);
}



module hole(){
	difference() {
		body();
		translate([size_1,0,0])
			cylinder (h = hight_1, r=hole_1, $fn=resolution);
		translate([size_1,size_2,0])
			cylinder (h = hight_1, r=hole_1, $fn=resolution);
		translate([2*size_1+size_3+size_4/2,size_2/2,0])
			cylinder (h = hight_4, r=hole_2, $fn=6);
		translate([2*size_1+size_3+size_4/2,size_2/2,hight_4+layer_thickness])
			cylinder (h = hight_3, r=hole_3, $fn=resolution);
	}
}

hole();