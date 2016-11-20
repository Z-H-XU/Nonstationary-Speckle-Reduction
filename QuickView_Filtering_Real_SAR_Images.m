

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


looks=[1,8];
Slooks={'1','8'};
for looklp=1:2
    
    L=looks(looklp);
    
    disp(['despeckling: looks-', char(Slooks(looklp)),  '.tif']);
    
    img = double(imread( ['Dataset/looks-', char(Slooks(looklp)),  '.tif']));

    if size(img,3) == 3, img = 255*rgb2gray(img/255); end

    img=img+0.1;
 
  
 %The following homogeneous regions are slelected to caculate the corresponding ENLs 
    switch char(Slooks(looklp)) 
       case '1'
        X1=324;X2=462;Y1=14;Y2=114;
     
       case '8'
        X1=44;X2=134;Y1=414;Y2=464;  
    end


   
    %% LogNMM-FOE
    disp('LogNMM-FOE')
    im1=img(:);
    N=length(im1);
    mK = 8; %number of distributions
    rng('default');
    omega_current = 1/mK * ones(1, mK);
    mus    =log(10*(1:mK)); 
    sigma2  = rand(1,mK);

    maxIter=50;%number of iterations
    disp('Step 1: EM')
    tic
    [zm,omega_current,mus,sigma2]=LogNMM_EM(mK,N,maxIter,omega_current,mus,sigma2,im1);
    EM_ctime=toc

    lw=4;fsz=12;
    bw=1;sl=0.1:bw:255.1;
    mixe=0;
    for j=1:mK
        mixe = mixe+omega_current(j) .* 1./(sl.*sqrt(2*pi*sigma2(j))) .* ...
                exp( -(log(sl)-mus(j)).^2./(2*sigma2(j)) );
    end

    %---------------------------------------------------------
    %      Proposed  (LogNMM-FOE)
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
    [r,c] = size(img);
    K{filter_num + 1} = size(img);
    f_noise = (im1(:));
    [lambda,options] = SAR_OptsSetting(exp(sigma2));


    disp('Step 2:  L-BFGS')
    tic;
    x0=f_noise;
    fn_ = @(input)  LogMM_FOE_SAR_ConvoMEX(input,K,f_noise,lambda,theta,zm,omega_current,mus,sigma2);
    [proposed,f,exitflag,output] = minFunc(fn_,x0,options);
    proposed = reshape(proposed,r,c);
    proposed= proposed-min(min(proposed));
    LBFGS_computational_time=toc
    Total_computational_time=EM_ctime+LBFGS_computational_time
    disp('----------------------------------')
    
   %% FANS
    %----------------------------------------------------------------------------
    %     D. Cozzolino, S. Parrilli, G. Scarpa, G. Poggi, and L. Verdoliva,2014
    %     Fast Adaptive Nonlocal SAR Despeckling(FANS) 
    %----------------------------------------------------------------------------
    disp('FANS')
    tic
    FANS_filtered = FANS(img, L);
    toc
    disp('----------------------------------')
%    %% Naka-FoE
%     %-----------------------------------------------------------------------------------
%     %     Y. Chen, W. Feng, R. Ranftl, H. Qiao, and T. Pock, 2014
%     %     A Higher-Order MRF Based Variational Model for Multiplicative Noise Reduction
%     %-----------------------------------------------------------------------------------
%     disp('Naka-FoE')
%     tic
%     FoE_Nakafiltered=FoE_Naka(img,L);
%     FoE_Nakafiltered=reshape(FoE_Nakafiltered,r,c);
%     toc
%     disp('----------------------------------')
  
    
   
  %% Results
    
    figure
    subplot(2,3,4);
    h1=hist(im1,sl);
    hh1(1:258)=0;
    hh1(2:257)=h1;
    sl1=-1:256;
    hh1(256:257)=0;
    fill(sl1,hh1,[0.7, 0.7,0.7])
    axis([-1 255 0 1.1*max(hh1)])
    hold on
    h =histfit(im1,255,'lognormal');
    delete(h(1))
    set(h(2),'LineStyle','--','Color',[0 0 1],'linewidth',lw)
    hold on
    h =histfit(im1,255,'naKagami');
    delete(h(1))
    set(h(2),'LineStyle','-.','Color',[0.02,0.92,0.04],'linewidth',lw)
    hold on
    plot(sl, N*bw*mixe,'Color',[0.97,0.39,0.97],'linewidth',lw)
    ylabel('histogram') 
    xlabel('greylevel') 
    legend('histogram','log-normal','Nakagami','LogNMM');
    set(gcf,'color',[1 1 1]);
    set(gca,'FontSize',fsz)
    set(findall(gcf,'type','text'),'FontSize',fsz)

    ENL=cal_enl(Y1,Y2,X1,X2,img,FANS_filtered,FANS_filtered,proposed);
    subplot(2,3,1);imshow(img,[]);title(['noisy image',',ENL:',num2str(ENL(1))]);hold on
    rectangle('Position',[X1,Y1,X2-X1+1,Y2-Y1+1],'EdgeColor','r','Linewidth',1);
    subplot(2,3,2);imshow(FANS_filtered,[ ]);title(['FANS,ENL:',num2str(ENL(2))]);
    subplot(2,3,3);imshow(proposed,[ ]);title(['Proposed,ENL:',num2str(ENL(4))]);

    Ratio=img./(img);
    Ratio_FANS_filtered=img./(FANS_filtered+0.1);
    Ratio_proposed=img./(proposed+0.1);
  
    subplot(2,3,5);imshow(Ratio_FANS_filtered, [0  5]);title('Ratio of FANS');
    subplot(2,3,6);imshow(Ratio_proposed, [0 5]);title('Ratio of Proposed');
    
end


