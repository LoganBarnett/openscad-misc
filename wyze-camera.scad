cameraWidth=52;
cameraHeightWithBase=58;
cameraDepth=51;
thickness=3;


module wyzeCamV3Dummy() {
  color("white")
    cube([cameraWidth, cameraHeightWithBase, cameraDepth], center = true);
}

function xFromOrientation(orientation, dimensions)
  = orientation == "up" || orientation == "bottom"
  ? dimensions.x
  : orientation == "left" || orientation == "right"
  ? dimensions.y
  : orientation == "back" || orientation == "front"
  ? dimensions.x
  : 0
  ;

function zFromOrientation(orientation, dimensions)
  = orientation == "up" || orientation == "bottom"
  || orientation == "left" || orientation == "right"
  ? dimensions.z
  : orientation == "back" || orientation == "front"
  ? dimensions.y
  : 0
  ;

function rotationAngleFromOrientation(orientation)
  = orientation == "up" || orientation == "bottom"
  ? 0
  : 90
  ;

function rotationVectorFromOrientation(orientation)
  = orientation == "up" ||
    orientation == "bottom"
  ? [0, 0, 0]
  : orientation == "left" || orientation == "right"
  ? [0, 0, 1]
  : orientation == "back" || orientation == "front"
  ? [1, 0, 0]
  : [0, 0, 0]
  ;

function rotationOffset(dimensions, orientation, thickness)
  = orientation == "left"
  ? [dimensions.x / 2 + thickness / 2, dimensions.y / 2 + thickness, 0]
  : orientation == "right"
  ? [-dimensions.x / 2 - thickness / 2, dimensions.y / 2 + thickness, 0]
  : orientation == "front"
  ? [0, dimensions.y / 2 + thickness, dimensions.z / 2 + thickness / 2]
  : orientation == "back"
  ? [0, dimensions.y / 2 + thickness, -dimensions.z / 2 - thickness / 2]
  : orientation == "up"
  ? [0, dimensions.y + thickness * 1.5, 0]
  : orientation == "bottom"
  ? [0, thickness / 2, 0]
  : [0, 0, 0]
  ;

/**
 * Creates the side of a bracket frame. Dimensions indicates its size, the
 * orientation indicates which side of the frame to create, and the thickness is
 * the thickness of the frame itself.
 */
module bracketFrameSide(dimensions, orientation, thickness=3) {
  // Bleh, just use strings as enums. No fancy normalization vector for us. I
  // don't know how to pull that off.
  let(
    x = xFromOrientation(orientation, dimensions),
    z = zFromOrientation(orientation, dimensions),
    angle = rotationAngleFromOrientation(orientation),
    rotationVector = rotationVectorFromOrientation(orientation)
  ) {
    // Offset the side to where it needs to be, post rotation.
    translate(rotationOffset(dimensions, orientation, thickness)) {
      rotate(angle, rotationVector) {
        difference() {
          cube([
            x + thickness * 2,
            thickness,
            z + thickness * 2,
          ], center = true);
          // Subtract a smaller cube to achieve a picture-frame like entity.
          cube([
            x - thickness,
            thickness + 2,
            z - thickness,
          ], center = true);
        }
      }
    }
  }
}

mountDimensions = [10, 10, 3];
module mount() {
  difference() {
    cube(mountDimensions, center = true);
    cylinder(r=3, h = mountDimensions.z * 1.5, center = true);
  }
}

/**
 * Creates a bracket to mount a Wyze Camera against a peep hole. Has countersink
 * holes, and should be adequate for any orientation.
 *
 * It's useful to protect the camera itself with something like a small piece of
 * plexiglass, whose thickness is included in the coverDepth parameter.
 */
module wyzeCameraPeepHoleBracket(thickness=3, coverDepth=0) {
  // TODO: Do a lookup for different cameras (WyzeCam v3, v2, etc).
  cameraDimensions = [
    cameraWidth,
    cameraHeightWithBase,
    cameraDepth,
  ];
  // The side edges are beveled to almost a 1/4in size, but I don't have the
  // tools needed to measure that precisely. However, we can create a bracket
  // that doesn't care about that.
  color("green") {
    bracketFrameSide(cameraDimensions, "up", thickness);
    bracketFrameSide(cameraDimensions, "left", thickness);
    bracketFrameSide(cameraDimensions, "right", thickness);
    bracketFrameSide(cameraDimensions, "bottom", thickness);
    bracketFrameSide(cameraDimensions, "back", thickness);
    // Don't do the front side, because that's where we will insert the camra.
  }
  color("teal") {
    translate([
      0,
      -mountDimensions.y / 2 + 1,
      cameraDimensions.z / 2 + mountDimensions.z / 2,
    ]) rotate(90, [0, 0, 0]) mount();
    translate([
      0,
      cameraDimensions.y + mountDimensions.y / 2 + thickness * 2 - 1,
      cameraDimensions.z / 2 + mountDimensions.z / 2,
    ]) rotate(90, [0, 0, 0]) mount();
    translate([
      cameraDimensions.x / 2 + mountDimensions.y / 2 + thickness - 1,
      (cameraDimensions.y / 2) + thickness,
      cameraDimensions.z / 2 + mountDimensions.z / 2,
    ]) rotate(90, [0, 0, 0]) mount();
    translate([
      -(cameraDimensions.x / 2 + mountDimensions.y / 2 + thickness - 1),
      (cameraDimensions.y / 2) + thickness,
      cameraDimensions.z / 2 + mountDimensions.z / 2,
    ]) rotate(90, [0, 0, 0]) mount();
  }
}

// In OpenSCAD, z is up, and y is depth. This inverts my understanding of how
// three dimensions are typically represented. However, one can add a final
// rotation to everything to "fix" it.
rotate(90, [1, 0, 0]) {
  difference() {
    wyzeCameraPeepHoleBracket();
    translate([0, cameraHeightWithBase / 2 + thickness, 0]) #wyzeCamV3Dummy();
  }
}
