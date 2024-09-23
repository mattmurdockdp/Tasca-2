classdef Solver < handle
    % Aquesta classe actua com a classe mare de les classe IterativeSolver i DirectSolver
    
    properties
        solverType
    end

    methods(Static, Access = public)
        function obj = chooseType(solverType,data,x,Tn,Tm,Td,m,K,f,p)

        % Boundary Conditions
        np = size(p,1);
        vp = zeros(1,np);
        up = zeros(1,np);

        for i=1:np
            vp(i)=nod2dof(data.ni,p(i,1),p(i,2));
        end

        for i=1:np
            up(i)=p(i,3);
        end
        
        % Set Solver Type and create instance 
            switch solverType
                case 'Direct'
                    obj = DirectSolver(data,x,Tn,Tm,Td,m,K,f,up,vp);
                case 'Iterative'
                    obj = IterativeSolver(data,x,Tn,Tm,Td,m,K,f,up,vp);
                otherwise
                    error('Tipus de solucionador no vàlid. Escull ''Direct'' o ''Iterative''.');
            end
        end
    end

    methods    
        function u = computeUL(obj)
            u = obj.computeUL();
        end
        
        function r = computeReactions(obj, u)
            r = obj.computeReactions(u);
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

end

