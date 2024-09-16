classdef DirectSolver
    properties
        data
        K
        f
        up
        vp
        ndof
    end

    methods
        function obj = DirectSolver(data,K,f,up,vp)
            obj.ndof = data.ndof;
            obj.K = K;
            obj.f = f;
            obj.up = up;
            obj.vp= vp;
        end
        
        function u = ComputeUL(obj)
            
            % Vector DOFs lliures
            vf = setdiff((1:obj.ndof)',obj.vp);

            % Inicialitzar vector desplaçaments a 0
            u = zeros(obj.ndof, 1);
            
            % Assignem DOFs restringits
            u(obj.vp) = obj.up;
            
            % Calculem desplaçaments de DOFs lliures
            u(vf) = obj.K(vf, vf) \ (obj.f(vf) - obj.K(vf, obj.vp) * u(obj.vp));
        end

        function r = ComputeReactions(obj, u)
            % Assegurar que f(obj.vp) sigui un vector columna
            f_vp = obj.f(obj.vp);  
            
            % Calcular les reaccions
            r = obj.K(obj.vp, :) * u - f_vp;
        end

    end
end

