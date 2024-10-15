%e = 10^(-8);
%evolutia normei gradientului cu timp 
%matricea de confuzie => pt a calcula acuratetea, adunam ce e pe diag si
%impartim la cate sunt 

clc
clear
%% Citirea si preprocesare datelor
dataFolder = 'train';
categories = {'cat', 'dog'};

imds = imageDatastore(fullfile(dataFolder, categories), 'LabelSource', 'foldernames', 'IncludeSubfolders', true);

dataFolder = 'test';
imds_t = imageDatastore(fullfile(dataFolder, categories), 'LabelSource', 'foldernames', 'IncludeSubfolders', true);

data=[];                            % date de antrenare
data_t =[];                         % date de test


while hasdata(imds) 
    img = read(imds) ;              % citeste o imagine din datastore
    img = imresize(img, [227 227]);
    %figure, imshow(img); % decomentati pentru a vizualiza pozele din
    %pause                        %baza de dat 
    img = double(rgb2gray(img));
    data =[data, reshape(img, [], 1)];

end
eticheta = double(imds.Labels == 'metal'); % eticheta 1 - pisica, 0 - caine
while hasdata(imds_t) 
    img = read(imds_t) ;              % citeste o imagine din datastore
    img = imresize(img, [227 227]); 
    %figure, imshow(img);    % decomentati pentru a vizualiza pozele din
    % pause                  %baza de date
    img = double(rgb2gray(img));
    data_t =[data_t, reshape(img, [], 1)];
    
end

eticheta = double(imds.Labels == 'paper'); % 1 - pisica, 0 - caine
while hasdata(imds_t)
    img = read(imds_t);
    img = double(rgb2gray(img));
    data_t = [data_t, reshape(img, [], 1)];
    %figure, imshow(img);
end

eticheta_t = double(imds_t.Labels == 'metal'); % eticheta 1 - pisica, 0 - caine

%Reducerea dimensiuni
data_pca = pca(data, 'NumComponents', 45)';
data_pca_t = pca(data_t, 'NumComponents', 45)';

clear categories imds imds_t img dataFolder data data_t

[n, N] = size(data_pca);

%% 
eps = 10^(-8);
maxIteratii = 10000;
alpha = 1; 
y = eticheta;
x = data_pca;
N = size(x, 2);
n = size(x, 1);
w = rand(n, 1);
w_c = w;
t1 = 0;
t = [];

% netwon pas constant 
iter1 = 0;
pc = []; % vect care stocheaza pasul constant 
time = 0;
t = tic 
while (norm(gradient(w, y, x))) > eps && (iter1 < maxIteratii)
    w = w - alpha * inv(hessiana(w, y, x)) * gradient(w, y, x);
    pc = [pc, norm(gradient(w, y, x))];
    iter1 = iter1 + 1;
    time = [time, toc(t)]
end 
figure; 
grid on;
semilogy(pc);

figure; 
grid on;
semilogy(t,pc);

% % newton pas ideal 
iter2 = 0;
pi = [];


tic
while (iter2 < maxIteratii) && (norm(gradient(w_c, y, x)) > eps)
    cost = @(a) obiectiv(w_c - a * (inv(hessian(w_c,y,x))) * gradient(w_c,y,x),y,x);
    a = fminbnd(cost,0,1); 
    w_c = wc - a * (inv(hessian(w_c, y, x))) * gradient(w_c, y, x);
    pi = [pi, norm(gradient(w_c, y, x))];
    iter2 = iter2 + 1;
end
toc


