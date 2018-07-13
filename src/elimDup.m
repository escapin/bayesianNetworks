function [res] = elimDup(arr)
length=size(arr);
arr=sortrows(arr,1);
res=cell(floor(length(1)/2), length(2));
j=1;
i=1;
while (i<length(1))
    if cell2mat(arr(i,1)) ~= cell2mat(arr(i+1,1))
        res(j,:)=arr(i,:);
        j=j+1;
        i=i+1;
    else
        if cell2mat(arr(i,length(2)))==1
            res(j,:)=arr(i,:);
        else
            res(j,:)=arr(i+1,:);
        end
        i=i+2;
        j=j+1;
    end
end