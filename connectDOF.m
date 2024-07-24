function Td = connectDOF(data,Tn)

Td=zeros(data.nel, data.nd*data.ni);

    for i=1:data.nel
        Td(i,1)=nod2dof(data.ni,Tn(i,1),1);
        Td(i,2)=nod2dof(data.ni,Tn(i,1),2);
        Td(i,3)=nod2dof(data.ni,Tn(i,2),1);
        Td(i,4)=nod2dof(data.ni,Tn(i,2),2);
    end
end