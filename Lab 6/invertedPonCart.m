clc, clear, close all
%% Descrierea sistemului pendulul inversat pe un carucior
M = .5;   %Masa cartului
m = 0.2;  %Masa pendulului
b = 0.1;  %coef de fracere pt carucior
I = 0.006;%momentul de inertie
g = 9.8;  %acceleratia gravitationala
l = 0.3;  %lungimea lantului
p = I*(M+m)+M*m*l^2; %denominator for the A and B matrices
A = [0      1              0           0;...
     0 -(I+m*l^2)*b/p  (m^2*g*l^2)/p   0;...
     0      0              0           1;...
     0 -(m*l*b)/p       m*g*l*(M+m)/p  0];
B = [     0;
     (I+m*l^2)/p;
          0;
        m*l/p];
    
Q = [10 0 0 0; ...
     0 1 0 0;...
     0 0 10 0;...
     0 0 0 1];
R = 1;
N = 3; % orizontul de predictie
% Constrangerea de tip box pentru intrare u
ub = 3; 
lb = -3;
% Starea initiala a sistemului
z0 = [2; 1 ; 0.3; 0];
% Referinta de urmarit
x_ref = 0; % nu impunem nici o referinta de urmarit pe intrare
z_ref = [0;0; 0; 0];  % iteresati sa aducem pendulul in pozitie verticala
maxIter = 20; steps = 0;
u =[]; z=z0;
x_0 = zeros(N,1); % warm start pentru metoda bariera
sigma = 0.6;
eps = 0.0001;
alfa = 0.00001;
% nr constrangeri = 6 (in pdf variabila m)
%%
while steps < maxIter  %are rolul de timp de simulare a sistemului 
   [H,q,C,d]= denseMPC(A,B,Q,R,z0,N,ub,lb, z_ref, x_ref);
   %% Quadprog
   % x = quadprog(H,q,C,d); 
   % metoda bariera cu metoda gradient
   % tau = 1;
   % x = zeros(N, 1);
   % 
   % 
   % while 6 * tau >= eps
   %     const= C * x - d;
   %     grad = H * x + q; %grad fct obiectiv
   %     for i = 1 : size(C, 1)
   %         grad = grad - tau * (C(i, :))'/const(i);
   %       end
   % 
   % while norm(grad) >= 0.5
   %     x = x - alfa * grad;
   %     const = C * x -d;
   %     grad = H * x + q; %actualizam grad
   %     for i = 1 : size(C, 1)
   %         grad = grad - tau * (C(i, :))'/const(i);
   %     end
   % end
   % tau = tau * sigma;
   % end

   %%
   %CVX
   cvx_begin
   variable x(N,1)
   minimize ((1/2) * x' * H * x + q' * x)
   subject to 
   C * x <= d
   cvx_end

   u = [u,x(1,1)];
   z_new = A* z0 + B *x(1,1); %la fiecare pas, noi rezolvam o noua problema de optimizare => in total 20 de probleme
   z0 = z_new;
   z = [z z0];
   steps = steps +1;
 end
%% --------------------------------------------
figure(1)
subplot(2,2,1)
plot(z(1,:))
legend('x Pozitia caruciorului');
hold on
subplot(2,2,2)
plot(z(2,:))
legend('Viteza caruciorului');
hold on
subplot(2,2,3)
plot(z(3,:))
legend('\phi Abaterea poziției pedulului de la echilibru');
hold on
subplot(2,2,4)
plot(z(4,:))
legend('Viteza abaterei unghiulare a pendulului');
figure(2)
plot(u);
legend('u = Forta aplicata caruciorului');



