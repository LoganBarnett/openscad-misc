/**
 * A guard that prevents floppy panniers from rubbing up against the back of the
 * rear wheel on a bike.
 */

// Yanked from the official docs.
function flatten(l) = [ for (a = l) for (b = a) b ] ;

module arc(theta, bore, thickness) {
  // Minus 1 because this increments one iteration ahead - therefore we cover
  // the final case properly without going over.
  for(i = [0 : $fn - 1])
    let(
      angle1 = (i / $fn) * theta,
      angle2 = ((i+1) / $fn) * theta,
      x1 = cos(angle1),
      y1 = sin(angle1),
      x2 = cos(angle2),
      y2 = sin(angle2)
    )
      // There might be more efficient ways to bundle this up (such as making
      // it a single polygon call), but vector mapping like that in OpenSCAD
      // eludes me.
      polygon([
        [x1 * bore, y1 * bore],
        [x1 * (bore + thickness), y1 * (bore + thickness)],
        [x2 * (bore + thickness), y2 * (bore + thickness)],
        [x2 * bore, y2 * bore],
      ]);
}

module pannierBlocker() {
  // Show me if this is cutting through the arc improperly.
  color("yellow")
    translate([armLength / 2 + barDiameter / 2, armThickness / 2, 0])
    cube([armLength, armThickness, armWidth,], center=true);
}

module frameHook(hookAngle) {
  translate([0, 0, -armWidth / 2])
    linear_extrude(armWidth)
      arc(hookAngle, barDiameter / 2, armThickness);
}

module screwReciever(hookAngle) {
  // Show me if this is cutting through the arc improperly.
  color("red")
    rotate([0, 0, -180 + hookAngle])
    translate([-(barDiameter / 2 + receiverLength / 2), armThickness / 2, 0])
    difference() {
      cube([receiverLength, armThickness, armWidth], center=true);
      rotate([90, 0, 0])
      cylinder(center=true, r=screwBore, h=20);
    }
}

/* armHalf(); */
receiverLength=25;
screwBore=5 / 2;
$fn=100;
armThickness=5;
armLength=115;
armWidth=20;
barDiameter=16;
// We probably don't want a perfect 180 degrees so we can pinch it between two
// of these using a screw.
hookAngleGap = 12;
hookAngle=180 - hookAngleGap / 2;

difference() {
  pannierBlocker();
  translate([barDiameter /2 + receiverLength / 2, 0, 0])
    rotate([90, 0, 0])
    cylinder(center=true, r=screwBore, h=20);
}
frameHook(180);
screwReciever(180);

translate([0, 15, 0]) {
  frameHook(hookAngle);
  screwReciever(hookAngle);
  rotate([0, 180, 0])
    screwReciever(180);
}
