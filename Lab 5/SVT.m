function [Lk1] = SVT(alpha, X, Sk, Ak, ro)

Ak = X - Sk - (1/ro) * Ak;
[U, Sigma, V] = svd(Ak,'econ');
m = size(Sigma, 1);
n = size(Sigma, 2);
Sigma = Sigma - alpha * eye(m);
i = 1;
while i <= m
    if Sigma(i,i)<0
        Sigma(i,i) = 0;
    end
    i = i + 1;
end
Lk1 = U * Sigma * V';
end
