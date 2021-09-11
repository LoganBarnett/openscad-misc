/*******************************************************************************
 * This is just a cylinder.
 *
 * I have magnetic discs which are 9.5mm x 1.6mm (diameter x thickness). For
 * my miniature shelves, I use corkboard to create a rough, ground or rock like
 * texture. I want the miniatures to be secure on the shelf without looking like
 * I've clamped them down, so my plan is to use magnets on the base and the
 * shelf. Glue doesn't work great for corkboard though, and I fear the magnets
 * will tear off of the corkboard - especially given the strength of the magnets
 * I'm using. My plan is to carve a roughly cylindrical hole in the corkboard
 * where I want the magnetic disc to go, and then use an insert glue directly to
 * the shelf base, which then the magnet can be glued to. The magnet won't be
 * glued to the corkboard directly.
 *
 * The height of the cylinder needs to be the corkboard's thickness - the
 * magnet's thickness. This keeps the magnet from rising above the corkboard's
 * base. The diameter is the magnet's diameter.
 ******************************************************************************/

magnetThickness=1.6;
magnetDiameter=9.5;
baseThickness=5.0;
fudgeThickness=0.5;

$fn=100;
cylinder(d=magnetDiameter, h=baseThickness - fudgeThickness - magnetThickness);
