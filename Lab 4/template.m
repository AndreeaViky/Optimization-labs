clc, clear
n = 70;                              % valoarea de redimensionare a img.
A_bar = imread("bunny.jpg");         % citirea img
A_bar = rgb2gray(A_bar);             % convertire in alb-negru
A_bar =im2double(A_bar);             % convertirea in valori double
A_bar = imresize(A_bar,[n n]);       % redimensionarea  pozei  
figure(1)
imshow(A_bar);                           % afisarea pozei initiale 
title("Imaginea originala")

nrintraricunoscute=3000;             % setam un numar de intrari cunoscute 
rPerm = randperm(n*n);                          %generarea random a indicilor pentru intrarile cunoscuti
omega = sort(rPerm(1 : nrintraricunoscute));    %intrarile care se cunosc
A = nan(n); A(omega) = A_bar(omega); 
figure(2)
imshow(A);
title("Imagine cu pixeli lipsa")


%% CVX

cvx_begin quiet
variable B(n,n);
minimize (norm_nuc(B))
subject to:
B(omega) == A(omega)
cvx_end

figure(3)
imshow(B);
title("Imaginea cvx");


%% GP

eps = 10e-3;
c = 10;
P = randn(n, n);
P(omega) = A(omega); 
P1 = zeros(n, n);
k_max = 1000;
% k_max = 10000;
k = 1;
oprire = 1;
criteriu = [];
while oprire >= eps && k < k_max
    criteriu = [criteriu, oprire];
    P = P1;
    alpha = c / k; 
    [U, ~, V] = svd(P);
    P1 = P - alpha * U * V';
    P1(omega) = A(omega);
    criteriu = norm(P1 - P);
    k = k + 1;
end

figure(4)
imshow(P1);
title("GP");

figure(6)
semilogy(criteriu(1 : k))

%% GC
eps_mp = 10e-6;
eps_gc = 10e-3;
criteriu2 = 1;
oprire2 = [];
C = randn(n, n);
C1 = zeros(n, n);
delta_r = 70; 
G = zeros(n, n); % gradientul functiei obiectiv 

while criteriu2 >= eps_gc && k <= k_max
    oprire2 = [criteriu2, oprire2];
    C = C1;
    G(omega) = C(omega) - A(omega); % calcul gradient 
    v1 = randn(n,1);
    v1 = v1/norm(v1);
    u1 = v1;
    sigma = 1;
    X = G' * G;
    c_mp = 1;

    while c_mp >= eps_mp
        v2 = X * v1 / norm(X * v1); %vect propriu asociat valorii proprii dominante a matricei G * G'
        u2 = G * v2 / norm(G * v1);
        c_mp = abs(u2' * G * v2 - sigma);
        sigma = norm(G * v1);
        v1 = v2;
        u1 = u2;
    end

    Sk = (-1) * delta_r * u1 * v1';
    alpha = 2/(k + 2);
    C1 = (1 - alpha) * C + alpha * Sk; 
    k = k + 1;         
    criteriu2 = norm(C1 - C);   
end
figure(5)
imshow(C);
title("GC");

% figure(6)
% semilogy(



