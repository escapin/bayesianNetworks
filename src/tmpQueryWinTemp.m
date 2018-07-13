tmp=round(cell2mat(cellfun(@str2num, data(1,:)))*10);

data(1,:)=num2cell(cellfun(@str2num, data(1,:)));

N = 3;
dag = zeros(N,N);
tempDoor = 1;
win01 = 2;
win02 = 3;
dag(win01,[tempDoor]) = 1;
dag(win02,[tempDoor]) = 1;
discrete_nodes = 2:3;
observed_nodes = 1:N;
node_sizes = [120 2 2]; 
bnet = mk_bnet(dag, node_sizes, 'discrete', discrete_nodes, 'observed', observed_nodes);

bnet.CPD{tempDoor} = tabular_CPD(bnet, tempDoor);
bnet.CPD{win01} = tabular_CPD(bnet, win01);
bnet.CPD{win02} = tabular_CPD(bnet, win02);

%data=cell2mat(temperature);

bnetPar = learn_params(bnet, data);

To view the learned parameters, we use a little Matlab hackery.
CPT = cell(1,N);
for i=1:N
  s=struct(bnet.CPD{i});  % violate object privacy
  CPT{i}=s.CPT;
end

Here are the parameters learned for node 1
disp 'CPT for temperature'
dispcpt(CPT{1})
disp 'CPT for window 1'
dispcpt(CPT{2})
disp 'CPT for window 2'
dispcpt(CPT{3})

save 'CPTtempWin.mat'