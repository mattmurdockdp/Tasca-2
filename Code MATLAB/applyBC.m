function [up,vp] = applyBC(data,p)

np = size(p,1);
up = zeros(np,1);
vp = zeros(np,1);

    for i=1:np
        vp(i)=nod2dof(data.ni,p(i,1),p(i,2));
        up(i)=p(i,3);
    end
end