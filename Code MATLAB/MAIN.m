%% STRUCTURAL PROBLEM CODE STRUCTURE

clear
close all

% PREPROCESS 

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

TypeA = 'Direct'; TypeB = 'Iterative'; TypeSolver=TypeA;

s.solverType = TypeSolver;
s.data       = data;
s.x          = x;
s.Tn         = Tn;
s.Tm         = Tm;
s.Td         = Td;
s.m          = m;
s.p          = p;
s.F          = F;

analysis = BykeFrameAnalysis(s);
[u,sig] = analysis.computeSolution(analysis);

% TEST

[DisplacementDiff, StressDiff] = testResults(u,sig);

tolerance = 1e-4;

if DisplacementDiff < tolerance && StressDiff < tolerance
    fprintf('The new results match the original results within the tolerance.\n');
else
    fprintf('The new results differ from the original results.\n');
end

% POSTPROCESS 

scale = 1000; % Set a number to visualize deformed structure properly
units = 'Pa'; % Define in which units you're providing the stress vector

plot2DBars(data,x,Tn,u,sig,scale,units);

