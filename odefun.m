function dx = odefun(t, x, auxdata)
%ODEFUN í”÷•ª•û’ö®

g = auxdata.g;
m1 = auxdata.m1;
m2 = auxdata.m2;
l1 = auxdata.l1;
l2 = auxdata.l2;
c1 = auxdata.c1;
c2 = auxdata.c2;

dx = zeros(size(x));

s = sin(x(2)-x(1));
c = cos(x(2)-x(1));
m11 = (m1+m2)*l1^2;
m12 = m2*l1*l2*c;
m22 = m2*l2^2;

M_inv = [m22 -m12; -m12 m11] ./ (m11*m22 - m12^2);
A = [- m2*l1*l2*x(4)^2*s + (m1+m2)*l1*g*sin(x(1))
     m2*l1*l2*x(3)^2*s + m2*l2*g*sin(x(2))];
Q = [- c1*x(3) + c2*(x(4)-x(3))
     - c2*(x(4)-x(3))];

dx(1) = x(3);
dx(2) = x(4);
dx(3:4) = M_inv*(-A+Q);
end

