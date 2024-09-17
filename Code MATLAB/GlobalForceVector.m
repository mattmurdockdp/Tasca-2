classdef GlobalForceVector < handle
  
    properties
        data    % Dades generals d'entrada
        Td      % Matriu connectivitats DOFs
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
        function obj = GlobalForceVector(data,x,Tn,Td,Tm,m)
            obj.init(data,x,Tn,Td,Tm,m)
        end
        

        % Mètode 1: Càlcul forces elementals
        function fel = forceFunction(obj)
            Xel = zeros(obj.nel,obj.nne*obj.ni);
            lcs = zeros(obj.nel,3);
            AO = zeros(obj.nel,2);

            for i=1:obj.nel                % FORCE FUNCTION BARRA A BARRA
                for j=1:obj.nne            % Matriz Xel
                    Xel(i,2*j-1)=obj.x(obj.Tn(i,j),1);
                    Xel(i,2*j)=obj.x(obj.Tn(i,j),2);
                end

            % Matriu long, cos, sin
            lcs(i,1)=sqrt((Xel(i,3)-Xel(i,1))^2+(Xel(i,4)-Xel(i,2))^2);
            lcs(i,2)=(Xel(i,3)-Xel(i,1))/lcs(i,1);
            lcs(i,3)=(Xel(i,4)-Xel(i,2))/lcs(i,1);

            % Matriu Area, Tensió inicial
            AO(i,1)=obj.m(obj.Tm(i),2);
            AO(i,2)=obj.m(obj.Tm(i),3);

            % Matriu de rotació
            R{i}=[
            lcs(i,2)    lcs(i,2)        0           0
            -lcs(i,3)   lcs(i,2)        0           0
                0           0       lcs(i,2)    lcs(i,3)
                0           0       -lcs(i,3)   lcs(i,2)
            ];

            % Matriu de forces de la barra en locals
            fel{i}=(-AO(i,2)*AO(i,1)/10^6)*(transpose(R{i})*[-1;0;1;0]);

            end
        end
    
    end

    methods (Access = private)
        
        function init(obj,data,x,Tn,Td,Tm,m)                
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
        end    
    end


end

