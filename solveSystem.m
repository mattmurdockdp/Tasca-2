function [u,r] = solveSystem(data,K,f,up,vp)

% Determinamos el vector de los free DOFs indices
vf = setdiff((1:data.ndof)',vp);

% Inicializamos el vector global DOFs
u = zeros(data.ndof,1);

% Asignamos los DOFs prescritos al vector DOFs global
u(vp)= up;

% Calculamos los DOFs libres
u(vf) = inv(K(vf,vf))*(f(vf)-K(vf,vp)*(u(vp)));

% Calculamos las reacciones para los DOFs prescritos
r = (K(vp,:))*u-f(vp);

end