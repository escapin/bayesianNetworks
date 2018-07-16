% Script loading the libraries 'mksqlite' and 'bnt' to the workspace

clear all

% add the library to query the SQLite db
addpath lib/mksqlite
% add the libraries of the Bayesian Network Toolbox
cd lib/bnt
addpath(genpathKPM(pwd))
cd BNT
addpath(genpathKPM(pwd))
cd ../../..
