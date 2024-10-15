clc;clear;close
%% Clasificarea binara: 
% Pentru fiecare student dintr-o grupa se cunoaste 
% x = prezenta la curs a studentilor
% y = ore dedicate proiectului final
% label = eticheta studentului( -1 = picat; 1 = promovat)
%% Date de intrare
x = [1;2;3;4;6;14;12;10;13;14;14;1;7;9;0;0;1;2;1;4]; 
y = [3;3;2;5;10;10;5;10;8;8;6;24;8;10;5;1;1;0;2;6];  
label= [-1;-1;-1;-1;1;1;1;1;1;1;1;1;1;1;-1;-1;-1;-1;-1;-1];  
%% Adaugam doi studenti pentru a studia cazul neseparabil
x_new = [2;8];
y_new = [20;15];
label_new = [-1;-1];
x = [x;x_new];
y =[y;y_new];
label =[label; label_new];
%% Prelucarea datelor 
N  = length(label);       % nr total de elemente
n1 = sum(label(:)==1);    % nr de elemente cu eticheta 1
n2 = length(label)- n1;   % nr de elemente cu eticheta -1
n  = 2;                   % dimensiunea vectorului de caracteristici

data = [label,x,y];
data = sortrows(data,data(:,1)); % aranjam datele dupa etichete
%% Afisarea datelor
scatter(data(1:n1,2),data(1:n1,3))
hold on
scatter(data(n1+1:N,2),data(n1+1:N,3),'*')
hold on 
%% Implementati problema LP conform prezentari din laborator 
%  si rezolvati utilizand linprog
% c = [zeros(n + 1, 1); ones(N, 1)];
% %coloana 2 si 3, caracteristicile 
% C = [-data(1 : n1, 2 : 3), ones(n1, 1), -eye(n1), zeros(n1, n2);...
%     data(n1 + 1 : end, 2 : 3), -ones(n2, 1), zeros(n2, n1), -eye(n2)];
% d = - ones(N, 1);
% lb = [-inf * ones(n + 1, 1); zeros(N, 1)];
% sol = linprog(c, C, d, [], [], lb, [])

% dupa rulare => primele 2 componente din solutie reprezinta w, a treia este
% b si u si v sunt 0, ce inseamna ca u si v sunt 0? u si v sunt eroarea de
% clasificare => clasificam totul corect => multimile noastre sunt
% separabile

% x - nr prezente la curs, care nu poate fi mai mare de 14

%% Implementati problema QP conform prezentari din laborator 
%  si rezolvati utilizand quadprog

lambda = 0.5;
% daca fac lambda mai mic 0.001 => se misca linia de separare dintre cele 2
% multimi 
Q = [eye(n), zeros(n, N+1); zeros(N + 1, n), zeros(N + 1, N + 1)];
q = lambda * [zeros(n + 1, 1); ones(N, 1)];
C = [-data(:, 1) * data(:, 2:3), data(:, 1), -eye(N)];
d = -ones(N, 1);
lb = [-inf * ones(n + 1, 1); zeros(N, 1)];
sol = quadprog(Q, q, C, d, [], [], lb, [])

%% Afisarea hyperplanului de separare gasit
x = linspace(0, 14, 10);
y = (sol(3) - sol(1) * x) / sol(2);
hold on
plot(x, y)
