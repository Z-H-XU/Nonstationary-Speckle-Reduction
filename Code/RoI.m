

img = double(imread('Dataset\barbara.tif'));
im=img(:,:,1);

figure
load mask_bk.mat 
load mask_roi1.mat 
load mask_roi2.mat 
load mask_roi3.mat 
load mask_roi4.mat
load mask_roi5.mat
imshow(im,[]);
h = impoly(gca, pos_bk);
setColor(h,'green');
h = impoly(gca, pos_roi1);
setColor(h,'blue');
h = impoly(gca, pos_roi2);
setColor(h,'blue');
h = impoly(gca, pos_roi3);
setColor(h,'blue');
h = impoly(gca, pos_roi4);
setColor(h,'blue');
h = impoly(gca, pos_roi5);
setColor(h,'blue');

title('Regions used for calculating CNR');
