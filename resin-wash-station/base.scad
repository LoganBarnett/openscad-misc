/*******************************************************************************
 * The base for the resin wash station.
 *
 * A key part of this design is that the motor should never be directly under a
 * liquid reservoir. Most designs I have found lack this principle.
 ******************************************************************************/

module baseCase(reservoirDimensions, baseDimensions, thickness) {
  translate([
    0,
    reservoirDimensions.y / 2,
    thickness / 2 + reservoirDimensions.z / 2,
  ])
    #cube(reservoirDimensions, center = true);
  // Floor.
  translate([
    0,
    reservoirDimensions.y - (baseDimensions.y / 2 - thickness),
    thickness / 2,
  ])
    cube([
      baseDimensions.x + thickness * 2,
      baseDimensions.y,
      thickness,
    ], center = true);

  // Port side.
  translate([
    baseDimensions.x / 2 + thickness / 2,
    reservoirDimensions.y - (baseDimensions.y / 2 - thickness),
    baseDimensions.z / 2 + thickness / 2,
  ])
    cube([
      thickness,
      baseDimensions.y,
      baseDimensions.z,
    ], center = true);

  // Starboard side.
  translate([
    -(baseDimensions.x / 2 + thickness / 2),
    reservoirDimensions.y - (baseDimensions.y / 2 - thickness),
    baseDimensions.z / 2 + thickness / 2,
  ])
    cube([
      thickness,
      baseDimensions.y,
      baseDimensions.z,
    ], center = true);

  // Back side.
  translate([
    0,
    reservoirDimensions.y + thickness / 2,
    baseDimensions.z / 2 + thickness / 2,
  ])
    cube([
      baseDimensions.x,
      thickness,
      baseDimensions.z,
    ], center = true);
}

module motorPlaceholder() {
  radius = 10;
  height = 40;
  shaftHeight = height * 0.2;
  color("cyan") {
    translate([10, 0, 0]) {
      translate([0, -radius * 2, (radius / 2) + 20])
        rotate(a=90, v=[0,1,0])
        cylinder(r = radius, h = height);
      translate([-shaftHeight, -radius * 2, (radius / 2) + 20])
        rotate(a=90, v=[0,1,0])
        cylinder(r = radius * 0.25, h = shaftHeight);
      }
  }
}

module bevelGearMotor() {
  radius = 20;
  height = 5;
  color("magenta")
    translate([0, -radius / 2, height + 5])
    cylinder(r = radius, h = height, center = true);
}

module stirringGear() {
  radius = 20;
  height = 5;
  color("green")
    translate([0, 50 - radius / 2, height + 5])
    cylinder(r = radius, h = height, center = true);
}

module stirringArms() {
  $fn=100;
  length = 40;
  width = 10;
  thickness = 3;
  magnetDiameter = 6;
  color("orange") {
    translate([0, 30, 20]) {
      difference() {
        union() {
          cube([length, width, thickness / 2], center = true);
          translate([length / 2 - magnetDiameter, 0, thickness / 2])
            magnetRing(magnetDiameter, thickness);
          translate([-length / 2 + magnetDiameter, 0, thickness / 2])
            magnetRing(magnetDiameter, thickness);
        }
        cylinder(radius = 5, h = thickness * 2, center = true);
      }
    }
  }
}

module magnetRing(magnetDiameter, thickness) {
  difference() {
    cylinder(d = magnetDiameter + thickness, h = thickness, center = true);
    translate([0, 0, 0.1])
      cylinder(d = magnetDiameter, h = thickness + 0.2, center = true);
  }
}

module spinner() {
  shaftThickness = 4;
  shaftGap = 2;
  fanHeight = 10;
  fanThickness = 2;
  bladeLength = 30;
  bladeCount = 6;
  // I could probably find fancy fan blade code here:
  // https://github.com/hyperair/fan-blades
  // but it's probably enough for now to just use 45º angled blades.
  color("lime")
    translate([0, 0, 20]) {
      difference() {
        cylinder(r = shaftThickness, h = fanHeight, center = true);
        cylinder(r = shaftGap, h = fanHeight + 0.2, center = true);
      }
      for(i = [0 : 1 : bladeCount]) {
        difference() {
          rotate(a=(i / bladeCount) * 360, v=[0, 0, 1])
          rotate(a=90, v=[1, 0, 0])
            rotate(a=45, v=[0,0,1])
            translate([0, 0, bladeLength / 2])
            // I need to do hypotenuse computation here.
            cube([fanThickness, fanHeight /*  * tan(0.5) */ , bladeLength], center = true);
          // Subtract the shaft so we don't intersect it.
          cylinder(r = shaftThickness, h = fanHeight, center = true);
        }
      }
    }
}

module spinnerCage() {

}

reservoir = [ 100, 100, 100 ];
base = [100, 140, 20 ];
thickness = 3;

baseCase(reservoir, base, thickness);
motorPlaceholder();
bevelGearMotor();
stirringGear();
stirringArms();
spinnerCage();
spinner();
