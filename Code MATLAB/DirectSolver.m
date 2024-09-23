classdef DirectSolver < Solver
    properties
        data
        x
        Tn
        Tm
        Td
        m
        K
        f
        up
        vp
        ndof
        nne
        nel
        ni
        np
    end

    methods (Access=public)
        function obj = DirectSolver(data,x,Tn,Tm,Td,m,K,f,up,vp)
            obj.init(data,x,Tn,Tm,Td,m,K,f,up,vp)
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
        function init(obj,data,x,Tn,Tm,Td,m,K,f,up,vp)
            obj.ndof = data.ndof;
            obj.nne=data.nne;
            obj.nel=data.nel;
            obj.ni=data.ni;
            obj.x=x;
            obj.Tn=Tn;
            obj.Tm=Tm;
            obj.Td=Td;
            obj.m=m;
            obj.K = K;
            obj.f = f;
            obj.up = up;
            obj.vp= vp;
        end
    end
end

