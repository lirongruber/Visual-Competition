function [paramMatrix,paramNames] = CalcImageParameters(org_images)
%% This function gets a cell array with the images and calcuates the image parameters 

spatFreq = [];
xVals = 129:256;
yVals = 2:129;
for im_i = 1:numel(org_images)
    im_gray = rgb2gray(org_images{im_i});
    im_hsv{im_i} = rgb2hsv(org_images{im_i});
    im_YIQ{im_i} = rgb2ntsc(org_images{im_i});
    im_LAB{im_i} = rgb2lab(org_images{im_i});
    
    im_saturation = im_hsv{im_i}(:,:,2);
    im_I{im_i} = im_YIQ{im_i}(:,:,2);
    im_Q{im_i} = im_YIQ{im_i}(:,:,3);
    im_a{im_i} = im_LAB{im_i}(:,:,2);
    im_b{im_i} = im_LAB{im_i}(:,:,3);
    
    im_R{im_i} = org_images{im_i}(:,:,1);
    im_G{im_i} = org_images{im_i}(:,:,2);
    im_B{im_i} = org_images{im_i}(:,:,3);
    mean_saturation(im_i) = mean(im_saturation(:));
    im_hue = im_hsv{im_i}(:,:,1);
    mean_hue(im_i) = mean(im_hue(:));
    % subplot(10,12,im_i); histogram(im_gray(:)); axis off;
    top_quant = quantile(im_gray(:),0.9);
    bottom_quant = quantile(im_gray(:),0.1);
    lum_dif(im_i) = double(top_quant-bottom_quant);
    rms_contrast(im_i) = std(double(im_gray(:)));
    loc_contrast= stdfilt(im_gray,ones(5));
    [Gmag,Gdir] = imgradient(im_gray);
    [Gx,Gy] = imgradientxy(im_gray);
    
    
    
    luminance(im_i) = mean(im_gray(:));
    
    energy_IQ(im_i) = sum(im_I{im_i}(:).^2) + sum(im_Q{im_i}(:).^2) ;
    energy_ab(im_i) = mean(im_a{im_i}(:).^2 +im_b{im_i}(:).^2);
    mean_loc_contrast(im_i) = sum(loc_contrast(:).^2);
    
    grad_mag(im_i) = sum(Gmag(:).^2);
    grad_magX(im_i) = sum(Gx(:).^2);
    grad_magY(im_i) = sum(Gy(:).^2);
	
    tot_R(im_i) = mean( im_R{im_i}(:));
    tot_G(im_i) = mean( im_G{im_i}(:));
    tot_B(im_i) = mean( im_B{im_i}(:));
    
        
    gray_images(:,:,im_i) = im_gray;
    spat = abs(fftshift(fft2(im_gray)));
    [maxVal,maxIdx(im_i)] = max(spat(:));
    spat(spat==maxVal) = 0;
    
    
    lower_freq = spat(yVals(end-31):yVals(end),xVals(1):xVals(32));
    all_freq = spat(yVals,xVals);
    low_freq_sum(im_i) = sum(lower_freq(:));
    high_freq_sum(im_i) = sum(all_freq(:))-low_freq_sum(im_i) ;
    freq_ratio(im_i) = high_freq_sum(im_i)/low_freq_sum(im_i);
    spatFreq(:,:,im_i) = spat(110:146,110:146);
end

paramNames = {'luminance','colorfulness','saturation','red','green','blue','gradient','global contrast' ,'lower freq'};
paramMatrix = [luminance ; energy_IQ ; mean_saturation ; tot_R ; tot_G ; tot_B ; grad_mag  ; rms_contrast ;  low_freq_sum];



end


