classdef StressSolution < Solver
    %STRESSSOLUTION Summary of this class goes here
    %   Detailed explanation goes here
    
    methods (Access = public)
        function obj = StressSolution(s)
            obj.init(s)
        end

        function sig = computeStress(obj,u)
        Xel = zeros(obj.nel,obj.nne*2);
        lcs = zeros(obj.nel,3);
        OE = zeros(obj.nel,2);
        sig = zeros(obj.nel,1);
        eps = zeros(obj.nel,1);
            for i=1:obj.nel                % FORCE FUNCTION BARRA A BARRA
                for j=1:obj.nne            % Matriz Xel
                    Xel(i,2*j-1)=obj.x(obj.Tn(i,j),1);
                    Xel(i,2*j)=obj.x(obj.Tn(i,j),2);
                end
            % Matriz long, cos, sin
            lcs(i,1)=sqrt((Xel(i,3)-Xel(i,1))^2+(Xel(i,4)-Xel(i,2))^2);
            lcs(i,2)=(Xel(i,3)-Xel(i,1))/lcs(i,1);
            lcs(i,3)=(Xel(i,4)-Xel(i,2))/lcs(i,1);
            % Matriz tensión inicial, Modulo de Young
            OE(i,1)=obj.m(obj.Tm(i),3);
            OE(i,2)=obj.m(obj.Tm(i),1);
            % Matriz de rotación
            R{i}=[
            lcs(i,2)    lcs(i,3)        0           0
            -lcs(i,3)   lcs(i,2)        0           0
            0           0       lcs(i,2)    lcs(i,3)
            0           0       -lcs(i,3)   lcs(i,2)
            ];
            uel = zeros(obj.nne*obj.ni,1);
                for j=1:obj.nne*obj.ni
                    uel(j) = u(obj.Td(i,j));
                end
            % Matriz de fuerzas de la barra en locales
            eps(i)=(1/lcs(i,1))*[-1 0 1 0]*R{i}*uel; % Adimensional
            sig(i)=10^6*OE(i,2)*eps(i)+OE(i,1);      % Transformado a Pascales
            end
        end
    end

    methods (Access=private)  
        function init(obj,s)
            obj.ndof = s.data.ndof;
            obj.nne=s.data.nne;
            obj.nel=s.data.nel;
            obj.ni=s.data.ni;
            obj.x=s.x;
            obj.Tn=s.Tn;
            obj.Tm=s.Tm;
            obj.Td=s.Td;
            obj.m=s.m;
            obj.p=s.p;
        end
    end
end

