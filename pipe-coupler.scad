diameterA=9.25;
heightA=10;
diameterB=16.50;
heightB=10;
connectorHeight=5;
wallThickness=3;

module tube(h, d, thickness) {
  difference() {
    cylinder(h=h, d=d + thickness, center=true);
    // Extra height helps z-fighting in the preview.
    cylinder(h=h + 0.01, d=d, center=true);
  }
}

module tubeConnector(h, d1, d2, thickness) {
  difference() {
    cylinder(h=h, d1=d1 + thickness, d2=d2 + thickness, center=true);
    // Extra height helps z-fighting in the preview.
    cylinder(h=h + 0.01, d1=d1, d2=d2, center=true);
  }
}

tube(h=heightB, d=diameterB, thickness=wallThickness);
translate([0, 0, heightB + connectorHeight])
  tube(h=heightA, d=diameterA, thickness=wallThickness);
translate([0, 0, heightB - connectorHeight / 2])
  tubeConnector(
    h=connectorHeight,
    d1=diameterB,
    d2=diameterA,
    thickness=wallThickness
  );
