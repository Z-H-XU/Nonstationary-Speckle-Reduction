function [decibels] = compute_psnr(A,B)

error_diff = A - B;
decibels = 20*log10(1/(sqrt(mean(mean(error_diff.^2)))));
