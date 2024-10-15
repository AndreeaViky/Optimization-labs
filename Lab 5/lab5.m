clear all
format long
R = VideoReader ('visiontraffic.avi'); %creates object v to read video data from the file named filename
X_Data = Matrix_video(R,171,200);%Put the 30 frames in a matrix
[n,m] = size(X_Data);
X = double(X_Data);

% criteriul de oprire este rank(Lk1) = 1 
% rank da numarul de coloane sau linii care sunt liniar dependente 

ro = 0.007;
lambda = 0.0002;

Lk = rand(n,m);
Sk = rand(n,m);
Ak = rand(n,m);

Lk1 = rand(n,m);
Sk1 = rand(n,m);
Ak1 = rand(n,m);

rezid = [];
k = 0;

while rank(Lk1) > 1
    k = k + 1;
    k
    rank(Lk1)
    norm(Sk1 - Sk)
    rezid = [rezid norm(Lk1 + Sk1 - X)];

    Lk = Lk1;
    Sk = Sk1;
    Ak = Ak1;

    Lk1 = SVT((1/ro), X, Sk, Ak, ro);
    Sk1 = ST((lambda/ro), X, Lk1, Ak, ro);
    Ak1 = Ak + ro * (Lk1 + Sk1 - X);
end

Lk1 = cast(Lk1, 'uint8'); 
figure('Name','Imaginea originala','NumberTitle','off')
imshow(reshape(X_Data(:,1),[360,640]));

figure('Name','Background','NumberTitle','off')
imshow(reshape(Lk1(:,1),[360,640]));

figure('Name','Prim-plan','NumberTitle','off')
imshow(reshape(Sk1(:,1),[360,640]));

figure('Name', 'Evolutia rezid')
semilogy(1:k,rezid(1:k),'b');


