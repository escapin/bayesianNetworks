# Machine Learning for Fault Detection of Energy Consumption #

A machine learning approach for fault detection of enery consumption
values in a room.

![Alt The relax room](img/room.png)

As depicted in the figure above, there is only one door to access the
room. On the opposite side there is a wide window. In the bottom-right corner
there are three electrical appliances: a microwave, a kettle, and a
water dispenser.

The room is equipped with the following sensors:

1. an open/close sensor on the windows;
2. a temperature and humidity sensor near the window;
3. a temperature and movement sensor near the door;
4. an energy consumption sensor, called _Z-Plug_, on which all the
   electrical appliances are plugged.

These sensors communicate with a central unit through (wireless) the
ZigBee protocol and the data collected are saved in a SQLite
database.


## Dependencies

* MATLAB (https://www.mathworks.com/products/matlab.html)
* The Bayes Net Toolbox (BNT) for MATLAB (https://github.com/bayesnet/bnt)
* `mksqlite`, the MATLAB Mex-DLL to access SQLite databases (https://github.com/AndreasMartin72/mksqlite)
Optional:
* Mozila Firefox (https://www.mozilla.org/en-US/firefox/)
* The SQLite Manager Firefox Add-on (https://addons.mozilla.org/en-US/firefox/addon/sqlite-manager/)

## How to
