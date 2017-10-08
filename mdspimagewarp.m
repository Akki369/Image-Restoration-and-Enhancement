clc;
clear all;
close all;
load('Image8')
I=mat2gray(IMAGE);
imshow(I);
title('Original Image')

%% Denoisy
N=21;
h1=fir1(N-1,0.3,'low',hamming(N));  %1d FIR filter 
h2=ftrans2(h1);   %frequency transfomration method
I1=filter2(h2,I);
figure
imshow((I1));

%% deblurring
LEN = 21;
THETA = 11;
N=21;
h1=fir1(N-1,0.3,'low',hamming(N));  % desgning a 1-D FIR filter   
h=ftrans2(h1);
 PSF = fspecial('gaussian',LEN,THETA);
  noise_var =0.9;
 estimated_nsr = noise_var / var(I1(:));
wnr3 = deconvwnr(I1, h,PSF,estimated_nsr);
figure, 
imshow(wnr3)
title('Restoration of Blurred, Noisy Image Using Estimated NSR');

%%warping

W=zeros(480,480);
R0=305;
for i=1:380
    for j=1:380
        x_ = j - 190.5;
        y_ = 190.5 - i;

        x = abs(x_);
        y = abs(y_);
        
         t = atan(y/x);
        r_ = sqrt(x^2+y^2);
        r = R0*(sin((r_/R0)));
        
        
       
        
        x = r*cos(t) ;
        y = r*sin(t) ;
        if x_ < 0
            x = -x;
        end
        
        if y_ < 0
            y = -y;
        end
        i_= ceil(235 - y);
        j_ = ceil(x + 235);
        W(i_,j_) = wnr3(i,j);
    end
end
figure
imshow(mat2gray(W));
