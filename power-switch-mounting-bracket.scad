/**
 * Provides a mount for a KCD1-101 power switch.
 *
 * The rocker switch is entirely encapsulated except for its face plate. The
 * rear section comes out the bottom of the mount so the wires have somehwere to
 * go that ideally enters whatever the mount is affixed to.
 *
 * The data sheet for the rocker switch can be found locally in this file:
 * data-sheets/kcd1-101-rocker-switch.pdf
 * The original URL is:
 * https://www.hobbytronics.co.za/Content/external/1106/JINGHAN_ROCKER_SWITCH_KCD1_101.pdf
 */

/**
 * The block (sans face plate and poles) as measured with calipers. Also
 * accounts for some wiggle to actually fit the box in there.
 */
body = [19, 12, 12];
/**
 * How far out to extend the shroud to allow wires to flow.
 */
wireGap = 25;
/**
 * General material thickness across the model. This could probably use higher
 * fidelity.
 */
mountThickness = 4;
/**
 * Prevent z-fighting in the preview and quite possibly the export.
 */
zFix = 0.01;
// Fix cylinder rendering - the y-plane is messed up.
/* cylinderFix=0.5; */
cylinderFix=0;
$fn=100;
/**
 * Switch crossSection to true to see a cross section of the shroud. Great for
 * debugging the inside of the shroud.
 */
crossSection=false;
/**
 * How wide to make the countersinks on the arms.
 */
countersinkDiameter=5;

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

/**
 * This volume is subtracted from the shroud to give the wires a place to go. It
 * is curved to ease feeding wires and also to allow printing without supports.
 */
module wireCavity() {
  translate([0, body.y * 2 - mountThickness, 0]) {
    difference() {
      // I found it easier to just scale the entire arc area to fit.
      scale([1, wireGap - mountThickness * 2, body.z + mountThickness])
        rotate([0, -90, 0])
        linear_extrude(height=body.x, center=true)
          arc(90, 1);
    }
  }
}

/**
 * This encases the body of the switch. The face place rests along the opening
 * of this shroud. The wires flow out the wire cavity in the back.
 */
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

/**
 * Give us arms with countersinks in which we can mount the bracket to a
 * surface.
 */
module mountCountersink() {
  let(dims = [
    body.x,
    body.y,
    mountThickness,
  ]) {
    translate([ body.x + mountThickness, dims.y / 2, dims.z / 2]) {
      difference() {
        union() {
          translate([dims.x / -4, 0, 0]) {
            cube([dims.x / 2, dims.y, dims.z], center=true);
          }
          // Use nice rounded arms for less material.
          rotate([0, 0, -90])
            linear_extrude(height=dims.z, center=true)
            arc(180, dims.y / 2);
        }
        cylinder(d=countersinkDiameter, h=dims.z * 2, center=true);
      }
    }
  }
}

/**
 * This was instrumental in seeing what was going wrong with the wire cavity.
 * Enable it setting `crossSection' to true.
 */
module shroudCrossSection() {
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
}

//------------------------------------------------------------------------------
// Begin model composition.
//------------------------------------------------------------------------------
difference() {
  shroud();
  if(crossSection) {
    shroudCrossSection();
  }
  wireCavity();
}

mountCountersink();
scale([-1, 1, 1])
  mountCountersink();
//------------------------------------------------------------------------------
// End model composition.
//------------------------------------------------------------------------------
