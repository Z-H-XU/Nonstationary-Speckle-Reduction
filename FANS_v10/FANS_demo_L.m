close all; clear all; clc;
%SARBM3D Demo

fp = fopen('napoli.raw','rb'); 
X  = fread(fp,[256,256],'float')'; 
fclose(fp);
figure;
subplot(2,4,[1, 5]); imshow(X,[0 255]);
title('clean');
drawnow();

L = 1;
Z = mulNakagamiNoise(X,L,10);
subplot(2,4,2); imshow(Z,[0 255]);
title(['L=',num2str(L),'; noisy PSNR=', num2str(psnr(X,Z))]);
drawnow();

tic;
Y = FANS(Z,L);
toc,
subplot(2,4,6); imshow(Y,[0 255]); 
title(['L=',num2str(L),'; filtered PSNR=', num2str(psnr(X,Y))]);
drawnow();

L = 4;
Z = mulNakagamiNoise(X,L,10);
subplot(2,4,3); imshow(Z,[0 255]);
title(['L=',num2str(L),'; noisy PSNR=', num2str(psnr(X,Z))]);
drawnow();

tic;
Y = FANS(Z,L);
toc,
subplot(2,4,7); imshow(Y,[0 255]); 
title(['L=',num2str(L),'; filtered PSNR=', num2str(psnr(X,Y))]);
drawnow();


L = 16;
Z = mulNakagamiNoise(X,L,10);
subplot(2,4,4); imshow(Z,[0 255]);
title(['L=',num2str(L),'; noisy PSNR=', num2str(psnr(X,Z))]);
drawnow();

tic;
Y = FANS(Z,L);
toc,
subplot(2,4,8); imshow(Y,[0 255]); 
title(['L=',num2str(L),'; filtered PSNR=', num2str(psnr(X,Y))]);
drawnow();