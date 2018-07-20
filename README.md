# Machine Learning for Fault Detection of Energy Consumption #

A machine learning approach for fault detection of enery consumption
values in a environment.

### Dependencies

* MATLAB (https://www.mathworks.com/products/matlab.html).
* The Matworks database toolbox (https://www.mathworks.com/products/database.html)
* The **Bayesian Network Toolbox (BNT)** for MATLAB (https://github.com/bayesnet/bnt).
* Optional: a SQLite browser to browse the database, e.g., https://sqlitebrowser.org/.

### Development environment

Download the `Bayesian Net Toolbox`:

 ```
 make
 ```

Open MATLAB, navigate to this working folder, and load these libraries
by running:

```
loadBNTlibrary
```

### Usage

To generate the Bayesian Network(s)
```
dataAcquisition
```

To compute the Conditional Probability Tables (CPTs) of each node of the Bayesian Network and 
to compute the Full Joint Distribution of the Bayesian Network:
```
fullJointDistribution
```



## Description of the environment

The environment consists in a room of about 20 square meters and it is
supposed to be used as a chill-out zone.

As depicted in the figure below, there is only one door to access the
room. On the opposite side there is a wide window. In the bottom-right corner
there are three electrical appliances: a microwave, a kettle, and a
water dispenser.

Sofas are placed on the wall in the bottom and on the wall to the left,
whereas coffee tables and chairs are present in the center of the room.


<img src="img/room.png" width="600" alt="The environment">

The room is equipped with the following **sensors**:

1. an open/close sensor for the windows;
2. a temperature and humidity sensor near the window;
3. a temperature and movement sensor near the door;
4. an energy consumption sensor, called _Z-Plug_, on which all the
   electrical appliances are plugged.

These sensors communicate with a central unit through (wireless) the
ZigBee protocol and the data collected are saved in a SQLite
database.

## Bayesian Networks

We use bayesian networks to represent dependencies among the data
gathered by the four sensors introduced above in order to design 
_[bayesian inference](https://en.wikipedia.org/wiki/Bayesian_inference)_
procedures, such as different fault-detection systems.

Bayesian networks are data structures that map the relationship between
events in terms of their probability.  More specifically, a bayesian
network is a **direct acyclic graph** where each _node_ corresponds to a
random variable (either descrete or continus) and each _direct arc_ from
node X to node Y means that X has a
_[conditional dependency](https://en.wikipedia.org/wiki/Conditional_dependence)_
on Y.  This conditional dependency is defined by a
_[Conditional Probability Distribution](https://en.wikipedia.org/wiki/Conditional_probability_distribution)_
(**CPD**) that, for each node, quantifies the effect of the parents on
that node.

In case the random variable is discrete, the _CPD_ can be represented as
a
_[Conditional Probability Table](https://en.wikipedia.org/wiki/Conditional_probability_table)_
(**CPT**). The _CPT_ lists the probability that a node takes on each of
its different values for each combination of values of its parents.

### Our Bayesian Network

The topology (structure) and the parameters of each CPD can be both
learned from data.  However, since learning structure is much harder
than learning parameters, we have designed the topology of the network
according to the method given in Chapter 14.2 of the book
_[Artificial Intelligence: A Modern Approach](http://aima.cs.berkeley.edu/)_.

The aim of our Bayesian Network is to model the environment (the room) by the data
gathered from all the sensors.

We define six _observable nodes_ that model the output of each sensor and
one _hidden node_ that models the possible presence of a person inside the
room.


Number | Name | Modelled data 
------ | ----  | -----------
1	| Movement	| Motion detection (_binary_)
2  | Presence (Hidden Node) | Presence inside the room  (_binary_)
3	| WindowOpen			| Window open (_binary_)
4	| Z-Plug			| Energy consumption (_Watt_)
5	| TemperatureDoor	| Temperature near the door (_Celsius_)
6	| Humidity			| Relative humidity (_percent_)
7	| TemperatureWindow	| Temperature near the window (_Celsius_)

The picture below shows the structure of our bayesian network.
<img src="img/bnet01.png" width="600" alt="The Bayesian Network">


### Data acquisition and Learning

In order to perform statistical inference on a bayesian network, it is necessary to
perform a _learning phase_ based on the available data.

The learning function of BNT Toolbox needs a _matrix_ with the samples
of the collected data. Each row of the matrix represents a node, whereas
each column a sample gathered from every sensor at a given point of
time.

As the sensors in the room provide samples in various format and with a
different timestamps, to collect data in a coherent way we have
performed the following steps:

1. We have defined a timeline **T** of timestamps based on when a new
   sample is gathered by the _TemperatureDoor_ sensor. The sampling rate
   is 1 sample every 3 minutes. (We note that the choice of the specific
   sensor is completely arbitrary; it is important to fix an unique
   _timeline_ and then adapt the samples of the other sensors to it.)

2. For each timestamp `t` in the timeline **T** defined at point 1., we
    have extracted the samples of the _Humidity_ sensor, the
    _TemperatureWindow_ sensor, and of the _Z-Plug_ energy consumption
    sensor whose timestamps are the closest to `t`.

3. For each timestamp `t` in the timeline **T** defined at point 1., we
   have set the value of _Movement_ and _WindowOpen_ sensors to 1 if, in
   the last 3 minutes, the corresponding sensor has been activated at
   least once.

#### How to

In the MATLAB terminal, run
```
dataAcquisition
```
Inside the script you can change the time period:

* earliest date: '2012-06-26 00:00:00'
* latest date: '2012-07-28 00:00:00'

In particular, the script calls the function
`dataAcquisition/computeBnet.m` that creates a matrix [8 x #samples]
representing the Bayesian Network. Each row contains the values of a
node over time:

Row | Sensor | Unit
--- | -----  | ----
1 | movementDetected | binary
2 | windowOpen | binary
3 | KettleOn | binary
4 | WaterDispenserOn | binary
5 | MicrowaveOn | binary
6 | TemperatureWindow | Celsius
7 | RelativeHumidity | percent
8 | TemperatureDoor | Celsius

All the data is saved in the MATLAB formatted data file `bNet_data.mat`.


### Bayesian Inference: Fault-Detection

To compute the Conditional Probability Tables (CPTs) of each node of the Bayesian Network
```
calculateCPT
```

To compute the Conditional Probability Tables (CPTs) of each node of the Bayesian Network and 
to compute the Full Joint Distribution of the Bayesian Network:
```
fullJointDistribution
```

