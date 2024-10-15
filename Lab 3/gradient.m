function [grd] = gradient(w, y, x)
N = size(x, 2);
h = zeros(N, 1);
for i = 1 : N
    h(i) = sigmoid(w' * x(:, i));
end
grd = ((h - y)' * x')/N;
grd = grd';