function out_im = morph_img_pair(im1, im2, alg, prm1,percentages)
%% This function gets a pair if images (im1,im2) and morphs them according to an algorithm specified in 'alg'. 


if any(size(im1) ~= size(im2))
    error('Input image sizes don''t match');
end

switch alg
    case 'fourier_mix_3d'
        switch prm1
            case 'keep_amp', mag = abs(double(fftn(im1))); phs = angle(double(fftn(im2)));
            case 'keep_phs', mag = abs(double(fftn(im2))); phs = angle(double(fftn(im1)));
            otherwise, error('prm1 can be either ''keep_amp'' or ''keep_phs''');
        end
        re = mag .* cos(phs);
        im = mag .* sin(phs);
        out_im = real(ifftn(re + 1i*im));
    case 'fourier_mix'
        out_im = im1;
        for cd_i = 1:size(im1, 3)
            c_im1 = im1(:, :, cd_i);
            c_im2 = im2(:, :, cd_i);
            switch prm1
                case 'keep_amp', mag = abs(double(fft2(c_im1))); phs = angle(double(fft2(c_im2)));
                case 'keep_phs', mag = abs(double(fft2(c_im2))); phs = angle(double(fft2(c_im1)));
                otherwise, error('prm1 can be either ''keep_amp'' or ''keep_phs''');
            end
            re = mag .* cos(phs);
            im = mag .* sin(phs);
            c_out = c_im1;
            c_out(:) = real(ifft2(re + 1i*im));
            out_im(:, :, cd_i) = c_out;
        end
    case 'pixel_mix'
        switch prm1
            case 'checkerboard'
                rnd_mask = bsxfun(@xor, mod(1:size(im1,1),2)', mod(1:size(im1,2),2));
            case 'magic'
                rnd_mask = mod(magic([size(im1, 1), size(im1, 2)]), 2) == 1;
            case 'rand'
                rnd_mask = randi(2, [size(im1, 1), size(im1, 2)]) == 1;
            case 'continuous'
                rnd_mask = mod(1:(size(im1,1)*size(im1,2)), 2) == 1;
            otherwise, error('Unrevgogniaed option');
        end
        
        out_im = im1;
        for cd_i = 1:size(im1, 3)
            c_im1 = im1(:, :, cd_i);
            c_im2 = im2(:, :, cd_i);
            if exist ('percentages','var')
                rnd_mask=double(rnd_mask);
                c_im1=double(c_im1);
                c_im2=double(c_im2);
                c_out=c_im1.*percentages(1)+c_im2.*percentages(2);
            else
                c_out = c_im1;
                c_out(rnd_mask) = c_im2(rnd_mask);
            end
            out_im(:, :, cd_i) = c_out;
        end
  
        end  
         
end