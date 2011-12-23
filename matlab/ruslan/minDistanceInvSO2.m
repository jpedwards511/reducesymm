function dmin=minDistanceInvSO2(a,b)

if size(b,2)>=size(a,2),
    aa=a;
    bb=b;
else
    aa=b;
    bb=a;
end

dmin=zeros(size(aa,2),1);
dij=zeros(size(bb,2),1);
 
for i=1:size(aa,2),
     for j=1:size(bb,2),
        dij(j)=norm(aa(:,i)-bb(:,j));
     end
     dmin(i)=min(dij);
end

