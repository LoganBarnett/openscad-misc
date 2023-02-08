// Procedurally generates a crystal suitable for an Aeldari objective marker.
// The crystal is generally spear-tip shaped. The crystals are randonly
// generated and meant to have some organic "slop" to them - they aren't perfect
// polyhedrons. Lots of variables exist to tune the size, length, variance, etc.
//
// See crystal-tip-preview-01.png for what this could look like.
//
// There are some good crystal generators out there, but I wanted my crystal to
// be spear-tip shaped and have a very short "neck" or body. It's sized to fit
// in the detatchable lids found in Nuun hydration tablet containers (and
// probably others). If someone wants to contribute some good presets, I am
// happy to include them here.
//
// The tablets, for reference: https://nuunlife.com/
//
// A more generic source listing for these containers would be wonderful to
// share. I believe I have seen them elsewhere, but have nothing to reference.
//
// Honorable mention (both links are for the same effort/model):
// https://www.thingiverse.com/thing:4210463
// https://cults3d.com/en/3d-model/game/openscad-crystal-procedural-generator
//

seed = 6255;
measuredDiameter = 20;
// If we make it slightly wider, it'll rest nicely inside on the top ring.
diameter = measuredDiameter + 2;
height = 64;
sides = 12;
vScale = 0.3;
cylinderOffset=15;

module crystalTip(
  seed,
  sides,
  intersectionOffset,
  cylinderOffset,
  diameter,
  height,
  sharpness,
  vHeight,
  vSharpness,
  vScale
) {
  $fn=sides;
  difference() {
    // Scaling would've added a nice organic touch to the crystal, but then the
    // crystal wouldn't fit in the aperature.
    /* scale([ */
    /*   1 + rands(-vScale, vScale, 1, seed)[0], */
    /*   1 + rands(-vScale, vScale, 1, seed + 1)[0], */
    /*   1, */
    /* ]) */
      translate([0, 0, cylinderOffset])
      cylinder(d=diameter, h=height, center = true);
    for(i=[0 : sides]) {
      let(
        // TODO: Use this rotation to compute the proper offset to shift the
        // cylinder downwards.
        rotation = sharpness + rands(-vSharpness, vSharpness, 1, seed + i + 3)[0]
      ) {
      translate([
        0,
        0,
      ])
        rotate([
          rotation,
          0,
          i / $fn * 360,
        ])
        translate([
          0,
          0,
          intersectionOffset + rands(-vHeight, vHeight, 1, seed + i + 2)[0],
        ])
          cube([diameter * 2, height * 2, diameter * 2], center = true);
      }
    }
  }
}

/* crystalTip( */
/*   seed, */
/*   6, // Sides. */
/*   90, // Intersection Offset. */
/*   30, // Diameter. */
/*   90, // Height. */
/*   50, // Sharpness. */
/*   6,  // Height variance. */
/*   3,  // Sharpness variance. */
/*   0.3 // Scale variance. */
/* ); */

crystalTip(
  seed,
  sides, // Sides.
  30, // Intersection Offset.
  cylinderOffset,
  diameter,
  height, // Height.
  70, // Sharpness.
  2,  // Height variance.
  1,  // Sharpness variance.
  vScale // Scale variance.
);

// Ugh. Why do we have to fix these two?
sphereFix=1.044;
translate([0, 0, -height / 2 + cylinderOffset ])
  // Scaling would've added a nice organic touch to the crystal, but then the
  // crystal wouldn't fit in the aperature.
  /* scale([ */
  /*   sphereFix * 1 + rands(-vScale, vScale, 1, seed)[0], */
  /*   sphereFix * 1 + rands(-vScale, vScale, 1, seed + 1)[0], */
  /*   1, */
  /* ]) */
  sphere(d=diameter, $fn=sides);
