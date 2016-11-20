
% we consider a qualitative measure for edge preservation. 
% using a parameter defined in the following references: 
% [1]A. Achim, P. Tsakalides, and A. Bezarianos, ¡°SAR image denoising
% via Bayesian wavelet shrinkage based on heavy-tailed modeling,¡± IEEE
% Trans. Geosci. Remote Sens., vol. 41, no. 8, pp. 1773¨C1784, Aug. 2003.
% [2]  F. Sattar, L. Floreby, G. Salomonsson, and B. L?vstr?m, ¡°Image en-
% hancementbasedonanonlinearmultiscalemethod,¡±IEEETrans.Image
% Processing, vol. 6, pp. 888¨C895, June 1997.

function   beta_index=cal_beta(orignal,filtered)

H = fspecial('laplacian');
orignal = imfilter(orignal,H,'replicate');
filtered = imfilter(filtered,H,'replicate');

s0=orignal(:)-mean(orignal(:));
s1=filtered(:)-mean(filtered(:));
beta_index=sum(s0.*s1)/sqrt(sum(s0.*s0)*sum(s1.*s1));

return


