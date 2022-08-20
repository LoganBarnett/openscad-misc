body = [18.8, 11.5, 11.75];
wireGap = 20;
mountThickness = 4;
zFix = 0.01;
// Fix cylinder rendering - the y-plane is messed up.
/* cylinderFix=0.5; */
cylinderFix=0;
$fn=100;

module arc(theta, thickness) {
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
        [0, 0],
        [x1 * thickness, y1 * thickness],
        [x2 * thickness, y2 * thickness],
      ]);
}

module wireCavity() {
  translate([0, body.y * 2 - mountThickness, mountThickness]) {
    difference() {
      rotate([0, -90, 0])
        linear_extrude(height=body.x, center=true)
          arc(90, body.z);
      /* rotate([0, 90, 0]) */
      /*   cylinder(r=body.z, h=body.x, center=true); */
      let(fixedBody = [
        body.x + zFix,
        body.y + zFix + cylinderFix,
        body.z + zFix,
      ]) {
        translate([0, body.y / -2, body.z / 2])
          cube(fixedBody, center=true);
        translate([0, body.y / -2, body.z / -2])
          cube(fixedBody, center=true);
        translate([0, body.y / 2, body.z / -2])
          cube(fixedBody, center=true);
      }
    }
    // Cut a hole through the shround to the bottom where the wires can come
    // out.
    translate([0, cylinderFix / 2 + body.y / 2, -mountThickness / 2])
      cube([body.x, body.y, mountThickness + zFix * 2], center=true);
  }
}

module shroud() {
  translate([0, 0, body.z / 2 + mountThickness / 2])
    difference() {
      translate([0, (body.y + wireGap + mountThickness) / 2, mountThickness / 2])
        cube([
          body.x + (mountThickness * 2),
          body.y + wireGap + mountThickness,
          body.z + (mountThickness * 2),
        ], center=true);
      translate([0, body.y / 2 + mountThickness, mountThickness / 2])
        cube([
          body.x,
          body.y + wireGap/ 2,
          body.z,
        ], center=true);
    }
}

module mountCountersink() {
  let(dims = [
    body.x,
    body.y,
    mountThickness,
  ]) {
    translate([body.x + mountThickness, dims.y, dims.z / 2])
      cube(dims, center=true);
  }
}

difference() {
  shroud();
  /*
  translate([
    (body.x + (mountThickness * 2)) / -2,
    (body.y + wireGap + mountThickness) / 2,
    (body.z + (mountThickness * 2)) / 2,
  ])
  cube([
    body.x + (mountThickness * 2) + zFix,
    body.y + wireGap + mountThickness + zFix,
    body.z + (mountThickness * 2) + zFix,
    ], center=true);
  */
  wireCavity();
}

/*
translate([10, 0, 0]) {
  wireCavity();
}
*/
mountCountersink();
