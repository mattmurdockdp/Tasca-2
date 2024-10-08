classdef BykeFrameAnalysis < handle
    properties
        data    % Dades generals d'entrada
        Td      % Matriu connectivitats DOFs
        x       % Coordenades dels nodes
        Tn      % Matriu connectivitats nodals
        Tm      % Matriu connectivitats materials
        m       % Matriu propietats materials
        F       % Matriu Forces
        solverType
        p
    end

    methods (Access=public)
        function obj = BykeFrameAnalysis(s)
            obj.init(s);
        end
    end

    methods(Static, Access = public)
        
        function [u,sig] = computeSolution(obj)
            
            K = obj.computeK();
            f = obj.computeF();

            u = obj.computeDisplacement(K,f);
            sig = obj.computeStress(u);
           
        end

    end
    
    methods (Access=private)
        function init(obj,s)
            obj.solverType = s.solverType;
            obj.data       = s.data;
            obj.x          = s.x;
            obj.Tn         = s.Tn;
            obj.Tm         = s.Tm;
            obj.Td         = s.Td;
            obj.m          = s.m;
            obj.p          = s.p;
            obj.F          = s.F;
        end

        function K = computeK(obj)
            GSM = GlobalStiffnessMatrix(obj.data,obj.x,obj.Tn,obj.Td,obj.Tm,obj.m);
            K = GSM.computeGSM();
        end

        function f = computeF(obj)
            Fgen = GlobalForceVector(obj.data,obj.x,obj.Tn,obj.Td,obj.Tm,obj.m,obj.F);
            f = Fgen.computeF();
        end

        function u = computeDisplacement(obj,K,f)
            s.solverType = obj.solverType;
            s.data       = obj.data;
            s.x          = obj.x;
            s.Tn         = obj.Tn;
            s.Tm         = obj.Tm;
            s.Td         = obj.Td;
            s.m          = obj.m;
            s.p          = obj.p;
            s.F          = obj.F;
            s.K          = K;
            s.f          = f;
            
            objSolver = Solver.create(s);
            u = objSolver.computeUL();
        end

        function sig = computeStress(obj,u)
            s.solverType = obj.solverType;
            s.data       = obj.data;
            s.x          = obj.x;
            s.Tn         = obj.Tn;
            s.Tm         = obj.Tm;
            s.Td         = obj.Td;
            s.m          = obj.m;
            s.p          = obj.p;
            s.F          = obj.F;

            objSolver = StressSolution(s);
            sig = objSolver.computeStress(u);
        end

    end

end

