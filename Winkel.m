function [winkel] = Winkel(P)
%g
x = P(1);
y = P(2);

        phi = atan2(y,x) - acos((0.3^2-(sqrt(x^2+y^2)^2)-0.4^2)/(-2*sqrt(x^2+y^2)*0.4));
      
        omega = atan2(y-sin(real(phi))*0.4,x-cos(real(phi))*0.4);

winkel = [phi, omega];

end
