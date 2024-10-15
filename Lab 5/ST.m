function [Sk1] = ST(alpha, X, Lk1, Ak, ro)
Ak = X - Lk1 - (1/ro) * Ak;
m = size(Ak, 1);
n = size(Ak, 2);
i = 1;
while i <= m
    for j = 1:n
        if Ak(i, j) > alpha
            Ak(i, j) = Ak(i, j) - alpha;
        elseif abs(Ak(i, j)) < alpha
            Ak(i, j) = 0;
        else
            Ak(i, j) = Ak(i, j) + alpha;
        end
    end
    i = i + 1;
end
Sk1 = Ak;

end