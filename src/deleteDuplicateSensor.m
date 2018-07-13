function [ res ] = deleteDuplicateSensor( data )
%Delete duplicate of Time Value
data = struct2cell(data);
lenght = size(data);

i = 1;
j = 1;
res = cell(lenght(1),floor(lenght(2)/2));
while (i<lenght(2))
     if datenum(data(2,i)) ~= datenum(data(2,i+1))
        res(:,j)=data(:,i);
        i=i+1;
        j=j+1; 
     else
         res(:,j)=data(:,i);
         i=i+2;
         j=j+1;
     end
     if(i==lenght(2))
         res(:,j)=data(:,i);
     end
end
end

