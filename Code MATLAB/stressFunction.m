function sig = stressFunction(data,x,Tn,m,Tm,Td,u)
Xel = zeros(data.nel,data.nne*2);
lcs = zeros(data.nel,3);
OE = zeros(data.nel,2);
sig = zeros(data.nel,1);
eps = zeros(data.nel,1);
for i=1:data.nel                % FORCE FUNCTION BARRA A BARRA
    for j=1:data.nne            % Matriz Xel
        Xel(i,2*j-1)=x(Tn(i,j),1);
        Xel(i,2*j)=x(Tn(i,j),2);
    end
    % Matriz long, cos, sin
    lcs(i,1)=sqrt((Xel(i,3)-Xel(i,1))^2+(Xel(i,4)-Xel(i,2))^2);
    lcs(i,2)=(Xel(i,3)-Xel(i,1))/lcs(i,1);
    lcs(i,3)=(Xel(i,4)-Xel(i,2))/lcs(i,1);
    % Matriz tensión inicial, Modulo de Young
    OE(i,1)=m(Tm(i),3);
    OE(i,2)=m(Tm(i),1);
    % Matriz de rotación
    R{i}=[
    lcs(i,2)    lcs(i,3)        0           0
    -lcs(i,3)   lcs(i,2)        0           0
        0           0       lcs(i,2)    lcs(i,3)
        0           0       -lcs(i,3)   lcs(i,2)
    ];
    uel = zeros(data.nne*data.ni,1);
    for j=1:data.nne*data.ni
    uel(j) = u(Td(i,j));
    end
    % Matriz de fuerzas de la barra en locales
    eps(i)=(1/lcs(i,1))*[-1 0 1 0]*R{i}*uel; % Adimensional
    sig(i)=10^6*OE(i,2)*eps(i)+OE(i,1);      % Transformado a Pascales
end
end