
% --------------------------------------------------------------------------------------------------
%
%    Demo software for Non-Stationary Speckle Reduction in SAR Images 
%                  Using Log-Normal Mixture Model and MRFs Priors
%
%                   Release ver. 1.0.1  (Nov. 16, 2016)
%
% --------------------------------------------------------------------------------------------
%
% authors:              Zhi-huo Xu, et al.
%
% web page:              https://github.com/Z-H-XU/Nonstationary-Speckle-Reduction
%
% contact:               xuzhihuo@gmail.com
%
% --------------------------------------------------------------------------------------------
% Copyright (c) 2016 NTU.
% Nantong University, China.
% All rights reserved.
% This work should be used for nonprofit purposes only.
% --------------------------------------------------------------------------------------------


clc;clear all;close all;

basepath = cd();

addpath([basepath, '/Code']);
addpath([basepath, '/FANS_v10']);
addpath([basepath, '/FoE-Naka']);
addpath([basepath, '/minFunc']);
addpath([basepath, '/minFunc/compiled']);


img = double(imread('Dataset\barbara.tif'));
img_o=img(:,:,1);
looks=[1,2,8];RoI;

% select the number of multi-looks
for lk=1:3
    
    Look=looks(lk); 


    [img,simu_ima]=LogNorGen_MultiLookingProc(img_o,Look);


    r_0=simu_ima./(img+eps);

    figure
    subplot(131);imshow(img,[]);title('Groundtruth');
    subplot(132);imshow(simu_ima,[ ]);title('Simulated SAR images');
    subplot(133);imshow(r_0,[ ]);title('Groundtruth of Ratio');




    %% LogNMM-FOE
    disp('The proposed method')
    im1=simu_ima(:);
    N=length(im1);
    mK = 8;   % the number of mixtures
    rng('default');
    omega_current = 1/mK * ones(1, mK);
    mus    =log(10*(1:mK)); 
    sigma2  = rand(1,mK);

    maxIter=50;%number of iterations
    disp('Step 1: EM')
    tic
    [zm,omega_current,mus,sigma2]=LogNMM_EM(mK,N,maxIter,omega_current,mus,sigma2,im1);
    EM_ctime=toc



    %%      Proposed  (LogNMM-FOE)
    %---------------------------------------------------------

    % load the FoE model
    load 7x7_15;
    [r, c]=size(filters);
    filter_size = sqrt(r);
    m = c;
    filter_num = m;
    K = cell(filter_num,1);
    for i = 1:filter_num
        filter = filters(:,i);
        K{i} = reshape(filter,filter_size,filter_size);
    end
    [r,c] = size(simu_ima);
    K{filter_num + 1} = size(simu_ima);
    f_noise = (im1(:));
    [lambda,options] = SimulatedSAR_OptsSetting(Look,exp(sigma2)); 
    disp('Step 2:  L-BFGS')
    tic;
    x0=f_noise;
    fn_ = @(input)  LogMM_FOE_SAR_ConvoMEX(input,K,f_noise,lambda,theta,zm,omega_current,mus,sigma2);
    [proposed,f,exitflag,output] = minFunc(fn_,x0,options);
    proposed = reshape(proposed,r,c);
    LBFGS_computational_time=toc
    total_computational_time=EM_ctime+LBFGS_computational_time
    disp('----------------------------------')


    %% FANS
    %----------------------------------------------------------------------------
    %     D. Cozzolino, S. Parrilli, G. Scarpa, G. Poggi, and L. Verdoliva,2014
    %     Fast Adaptive Nonlocal SAR Despeckling(FANS) 
    %----------------------------------------------------------------------------
    disp('FANS')
    tic
    FANS_filtered = FANS(simu_ima, Look);
    toc
    disp('----------------------------------')


    %% Naka-FoE
    %-----------------------------------------------------------------------------------
    %     Y. Chen, W. Feng, R. Ranftl, H. Qiao, and T. Pock, 2014
    %     A Higher-Order MRF Based Variational Model for Multiplicative Noise Reduction
    %-----------------------------------------------------------------------------------
    disp('Naka-FoE')
    tic
    FoE_Nakafiltered=FoE_Naka(simu_ima,Look);
    FoE_Nakafiltered=reshape(FoE_Nakafiltered,r,c);
    toc
    disp('----------------------------------')
    %% Results

    psnr_noisy    =   cal_psnr(img,simu_ima,0,0)
    psnr_fans    =   cal_psnr(img,FANS_filtered,0,0)
    psnr_foenaka    =   cal_psnr(img,FoE_Nakafiltered,0,0)
    psnr_proposed    =   cal_psnr(img,proposed,0,0)

    ssim_noisy     =  cal_ssim(img, simu_ima, 0, 0 )
    ssim_fans     =  cal_ssim(img, FANS_filtered, 0, 0 )
    ssim_foenaka    =   cal_ssim(img,FoE_Nakafiltered,0,0)
    ssim_proposed     =  cal_ssim(img, proposed, 0, 0 )


    edge_noisy =  cal_beta(img,simu_ima)
    edge_fans  =  cal_beta(img,FANS_filtered)
    edge_foenaka    =  cal_beta(img,FoE_Nakafiltered)
    edge_proposed = cal_beta(img,proposed)
    
    cnr_noisy =  cal_cnr(img,simu_ima,Look)
    cnr_fans  =  cal_cnr(img,FANS_filtered,Look)
    cnr_foenaka    =  cal_cnr(img,FoE_Nakafiltered,Look)
    cnr_proposed = cal_cnr(img,proposed,Look)

    figure
    subplot(2,4,1);imshow(simu_ima,[]);title(['Noisy,PSNR:',num2str(psnr_noisy),',SSIM:',num2str(ssim_noisy)]);
    subplot(2,4,2);imshow(FANS_filtered,[ ]);title(['FANS,PSNR:',num2str(psnr_fans),',SSIM:',num2str(ssim_fans)]);
    subplot(2,4,3);imshow(FoE_Nakafiltered,[ ]);title(['Naka-FoE,PSNR:',num2str(psnr_foenaka),',SSIM:',num2str(ssim_foenaka)]);
    subplot(2,4,4);imshow(proposed,[ ]);title(['Proposed,PSNR:',num2str(psnr_proposed),'SSIM:',num2str(ssim_proposed)]);

    Ratio_FANS_filtered=simu_ima./(FANS_filtered+eps);
    Ratio_FoE_Nakafiltered=simu_ima./(FoE_Nakafiltered+eps);
    Ratio_proposed=simu_ima./(proposed+eps);

    subplot(2,4,5);imshow(r_0, [ ]);title('Groundtruth of Ratio');
    subplot(2,4,6);imshow(Ratio_FANS_filtered, [ ]);title('Ratio of FANS');
    subplot(2,4,7);imshow(Ratio_FoE_Nakafiltered,[ ]);title('Ratio FoE-Naka');
    subplot(2,4,8);imshow(Ratio_proposed, [ ]);title('Ratio of Proposed');


end