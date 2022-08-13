/**
 * This is a small clip for fixing small wires to walls.
 *
 * A countersink could be added, but not done yet.
 *
 * Print laying on its side for maximum strength. No supports needed. It's
 * pretty small, so that strength is desired.
 *
 * Designed to be strong, minimal footprint, easy to print, and wire can be
 * wrapped around the arm.
 */

armHeight=10;
armReach=15;
armWidth=3;
armThickness=3;
bodyWidth=10;
bodyThickness=2.5;

module body() {
  difference() {
    translate([0, bodyWidth / -2 + armWidth / 2, bodyThickness / 2])
      cube([
        bodyWidth,
        bodyWidth,
        bodyThickness,
      ], center=true);
  }
}

module arm() {
  translate([0, armWidth / 2, 0])
  rotate([90, 0, 0])
    linear_extrude(armWidth)
  polygon(points=[
    [0, 0],
    [armReach / 2, armHeight],
    [armReach, 0],
    [armReach - armThickness, 0],
    [armReach / 2, armHeight - armThickness],
    [armThickness, 0],
    [0, 0],
  ]);
}

body();
arm();
