function run_experiments_FANS(L)
%run_experiments_FANS 
%   execute the experiments for FANS.
%   The results of this experimentes are showed in table 1 of article
%   "Fast Adaptive Nonlocal SAR Despeckling", written by D. Cozzolino,
%   S. Parrilli, G. Scarpa, G. Poggi and L. Verdoliva, 
%   IEEE Geoscience and Remote Sensing Letters, VOL. 11, 2013.
%   Please refer to this paper for a more detailed description of
%   the experiments.
%
%   run_experiments_FANS(L)
%
%       ARGUMENT DESCRIPTION:
%               L - Number of looks of the speckle noise
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Copyright (c) 2013 Image Processing Research Group of University Federico II of Naples ('GRIP-UNINA').
% All rights reserved.
% This work should only be used for nonprofit purposes.
% 
% By downloading and/or using any of these files, you implicitly agree to all the
% terms of the license, as specified in the document LICENSE.txt
% (included in this package) and online at
% http://www.grip.unina.it/download/license_closed.txt
%

if nargin<1, L=1; end;
repliche = 100;

fileOut = ['FANS_L',num2str(L,'%02d')];
X = double(imread('lena_noisefree.png'));
seed = 1:repliche;

PSNR  = zeros(repliche,1);
TIME  = zeros(repliche,1);
%SSIM  = zeros(repliche,1);
%BETA  = zeros(repliche,1);
for i = 1:repliche,
    Z = mulNakagamiNoise(X,L,seed(i));
    disp(i); 
    flag    = tic();
    Y       = FANS(Z,L);
    TIME(i) = toc(flag);
    PSNR(i) = psnr(X,Y);
   % SSIM(i) = ssim_index(X,Y);
   % BETA(i) = beta_index(X,Y);
end
fprintf('\n %s \n',fileOut);
fprintf('TIME  %5.2f (%5.3f)\n',mean(TIME ), std(TIME ));
fprintf('PSNR  %5.2f (%5.3f)\n',mean(PSNR ), std(PSNR ));
%fprintf('SSIM  %5.3f (%5.3f)\n',mean(SSIM ), std(SSIM ));
%fprintf('BETA  %5.3f (%5.3f)\n',mean(BETA ), std(BETA ));
%save(fileOut,'PSNR','TIME');%,'SSIM','BETA');
