function [K,f] = assemblyFunction(data,Td,Kel,fel)
f = zeros(data.ndof,1);
K = zeros(data.ndof,data.ndof);
    for e=1:data.nel
        for i=1:data.nne*data.ni
            f(Td(e,i))=f(Td(e,i))+fel{e}(i);
            for j=1:data.nne*data.ni
                K(Td(e,i),Td(e,j))=K(Td(e,i),Td(e,j))+Kel{e}(i,j);
            end
        end
    end
end