classdef BoundaryConditionsClass
 
    properties
        data
        p
        ni
        np
    end
    
    methods
        function obj = BoundaryConditionsClass(data,p)
            obj.ni = data.ni;
            obj.p = p;
            obj.np = size(p,1);
        end
        
        function I = nod2dof(ni,i,j)
            I=(i-1)*ni+j;
        end

        function vp = SetVp(obj)
            for i=1:obj.np
                vp(i)=nod2dof(obj.ni,obj.p(i,1),obj.p(i,2));
            end
        end

        function up = SetUp(obj)
            for i=1:obj.np
                up(i)=obj.p(i,3);
            end
        end

    end
end

