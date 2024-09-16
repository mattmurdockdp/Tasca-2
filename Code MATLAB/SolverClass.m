classdef SolverClass
    % Aquesta classe actua com a classe mare de les classe IterativeSolver i DirectSolver
    
    properties
        solverType
        solverObj
    end
    
    methods
        function obj = SolverClass(solverType, data, K, f, up, vp)
            obj.solverType = solverType;
            switch solverType
                case 'Direct'
                    obj.solverObj = DirectSolver(data, K, f, up, vp);
                case 'Iterative'
                    obj.solverObj = IterativeSolver(data, K, f, up, vp);
                otherwise
                    error('Tipo de solucionador no vàlid. Escull ''Direct'' o ''Iterative''.');
            end
        end
        
        function u = ComputeUL(obj)
            u = obj.solverObj.ComputeUL();
        end
        
        function r = ComputeReactions(obj, u)
            r = obj.solverObj.ComputeReactions(u);
        end
    end
end