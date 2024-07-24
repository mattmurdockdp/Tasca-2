function x=polireg(n,r)
x=zeros(n+1,2);
x(1,1)=0;
x(1,2)=0;
deltang=2*pi/n;

for i=1:n
    ang=pi/n+deltang*(i-1);
    x(i+1,1)=r*cos(ang);
    x(i+1,2)=r*sin(ang);
end
end