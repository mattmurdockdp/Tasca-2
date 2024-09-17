classdef SolverClass < handle
    % Aquesta classe actua com a classe mare de les classe IterativeSolver i DirectSolver
    
    properties
        solverType
        solverObj
    end
    
    methods(Static, Access = public)
        function obj = create(solverType, data, K, f, up, vp)
            switch solverType
                case 'Direct'
                    obj = DirectSolver(data, K, f, up, vp);
                case 'Iterative'
                    obj = IterativeSolver(data, K, f, up, vp);
                otherwise
                    error('Tipus de solucionador no vàlid. Escull ''Direct'' o ''Iterative''.');
            end
        end
    end

    methods    
        function u = ComputeUL(obj)
            u = obj.solverObj.ComputeUL();
        end
        
        function r = ComputeReactions(obj, u)
            r = obj.solverObj.ComputeReactions(u);
        end
   end

end