# 16717A Redux

TODO 3D render

## Quick Stats
* Dimensions: 366.75mm x 206mm x 1.6mm
* 10 Layers
* 1250 Components
* 9605 Total Pads
* 6309 Total Drills
* 5143 Filled & Capped Vias

## Stackup

While reverse engineering the 16717A I noticed a lot of potential signal integrity issues:
* Most signals on the inner layers use +5V or +3.3V as a reference plane, but that is often not a power rail associated with the source and/or destination chips.
* Many signals move between front/back layers through vias without any nearby return path via.
* Many signals change between layers with different reference plane potentials without any nearby decoupling caps between the planes.

I'm sure that HP did a ton of testing to ensure there were no real world performance or EMI issues because of this, but since I don't know exactly what FR4 stackup they used, nor the dielectric constant of their core/prepreg layers, I decided it would be better to rework some things and go to a 10-layer design instead.  For small quantities of large size boards, 10-layer boards through JLCPCB are only a little more expensive than 8 layers (relatively speaking), and their default stackup for 10 layers is a bit nicer as well.

Here is the layer ordering I chose:

* Layer 1 (top): components, signals, +3.3V, -1.7V
* Layer 2: ground
* Layer 3: signals, +3.3V, +5V, -3.3V
* Layer 4: ground
* Layer 5: +3.3V, +5V, -3.3V, few signals
* Layer 6: +3.3V, +5V, -3.3V, ground
* Layer 7: ground
* Layer 8: signals, -5.2V, +3.3V, +3.3VP, -3.3V, +1.5V, +12V, -12V
* Layer 9: ground
* Layer 10 (bottom): components, signals, +3.3V

The most important goal here is to ensure that all signal layers are adjacent to ground plane layers.  No two signal layers are adjacent to each other, and all stripline layers have ground on both sides, not just one.  Additionally, since the board is quite large, the ground and power layers are symetrical to avoid any twist/bend from copper imbalance.  The inner lower layers (layer 5 and 6), rather than having having one +5V and one +3.3V layer, are routed with mostly identical planes covers only areas that need 5V and +3.3V separately, to avoid coupling noise from one rail to the other.

Trace widths were selected assuming JLCPCB's default 10 layer stackup (JLC10161H-2116) with 1oz outer copper and 0.5oz inner copper.  If you choose to have it manufactured elsewhere, you might need to adjust them.  For reference, JLC10161H-2116 uses four 0.2mm cores (Er = 4.6) and five 4.7mil prepregs (Er = 4.16).

All 0.3mm holes should be epoxy filled and capped (JLCPCB should do this by default for 6+ layer boards).

## Bringup
TODO

## Full Change List

* Stackup changed to 10 layers and added layer ID area in lower right corner
* Adjusted trace widths for JLCPCB's 10 layer stackup
* Removed debug connectors and test points
* BGA escapement and other areas use via-in-pad (epoxy filled vias)
* Added test points for electrically checking BGA connections after reflow 
* Added return path vias near signals that change layers, where possible
* Replaced almost all SOIC resistor packs and some discrete resistors with 4x0603 resistor arrays (except custom comparator output networks)
* Moved zoom oscillator closer to PLL
* Adjusted FPGA oscillator footprint to accept alternative packages (including DIP-8), since SG-615P is obsolete and I have a few boards where corrosion got to it
* Moved 1.5V ICR termination regulator to be adjacent to the ASICs that use it
* Moved zoom data bus to stay almost entirely on one inner layer and not to wrap around both edges of the board
* Zoom clocks coming from distribution chip are now exclusively on an internal layer
* LM2991 (-1.7V regulator for zoom distribution chip) now delivers power via a plane on the top layer
* ON/OFF pin on LM2991 is tied to GND pin as datasheet recommends
* ICR bus between ASICs is now on top and one internal layer, rather than top and bottom layers, freeing up the bottom layer for more flexible component placement & routing
* Inter-chip clock lines now correctly length-matched
* Significantly changed power plane layout: 2 middle layers mostly devoted to +5V and +3.3V, -5.2V is on layer 8
* Added +3.3V fills to large unused areas on signal layers (stitched together and to the main +3.3V plane on layer 5/6 with lots of vias)
* Unused inputs on 74LVC08 are grounded
* Increased the values of a few ceramic decoupling caps
* Probe connectors now have mounting holes in case additional strain relief is desired

I also considered reworking some of the LDOs; in particular the LM2991 which is using +3.3VP as a virtual ground, since the LM2991 can't regulate close to its ground reference.  It seems strange that they didn't just use the 3-terminal LM337 instead, since -1.7V shouldn't be a problem for it.  The parts do have slightly different noise characteristics, but I can't see that being a problem here, as ECL is pretty tolerant to noise on `Vee`.  In the end, I decided to keep all the LDO circuits as-is, except for some layout adjustments.
