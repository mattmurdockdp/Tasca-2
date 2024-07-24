function fel = forceFunction(data,x,Tn,m,Tm)
Xel = zeros(data.nel,data.nne*2);
lcs = zeros(data.nel,3);
AO = zeros(data.nel,2);

for i=1:data.nel                % FORCE FUNCTION BARRA A BARRA
    for j=1:data.nne            % Matriz Xel
        Xel(i,2*j-1)=x(Tn(i,j),1);
        Xel(i,2*j)=x(Tn(i,j),2);
    end
    % Matriz long, cos, sin
    lcs(i,1)=sqrt((Xel(i,3)-Xel(i,1))^2+(Xel(i,4)-Xel(i,2))^2);
    lcs(i,2)=(Xel(i,3)-Xel(i,1))/lcs(i,1);
    lcs(i,3)=(Xel(i,4)-Xel(i,2))/lcs(i,1);
    % Matriz Area, Tensión inicial
    AO(i,1)=m(Tm(i),2);
    AO(i,2)=m(Tm(i),3);
    % Matriz de rotación
    R{i}=[
    lcs(i,2)    lcs(i,2)        0           0
    -lcs(i,3)   lcs(i,2)        0           0
        0           0       lcs(i,2)    lcs(i,3)
        0           0       -lcs(i,3)   lcs(i,2)
    ];
    % Matriz de fuerzas de la barra en locales
    fel{i}=(-AO(i,2)*AO(i,1)/10^6)*(transpose(R{i})*[-1;0;1;0]);
end
end
