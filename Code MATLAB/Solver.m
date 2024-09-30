classdef Solver < handle
    % Aquesta classe actua com a classe mare de les classe IterativeSolver i DirectSolver    
    properties
        solverType
        up
        vp
        data
        x
        Tn
        Tm
        Td
        m
        K
        f
        ndof
        nne
        nel
        ni
        np
        p
    end

    methods(Static, Access = public)
        function obj = create(s)

        % Set Solver Type and create instance 
            switch s.solverType
                case 'Direct'
                    obj = DirectSolver(s);
                case 'Iterative'
                    obj = IterativeSolver(s);
                otherwise
                    error('Tipus de solucionador no vàlid. Escull ''Direct'' o ''Iterative''.');
            end
        end
    end
    methods (Access=protected)
        function calculatePrescDOFS(obj)
            
            % Boundary Conditions
            numberDOFS = size(obj.p,1);

            for i=1:numberDOFS
                obj.vp(i)=nod2dof(obj.ni,obj.p(i,1),obj.p(i,2));
            end

            for i=1:numberDOFS
                obj.up(i)=obj.p(i,3);
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

