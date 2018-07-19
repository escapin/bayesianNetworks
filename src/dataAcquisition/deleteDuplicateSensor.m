function [ res ] = deleteDuplicateSensor( data )
%Delete duplicate of Time Value

%data = struct2cell(data);

lenghtData = size(data);

i = 1;
j = 1;
res = cell(lenghtData(1),floor(lenghtData(2)/2));
while (i<lenghtData(2))
     if datenum(data(2,i)) ~= datenum(data(2,i+1))
        res(:,j)=data(:,i);
        i=i+1;
        j=j+1; 
     else
         res(:,j)=data(:,i);
         i=i+2;
         j=j+1;
     end
     if(i==lenghtData(2))
         res(:,j)=data(:,i);
     end
end
end

