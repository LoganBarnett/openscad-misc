/*******************************************************************************
 * A U bracket for mounting.
 ******************************************************************************/

module uBracket(
  width,
  height,
  thickness,
  depth,
  mountWidth,
  screwDiameter
) {
  difference() {
    union() {
      cube([width + thickness * 2, depth, thickness], center=true);
      // Stands.
      translate([(width + thickness) / 2, 0, (height + thickness) / -2])
        cube([thickness, depth, height], center=true);
      translate([(width + thickness) / -2, 0, (height + thickness) / -2])
        cube([thickness, depth, height], center=true);
      // Mounting surface.
      translate([(width / 2) + (mountWidth / 2), 0, -(height + thickness)])
        cube([mountWidth, depth, thickness], center=true);
      translate([-((width / 2) + (mountWidth / 2)), 0, -(height + thickness)])
        cube([mountWidth, depth, thickness], center=true);
    }
    // Counter sinks.
    translate([
      -((width / 2) + mountWidth - (screwDiameter * 2)),
      0,
      -(height + thickness),
    ])
      cylinder(d=screwDiameter, h=thickness * 1.5, center=true);
    translate([
      ((width / 2) + mountWidth - (screwDiameter * 2)),
      0,
      -(height + thickness),
    ])
      cylinder(d=screwDiameter, h=thickness * 1.5, center=true);
  }
}

// Measured 45mm high but reduce to pinch.
// Measured 187mm wide but rounded to 190mm to fit.
// Measured 3.4mm for screw.
uBracket(190, 44, 3, 10, 15, 3.4);
