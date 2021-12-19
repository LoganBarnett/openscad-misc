/**
 * Inspired by the Altoids tin caddy here:
 * https://www.thingiverse.com/thing:67893
 *
 * I felt this used too much material for my tastes. Everything prints solid
 * with two layers for walls, and I figured the shelves were a little too
 * "complete". At time of writing, it's a $5-6 print. I felt there were savings
 * to made in the shelving areas themselves. This new design clocks in closer to
 * $2.5-3 to print.
 */

// Width and depth account for lip around the container. All measurements
// rounded to the highest millimeter.
altoidSize = [97.0, 63.0, 22.0];
containers = 5;
toleranceFactor = 1.1;
wallThickness = 0.4 * 4;
zPeace = 0.01;

module tin() {
  cube(altoidSize, center=true);
}

// The gap along the sides which makes it easy to grip.
module gripGap() {
  rotate(a=90, v=[0, 1, 0])
    // Give us extra grip space.
    scale([1, 2, 1])
    cylinder(
      d=altoidSize.z * toleranceFactor,
      h=altoidSize.x * toleranceFactor + wallThickness * 2 + zPeace,
      center = true
    );
}

// The gap on the bottom and top of the shelf - purely for saving material cost.
module shelfGap() {
  resize(newsize=[altoidSize.x * toleranceFactor + wallThickness, 0, 0])
    cylinder(
      d=altoidSize.y * 2,
      h = wallThickness * 2,
      center = true
    );
}

module enclosureBase() {
  cube([
    altoidSize.x * toleranceFactor + wallThickness * 2,
    altoidSize.y * toleranceFactor + wallThickness,
    altoidSize.z * toleranceFactor + wallThickness * 2,
  ], center=true);
}

module enclosure() {
  difference() {
    enclosureBase();
    translate([
      0,
      altoidSize.y / 2,
      altoidSize.z / 2 * toleranceFactor + wallThickness - zPeace,
    ])
      shelfGap();
    translate([
      0,
      altoidSize.y / 2,
      -(altoidSize.z / 2 * toleranceFactor + wallThickness - zPeace),
    ])
      shelfGap();
    translate([0, wallThickness + altoidSize.y * toleranceFactor / 2, 0])
      gripGap();
    scale([1, 1, 1] * toleranceFactor)
      translate([0, wallThickness, 0])
        tin();
  }
}

// Lay it on its back for printing.
module caddy() {
  rotate(a=90, v=[1, 0, 0]) {
    for(i=[0:containers - 1]) {
      translate([0, 0, i * (altoidSize.z * toleranceFactor + wallThickness)])
        enclosure();
    }
  }
}

caddy();

// Use to debug:
// enclosure();
