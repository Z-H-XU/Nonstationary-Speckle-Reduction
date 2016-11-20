function [ y2, y1, mapp ] = FANS( z,L )
%FANS filter for multiplicative speckle noise
%   Denoise an image corrupted by multiplicative speckle noise
%   with the non-local filter described in "Fast Adaptive Nonlocal SAR Despeckling", written by
%   D. Cozzolino, S. Parrilli, G. Scarpa, G. Poggi and L. Verdoliva, 
%   IEEE Geoscience and Remote Sensing Letters, in press, 2013.
%   Please refer to this paper for a more detailed description of
%   the algorithm.
%
%   IMA_FIL = FANS(IMA_NSE, L)
%
%       ARGUMENT DESCRIPTION:
%               IMA_NSE  - Noisy image (in square root intensity) 
%               L        - Number of looks of the speckle noise
%
%       OUTPUT DESCRIPTION:
%               IMA_FIL  - Fixed-point filtered image (in square root intensity)
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

    %%% Removal of zeros
    z = removezeros(z);
    
    %%% Classification parameters:
    opt0.B_dim = 16;     % Number of rows/cols of block
    opt0.FAR   = 0.001;  % False alarm probability 
    opr0.th    = thForAGR(L,opt0.B_dim,opt0.FAR); % Threshold
    
    %%%% Classification elaboration:
    mapp = FANS_classifier(z,opt0.B_dim,opr0.th);

    %%%% First Step parameters:
    opt1.L              = L;       %% Number of looks of the speckle noise
    opt1.B_dim          = 8;       %% Number of rows/cols of block, must be a power of two
    opt1.S_dim          = 16;      %% Maximum size of the 3rd dimension of a stack, must be a power of two 
    opt1.SA_dim_C0      = 19;      %% Diameter of search area for "zero" class, must be odd
    opt1.SA_dim_C1      = 39;      %% Diameter of search area for " one" class, must be odd
    opt1.N_step         = 3;       %% Dimension of step in sliding window processing
    opt1.T2D_name       = 'daub4'; %% Transform used in the 2D spatial domain (*)
    opt1.lambda         = 2.7;     %% Threshold parameter for the thresholding
    opt1.tau_match      = inf();   %% Threshold for the block-distance
    opt1.beta           = 2.0;     %% Parameter of the 2D Kaiser window used in the reconstruction
    opt1.LUT_points     = 512;     %% Number of points of LUT to compute distances
    opt1.PET_parameter  = 0.9154;  %% Parameter of the Probabilistic Early Termination (=qfuncinv(0.18))
   
    %%%% First Step elaboration:
    y1 = FANS_step1(z,mapp,opt1);
    
    %%%% Second Step parameters:
    opt2.L             = L;       %% Number of looks of the speckle noise
    opt2.B_dim         = 8;       %% Number of rows/cols of block, must be a power of two
    opt2.S_dim         = 32;      %% Maximum size of the 3rd dimension of a stack, must be a power of two 
    opt2.SA_dim_C0     = 19;      %% Diameter of search area for "zero" class, must be odd 
    opt2.SA_dim_C1     = 39;      %% Diameter of search area for " one" class, must be odd
    opt2.N_step        = 3;       %% Dimension of step in sliding window processing
    opt2.T2D_name      = 'dct';   %% Transform used in the 2D spatial domain (*)
    opt2.tau_match     = inf();   %% Threshold for the block-distance
    opt2.beta          = 2.0;     %% Parameter of the 2D Kaiser window used in the reconstruction
    opt2.LUT_points    = 512;     %% Number of points of LUT to compute distances
    opt2.PET_parameter = 0.3585;  %% Parameter of the Probabilistic Early Termination (=qfuncinv(0.36))
    
    %%%% Second Step elaboration:
    y2 = FANS_step2(z,y1,mapp,opt2);
    
    %
    % (*) possible transforms are:
    %         'eye'    , 'dct'    , 'haar' ,
    %         'daub2'  , 'daub3'  , 'daub4',
    %         'bior1.3', 'bior1.5'
    %
    

function th = thForAGR(L,N,FAR)
% ln(A/G) < th => uniform blocco
    if nargin<2, N = 16; end;
    if nargin<3, FAR = 10^(-3); end;

    N2   = N*N;
    v    = psi(1,L)./N2-psi(1,N2.*L);
    m    = psi(0,N2.*L)-psi(0,L)-log(N2);
    lp   = m./v;
    k    = (m.^2)./v;
    th   = gammaincinv(1-FAR,k)./lp;