classdef DirectSolver < Solver
    properties

    end

    methods (Access=public)
        function obj = DirectSolver(s)
            obj.init(s)
            obj.calculatePrescDOFS();
        end
        
        function u = computeUL(obj)
            
            % Vector DOFs lliures
            vf = setdiff((1:obj.ndof)',obj.vp);

            % Inicialitzar vector desplaçaments a 0
            u = zeros(obj.ndof, 1);
            
            % Assignem DOFs restringits
            u(obj.vp) = obj.up;
            
            % Calculem desplaçaments de DOFs lliures
            u(vf) = obj.K(vf, vf) \ (obj.f(vf) - obj.K(vf, obj.vp) * u(obj.vp));
        end

        function r = computeReactions(obj, u)
            % Assegurar que f(obj.vp) sigui un vector columna
            f_vp = obj.f(obj.vp);  
            
            % Calcular les reaccions
            r = obj.K(obj.vp, :) * u - f_vp;
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
            obj.K = s.K;
            obj.f = s.f;
            obj.p=s.p;
        end
    end
end

