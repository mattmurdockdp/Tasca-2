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

