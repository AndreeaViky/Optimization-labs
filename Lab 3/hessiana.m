function[he] = hessiana(w, y, x)
N = size(x, 2);
n = size(x, 1);
q = zeros(N, 1);
for i = 1 : N
    h = sigmoid(w' * x(:, i));
    q(i) = h * (1 - h);
end

Q = diag(q);
he = (x * Q * x')/N;