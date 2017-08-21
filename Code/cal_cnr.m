% 2017.08.17
% zhihuo, xu

function   cnr_index=cal_cnr(groundtruth,image,L)

load mask_bk.mat 
load mask_roi1.mat 
load mask_roi2.mat 
load mask_roi3.mat 
load mask_roi4.mat
load mask_roi5.mat

mask_bk=floor(Mask_MultiLookingProc(mask_bk,L));
mask_roi1=floor(Mask_MultiLookingProc(mask_roi1,L));
mask_roi2=floor(Mask_MultiLookingProc(mask_roi2,L));
mask_roi3=floor(Mask_MultiLookingProc(mask_roi3,L));
mask_roi4=floor(Mask_MultiLookingProc(mask_roi4,L));
mask_roi5=floor(Mask_MultiLookingProc(mask_roi5,L));

N=length(image(:));

noise=(image-groundtruth);
n_dev=sqrt(var(noise(:)));

tem=image.*mask_bk;
contrast=mean(tem(:));

snr_bk=contrast/(n_dev*sum(mask_bk(:))/N);


tem=image.*mask_roi1;
contrast=mean(tem(:));

snr_rio1=contrast/(n_dev*sum(mask_roi1(:))/N);

tem=image.*mask_roi2;
contrast=mean(tem(:));
snr_rio2=contrast/(n_dev*sum(mask_roi2(:))/N);

tem=image.*mask_roi3;
contrast=mean(tem(:));
snr_rio3=contrast/(n_dev*sum(mask_roi3(:))/N);


tem=image.*mask_roi4;
contrast=mean(tem(:));
snr_rio4=contrast/(n_dev*sum(mask_roi4(:))/N);


tem=image.*mask_roi5;
contrast=mean(tem(:));
snr_rio5=contrast/(n_dev*sum(mask_roi5(:))/N);

cnr_index=(snr_rio1+snr_rio2+snr_rio3+snr_rio4+snr_rio5)/5-snr_bk;


cnr_index=20*log10(cnr_index);

return
