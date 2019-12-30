# ringlamp

Neopixel ringlamp, programmed in CircuitPython

## Repo

### housing

OpenSCAD file to generate the housing

### hardware

Hardware related stuff

### software

CircuitPython software.

#### code.py

Main: reads in 3 pots, and one switch.

The switch switches trough 6 modes, where the pots have slightly different functions:

 * **Mode 1:** warmwhite 
    * pot 1 sets the brightness
 * **Mode 2:** coldwhite 
    * pot 1 sets the brightness
 * **Mode 3:** RGB
    * pot 1 sets red
    * pot 2 sets green
    * pot 3 sets blue
 * **Mode 4:** split colors, half of the circle gets one color, the other half a second
    * pot 1 sets the brightness
    * pot 2 sets the rotation angle
    * pot 3 sets 10 different presets
 *  **Mode 5:** colorwheel
    * pot 1 sets the brightness
    * pot 2 rotates through the colorwheel
 * **Mode 6:** blend colors, every other LED gets color 1 or color 2 
    * pot 1 sets the brightness
    * pot 2 rotates through the colorwheel for color 1
    * pot 2 rotates through the colorwheel for color 2
