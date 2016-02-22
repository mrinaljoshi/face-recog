clc
close all

subdim = 100 ;                                % 100 is the subdim chosen. can be varied
PCA_recog(subdim);                            % calling PCA_recog to create projections (pcaProj) of database images

load psi;                                     % mean face
load w;                                       % lower dimentional projection space
load pcaProj;                                 

test_img_name = 'mj2' ;                         % Name of the test image
thepath = 'C:\Users\sivagee\Desktop\IMAGE\all_image\';         % change the path to where folder of data base is stored
fname = [thepath '/' test_img_name '.jpg'];
test_img = imread(fname);                         
figure()
imshow(test_img)
test_img = rgb2gray(test_img);                   % Pre-processing 
test_img = reshape(imresize(test_img,[112 92]),92*112 ,1);

zero_mean_test_img = double(test_img) - psi;

Proj_test = w' *zero_mean_test_img;             % PCA components of test image
Test_proj_img = w*Proj_test;                    % reconstructed image
figure()

imshow(reshape(Test_proj_img+psi,112,92),[0 255])
title('Projected Image to be matched with stored data')

MSE_arr = zeros([1 size(pcaProj,2) ]);
for i = 1:size(pcaProj,2)
   MSE_arr(i) =  (sum((pcaProj(:,i) - Proj_test).^2))/size(pcaProj,1);     % Mean square error calculation 
end
[~,index] = min(MSE_arr);                                                  % final image will be one with min MSE
fprintf('Our image is %d',index) 
load DATA
figure()

imshow(reshape(DATA(:,index),112,92),[0 255])
title('Recognised face')