% load ("data.mat") - folosim matricea R3
% k = 10 -> dim U = 50 x 10 -> dim 
% evolutia fctii obiectiv -> salvam intr un vector 

load('data.mat');

epsilon = 0.001;
alfa = 0.003;
k = 10;

[n, N] = size(R_train);
%n = size(R, 1);
%N = size(R, 2);
U = randn(n, k);
M = randn(N, k);

f = zeros(100, 1);
% metoda gradient 

for i = 1 : n
    for j = find(R_train(i, :)) : N
        U(i, :) = U(i, :) - alfa * (-R_train(i,j) - U(i, :) * M(j, :)') * M(j, :);
        M(j, :) = M(j, :) - alfa * (-R_train(i,j) - U(i, :) * M(j, :)') * U(i, :);
        f(i) = 1/2 * (R_train(i,j) - (U(i,:) * M(j, :)'))^2;
    end
end

t = 1; 
criteriu = f(2) - f(1);
criterii = zeros(n, 1);

while criteriu > epsilon  
    criteriu = abs(f_t - f_t1);
    criterii(t) = criteriu;
    t = t + 1;
  
    return;
end 


%v = 1 : criteriu
%subplot(2, 1, 1);

