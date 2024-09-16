classdef GlobalStiffnessMatrixComputer 
    properties
        data    % Datos generales de entrada
        Td      % Matriz de conectividades nodales
        Kel     % Matrices de rigidez de los elementos
        fel     % Fuerzas de los elementos
        nnod    % Número total de nodos
        ndof    % Grados de libertad totales
        nel     % Número de elementos
        nne     % Número de nodos por elemento
        ni      % Grados de libertad por nodo
    end
    
    methods
        function obj = GlobalStiffnessMatrixComputer(data,Td,Kel,fel)
            obj.Kel = Kel;          
            obj.Td = Td;            
            obj.nnod = data.nnod;   
            obj.ndof = data.ndof;   
            obj.nel = data.nel;     
            obj.nne = data.nne;     
            obj.ni = data.ni;       
            obj.fel = fel;          
        end
        
        function K = ComputeGSM(obj)
        K = zeros(obj.ndof,obj.ndof);
            for e=1:obj.nel
                for i=1:obj.nne*obj.ni
                    for j=1:obj.nne*obj.ni
                        K(obj.Td(e,i),obj.Td(e,j))=K(obj.Td(e,i),obj.Td(e,j))+obj.Kel{e}(i,j);
                    end
                end
            end
        end

        function f = ComputeF(obj)
        f = zeros(obj.ndof,1);
            for e=1:obj.nel
                for i=1:obj.nne*obj.ni
                    f(obj.Td(e,i))=f(obj.Td(e,i))+obj.fel{e}(i);
                end
            end
        end
    end
end

