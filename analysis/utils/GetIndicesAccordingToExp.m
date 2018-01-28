function [image_pairs_exp_idx,image_names,org_images] = GetIndicesAccordingToExp(main_dir)
dirIm = fullfile(main_dir,'originalImages_exp');
filesInDir = dir(dirIm) ;
% run over dirs :
org_images = cell(1,180);
org_images_path = cell(1,180);
im_names = cell(1,180);
count = 0;
for im_i = 3:numel(filesInDir)
    curr_dir_name = filesInDir(im_i).name ;
    images_in_curr_dir = dir(fullfile(dirIm,curr_dir_name));
    count = count+1;
    im_names{count} = images_in_curr_dir.name;

    org_images_path{count} = fullfile(dirIm,images_in_curr_dir.name);
    curr_im = imread(org_images_path{count});
    org_images{count} = curr_im;
    %            subplot(10,12,count); imagesc( org_images{count} ); hold on; axis off; title(num2str(count));
    
end
% save('org_image_names.mat','im_names');
startIdx = cellfun(@(x) regexp(x,'n[01]'),org_images_path,'UniformOutput',false);

image_names = cellfun(@(x,y) y(x(1):(x(1)+17)),startIdx,org_images_path,'UniformOutput',false)';

image_pairs_exp_idx = GetOriginalIdxPerMix(im_names,main_dir);
image_pairs_exp_idx = image_pairs_exp_idx(1:90,:);

end
 