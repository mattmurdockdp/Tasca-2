% STRUCTURAL PROBLEM CODE STRUCTURE

clear
close all

%% PART 1

% PREPROCESS QUADRE

% Input data FRAME (define your input parameters here)
data.ni = 2;  % Degrees of freedom per node

% Build geometry (mesh)
% Nodal coordinates matrix
x = [% column_1 = x-coord , column_2 = y-coord , ...    
        0        0
    0.459   -0.054
    1.125        0
    0.315    0.486
    0.864     0.486
];

data.nnod = size(x,1); % Number of nodes 
data.nd = size(x,2);   % Problem dimension
data.ndof = data.nnod*data.ni;  % Total number of degrees of freedom

% Nodal connectivities matrix
Tn = [% column_1 = element node 1 , column_2 = element node 2, ...
        1 2  % Stray
        1 4  % Stray
        2 4  % Seat 
        2 5  % Down
        3 5  % Head
        4 5  % Top
];
data.nel = size(Tn,1); % Number of elements 
data.nne = size(Tn,2); % Number of nodes in a bar

% Create degrees of freedom connectivities matrix
Td = connectDOF(data,Tn);

% Material properties matrix (mm)
diameter.HD=36;  espesor.HD=1.5;
diameter.TS=30;  espesor.TS=1.2;
diameter.Sts=20; espesor.Sts=1;

A.HD = (diameter.HD+(espesor.HD))^2*pi/4-(diameter.HD-(espesor.HD))^2*pi/4;
A.TS = (diameter.TS+(espesor.TS))^2*pi/4-(diameter.TS-(espesor.TS))^2*pi/4;
A.Sts = (diameter.Sts+(espesor.Sts))^2*pi/4-(diameter.Sts-(espesor.Sts))^2*pi/4;

m = [% Each column corresponds to a material property (area, Young's modulus, sig_0, I)
       71*1000 A.HD  0 0
       71*1000 A.TS  0 0
       71*1000 A.Sts 0 0
];

% Material connectivities matrix
Tm = [% Each row is the material (row number in 'm') associated to each element
     3
     3
     2
     1
     1
     2
];

% Input boundary conditions
% Fixed nodes matrix
p = [% Each row is a prescribed degree of freedom | column_1 = node, column_2 = direction, column_3 = value of prescribed displacement
    1 1 0
    1 2 0
    3 1 0
    3 2 0
];

% Point loads matrix
masa = 75;
g = 9.8;
aceleracion = 2.5;
W = masa*g;
netforce=masa*aceleracion;

F = [% Each row is a point force component | column_1 = node, column_2 = direction (1 = x-direction, 2 = y-direction), column_3 = force magnitude
    2 2 -0.45*W
    4 2 -0.5*W
    5 1 netforce
    5 2 -0.05*W
];

% SOLUTION BYKE FRAME

objGSM = BykeFrameAnalysis.getGSM(data,x,Tn,Td,Tm,m);
K = objGSM.computeGSM();

objF = BykeFrameAnalysis.getF(data,x,Tn,Td,Tm,m,F);
f = objF.computeF();

TypeA = 'Direct'; TypeB = 'Iterative'; TypeSolver=TypeA;
ObjSol = BykeFrameAnalysis.getSol(TypeSolver,data,x,Tn,Tm,Td,m,K,f,p);
u = ObjSol.computeUL();
r = ObjSol.computeReactions(u);
sig = ObjSol.computeStress(u);

% POSTPROCESS QUADRE

scale = 1000; % Set a number to visualize deformed structure properly
units = 'Pa'; % Define in which units you're providing the stress vector

plot2DBars(data,x,Tn,u,sig,scale,units);


%%  PART 2 
% 
% %% PREPROCESS RODA
% 
% % Input data
% data.ni=2; % degrees of freedom per node
% 
% % Geometria de la rueda 
% 
% % Nodal coordinates matrix
% data.nnod = 9;  % numero de nodos de la rueda
% data.radio = 0.35;  % radio de la rueda 
% x = polireg(data.nnod-1,data.radio); % coordenadas de los nodos de la rueda
% 
% % Nodal connectivities matrix
% Tn = [% column_1 = element node 1 , column_2 = element node 2, ...
%         1 2  % Spoke 1
%         1 3  % Spoke 2
%         1 4  % Spoke 3
%         1 5  % Spoke 4
%         1 6  % Spoke 5
%         1 7  % Spoke 6
%         1 8  % Spoke 7
%         1 9  % Spoke 8
%         2 3  % Rim 1
%         3 4  % Rim 2
%         4 5  % Rim 3
%         5 6  % Rim 4
%         6 7  % Rim 5
%         7 8  % Rim 6
%         8 9  % Rim 7
%         2 9  % Rim 8
% ];
% 
% data.nd = size(x,2);   % Problem dimension
% data.ndof = data.nnod*data.ni;  % Total number of degrees of freedom
% data.nel = size(Tn,1); % Number of elements 
% data.nne = size(Tn,2); % Number of nodes in a bar
% 
% Td = connectDOF(data,Tn);
% 
% % Material properties matrix
%     % MPa               % mm^2           % mm^4
% E.Rim = 70*1000;     A.Rim = 140;    I.Rim = 1470;
% E.Spokes = 210*1000; A.Spokes = 3.8; I.Spokes = 1.15; 
% 
% m = [% Each column corresponds to a material property (area, Young's modulus, sig_0, I)
%        E.Rim    A.Rim     0    I.Rim
%        E.Spokes A.Spokes  0    I.Spokes
% ];
% 
% Tm= [% Each row is the material (row number in 'm') associated to each element
%      2  % Spoke 1
%      2  % Spoke 2
%      2  % Spoke 3
%      2  % Spoke 4
%      2  % Spoke 5
%      2  % Spoke 6
%      2  % Spoke 7
%      2  % Spoke 8
%      1  % Rim 1
%      1  % Rim 2
%      1  % Rim 3
%      1  % Rim 4
%      1  % Rim 5
%      1  % Rim 6
%      1  % Rim 7
%      1  % Rim 8
% ];
% 
% % Boundary conditions
% % Fixed nodes matrix
%  p = [% Each row is a prescribed degree of freedom | column_1 = node, column_2 = direction, column_3 = value of prescribed displacement
%     7 1 0
%     7 2 0
%     8 2 0
% ];
% 
% %% SOLVER RODA DAVANTERA
% % Point loads matrix 
% FRD = [% Each row is a point force component | column_1 = node, column_2 = direction (1 = x-direction, 2 = y-direction), column_3 = force magnitude
%     1 1 -r.bici(3)  % Rx (nodo 3 bicicleta)
%     1 2 -r.bici(4)  % Ry (nodo 3 bicicleta)
% ];
% 
% % Apliquem el solver
% % Compute element stiffness matrices
% Kel = stiffnessFunction(data,x,Tn,m,Tm);
% 
% % Compute element force vectors
% fel = forceFunction(data,x,Tn,m,Tm); 
% 
% % Assemble global stiffness matrix
% assembly = GlobalStiffnessMatrixComputer(data,Td,Kel,fel);
% 
% K = assembly.ComputeGSM(); 
% f = assembly.ComputeF();
% 
% % Apply prescribed DOFs
% [up,vp] = applyBC(data,p); % MOVIMIENTOS (todo 0) Y DIRECCIONES RESTRINGIDAS {[7](13,14);[8](15,16)}
% 
% % Apply point loads
% f = pointLoads(data,Td,f,FRD);
% 
% % Solve system
% [u.ruedaD,r.ruedaD] = solveSystem(data,K,f,up,vp);
% 
% % Compute stress
% sig_ruedaD = stressFunction(data,x,Tn,m,Tm,Td,u.ruedaD);
% 
% %% POSTPROCESS RODA DAVANTERA
% 
% scale = 80; % Set a number to visualize deformed structure properly
% units = 'Pa'; % Define in which units you're providing the stress vector
% 
% plot2DBars(data,x,Tn,u.ruedaD,sig_ruedaD,scale,units);

% %% SOLVER RODA POSTERIOR
% 
% % Point loads matrix 
% FRT = [% Each row is a point force component | column_1 = node, column_2 = direction (1 = x-direction, 2 = y-direction), column_3 = force magnitude
%     1 1 -r.bici(1)  % Rx (nodo 1 bicicleta)
%     1 2 -r.bici(2)  % Ry (nodo 1 bicicleta)
% ];
% 
% % Apliquem el solver 
% % Compute element stiffness matrices
% Kel = stiffnessFunction(data,x,Tn,m,Tm);
% 
% % Compute element force vectors
% fel = forceFunction(data,x,Tn,m,Tm); 
% 
% % Assemble global stiffness matrix
% [K,f] = assemblyFunction(data,Td,Kel,fel);
% 
% % Apply prescribed DOFs
% [up,vp] = applyBC(data,p); % MOVIMIENTOS (todo 0) Y DIRECCIONES RESTRINGIDAS {[7](13,14);[8](15,16)}
% 
% % Apply point loads
% f = pointLoads(data,Td,f,FRT);
% 
% % Solve system
% [u.ruedaT,r.ruedaT] = solveSystem(data,K,f,up,vp);
% 
% 
% % Compute stress
% sig_ruedaT = stressFunction(data,x,Tn,m,Tm,Td,u.ruedaT);
% 
% %% POSTPROCESS RODA POSTERIOR
% 
% scale = 250; % Set a number to visualize deformed structure properly
% units = 'Pa'; % Define in which units you're providing the stress vector
% 
% % plot2DBars(data,x,Tn,u.ruedaT,sig_ruedaT,scale,units);
% 
% 
% %% PREPROCESS BUCKLING RODES
% 
% m = [% Each column corresponds to a material property (area, Young's modulus, sig_0, I)
%        E.Rim    A.Rim     0    I.Rim
%        E.Spokes A.Spokes  110.53*10^6   I.Spokes
% ];
% 
% %% SOLVER RODA DAVANTERA BUCKLING
% % Point loads matrix 
% FRDB = [% Each row is a point force component | column_1 = node, column_2 = direction (1 = x-direction, 2 = y-direction), column_3 = force magnitude
%     1 1 -r.bici(3)  % Rx (nodo 3 bicicleta)
%     1 2 -r.bici(4)  % Ry (nodo 3 bicicleta)
% ];
% 
% % Apliquem el solver
% % Compute element stiffness matrices
% Kel = stiffnessFunction(data,x,Tn,m,Tm);
% 
% % Compute element force vectors
% fel = forceFunction(data,x,Tn,m,Tm); 
% 
% % Assemble global stiffness matrix
% [K,f] = assemblyFunction(data,Td,Kel,fel);
% 
% % Apply prescribed DOFs
% [up,vp] = applyBC(data,p); % MOVIMIENTOS (todo 0) Y DIRECCIONES RESTRINGIDAS {[7](13,14);[8](15,16)}
% 
% % Apply point loads
% f = pointLoads(data,Td,f,FRDB);
% 
% % Solve system
% [u.ruedaDB,r.ruedaDB] = solveSystem(data,K,f,up,vp);
% 
% % Compute stress
% sig_ruedaDB = stressFunction(data,x,Tn,m,Tm,Td,u.ruedaDB);
% 
% %% POSTPROCESS RODA DAVANTERA BUCKLING
% 
% scale = 80; % Set a number to visualize deformed structure properly
% units = 'Pa'; % Define in which units you're providing the stress vector
% 
% % plot2DBars(data,x,Tn,u.ruedaDB,sig_ruedaDB,scale,units);
% 
% %% SOLVER RODA POSTERIOR BUCKLING
% 
% % Point loads matrix 
% FRTB = [% Each row is a point force component | column_1 = node, column_2 = direction (1 = x-direction, 2 = y-direction), column_3 = force magnitude
%     1 1 -r.bici(1)  % Rx (nodo 1 bicicleta)
%     1 2 -r.bici(2)  % Ry (nodo 1 bicicleta)
% ];
% 
% % Apliquem el solver
% % Compute element stiffness matrices
% Kel = stiffnessFunction(data,x,Tn,m,Tm);
% 
% % Compute element force vectors
% fel = forceFunction(data,x,Tn,m,Tm); 
% 
% % Assemble global stiffness matrix
% [K,f] = assemblyFunction(data,Td,Kel,fel);
% 
% % Apply prescribed DOFs
% [up,vp] = applyBC(data,p); % MOVIMIENTOS (todo 0) Y DIRECCIONES RESTRINGIDAS {[7](13,14);[8](15,16)}
% 
% % Apply point loads
% f = pointLoads(data,Td,f,FRTB);
% 
% % Solve system
% [u.ruedaTB,r.ruedaTB] = solveSystem(data,K,f,up,vp);
% 
% % Compute stress
% sig_ruedaTB = stressFunction(data,x,Tn,m,Tm,Td,u.ruedaTB);
% 
% %% POSTPROCESS RODA POSTERIOR BUCKLING
% 
% scale = 200; % Set a number to visualize deformed structure properly
% units = 'Pa'; % Define in which units you're providing the stress vector
% 
% % plot2DBars(data,x,Tn,u.ruedaTB,sig_ruedaTB,scale,units);
% 
% 
% %% TENSIONS DESPRÉS DE LA PRETENSIÓ I FACTOR DE CÀRREGA
% sigmacr=(pi^2*E.Spokes*I.Spokes)/((data.radio*1000)^2*A.Spokes); % En MPa
% fc=zeros(8,4);
% for i=1:8
%     fc(i,1)=sig_ruedaTB(i)*10^-6;
%     fc(i,2)=sig_ruedaDB(i)*10^-6;
%     fc(i,3)=abs(sigmacr/(sig_ruedaTB(i)*10^-6));
%     fc(i,4)=abs(sigmacr/(sig_ruedaDB(i)*10^-6));
% end
