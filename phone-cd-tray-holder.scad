/**
 * A phone holder that is lodged into the CD tray of the car's dashboard.
 */

// Figuring out the pinch is the hard part. Different cases have different
// levels of squishy.
pinch=0.5;
// Phone width needs to be measured down to a 10th of a milimeter.
phoneWidth=82 - pinch;
phoneThickness=16;
phoneWidth=78 - pinch;
phoneHeight=phoneWidth * 16 / 10;
phoneArmWidth=10;
phoneArmGraspThickness = 10;
phoneArmDepth=phoneThickness + phoneArmGraspThickness;
cdTrayWidth=phoneWidth / 2;
// Measured at 5.30, but 5.00 on a slot that fits there rather well.
cdTrayHeight=5.3;
cdTrayDepth=15;

module cdTraySlot() {
  cube([
    cdTrayWidth,
    cdTrayDepth,
    cdTrayHeight,
  ], center=true);
}

module clawArm() {
  translate([0, 0, cdTrayHeight / -2])
    linear_extrude(cdTrayHeight)
    polygon([
      [0, 0],
      [phoneWidth / 2, 0],
      [phoneWidth / 2 + phoneArmWidth, phoneArmWidth],
      [phoneWidth / 2 + phoneArmWidth, phoneArmDepth],
      [phoneWidth / 2, phoneArmDepth],
      [phoneWidth / 2, phoneArmWidth],
      [0, phoneArmWidth],
      [0, 0],
    ]);
}

module claws() {
  clawArm();
  rotate([0, 180, 0])
    clawArm();
}

cdTraySlot();

claws();
