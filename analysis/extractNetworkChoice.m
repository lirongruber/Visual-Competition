
main_dir = ''; % dir of .mat files of network's output 
dir_labels = fullfile(main_dir,'...ImageNet_ILSVRC2012\ILSVRCLabels\synset_labels.txt'); % dir of imagenet labels


dataset ='5050_PW';   %'5050_PW'; %phsAmp_PW'; %'5050_PW_resnet ; %phsamp_PW_resnet 
nOrgImages = 180;

    
if strcmp(dataset,'5050_PW')
    subdir = fullfile(main_dir,'val_resize256_5050_allPW_processed'); % uploads networks output
    images_path_name = fullfile(main_dir,'val_resize256_5050_allPW\20170420_162446_770\pixel_mix_per5050\val');
    [Idxs1, Idxs2] = meshgrid( ...
        1:nOrgImages, 1:nOrgImages);
    nonself_corr = Idxs1~=Idxs2;
    InputPaths1 = Idxs1(nonself_corr);
    InputPaths2 = Idxs2(nonself_corr);
    im_org_idx = [InputPaths1,InputPaths2];
    cond_idx = 1:3;
    
elseif strcmp(dataset,'phsAmp_PW')
    subdir = fullfile(main_dir,'val_resize256_phsAmp_allPW_processed');
    images_path_name = fullfile(main_dir,'val_resize256_phsAmp_allPW\20170423_085927_218\sort_by_amp\val');
    cond_idx = 4:6;
elseif strcmp(dataset,'phsAmp_PW_resnet')
    subdir = fullfile(main_dir,'val_resize256_phsAmp_allPW_resnet_processed');
    images_path_name = fullfile(main_dir,'val_resize256_phsAmp_allPW\20170423_085927_218\sort_by_amp\val');
    cond_idx = 4:6;    
elseif strcmp(dataset,'5050_PW_resnet')
    subdir = fullfile(main_dir,'val_resize256_5050_allPW_resnet_processed');
    images_path_name = fullfile(main_dir,'val_resize256_5050_allPW\20170420_162446_770\pixel_mix_per5050\val');
    [Idxs1, Idxs2] = meshgrid( ...
        1:nOrgImages, 1:nOrgImages);
    nonself_corr = Idxs1~=Idxs2;
    InputPaths1 = Idxs1(nonself_corr);
    InputPaths2 = Idxs2(nonself_corr);
    im_org_idx = [InputPaths1,InputPaths2];
    cond_idx = 1:3;
  
else
    cond_idx = 1:3;    
    subdir = fullfile(main_dir,'val_resize256_Catagories_human_phsamp_processed');
    images_path_name = fullfile(main_dir,'val_resize256_Catagories_fourier_forExp\20170130_145153_065\sort_by_amp\val');
end


[im_net_idx,image_name_1,image_name_2,imagePaths_netMix,image_catagories_idx,image_names_net]  = GetIndicesAccordingToNet(main_dir,dataset); 
[image_pairs_exp_idx,image_names_exp,org_images] = GetIndicesAccordingToExp(main_dir); 
if ~(strcmp(dataset,'5050_PW') || strcmp(dataset,'phsAmp_PW') || strcmp(dataset,'5050_PW_resnet') || strcmp(dataset,'phsAmp_PW_resnet') )
shuffle_idx = FindTransformFromNetToExp(im_net_idx,image_pairs_exp_idx);
end

subdir_org =fullfile(main_dir,'val_resize256_Catagories_human_processed');
net_architectures_todo = {'VGG_ILSVRC_19_layers'};

if strcmp(dataset,'5050_PW_resnet') || strcmp(dataset,'phsAmp_PW_resnet') 
subdir_org =fullfile(main_dir,'val_resize256_Catagories_resnet');
net_architectures_todo = {'ResNet_152'};
end

% Finds the category indices and the transformation that matches between experiment order and net's order:
[im_net_idx,image_name_1,image_name_2,imagePaths_netMix,image_catagories_idx,image_names_net]  = GetIndicesAccordingToNet(main_dir,dataset); 
[image_pairs_exp_idx,image_names_exp,org_images,org_im_names] = GetIndicesAccordingToExp(main_dir); 
org_im_names = org_im_names.im_names;

if ~(strcmp(dataset,'5050_PW') || strcmp(dataset,'phsAmp_PW') || strcmp(dataset,'5050_PW_resnet') || strcmp(dataset,'phsAmp_PW_resnet') )
    for pair_idx = 1:size(im_net_idx,1)
        curr_pair = image_pairs_exp_idx(pair_idx,:);
        shuffle_idx(pair_idx) = find(ismember(image_pairs_exp_idx,curr_pair,'rows'));

    end
end

subdir_org =fullfile(main_dir,'val_resize256_Catagories_human_processed');
net_architectures_todo = {'VGG_ILSVRC_19_layers'};

if strcmp(dataset,'5050_PW_resnet') || strcmp(dataset,'phsAmp_PW_resnet') 
subdir_org =fullfile(main_dir,'val_resize256_Catagories_resnet');
net_architectures_todo = {'ResNet_152'};
end

% Load results of mixed images: 
[final_probs_all,top1_all,top5_all,image_paths,layer_activities_allIm] = LoadNetResults(net_architectures_todo,c_todo,subdir); 

% Load results of original images: 
[final_probs_all_org,top1_all_org,top5_all_org,image_paths_org,layer_activities_allIm_org] = LoadNetResults(net_architectures_todo,{'org'},subdir_org); 

% Calculates the image parameters: 
[paramMatrix,paramNames] = CalcImageParameters(org_images);

% Change the order to make sure the net and the experiment are the same
if ~(strcmp(dataset,'5050_PW') || strcmp(dataset,'phsAmp_PW') || strcmp(dataset,'5050_PW_resnet') || strcmp(dataset,'phsAmp_PW_resnet'))
final_probs_all_exp_order = final_probs_all{1}(shuffle_idx,:); 
image_catagories_idx_expOrder = image_catagories_idx(shuffle_idx,:); 
cat_idx_unique = image_catagories_idx_expOrder; %(idx_keep,:);
im_net_idx_expOrder = im_net_idx(shuffle_idx,:); 
else
 final_probs_all_exp_order = final_probs_all{1}; 
image_catagories_idx_expOrder = image_catagories_idx; 
cat_idx_unique = image_catagories_idx; %(idx_keep,:);
im_net_idx_expOrder = im_net_idx; 
end
    
%% Taking top five of each pair before and after: 
   
nTopProbs2Take = 5; 
% ranking_struct = struct('type',[],'catagories_of_interest',[]);
top_probs_1 = []; top_cat_1 = []; top_probs_2 =[]; top_cat_2 = []; ranking_struct = []; prob_1_of_cat = []; prob_2_of_cat =[]; 
prob_1_mix_of_cat = []; prob_2_mix_of_cat = []; 
for pair_i = 1:size(image_catagories_idx_expOrder,1)
   
    curr_pair = image_catagories_idx_expOrder(pair_i,:);
    curr_cat_idx = cat_idx_unique(pair_i,:);
    [probs_1,ranking_1] = sort(final_probs_all_org(curr_pair(1),:),'descend');
    top_probs_1(pair_i,:) = probs_1(1:nTopProbs2Take);
    top_cat_1(pair_i,:) = ranking_1(1:nTopProbs2Take);
    [probs_2,ranking_2] = sort(final_probs_all_org(curr_pair(2),:),'descend');
    top_probs_2(pair_i,:) = probs_2(1:nTopProbs2Take);
    top_cat_2(pair_i,:) = ranking_2(1:nTopProbs2Take);

    global_pair_idx(1) = find(ismember(im_net_idx_expOrder,curr_pair,'rows')); % the indices of this pair in the full idx vector:
        
    [probs_mix_1,ranking_mix_1] = sort(final_probs_all_exp_order(global_pair_idx(1),:),'descend');

    
    %% Check these top catagories in the original images and in the mixing 
    catagories_of_interest = unique([top_cat_1(pair_i,:), top_cat_2(pair_i,:)]'); 
    for cat_i = 1:numel(catagories_of_interest)
       
        catagories_of_interest(cat_i,2)= find(ranking_1==catagories_of_interest(cat_i));
        catagories_of_interest(cat_i,3)= find(ranking_2==catagories_of_interest(cat_i));
        catagories_of_interest(cat_i,4)= find(ranking_mix_1==catagories_of_interest(cat_i));
%         catagories_of_interest(cat_i,5)= find(ranking_mix_2==catagories_of_interest(cat_i));
        
    end
    % Each cell is a matrix of a unique pair
    % Colum 1 - the top 10 catagories for each of the original images
    % Colum 2,3 - the ranking of this catagory in orignal image 1,2
    % Colum 4,5 - the ranking of this catagory in mixing 1 and mixing 2
    
    ranking_struct(pair_i).ranking_matrix = catagories_of_interest;
    row_idx = find(catagories_of_interest(:,4)<=nTopProbs2Take);
    if isempty(row_idx)
        type_mix_1 = 1;
    elseif any(catagories_of_interest(row_idx,2)<=nTopProbs2Take) && any(catagories_of_interest(row_idx,3)<=nTopProbs2Take)
        type_mix_1 = 4;
    elseif any(catagories_of_interest(row_idx,2)<=nTopProbs2Take)
        type_mix_1 = 2;
        
    elseif any(catagories_of_interest(row_idx,3)<=nTopProbs2Take)
        type_mix_1 = 3;
      
    end
    
    ranking_struct(pair_i).types =[type_mix_1];

        % Classify ranking matrix: 
        % Type 1: Didnt see none of the original catagories. Meaning, in
        % both coloums of mixing- we don't see catagories 1 to 5
        % Type 2: Chose the first 
        % Type 3: Chose the second 
        % Type 4: Chose both
       
   
        


    prob_1_of_cat(pair_i,:) = final_probs_all_org(curr_pair(1),curr_cat_idx(1));
    prob_2_of_cat(pair_i,:) = final_probs_all_org(curr_pair(2),curr_cat_idx(2));
    
   
    
    
end


all_types = extractfield(ranking_struct,'types'); 

