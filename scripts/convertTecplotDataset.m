% Convert an entire directory of .dat files to .mat

setupPath;

datDir = '/home/afishman/flow-modelling/jleontin/villi_2/for_aaron/';
matDir = '/home/afishman/flow-modelling/jleontin/villi_2/aaron/';

% Load Metadata. You can override settings here as needed
metadata = load('simulation1Hz.mat');

% Batch convert files
dat2mat(datDir, matDir, metadata);