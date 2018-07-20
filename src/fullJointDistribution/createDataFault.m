function [dataFault, indexMat] = createDataFault(dataZplug, startFault, faultValue, type)

%
% Insert fault in dataZplug from startFalut index to the end. The faults values are inserted when there aren't movement for at least ten instant.
% Parameter:
%	-dataZplug	: data from Z-Plug sensor
%	-startFalut	: index of start fault
%	-faultValue	: watt value of fault
%	-type       : "complete" :  insert in all interval
%                 "random":     insert in a random interval
%                 "one":		one for interaval


assert(startFault > 0 && startFault <= size(dataZplug,2), 'startFault must be betwenn 1 and size(dataZplug,2)');

range=startFault:size(dataZplug,2);


dataMov=cell2mat(dataZplug(1,range));

index=find(dataMov==0);

i=1;
indexMat=zeros(3,round(size(index,2)/10));
j=1;
while(i<=size(index,2))
    startI=index(i);
    endI=index(i);
    k=10;
    while(i+k<=size(index,2) && index(i)+k==index(i+k))
        endI=index(i+k);
        k=k+1;
    end
    
    if(startI==endI)
        i=i+1;
    else
        indexMat(1,j)=startI+1;
        indexMat(2,j)=endI-1;
        j=j+1;
        i=i+k;
    end
end
indexMat=indexMat(:,1:j-1);

indexMat = indexMat + startFault-1;
indexMat(3,:)=-2; % red

%zPlugPower=dataZplug(4,:);

for i=1:size(indexMat,2)
    switch(type)
        case 'complete'
            for j=indexMat(1,i):indexMat(2,i)
                    dataZplug(4,j)={faultValue};
            end
        case 'random'
            if(rand>0.5)
                for j=indexMat(1,i):indexMat(2,i)
                    dataZplug(4,j)={faultValue};
                end
            else
                indexMat(3,i)=-1;   % green
            end
        case 'one'
            k=indexMat(1,i)+round((indexMat(2,i)-indexMat(1,i))/2);
            dataZplug(4,k)={faultValue};
            indexMat(3,i)=k;
    end
end
dataFault=dataZplug;
