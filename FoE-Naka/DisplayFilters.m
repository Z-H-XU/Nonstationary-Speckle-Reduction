function DisplayFilters(Omega,nRow,nCol,patchsize,theta)
norm_filters = sqrt(sum(Omega.^2,2));
% norm_filters = theta;
dis = norm_filters.*theta;
[Y I] = sort(dis,'descend');
Omega = Omega(I,:);
theta = theta(I);
for row = 1:nRow
    for col = 1:nCol
%         idx1 = (row-1)*nCol + col;
        idx2 = (col - 1)*nRow + row;
        subplot(nRow,nCol,idx2);
        
        tt = reshape(Omega(idx2,:)',patchsize,patchsize);
%         norm_filter = norm(tt(:));
        norm_filter = sqrt(sum(tt(:).^2) + (1e-3).^2);
        tt = tt/norm_filter;
        imshow(tt,[]);
        str1 = num2str(norm_filter,'%.2f');
        str2 = num2str(theta(idx2),'%.2f');
        str = strcat('(',str1,',',str2,')');
        title(str);
    end
end