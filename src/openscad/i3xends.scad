//////////////////////////////////////////////////////////////////////////////////////
///
///  I3XENDS - Split X-Ends for Prusa i3, with Endstop and Belt Tensioner
///
///  This file contains a redesign of the X-ends for the Prusa i3, including
///  motor end, idler end with belt tensioner and endstop.
///
///  The design goal is to make the X-ends stronger by splitting them into two
///  interlocking parts, printing the Z-axis related part vertically and the
///  X-axis relating part rotated 90 degrees to the back.  This way, each part
///  is printed in its optimal position, resulting in improved object strength
///  and reduced printing difficulties, such as warping and cracking. The two
///  part are joined by means of a trapezoidal slide and are locked firmly
///  together once the upped X-rod is inserted.
///
///  The idler bearing is mounted on a configurable fork which also acts as a
///  belt tensioner, being attached to the left X-end by means of an ajuster bolt.
///  Idler forks for the following bearing are predefined:
///     2x623ZZ, 2x604ZZ, 2x624Z, 2x625ZZ, 1x608ZZ
///
///  The motor X-end contains has the option for integrating a Z-endstop adjustment
///  screw.
///
///  Finally, the X-endstop holder is implemented a separate object which slides
///  on boths X-rods and is maintained firmly in its position bt means of two locking
///  screws.
///
///  The rod channels and screw holes are defined to be tight.  Use a drill with
///  the corresponding diameter to obtain perfectly fitting cavities.
///
//////////////////////////////////////////////////////////////////////////////////////
///
///  2014-10-24 Heinz Spiess, Switzerland
///
///  released under Creative Commons - Attribution - Share Alike licence (CC BY-SA)
//////////////////////////////////////////////////////////////////////////////////////

// extrusion specific parameters
ew = 0.56;    // extrusion width
eh = 0.3;    // layer height
epsgap = 0.1; // gap between complementing parts
wall = [6*ew, 8*ew, 14*eh, 4*ew]; // wall thickness x/y/z/lm8uu


// build a cube with chamfered edges
module chamfered_cube(size,d=[1,1,1]){
   hull(){
     translate([d[0],d[1],0])cube(size-2*[d[0],d[1],0]);
     translate([0,d[1],d[2]])cube(size-2*[0,d[1],d[2]]);
     translate([d[0],0,d[2]])cube(size-2*[d[0],0,d[2]]);
   }
}


// build a cylinder with chamfered edges
module chamfered_cylinder(r=0,r1=0,r2=0,h=0,d=1){
   hull(){
      translate([0,0,d])cylinder(r1=(r?r:r1),r2=(r>0?r:r2),h=h-2*d);
      cylinder(r1=(r?r:r1)-d,r2=(r>0?r:r2)-d,h=h);
   }
}


//////////////////////////////////////////////////////////////////////////////////////
///
///  The module i3_xend() contains all parts of the project as sub-modules. 
///  (This is convenient since this way, the parameters can easily be shared.)
///
//////////////////////////////////////////////////////////////////////////////////////
module i3_xend(motorend=true, idlerend=false, idler=false, bearing=[5,17,11], endstop=false, zcarriage=true, support=true, idlerclamps=false){
xdist = 45;   // distance between x-rods
xrod = 8;     // diameter of x-rods
lm8uu = 14.9;   // diameter of linear bearing;


motor_d = 42; // motor side length (Nema 17)
motor_s = 31; // motor mounting screws spacing

madj = 2.5;   // screw hole for adjuster screw (cut thread with M3 tap)
m3 = 3;       // motor screw diameter
m3n = 5.5;    // M3 nut diameter
m3nh = 2.5;   // M3 nut height
m5 = 5;       // threaded z-rod diameter
m5n = 8.2;    // nut size on threaded x-rod (not too tight!)
m5nh = 5;     // nut height on threaded x-rod
zsrod = 8;    // diameter of smooth z-rod
ztrod = 5;    // diameter of threaded z-rod
zdist = motor_d/2-zsrod/2; // center-to-center distance between z-rods

idl = 20;     // idler length
idg = 0.25;   // gap for idler
ids = m3;      // idler tensioning screw diameter
idn = m3n;    // idler nut diameter
idnh = m3nh;   // idler nut height

xgap = 10-wall[0]-(lm8uu-xrod)/2;    // gap between x-motor and wall

esl = 15;     // endstop length (along x-rods)
esd = 9.5;    // endstop switch screw distance

//  don't change the following, they are just to make code more readble
ml1 = motor_d+xgap;                    // upper length of motor end left of origin
ml2 = lm8uu/2+2*wall[0]+zdist+m5n;      // length of motor end right of origin
ml3 = motor_d/2-motor_s/4-m3+xgap;      // lower length of motor end left of origin
mlz = wall[0]+lm8uu/2;                  // x-position of smooth zrod
d1 = 2*wall[2]+xrod;                    // height of main body
d2 = wall[2]+xrod-1;                    // height of motor base
h1 = xdist+2*wall[1]+xrod;              // total height

itl = ml2-idl-2*wall[0];                // idler tail length
idh = d1;     // idler height
ith = d1;                               // idler tail height
idd = d1;   // idler depth
idc = d1-1;
idca = -45;


///////////////////////////////////////////////////////////////////////////////
// local module for the interlocking Z-carriage part for motor and idler end
///////////////////////////////////////////////////////////////////////////////
module zcarriage(hole=true,l=h1,eps=0){
   translate([0,0,-eps])difference(){
      union(){
         // outer cylinder for linear bearing holder
         cylinder(r=lm8uu/2+wall[3]+eps,h=l+2*eps);
	 // locking rail
         hull(){
            translate([-lm8uu/2-wall[3]-eps,-lm8uu/2-eps,0])cube([ew+2*eps,lm8uu+2*eps,l+2*eps]);
            translate([-lm8uu/2-eps,-lm8uu/2+wall[3]-eps,0])cube([ew+2*eps,lm8uu-2*wall[3]+2*eps,l+2*eps]);
         }
	 // upper x-rod lock
         translate([-lm8uu/2-d1-eps,-lm8uu-eps,0-eps])chamfered_cube([d1+2*eps,lm8uu+2*eps,d1-1+2*eps],[1,0,1]);
	 // nut holder for threaded z-rod
	 hull(){
	   translate([0,-zdist,0])rotate(30)chamfered_cylinder(r=lm8uu/2+1,h=h1/2-motor_d/2,$fn=6);
	   translate([-lm8uu/2-wall[3],-ml2+mlz-eps+0.01,0])chamfered_cube([wall[3],ml2-mlz+2*eps,h1/2-motor_d/2],[0,1,1]);
	 }
      }
      // lock for nut holder
      hull(){
         translate([-lm8uu/2-wall[2]-0.1,-ml2+mlz,wall[2]+0.5+eps])cube([1,ml2-mlz-lm8uu,h1/2-motor_d/2],[0,1,1]);
         translate([-lm8uu/2-1,-ml2+mlz-1,wall[2]-1+eps])cube([1.01,ml2-mlz-lm8uu+1,h1/2-motor_d/2],[0,1,1]);
      }
      // cavities
      if(hole){
         // cavity for linear bearings
         translate([0,0,-1])cylinder(r=lm8uu/2,h=l+2);
	 // longitudinal cutout to allow flexing
         rotate(210)translate([-1,0,-1])cube([2,lm8uu/2+wall[3]+0.1,l+2]);
	 // x-rod hole throu x-rod lock
         translate([-lm8uu/2-d1/2,1,wall[1]+xrod/2])rotate([90,0,0])rotate(22.5)cylinder(r=xrod/2/cos(22.5),h=lm8uu+2,$fn=8);
	 // hole for threaded z-rod
	 //%color("grey")translate([0,-zdist,-1])cylinder(r=m5/2,h=h1+2,$fn=12);
	 translate([0,-zdist,-1])cylinder(r=m5/2,h=h1/2-motor_d/2+2,$fn=12);
	 // nut cavity for threaded z-rod
	 translate([0,-zdist,h1/2-motor_d/2-m5nh])rotate(30)cylinder(r=m5n/2/cos(30),h=m5nh+1,$fn=6);
      }
   }
}


///////////////////////////////////////////////////////////////////////////////
// local module to build the base of the motor end
///////////////////////////////////////////////////////////////////////////////
module motorend(){
difference(){
union(){
difference(){
   union(){
      // main body upper part
      hull(){
         translate([-ml1,-1,0])
            chamfered_cube([ml1+ml2,h1/2+1,d2]);
         translate([-ml3,-1,0])
            chamfered_cube([ml3+ml2,h1/2+1,d1]);
      }
      // main body lower part
      translate([-ml3,-h1/2,0])
         chamfered_cube([ml3+ml2,h1/2+2,d1]);
      // z-adjuster screw base
      if(endstop)
         hull()for(xz=[[0,d1/2,6],[0,d1+lm8uu/2,36],[10,d1-5,6]])
            translate([-motor_d/2-xgap+motor_s/2+xz[0],-h1/2,xz[1]])rotate([-90,0,0])
               chamfered_cylinder(r=motor_s/2-motor_s/4-m3,h=h1/2-motor_d/2,$fn=xz[2]);

   }

   for(sy=[-1,1])scale([1,sy,1]){
      // x-rod holes
      translate([0,xdist/2,d1/2])rotate([0,90,0])rotate(22.5)cylinder(r=xrod/2/cos(22.5),h=ml2+1,$fn=8);
      // holes for motor screws
      for(fx=[-1,1])translate([-xgap-motor_d/2+fx*motor_s/2,motor_s/2,-1]){
         // main screw holes
         cylinder(r=m3/2,h=d2+1,$fn=6);
         // cavities for screw heads
	 translate([0,0,7]) cylinder(r=m3,h=d1+2,$fn=12);
      }
   }
   
   // main belt channel 
   translate([-motor_d-xgap-1,-motor_d/4,wall[2]])
      cube([motor_d+xgap+ml2+2,motor_d/2,xrod]);
   hull(){
      translate([-xgap-wall[0],-motor_d/4,wall[2]])
         cube([xgap+ml2+2,motor_d/2,xrod]);
      translate([0,-motor_s/2+2,wall[2]])
         cube([ml2+2,motor_s-4,xrod]);
   }
   // upper motor cavity
   translate([-motor_d-xgap-1,-motor_d/2,d2])
      cube([motor_d+xgap,motor_d,wall[2]+2]);
   //main cutout for motor
   translate([-motor_d-xgap-1,-motor_d/4,-1])
      cube([motor_d,motor_d/2,wall[2]+xrod+2]);
   // octogonal cutout centered on motor axis
   translate([-xgap-motor_d/2,0,0])hull()for(a=[0,90])rotate(a)
      cube([motor_d/2,motor_s-2,motor_d],true);

    // Z-adjuster screw hole
    if(endstop)
       translate([-motor_d/2-xgap+motor_s/2,-h1/2,d1+lm8uu/2])rotate([-90,0,0])
          translate([0,0,-1])cylinder(r=madj/2,h=h1/2+wall[1]-motor_d/2+2,$fn=6);
}
 
    // belt separating wall 
    translate([0,-wall[1]/2,0])chamfered_cube([ml2,wall[1],d1]);
}
   // cutout for linear bearings holder
    translate([wall[0]+lm8uu/2,h1/2,d1+lm8uu/2])rotate([90,0,0])
       rotate(90){
          zcarriage(hole=false,eps=epsgap);
          if(!support)%color("cyan")zcarriage(hole=true);
       }

}

    if(zcarriage)translate([-motor_d+xgap,0,0])rotate(90)
       zcarriage(hole=true);
}

///////////////////////////////////////////////////////////////////////////////
// local module to build the idler fork for the specified bearing parameters
//    bearing[0]   inner diameter (axis)
//    bearing[1]   outer diameter (incl. belt)
//    bearing[2]   width of bearing (incl. washers)
///////////////////////////////////////////////////////////////////////////////
module idler(){
   assign(idD = bearing[2]+2*wall[2])
   assign(idE = bearing[1]/2)
   difference(){
      union(){
         // main body
	 hull(){
            translate([0,-idd/2,0])chamfered_cube([idl,idd,idh]);
            translate([-idE-2,-idD/2,0])chamfered_cube([idl/2+idE,idD,idh]);
	    // front end
            translate([-idE+1,-idD/2,idh/2])rotate([-90,0,0])rotate(0)chamfered_cylinder(r=idh/2,h=idD);
	 }
	 // tail
         translate([0,-idd/2+wall[2]+epsgap,0])chamfered_cube([ml2-2*wall[0],idd-2*wall[2]-2*epsgap,idh]);
      }
      // hole tensioning screw
      translate([-1,0,d1/2])rotate([0,90,0])rotate(30)cylinder(r=ids/2,h=ml2+2,$fn=6);
      // axis hole
      translate([-idE+bearing[0]/2,-idD/2-1,d1/2])rotate([-90,0,0])cylinder(r=bearing[0]/2,h=idD+2);
      hull(){
         // bearing cavity 
         translate([-idE+2,-bearing[2]/2,d1/2])rotate([-90,0,0])cylinder(r=max(bearing[1],idh/cos(30)+2)/2,h=bearing[2]);
         // main cavity
         translate([-idd-1,-idd/2+wall[1],-1])chamfered_cube([idd+idl-wall[0]+1,idd-2*wall[1],idh+2]);
      }
      // tensioning nut cage
      hull()for(y=[0,xrod])translate([(idl+ml2-3*wall[1])/2,y,d1/2])rotate([0,90,0])
         rotate(30)cylinder(r=idn/2/cos(30)+(y?0.4:0),h=idnh,$fn=6);
   }
     
}

///////////////////////////////////////////////////////////////////////////////
// local module to build the idler X-end
///////////////////////////////////////////////////////////////////////////////
module idlerend(){
   difference(){
      union(){
         // main body
         translate([0,-h1/2,0]) chamfered_cube([ml2,h1,d1]);
	 // idler clamp screws
	 if(idlerclamps)for(sy=[-1,1])scale([1,sy,1]){
	     translate([ml2-idc/2,-xdist/2,d1/2])rotate([idca,0,0])chamfered_cylinder(r=idc/2,h=d1/2+m3nh+wall[2],d=2,$fn=36);
	 }
      }
   
      for(sy=[-1,1])scale([1,sy,1]){
         // x-rod holes
         translate([-1,xdist/2,d1/2])rotate([0,90,0])rotate(22.5)cylinder(r=xrod/2/cos(22.5),h=ml2+2,$fn=8);
      }
      
      // idler clamp screw
      if(idlerclamps)for(sy=[-1,1])scale([1,sy,1])
         translate([ml2-idc/2,-xdist/2,d1/2])rotate([idca,0,0]){
           // idler clamp screw head cavity (if needed)
	   cylinder(r=m3/2,h=d1/2+m3nh+wall[2]+3,$fn=6);
           // idler clamp screw holes
	   translate([0,0,d1/2+m3nh+wall[2]+0.01])cylinder(r=m3,h=d1/2+m3nh+wall[2]+3,$fn=12);
           // idler clamp screw nut traps
	   hull()for(x=[0,idc/2+.1])translate([x,0,xrod/2+wall[2]-1-epsgap/2])
	      cylinder(r=m3n/2+(x?0.35:epsgap),h=m3nh+epsgap,$fn=6);
      }
      // main belt channel 
      translate([-1,-motor_s/2+(idlerclamps?3.5:2),wall[2]-eh])
         cube([ml2+2,motor_s-(idlerclamps?7:4),xrod+eh]);
   
      // idler cut-out
      translate([ml2-idl-idg,-idh/2-idg,-0.01])chamfered_cube([idl+10,idh+2*idg,d1+0.02],[1,0,1]);
   
 
      // cutout for linear bearings holder
      translate([wall[0]+lm8uu/2,h1/2,d1+lm8uu/2])rotate([90,0,0])
         rotate(90){
            zcarriage(hole=false,eps=epsgap);
            if(!support)%color("cyan")zcarriage(hole=true);
         }
   }
   // idler support structure (cut away after printing!)
   if(support)color("red")difference(){
      union(){
         translate([ml2-idl-2,-idh/2-2,d1-wall[2]])cube([idl+2,idh+4,eh]);
         translate([ml2-idl+1,-idh/2+1,0])cube([idl-1,idh-2,d1-wall[2]]);
      }
      translate([ml2-idl+1+2,-idh/2+1+2,-1])cube([idl-1,idh-2-4,d1-wall[2]+2]);
   }else{  // draw idler
      %color("green")translate([ml2+5,idd/2,idh/2])rotate([90,0,0])rotate(180)idler();
   }

   // tail cage for idler fork
   difference(){
      translate([0,-ith/2-wall[1]+(idlerclamps?1:0),wall[2]-eh-0.01])cube([ml2-idl,ith+2*wall[1]-(idlerclamps?2:0),xrod+eh+0.02]);
      translate([2*wall[0],-ith/2-idg,wall[2]])cube([ml2-idl-2*wall[0]+1,ith+2*idg,xrod]);
      translate([-1,0,d1/2])rotate([0,90,0])cylinder(r=ids/2,h=2*wall[0]+2);
   }

    
   // build separate interlocking z-carriage part
   if(zcarriage)translate([-2*lm8uu,h1/3,0]) rotate(90)zcarriage(hole=true);
}

///////////////////////////////////////////////////////////////////////////////
// local module to build the X-endstop
///////////////////////////////////////////////////////////////////////////////
module endstop(){
   difference(){
      union(){
         // main body upper part
         translate([0,-h1/2,0]) chamfered_cube([esl,h1,d1+m3nh+wall[2]]);
      }

      for(sy=[-1,1])scale([1,sy,1]){
         // x-rod holes
         translate([-1,xdist/2,d1/2])rotate([0,90,0])
            rotate(22.5)cylinder(r=xrod/2/cos(22.5),h=esl+2,$fn=8);
         // x-rod nut cavities
         hull()for(x=[0,esl/2])translate([x,xdist/2,d1-1])
            rotate(30)cylinder(r=m3n/2/cos(30)+(x?0.2:0),h=m3nh,$fn=6);
         // x-rod clamping screw holes - lower part
         translate([esl/2,xdist/2,d1-wall[2]])cylinder(r=m3/2,h=wall[2],$fn=6);
         // x-rod clamping screw holes - upper part
         translate([esl/2,xdist/2,d1+m3nh-1+eh])cylinder(r=m3/2,h=wall[2]+2,$fn=6);
         // end switch screw slots
         for(i=[0:1])translate([esl/2-m3/2,i*esd+esd/8,d1+m3nh])
            cube([m3,0.75*esd,wall[2]+1]);
         translate([esl/2,-xdist/2+xrod/2+wall[1]+0.5,0])cylinder(r1=0,r2=m3+1,h=d1+m3nh-0.01);
      }
         
      // belt channel 
      translate([-1,-xdist/2+xrod/2+wall[1],-1])
         cube([ml2+2,xdist-xrod-2*wall[1],xrod+2*wall[2]+m3nh+1]);
      translate([esl/2-m3/2,-motor_s/2,d1+m3nh-eh])
         cube([m3,motor_s,3*eh]);
   }
   // bridging support  
   if(support)color("red")hull(){
      translate([2,-2,0])cube([esl-4,4,1]);
      translate([-1,-ew/2,d1+m3nh-1])cube([esl+2,ew,1]);
   }

}
   
//  now build the desired part(s)

if(motorend)motorend();

if(endstop && !motorend)endstop();

if(idlerend)
   scale([-1,1,1])idlerend();
if(idler)
   translate([35,20,0])rotate(180)idler();

if(zcarriage && !motorend && !idlerend && !endstop &&!idler)zcarriage();

}

//////////////////////////////////////////////////////////////////////////////
///  Modules for automatic building of specific STL file via Makefile
//////////////////////////////////////////////////////////////////////////////

module motorxend(){ // AUTO_MAKE_STL
   i3_xend(motorend=true,idlerend=false,idler=false);
}

module motorxend_zendstop(){ // AUTO_MAKE_STL
   i3_xend(motorend=true,idlerend=false,idler=false,endstop=true);
}

module idlerxend(){ // AUTO_MAKE_STL
   i3_xend(motorend=false,idlerend=true,idler=false);
}

module idlerxend_xrodclamps(){ // AUTO_MAKE_STL
   i3_xend(motorend=false,idlerend=true,idler=false,idlerclamps=true);
}

module xendstop(){ // AUTO_MAKE_STL
   i3_xend(motorend=false,idlerend=false,idler=false,endstop=true);
}

module idler2x625(){ // AUTO_MAKE_STL
   i3_xend(motorend=false,idlerend=false,idler=true,bearing=[5,17,11]);
}

module idler2x624(){ // AUTO_MAKE_STL
   i3_xend(motorend=false,idlerend=false,idler=true,bearing=[4,14,11]);
}

module idler2x623(){ // AUTO_MAKE_STL
   i3_xend(motorend=false,idlerend=false,idler=true,bearing=[3,11,9]);
}

module idler2x604(){ // AUTO_MAKE_STL
   i3_xend(motorend=false,idlerend=false,idler=true,bearing=[4,13,9]);
}

module idler608(){ // AUTO_MAKE_STL
   i3_xend(motorend=false,idlerend=false,idler=true,bearing=[8,18,8]);
}

//////////////////////////////////////////////////////////////////////////////
///  Uncomment as needed for manual printing
//////////////////////////////////////////////////////////////////////////////

//i3_xend(motorend=false,idlerend=true,idler=false,support=true,zcarriage=false,idlerclamps=true);
//scale([-1,1,1])i3_xend(motorend=false,idlerend=false,idler=false,support=false,zcarriage=true,idlerclamps=false);
//idlerxend();
//motorxend();
//motorxend_zendstop();
idlerxend_xrodclamps();
//xendstop();
//idler2x625();
//idler2x623();
//idler2x604();
//idler608();
//
/// show all in print position:
//motorxend_zendstop();
//translate([55,0,0])xendstop();
//translate([120,0,0])idlerxend();
//translate([110,-45,0])rotate(180)idler2x604();
//
/// show all in working position:
//rotate(180)translate([30,90,0])
//{translate([-50,0,0])i3_xend(motorend=true,idlerend=false,idler=false,support=false,zcarriage=false);
//translate([85,0,0])i3_xend(motorend=false,idlerend=true,idler=false,support=false,zcarriage=false);
//i3_xend(motorend=false,idlerend=false,endstop=true,support=false,zcarriage=false);}
//translate([-50,0,0])i3_xend(motorend=true,idlerend=false,idler=false,support=false,zcarriage=false);
//translate([85,0,0])i3_xend(motorend=false,idlerend=true,idler=false,support=false,zcarriage=false);
//i3_xend(motorend=false,idlerend=false,endstop=true,support=false,zcarriage=false);
