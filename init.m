function [t0, x0] = init()
%INIT ‰Šú’l
t0 = 0;
x0 = [
    pi*2/3   % theta1
    pi*2/3   % theta2
    pi*0   % theta1_dot
    pi*0   % theta2_dot
];
end

