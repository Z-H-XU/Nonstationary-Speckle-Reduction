

function ENL=cal_enl(Y1,Y2,X1,X2,img,FANS_filtered,FoE_Nakafiltered,proposed)

    A=4/pi-1;
    
    mask=img(Y1:Y2,X1:X2);
    fmean=mean2(mask);
    fvar=mean2((mask-fmean).^2);
    ENL(1)=A*fmean^2/fvar;

    mask=FANS_filtered(Y1:Y2,X1:X2);
    fmean=mean2(mask);
    fvar=mean2((mask-fmean).^2);
    ENL(2)=A*fmean^2/fvar;

    mask=FoE_Nakafiltered(Y1:Y2,X1:X2);
    fmean=mean2(mask);
    fvar=mean2((mask-fmean).^2);
    ENL(3)=A*fmean^2/fvar;

    mask=proposed(Y1:Y2,X1:X2);
    fmean=mean2(mask);
    fvar=mean2((mask-fmean).^2);
    ENL(4)=A*fmean^2/fvar;
     
return