close all;
clear all;
% img = double(imread('couple.png'));
img = double(imread('lena_Noisefree.png'));
img = imresize(img,0.5);
% img = double(imread('peppers256.png'));
% img = double(imread('test003.png'));
% img = double(imread('SAR3.jpg'));
% img = img(:,:,1);
% img = double(imread('TerraSAR-X-Amplitude-6.4looks.tif'));
% img = double(imread('AirSAR-Amplitude-3looks.bmp'));
% img = double(imread('MiniSAR-Amplitude-3looks-Kuband-0.3m-resolution.bmp'));
% f = img;
%% L can only be {1, 2, 3, 4, 5, 8}
L = 3;
f = mulNakagamiNoise(img,L,10);
f(f <= 0) = 0.5;

fsz = 7;
filename = '7x7_15.mat';
load (filename);
filt = cell(48+1,1);
for i=1:48
    filt{i} = reshape(filters(:,i), fsz, fsz);
end
filt{end} = size(f);
%% Load default parameter settings
para = setparameters(L,f);
%% model parameters
theta = theta*0.2;
lambda = para.lambda;
mu = para.mu;
%% algorithm parameters
alpha = para.alpha;
beta  = para.beta;
maxiter = para.maxiter;
x0 = para.x0;
[M,N] = size(f);
w0 = log(x0);
%% despeckling process
x = ipiano_Despeck_AmplitudeCombEXP(f, img, w0, filt, theta, maxiter, alpha, beta, mu, lambda);
rms = sqrt(mean((f(:) - img(:)).^2));
psnr1 = 20*log10(255/rms);
rms = sqrt(mean((x - img(:)).^2));
psnr2 = 20*log10(255/rms);
figure;
subplot(1,3,1);imshow(img, [0 255]);title('original image');
subplot(1,3,2);imshow(f, [0 255]);title(['noisy image, psnr: ',sprintf('%.2f',psnr1)]);
subplot(1,3,3);imshow(reshape(x,M,N), [0 255]);title(['recovered image, psnr: ',sprintf('%.2f',psnr2)]);
drawnow;

%% result given by SAR-BM3D. Pleas download SAR-BM3D codes to run the following script
% x_sarbm3d = SARBM3D_v10(f,L);