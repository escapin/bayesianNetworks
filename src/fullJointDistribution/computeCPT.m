function bnetCPT = calculateCPT(dataLearning, minmaxVector)

%% Calculate the CPT for Bayesian Network
%  Parameters:
%   datalearning: matrix of data for learn_params_em
%   minmaxVector: array that contains the minumum and the maxium values for 
%                 TemperatureWindow, TemperatureDoor, and Humidity sensors
%  Return:
%   Bayesian Network with populated CPT
%

N = 7;

dag = zeros(N,N);
observed_nodes = [1 3 4 5 6 7];
discrete_nodes = 1:N;

movement = 1;

presence = 2;

window = 3;
zPlug=4;

tempWin = 5;
humidity = 6;
tempDoor = 7;

%% Creating Edges
dag(movement, presence) = 1;
dag(presence,[window zPlug])=1;
dag(window,[tempWin humidity tempDoor])=1;



%% Generate Bnet

minZplugPower=minmaxVector(1,1);
maxZplugPower=minmaxVector(2,1);
minTempWin=minmaxVector(1,2);
maxTempWin=minmaxVector(2,2);
minHumidity=minmaxVector(1,3);
maxHumidity=minmaxVector(2,3);
minTempDoor=minmaxVector(1,4);
maxTempDoor=minmaxVector(2,4);

node_sizes = [2 2 2 maxZplugPower-minZplugPower+1 maxTempWin-minTempWin+1 maxHumidity-minHumidity+1 maxTempDoor-minTempDoor+1];

bnetHid = mk_bnet(dag, node_sizes, 'discrete', discrete_nodes, 'observed', observed_nodes);

% CPD
% The initial values of bnet don't matter in this case, since we can find the globally optimal MLE independent of where we start.
bnetHid.CPD{movement} = tabular_CPD(bnetHid, movement, 'prior_type', 'dirichlet', 'dirichlet_type', 'BDeu');
% Hidden Node
bnetHid.CPD{presence} = tabular_CPD(bnetHid, presence, 'prior_type', 'dirichlet', 'dirichlet_type', 'BDeu');

bnetHid.CPD{window} = tabular_CPD(bnetHid, window, 'prior_type', 'dirichlet', 'dirichlet_type', 'BDeu');

bnetHid.CPD{zPlug} = tabular_CPD(bnetHid, zPlug, 'prior_type', 'dirichlet', 'dirichlet_type', 'BDeu');


bnetHid.CPD{tempWin} = tabular_CPD(bnetHid, tempWin, 'prior_type', 'dirichlet', 'dirichlet_type', 'BDeu');
bnetHid.CPD{humidity} = tabular_CPD(bnetHid, humidity, 'prior_type', 'dirichlet', 'dirichlet_type', 'BDeu');
bnetHid.CPD{tempDoor} = tabular_CPD(bnetHid, tempDoor, 'prior_type', 'dirichlet', 'dirichlet_type', 'BDeu');






%% Learning Phase
disp('Executing Learn Params EM...');


% Configuring Engine and Data 
engine=jtree_inf_engine(bnetHid);
max_iter=10;
[bnetCPT, LLtrace, engineHid] = learn_params_em(engine, dataLearning, max_iter);

%% View Data
% To view the learned parameters, we use a little Matlab hackery.
CPT = cell(1,N);
for i=1:N
  s=struct(bnetCPT.CPD{i});  % violate object privacy
  CPT{i}=s.CPT;
end

% 1 = false, 2 = true, 
%Here are the parameters learned for node 1
disp 'CPT for movement'
dispcpt(CPT{movement})

disp 'CPT for presence'
dispcpt(CPT{presence})

disp 'CPT for window'
dispcpt(CPT{window})

disp 'CPT for zPlug'
dispcpt(CPT{zPlug})

disp 'CPT for temperature window'
dispcpt(CPT{tempWin})
disp 'CPT for humidity'
dispcpt(CPT{humidity})
disp 'CPT for temperature door'
dispcpt(CPT{tempDoor})


