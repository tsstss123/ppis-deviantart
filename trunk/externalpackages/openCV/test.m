image = imread('../deviant/10_Xanxus_x_Squalo_by_LALAax.jpg');
% image = rgb2gray(image);

for i = 1:100
    i
%     a = cvlib_mex('canny',image);
%     a = rgb2hsv(image);
    a = cvlib_mex('color',image,'rgb2hsv');
%     a = edge(image,'canny');
end

