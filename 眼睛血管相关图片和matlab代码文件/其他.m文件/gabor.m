function [OutImg, GaborFilter] = gabor(I, gamma, lambda, b, theta, phi, shape)
if nargin < 7, shape = 'same'; end;
if isa(I, 'double') ~= 1, I = double(I); end
sigma = (1 / pi) * sqrt(log(2)/2) * (2^b+1) / (2^b-1) * lambda;
Sy = sigma * gamma;
for x = -fix(sigma):fix(sigma)
    for y = -fix(Sy):fix(Sy)
        xp = x * cos(theta) + y * sin(theta);
        yp = y * cos(theta) - x * sin(theta);
        % GF is Gabor Filter
        GaborFilter(fix(Sy)+y+1,fix(sigma)+x+1) = ...
            exp(-.5*(xp^2+gamma^2*yp^2)/sigma^2) * cos(2*pi*xp/lambda+phi);
    end
end
OutImg = conv2(I, double(GaborFilter), shape);
end