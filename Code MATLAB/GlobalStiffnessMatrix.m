classdef GlobalStiffnessMatrix < handle
    properties (Access = private)
        data    % Dades generals d'entrada
        Td      % Matriu connectivitats DOFs
        fel     % Fuerzas de los elementos
        nnod    % Nombre total de nodes
        ndof    % Graus de llibertat totals
        nel     % Nombre d'elements
        nne     % Nombre de nodes per element
        ni      % Graus llibertat per node
        x       % Coordenades dels nodes
        Tn      % Matriu connectivitats nodals
        Tm      % Matriu connectivitats materials
        m       % Matriu propietats materials
    end
    
    methods (Access = public)
        

        % Constructor
        function obj = GlobalStiffnessMatrix(data,x,Tn,Td,Tm,m,fel)
            obj.init(data,x,Tn,Td,Tm,m,fel)
        end
        

        % Mètode 1: Càlcul matrius rigidesa elementals
        function Kel = computeKel(obj)
        Xel = zeros(obj.nel,obj.nne*obj.ni);
        lcs = zeros(obj.nel,3);
        EA = zeros(obj.nel,2);
            for i=1:obj.nel
                for j=1:obj.nne
                    Xel(i,2*j-1)=obj.x(obj.Tn(i,j),1);
                    Xel(i,2*j)=obj.x(obj.Tn(i,j),2);
                end

            lcs(i,1)=sqrt((Xel(i,3)-Xel(i,1))^2+(Xel(i,4)-Xel(i,2))^2);
            lcs(i,2)=(Xel(i,3)-Xel(i,1))/lcs(i,1);
            lcs(i,3)=(Xel(i,4)-Xel(i,2))/lcs(i,1);
            EA(i,1)=obj.m(obj.Tm(i),1);
            EA(i,2)=obj.m(obj.Tm(i),2);

            Kel{i}=((EA(i,1)*EA(i,2))/(lcs(i,1)))*[ % Matriz cos & sin
            (lcs(i,2))^2        lcs(i,2)*lcs(i,3)       -(lcs(i,2))^2       -lcs(i,2)*lcs(i,3)
            lcs(i,2)*lcs(i,3)   (lcs(i,3))^2            -lcs(i,2)*lcs(i,3)  -(lcs(i,3))^2
            -(lcs(i,2))^2       -lcs(i,2)*lcs(i,3)      (lcs(i,2))^2        lcs(i,2)*lcs(i,3)
            -lcs(i,2)*lcs(i,3)  -(lcs(i,3))^2           lcs(i,2)*lcs(i,3)   (lcs(i,3))^2
            ];
            end
        end
        

        % Mètode 2: Càlcul matriu rigidesa global        
        function K = computeGSM(obj)
        Kel = computeKel(obj);    
        K = zeros(obj.ndof,obj.ndof);
            for e=1:obj.nel
                for i=1:obj.nne*obj.ni
                    for j=1:obj.nne*obj.ni
                        K(obj.Td(e,i),obj.Td(e,j))=K(obj.Td(e,i),obj.Td(e,j))+Kel{e}(i,j);
                    end
                end
            end
        end


        function f = computeF(obj)
        f = zeros(obj.ndof,1);
            for e=1:obj.nel
                for i=1:obj.nne*obj.ni
                    f(obj.Td(e,i))=f(obj.Td(e,i))+obj.fel{e}(i);
                end
            end
        end
    end


    methods (Access = private)
        function init(obj,data,x,Tn,Td,Tm,m,fel)                
            obj.Td = Td;    
            obj.x=x;
            obj.Tn=Tn;
            obj.Tm=Tm;
            obj.m=m;
            obj.nnod = data.nnod;   
            obj.ndof = data.ndof;   
            obj.nel = data.nel;     
            obj.nne = data.nne;     
            obj.ni = data.ni;       
            obj.fel = fel;          
        end
    end
end


