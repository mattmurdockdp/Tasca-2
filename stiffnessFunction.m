function Kel = stiffnessFunction(data,x,Tn,m,Tm)

Xel = zeros(data.nel,data.nne*2);
lcs = zeros(data.nel,3);
EA = zeros(data.nel,2);

for i=1:data.nel
    for j=1:data.nne
        Xel(i,2*j-1)=x(Tn(i,j),1);
        Xel(i,2*j)=x(Tn(i,j),2);
    end

    lcs(i,1)=sqrt((Xel(i,3)-Xel(i,1))^2+(Xel(i,4)-Xel(i,2))^2);
    lcs(i,2)=(Xel(i,3)-Xel(i,1))/lcs(i,1);
    lcs(i,3)=(Xel(i,4)-Xel(i,2))/lcs(i,1);
    EA(i,1)=m(Tm(i),1);
    EA(i,2)=m(Tm(i),2);

    Kel{i}=((EA(i,1)*EA(i,2))/(lcs(i,1)))*[ % Matriz cos & sin
            (lcs(i,2))^2        lcs(i,2)*lcs(i,3)       -(lcs(i,2))^2       -lcs(i,2)*lcs(i,3)
            lcs(i,2)*lcs(i,3)   (lcs(i,3))^2            -lcs(i,2)*lcs(i,3)  -(lcs(i,3))^2
            -(lcs(i,2))^2       -lcs(i,2)*lcs(i,3)      (lcs(i,2))^2        lcs(i,2)*lcs(i,3)
            -lcs(i,2)*lcs(i,3)  -(lcs(i,3))^2           lcs(i,2)*lcs(i,3)   (lcs(i,3))^2
            ];
end
end