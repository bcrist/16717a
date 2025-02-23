# 16717A Redux

TODO 3D render

## Quick Stats
* Dimensions: 366.75mm x 206mm x 1.6mm
* 10 layers
* 1250 components
* 9627 total pads
* 5392 total holes
* 3803 ~ 5048 filled & capped holes

## Stackup

While reverse engineering the 16717A I noticed a lot of potential signal integrity issues:
* Most signals on the inner layers use +5V or +3.3V as a reference plane, but that is often not a power rail associated with the source and/or destination chips.
* Many signals move between front/back layers through vias without any nearby return path via.
* Many signals change between layers with different reference plane potentials without any nearby decoupling caps between the planes.

I'm sure that HP did a ton of testing to ensure there were no real world performance or EMI issues because of this, but since I don't know exactly what FR4 stackup they used, nor the dielectric constant of their core/prepreg layers, I decided it would be better to rework some things and go to a 10-layer design instead.  For small quantities of large size boards, 10-layer boards through JLCPCB are only a little more expensive than 8 layers (relatively speaking), and their default stackup for 10 layers is a bit nicer as well.

Here is the layer ordering I chose:

* Layer 1 (top): components, signals, -1.7V
* Layer 2: ground
* Layer 3: signals, +5V, -3.3V
* Layer 4: ground
* Layer 5: +3.3V, +5V, -3.3V, few signals
* Layer 6: +3.3V, +5V, -3.3V, ground
* Layer 7: ground
* Layer 8: signals, -5.2V, +3.3VP
* Layer 9: ground
* Layer 10 (bottom): components, signals

The most important goal here is to ensure that all signal layers are adjacent to ground plane layers.  No two signal layers are adjacent to each other, and all stripline layers have ground on both sides, not just one.  Additionally, since the board is quite large, the ground and power layers are symetrical to avoid any twist/bend from copper imbalance.  The inner lower layers (layer 5 and 6), rather than having having one +5V and one +3.3V layer, are routed with mostly identical planes covering only areas that need 5V and +3.3V separately, to avoid coupling noise from one rail to the other.

Trace widths were selected assuming JLCPCB's default 10 layer stackup (JLC10161H-2116) with 1oz outer copper and 0.5oz inner copper.  If you choose to have it manufactured elsewhere, you might need to adjust them.  For reference, JLC10161H-2116 uses four 0.2mm cores (Er = 4.6) and five 4.7mil prepregs (Er = 4.16).

All 0.3mm holes should be epoxy filled and capped (JLCPCB should do this by default for 6+ layer boards).

Note that JLCPCB will charge an extra $15 for any design with more than 4000 holes under 0.5mm in diameter.  This is listed on their "special cases" page, but it isn't described very clearly, and at the time of writing isn't included in their automated quoting tool.  To avoid this most power vias in the design have been set to 0.5mm, keeping the 0.3mm drill count below the 4000 hole limit, even though the total number of vias in the design is well above 4000.  All of the 0.5mm holes on the board _may_ be filled and capped, but it shouldn't be a problem if they are not.

Note that JLCPCB will likely charge an additional $7.50 above their quoted price for this board.  After inquiring they informed me this was due to the large number of electrical test points, though they didn't tell me exactly what the limit is before that kicks in; I decided it wasn't worth pursuing that since there's not much I could do to reduce the number of pads in the design anyway.

## Bringup

It is by no means necessary to follow these exact procedures, however if you are concerned about parts having been potentially damaged in removal from the old board, this guide allows incrementally verifying some subsystems with a minimum of time sunk into soldering hundreds of passive components.

Note: I highly recommend checking all power rails for shorts after each step below, before powering up the mainframe.  The 167xx power supplies do not seem to have short-circuit protection.  I once accidentally plugged in an original 16717A "upside-down" and ended up blowing the PSU (and maybe the FPGA on the 16717A too; it wasn't working beforehand so I can't be sure).  I was using a ribbon cable backplane extender, and forgot that the mainframe was sitting on my desk upside down.  doh!  After replacing the PSU the mainframe still works fine, thankfully.  I was afraid I might have blown the backplane interface board as well, but it seems to still work fine.

### 1. FPGA

The first goal is to get a 16700A/B to recognize the board as a 16717A module, which indicates that the FPGA isn't completely dead, and is able to communicate with the backplane.  The main parts that need to be populated for this test are:

* The AMP 1-534204-4 backplane connector
* The +5V and +3.3V ferrites and bulk capacitors
* The Actel A32140DX FPGA (the large PQFP-208 package near the backplane connector) and some decoupling capacitors
* The 19.6608 MHz crystal oscillator which is the FPGA's main clock source
* Two of the ribbon cable connectors near the front and some associated resistors and capacitors (the FPGA needs these to determine whether it is the master or an extension board)

TODO add board images highlighting components that need to be populated

Once these components have been populated, the board should be selectable in `vp` and `pv`, although most of the `pv` tests will fail:

TODO chipRegTest?

TODO add pv output

### 2. Acquisition ASICs

By far the most difficult parts to solder are the two ASIC BGAs, so as soon as possible, we want to get them populated and verify that they haven't been destroyed by reflowing.  You may even want to do these before populating the FPGA components in the previous section.

If you're not comfortable soldering BGAs I'd suggest practicing on something less rare/useful first.  Your mileage may vary but what works well for me is preheating from the bottom with a hotplate or IR preheater to around 120-150C, followed by low speed hot air from above at around 320C.

After soldering, use a multimeter in diode/resistance/continuity mode to check that each of the test points on the back side of the board has a solid connection to the chip.  There are also a few test points on the top side for signals that never traverse a via.

Once you are confident that all the BGA balls are attached properly, you can install the remaining components for the next test:

* Various resistors and capacitors underneath the ASICs (decoupling, pull ups, etc.)
* Optional: 3M P08-080-SL-A-G board-to-board connectors (these aren't really needed right now, but it may be easier to populate them before the various parts nearby)
* Transistors and ECL buffers near the board-to-board connectors near the edge of the board (used to synchronize clocks between the ASICs)
* Linear regulator for the +1.5V GTLP termination voltage, along with various associated resistors and capacitors
* MMBT3906 transistor and base resistor (allows FPGA to control biasing of inter-module clocks)
* 74FB2040 BTL transciever, 74ABT540 inverting buffer, and associated passives (forwards async signals from the backplane/FPGA to the ASICs)
* ECL clock buffer for the 100 MHz backplane clock, along with associated passives
* Some additional passives near the FPGA, related to ASIC control signals

TODO add board images highlighting components that need to be populated

Once these components have been populated, `pv` should show the board passing `icrTest` and `clksTest` (maybe?)

TODO chipRegTest?
TODO bpClkTest?

TODO add pv output

### 3. DRAM

Next, populate the 34 DRAM chips, decoupling capacitors beneath them on the bottom side, and the RAS/CAS termination networks on the top side.

TODO add board images highlighting components that need to be populated

Once these have been populated, `pv` should report `vramDataTest`, `vramAddrTest`, and `vramCellTest` passing:

TODO maybe also vramUnloadTest?
TODO add pv output

### 4. Comparators & Test Clock Generator

To make progress on the rest of the `pv` tests, we need to get the internal test clock working.  To do this we need to populate:

* The 100LVEL14 clock buffer chip and related passives
* The 10EL34 clock divider chip and related passives
* The remaining ribbon cable connectors and some miscellaneous capacitors nearby
* All of the 1NB4-5036 comparator chips and related passives (though if you want to, you could save the input filtering RC networks for later, since they add up to around 400 individual parts, and aren't needed if you aren't measuring real signals)
* A variety of miscellaneous capacitors and resistors near the comparators
* All of the 4816P-B07-000 custom resistor networks
* Two TPS2011 high-side switches
* The -3.3V and -5.2V backplane ferrites and bulk capacitors
* Two small capacitors on the -12V and +12V rails, near the backplane connector
* The AD7841 DAC and two AD586 references, along with their associated passives
* The PCF8584 controller, 74CBT3125 mux, and a few remaining passives on the FPGA side of the board

TODO add board images highlighting components that need to be populated

At this point, the only parts not populated should be zoom-related, and we effectively have a 16715A board that thinks it's a 16717A.  Only the last five `pv` tests should fail:

TODO add pv output

TODO if you set the identification resistor for 16715A, does it pass all pv tests?

### 5. Timing Zoom

Once everything else is working, we can add the timing zoom components:

* 1NB4-5040 zoom FISO chips (5x)
* 74LVC08 quad AND gates (2x)
* 1821-4731 zoom clock distribution chip
* LM311 comparator
* NEL HS-2810 ECL zoom base clock oscillator
* 100LVEL16 zoom base clock buffer
* SY89421V zoom clock PLL
* 100LVEL16 zoom clock buffer (after ribbon cable)
* +3.3V and -1.7V linear regulators for the PLL and zoom clock chips
* All remaining passives (except the 16717A board identification resistor)

TODO add board images highlighting components that need to be populated

Once everything is complete, cross your fingers and hope that `pv` shows no failures:

TODO add pv output

There's only two things left to test now:
* Testing the board with real probes and signals.  I'll let you decide exactly how you want to do that.  If `pv` doesn't report any errors, but something isn't working, it's likely either a faulty comparator chip, a problem with one of the input filtering networks, or a bad probe/cable.
* Testing the board when used in a multi-card configuration.  Make sure both/all boards pass all `pv` tests in master configuration before attempting to use them together.  If `pv` reports errors in a multi-card configuration, but not when the boards are all masters, it probably means there's a problem with the circuitry near the board-to-board connectors, or the FFC connectors/cables themselves.

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
* Zoom clocks coming from distribution chip are now exclusively on inner stripline layers
* LM2991 (-1.7V regulator for zoom distribution chip) now delivers power via a plane on the top layer
* ON/OFF pin on LM2991 is tied to GND pin as datasheet recommends
* ICR bus between ASICs is now on top and one internal layer, rather than top and bottom layers, freeing up the bottom layer for more flexible component placement & routing
* Inter-chip clock lines are now correctly length-matched
* Significantly changed power plane layout: 2 middle layers mostly devoted to +5V and +3.3V, -5.2V is on layer 8
* Unused inputs on 74LVC08 are grounded
* Removed length matching on ECL signals from comparators to acquisition BGAs.  Not all signals were matched to the same length, and the delay is automatically tuned for each signal individually anyway.
* Increased the values of a few ceramic decoupling caps
* Probe connectors now have mounting holes in case additional strain relief is desired

I also considered reworking some of the LDOs; in particular the LM2991 which is using +3.3VP as a virtual ground, since the LM2991 can't regulate close to its ground reference.  It seems strange that they didn't just use the 3-terminal LM337 instead, since -1.7V shouldn't be a problem for it.  The parts do have slightly different noise characteristics, but I can't see that being a problem here, as ECL is pretty tolerant to noise on `Vee`.  In the end, I decided to keep all the LDO circuits as-is, except for some layout adjustments.
