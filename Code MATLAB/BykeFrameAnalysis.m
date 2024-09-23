classdef BykeFrameAnalysis < handle
    
    methods(Static, Access = public)
        
        function objSolver = getSol(typeSolv,data,x,Tn,Tm,Td,m,K,f,p)

            objSolver = Solver.chooseType(typeSolv,data,x,Tn,Tm,Td,m,K,f,p);

        end

        function objGSM = getGSM(data,x,Tn,Td,Tm,m)
            
            objGSM = GlobalStiffnessMatrix(data,x,Tn,Td,Tm,m);

        end

        function objF = getF(data,x,Tn,Td,Tm,m,F)

            objF = GlobalForceVector(data,x,Tn,Td,Tm,m,F);
        end
    end

    methods
        
        function K = computeGSM(objGSM)
            K = objGSM.computeGSM();
        end
        
        function K = computeF(objF)
            K = objF.computeF();
        end

        function u = computeUL(objSolver)
            u = objSolver.computeUL();
        end

        function r = computeReactions(objSolver,u)
            r = objSolver.computeReactions(u);
        end

        function sig = computeStress(objSolver,u)
            sig = objSolver.computeStress(u);
        end

    end
end

