

$fa = 15;
$fs = 0.6;
phi = (1 + sqrt(5)) / 2;  // The golden ratio
pi = 3.14159;
imax = 680;

a_bit = 0.01;
a_bit_more = a_bit * 2;

// The dimensions of the front of the speaker cone -
// gives the size of the speaker grille opening
spkr_cone_h = 34;
spkr_cone_w = 64;
spkr_cone_r = spkr_cone_h/2;
spkr_cone_centre_offset = (spkr_cone_w/2) - (spkr_cone_r);

// The dimensions of the felt border around the speaker cone -
// gives the size of the mounting "pad" on which it sits
spkr_border_h = 38;
spkr_border_w = 69;
spkr_border_r = spkr_border_h/2;
spkr_border_centre_offset = (spkr_border_w/2) - (spkr_border_r);
spkr_border_depth = 0.5;

// The distances between the speaker mounting holes
spkr_holes_h = 34;
spkr_holes_w = 64;
spkr_holes_r = 3.5 / 2;

// dimesions of speaker rectangular flange
spkr_w = 71;
spkr_h = 42;

spkr_grille_clearance = 1;
spkr_grille_thickness = 1;
case_front_thickness = spkr_grille_thickness + spkr_grille_clearance + spkr_border_depth;
case_wall_thickness = 2;
case_rear_thickness = 3;

case_outside_h = spkr_h + (case_wall_thickness * 2);
case_outside_r = case_outside_h / 2;
case_outside_w = spkr_w + (case_outside_r * 2);
case_side_offset = (spkr_w / 2);
case_outside_d = 120;

case_inside_h = spkr_h;
case_inside_r = case_inside_h / 2;
case_inside_w = spkr_w + (case_inside_r * 2);

crm_w = 9;
crm_h = 5;
crm_d = 6;
crm_offset_w = (case_outside_w / 2) - case_wall_thickness - 6;
crm_hole_r = 2.5 / 2;
crm_hole_d = 5;

sw_offset_d = 40;
sw_offset_w = spkr_holes_w / 2;
sw_holes_d = 41;
sw_holes_r = 3.5 / 2;
sw_slot_w = 2;
sw_slot_d = 23;


// The raspberry pi mounting holes
pi_supp_w = 8;
pi_supp_d = 34;
pi_supp_h = 10;
pi_supp_thickness = 2;
pi_holes_w = 58;
pi_holes_d = 23;
pi_holes_clearance_z = 3.5;
pi_holes_r = 3 / 2;
pi_supp_offset_x = (pi_holes_w / 2) + (pi_supp_thickness / 2);
pi_supp_offset_z = case_outside_d - (pi_supp_d / 2);
pi_supp_offset_y = (pi_supp_thickness / 2) - 5;
pi_holes_offset_x = pi_holes_w / 2;
pi_holes_offset_y = pi_supp_offset_y + pi_supp_thickness;
pi_holes_offset_z = case_outside_d - case_rear_thickness - pi_holes_clearance_z;

usb_hole_offset_x = 21.5;
usb_hole_offset_y = pi_supp_offset_y + 4;
usb_rebate_thickness = 1;
usb_rebate_depth = case_rear_thickness - usb_rebate_thickness;

pb_supp_w = 5;
pb_supp_d = 10;
pb_supp_thickness = 2;
pb_holes_clearance_z = 3.5;
pb_holes_r = 3 / 2;
pb_holes_w = 58;
pb_supp_offset_x = pb_holes_w / 2;
pb_supp_offset_z = case_outside_d - (pb_supp_d / 2);
pb_supp_offset_y = pi_supp_offset_y + 15;
pb_holes_offset_x = pb_holes_w / 2;
pb_holes_offset_y = pb_supp_offset_y + pb_supp_thickness;
pb_holes_offset_z = case_outside_d - case_rear_thickness - pb_holes_clearance_z;


btns_w = 4;
btns_r = 1.5;
btns_d = 3;
btns_pitch = 11;
btns_rebate_thickness = 1;
btns_rebate_depth = case_rear_thickness - btns_rebate_thickness;
btns_striker_w = 2;
btns_striker_h = 3;
btns_striker_d = btns_rebate_depth + 1;
btns_clearance_r = btns_r + 0.4;
btns_offset_y=pi_supp_offset_y+14;
btns_spring_h=0.4;
btns_spring_d=1.5;
btns_spring_r=2.75;


vol_r = 7 / 2;
vol_fence_thickness = 2;
vol_fence_w = 12.4 + vol_fence_thickness;
vol_fence_h=2;
vol_d = 12;

vol_tab_r = 1.5;
vol_tab_h = 1;
vol_tab_offset_d=6;

* front_face();
* side_walls();
rear_face();
* buttons();

module front_face() {
  // Construct the front face
  difference() {

    // the front plate
    stadium(radius=case_outside_r, length=spkr_w, height=case_front_thickness, quality=100);
    
    // Remove the speaker grille holes
    intersection() {
    
      // Speaker grille outline
      translate([0,0,-a_bit])
        stadium(radius=spkr_cone_r, length=spkr_cone_centre_offset*2, height=spkr_grille_thickness + a_bit_more, quality=50);
        
      // Speaker grille holes - a golden spiral
      union() {
        for (i = [160:imax]) {
          th = i * 360 * phi * 20;
          r = i* 0.05;
          x = r * sin(th);
          y = r * cos(th);
          translate([x, y, -a_bit]) 
              cylinder(h = spkr_grille_thickness + a_bit_more, r = i * 0.0023);
        }
      
      // Pi symbol  
      translate([0,0,-a_bit])
        linear_extrude(spkr_grille_thickness + a_bit_more)
          mirror([1,0,0])
            text("\u03C0", font="GFS Didot:style=Bold", halign="center", valign="center");
      }
      
    }
    
    // remove the speaker cutout behind the grille
    translate([0,0,spkr_grille_thickness])
      stadium(radius=spkr_cone_r, length=spkr_cone_centre_offset*2, height=case_front_thickness, quality=50);
  
    // remove the speaker mounting border
    translate([0,0,spkr_grille_thickness + spkr_grille_clearance])
      stadium(radius=spkr_border_r, length=spkr_border_centre_offset*2, height=spkr_border_depth * 2, quality=50);
  
    // remove the speaker mounting holes
    union() {
      translate([-spkr_holes_w / 2, -spkr_holes_h / 2, -case_front_thickness / 2])
        cylinder(h=case_front_thickness * 2, r=spkr_holes_r);
      translate([spkr_holes_w / 2, -spkr_holes_h / 2, -case_front_thickness / 2])
        cylinder(h=case_front_thickness * 2, r=spkr_holes_r);
      translate([spkr_holes_w / 2, spkr_holes_h / 2, -case_front_thickness / 2])
        cylinder(h=case_front_thickness * 2, r=spkr_holes_r);
      translate([-spkr_holes_w / 2, spkr_holes_h / 2, -case_front_thickness / 2])
        cylinder(h=case_front_thickness * 2, r=spkr_holes_r);
    }
  }
  
}

module side_walls() {
// Construct the side walls

  

  difference() {
    // create the body
    stadium(radius=case_outside_r, length=spkr_w, height=case_outside_d, quality=100);
    
    // cut out the interior
    translate([0,0,-a_bit])
      stadium(radius=case_inside_r, length=spkr_w, height=case_outside_d+a_bit_more, quality=100);
    
    // cut out switch mountings
    
    // switch slots
    translate([sw_offset_w,case_inside_r-a_bit,sw_offset_d]) 
      rotate([-90,90,0])
        stadium(radius=sw_slot_w/2, length = sw_slot_d, height = case_wall_thickness + a_bit_more, quality = 20);
    translate([-sw_offset_w,case_inside_r-a_bit,sw_offset_d]) 
      rotate([-90,90,0])
        stadium(radius=sw_slot_w/2, length = sw_slot_d, height = case_wall_thickness + a_bit_more, quality = 20);
    
    // switch screw holes
    translate([sw_offset_w, case_inside_r-a_bit, sw_offset_d-(sw_holes_d/2)]) 
      rotate([-90,0,0])
        cylinder(r = sw_holes_r, h = case_wall_thickness + a_bit_more);
    translate([sw_offset_w, case_inside_r-a_bit, sw_offset_d+(sw_holes_d/2)]) 
      rotate([-90,0,0])
        cylinder(r = sw_holes_r, h = case_wall_thickness + a_bit_more);
    translate([-sw_offset_w, case_inside_r-a_bit, sw_offset_d-(sw_holes_d/2)]) 
      rotate([-90,0,0])
        cylinder(r = sw_holes_r, h = case_wall_thickness + a_bit_more);
    translate([-sw_offset_w, case_inside_r-a_bit, sw_offset_d+(sw_holes_d/2)]) 
      rotate([-90,0,0])
        cylinder(r = sw_holes_r, h = case_wall_thickness + a_bit_more);
        
    // cut out volume encoder mounting hole
    translate([0, case_inside_r-a_bit, sw_offset_d]) 
      rotate([-90,0,0])
        cylinder(r = vol_r, h = case_wall_thickness + a_bit_more);
    // cut out volume encoder tab recess
    translate([0, case_inside_r-a_bit, sw_offset_d-vol_tab_offset_d]) 
      rotate([-90,0,0])
        cylinder(r = vol_tab_r, h = vol_tab_h + a_bit);
   
    }

  // create volume encoder "fences"
  translate([-vol_fence_w/2, case_inside_r-(vol_fence_h/2), sw_offset_d]) 
    cube([vol_fence_thickness,vol_fence_h,vol_d],center=true);
  translate([vol_fence_w/2, case_inside_r-(vol_fence_h/2), sw_offset_d]) 
    cube([vol_fence_thickness,vol_fence_h,vol_d],center=true);
  
  // create rear lip
  
  difference() {
    translate([0,0,case_outside_d-case_rear_thickness-2])
      stadium(radius=case_inside_r, length=spkr_w, height=2, quality=100);
    union() {
      for (i = [0:6]) {
        translate([0,0,case_outside_d-case_rear_thickness-((6-i)/3)-0.95])
          stadium(radius=case_inside_r-(i/3), length=spkr_w, height=(i/3)+1, quality=100);
      }
    }
  }
  
  // create rear panel screw holes
/*  crm_w = 9;
crm_h = 5;
crm_d = 15;
crm_offset_w = (case_outside_w / 2) - case_wall_thickness - 5;
  */
  difference(){
  union() {
    translate([crm_offset_w+2,0,case_outside_d-case_rear_thickness-(crm_d/2)])
      cube([crm_w,crm_h,crm_d],center=true);
    translate([crm_offset_w+2, 0, case_outside_d-case_rear_thickness-crm_d-crm_w])
      rotate([90,0,180])
        linear_extrude(height=crm_h,center=true)
          polygon([[-crm_w/2,-crm_w],[-crm_w/2,crm_w],[crm_w/2,crm_w]]);
    translate([-crm_offset_w-2,0,case_outside_d-case_rear_thickness-(crm_d/2)])
      cube([crm_w,crm_h,crm_d],center=true);
    translate([-crm_offset_w-2, 0, case_outside_d-case_rear_thickness-crm_d-crm_w])
      rotate([90,0,0])
        linear_extrude(height=crm_h,center=true)
          polygon([[-crm_w/2,-crm_w],[-crm_w/2,crm_w],[crm_w/2,crm_w]]);
  }
  
  translate([crm_offset_w,0,case_outside_d-case_rear_thickness-crm_hole_d])
    cylinder(h=crm_hole_d + a_bit, r=crm_hole_r);
  
  translate([-crm_offset_w,0,case_outside_d-case_rear_thickness-crm_hole_d])
    cylinder(h=crm_hole_d + a_bit, r=crm_hole_r);
  }
}

module rear_face() {
  
  difference() {
  union() {
    // construct the rear face
    translate([0,0,case_outside_d-case_rear_thickness])
      stadium(radius=case_inside_r-0.5, length=spkr_w, height=case_rear_thickness, quality=100);

    // construct the raspberry pi supports
  
    translate([-pi_supp_offset_x, pi_supp_offset_y, pi_supp_offset_z])
      cube([pi_supp_w,pi_supp_thickness,pi_supp_d], center=true);
    translate([pi_supp_offset_x, pi_supp_offset_y, pi_supp_offset_z])
      cube([pi_supp_w,pi_supp_thickness,pi_supp_d], center=true);
   
    translate([-pi_supp_offset_x-(pi_supp_w/2)+(pi_supp_thickness/2), -pi_supp_h/2+pi_supp_offset_y, pi_supp_offset_z])
      rotate([90,0,-90])
        linear_extrude(height=pi_supp_thickness,center=true)
          polygon([[-pi_supp_h/2,-pi_supp_d/2],[-pi_supp_h/2,pi_supp_d/2],[pi_supp_h/2,pi_supp_d/2]]);
    translate([pi_supp_offset_x+(pi_supp_w/2)-(pi_supp_thickness/2), -pi_supp_h/2+pi_supp_offset_y, pi_supp_offset_z])
      rotate([90,0,-90])
        linear_extrude(height=pi_supp_thickness,center=true)
          polygon([[-pi_supp_h/2,-pi_supp_d/2],[-pi_supp_h/2,pi_supp_d/2],[pi_supp_h/2,pi_supp_d/2]]);
    
    // construct the pHat Beat supports
  
    translate([-pb_supp_offset_x, pb_supp_offset_y, pb_supp_offset_z])
      cube([pb_supp_w,pb_supp_thickness,pb_supp_d], center=true);
    translate([pb_supp_offset_x, pb_supp_offset_y, pb_supp_offset_z])
      cube([pb_supp_w,pb_supp_thickness,pb_supp_d], center=true);
  }
  
  // remove raspberry pi mounting holes
  
  translate([-pi_holes_offset_x, pi_holes_offset_y, pi_holes_offset_z]) 
    rotate([90,0,0])
      cylinder(r = pi_holes_r, h = pi_supp_thickness * 2);
  translate([-pi_holes_offset_x, pi_holes_offset_y, pi_holes_offset_z-pi_holes_d]) 
    rotate([90,0,0])
      cylinder(r = pi_holes_r, h = pi_supp_thickness * 2);
  translate([pi_holes_offset_x, pi_holes_offset_y, pi_holes_offset_z]) 
    rotate([90,0,0])
      cylinder(r = pi_holes_r, h = pi_supp_thickness * 2);
  translate([pi_holes_offset_x, pi_holes_offset_y, pi_holes_offset_z-pi_holes_d]) 
    rotate([90,0,0])
      cylinder(r = pi_holes_r, h = pi_supp_thickness * 2);
  
  // remove pHat Beat mounting holes
  
  translate([-pb_holes_offset_x, pb_holes_offset_y, pb_holes_offset_z]) 
    rotate([90,0,0])
      cylinder(r = pb_holes_r, h = pb_supp_thickness * 2);
  translate([pb_holes_offset_x, pb_holes_offset_y, pb_holes_offset_z]) 
    rotate([90,0,0])
      cylinder(r = pb_holes_r, h = pb_supp_thickness * 2);
  
  
  // remove micro usb power slot
  translate([usb_hole_offset_x, usb_hole_offset_y, case_outside_d - case_rear_thickness - a_bit])
    stadium(radius = 2, length = 6, height = case_rear_thickness + a_bit_more, quality = 50);
  // remove rebate for micro usb power slot
  translate([0, usb_hole_offset_y, case_outside_d - case_rear_thickness - a_bit])
    stadium(radius = 3, length = 50, height = usb_rebate_depth + a_bit, quality = 50);


  
  // remove button slots
  translate([0, btns_offset_y, case_outside_d - btns_rebate_thickness - a_bit])
    stadium(radius = btns_clearance_r, length = btns_w, height = btns_rebate_thickness + a_bit_more, quality = 50);
  translate([btns_pitch, btns_offset_y, case_outside_d - btns_rebate_thickness - a_bit])
    stadium(radius = btns_clearance_r, length = btns_w, height = btns_rebate_thickness + a_bit_more, quality = 50);
  translate([btns_pitch * 2, btns_offset_y, case_outside_d - btns_rebate_thickness - a_bit])
    stadium(radius = btns_clearance_r, length = btns_w, height = btns_rebate_thickness + a_bit_more, quality = 50);
  translate([-btns_pitch, btns_offset_y, case_outside_d - btns_rebate_thickness - a_bit])
    stadium(radius = btns_clearance_r, length = btns_w, height = btns_rebate_thickness + a_bit_more, quality = 50);
  translate([-btns_pitch * 2, btns_offset_y, case_outside_d - btns_rebate_thickness - a_bit])
    stadium(radius = btns_clearance_r, length = btns_w, height = btns_rebate_thickness + a_bit_more, quality = 50);
  // remove rebate for buttons
  translate([0, btns_offset_y, case_outside_d - case_rear_thickness - a_bit])
    stadium(radius = 3, length = 50, height = btns_rebate_depth + a_bit, quality = 50);
  
  // remove rear face mounting holes
  union() {
      translate([crm_offset_w,0,case_outside_d-case_rear_thickness-a_bit])
    cylinder(h=case_rear_thickness + a_bit_more, r=spkr_holes_r);
  
  translate([-crm_offset_w,0,case_outside_d-case_rear_thickness-a_bit])
    cylinder(h=case_rear_thickness + a_bit_more, r=spkr_holes_r);
    }

} 
}

module buttons() {
  // creates the strip of buttons at the rear of the case
  color("red") union() {
    // buttons
    translate([0,btns_offset_y,case_outside_d-btns_rebate_thickness])
      button(radius=btns_r, length=btns_w, height=btns_d, swidth=btns_striker_w, slength=btns_striker_h, sheight=btns_striker_d);
    translate([btns_pitch,btns_offset_y,case_outside_d-btns_rebate_thickness])
      button(radius=btns_r, length=btns_w, height=btns_d, swidth=btns_striker_w, slength=btns_striker_h, sheight=btns_striker_d);
    translate([btns_pitch*2,btns_offset_y,case_outside_d-btns_rebate_thickness])
      button(radius=btns_r, length=btns_w, height=btns_d, swidth=btns_striker_w, slength=btns_striker_h, sheight=btns_striker_d);
    translate([-btns_pitch,btns_offset_y,case_outside_d-btns_rebate_thickness])
      button(radius=btns_r, length=btns_w, height=btns_d, swidth=btns_striker_w, slength=btns_striker_h, sheight=btns_striker_d);
    translate([-btns_pitch*2,btns_offset_y,case_outside_d-btns_rebate_thickness])
      button(radius=btns_r, length=btns_w, height=btns_d, swidth=btns_striker_w, slength=btns_striker_h, sheight=btns_striker_d);
    
    // button strikers
    translate([btns_pitch,btns_offset_y,case_outside_d-btns_rebate_thickness-(btns_striker_d/2)])
      cube([btns_striker_w,btns_striker_h,btns_striker_d], center=true);
    translate([btns_pitch*2,btns_offset_y,case_outside_d-btns_rebate_thickness-(btns_striker_d/2)])
      cube([btns_striker_w,btns_striker_h,btns_striker_d], center=true);
    translate([-btns_pitch,btns_offset_y,case_outside_d-btns_rebate_thickness-(btns_striker_d/2)])
      cube([btns_striker_w,btns_striker_h,btns_striker_d], center=true);
    translate([-btns_pitch*2,btns_offset_y,case_outside_d-btns_rebate_thickness-(btns_striker_d/2)])
      cube([btns_striker_w,btns_striker_h,btns_striker_d], center=true);
      
      
    // button springs
    for (i = [-btns_pitch*2:btns_pitch:btns_pitch]) {
    translate([i,btns_offset_y,case_outside_d-3.8])
      cube([btns_spring_d,3,btns_spring_h], center=true);
    translate([i+(btns_pitch/2),btns_offset_y,case_outside_d-3.8])
      cube([btns_spring_d,3,btns_spring_h], center=true);
    translate([i+btns_spring_r,btns_offset_y-1.5,case_outside_d-3.8])
      rotate([180,0,0])
        rotate_extrude(convexity = 10, angle = 180)
          translate([btns_spring_r,0,0])
            square([btns_spring_d,btns_spring_h],center=true);
    translate([i+btns_spring_r+(btns_pitch/2),btns_offset_y+1.5,case_outside_d-3.8])
      rotate([0,0,0])
        rotate_extrude(convexity = 10, angle = 180)
          translate([btns_spring_r,0,0])
            square([btns_spring_d,btns_spring_h],center=true);
    } 
    
  }
}

module button(radius,length,height,swidth,slength,sheight) {
  stadium(radius=radius, length=length, height=height, quality = 50);
  for (i = [0.4:0.2:radius]) {
    translate([0,0,(0.5*i)-0.8])
      stadium(radius=i, length=length, height=0.2, quality = 50);
  }
  for (i = [swidth-0.4:0.2:length]) {
    translate([0,0,(0.5*i)-2.6])
      stadium(radius=0.4, length=i, height=0.2, quality = 50);
  }  
  translate([0,0,-sheight/2])
      cube([swidth,slength,sheight], center=true);
}
  

// creates a stadium shape (rectangle with semicircles at each end)
// rising from z=0 and centred on the x and y axes
//
//  radius = radius of semicircles = width of rectangular section / 2
//  length = length of rectangular section between semicircles
//           NOT the overall length of the whole shape!
//  height = depth in the z axis
//  quality = the value passed to $fn for the semicircular segments
module stadium(radius,length,height,quality=50) {
  union() {
    translate([-length / 2, 0, 0])
      cylinder(h=height, r=radius, $fn=quality);
    translate([length / 2, 0, 0])
      cylinder(h=height, r=radius, $fn=quality);
    translate([-length / 2, -radius, 0])
      cube([length, radius * 2, height]);
  }
}


