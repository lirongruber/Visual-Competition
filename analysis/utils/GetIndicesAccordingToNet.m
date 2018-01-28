
%% Creating the baseline probabilities matrix , image idx and catagories idx 
function [im_net_idx,image_name_1,image_name_2,imagePaths_netMix,image_catagories_idx,image_name_org] = GetIndicesAccordingToNet(main_dir,dataset)

% To create a matrix with the indices of the original images
nOrgImages = 180; 
if strcmp(dataset,'5050_PW') || strcmp(dataset,'phsAmp_PW') || strcmp(dataset,'5050_PW_resnet') || strcmp(dataset,'phsAmp_PW_resnet')
[Idxs1, Idxs2] = meshgrid( ...
    1:nOrgImages, 1:nOrgImages);
nonself_corr = Idxs1~=Idxs2;
InputPaths1 = Idxs1(nonself_corr);
InputPaths2 = Idxs2(nonself_corr);
im_net_idx = [InputPaths1,InputPaths2];
end
% im_org_idx 

%% Creating the catagory index matrix 
% cd Z:\liron\finalProject
if strcmp(dataset,'5050_PW')
    subdir_temp = fullfile(main_dir,'val_resize256_5050_allPW_processed');
    c_todo = {'phs'};
    net_architectures_todo = {'VGG_ILSVRC_19_layers'};

elseif strcmp(dataset,'phsAmp_PW')
    subdir_temp = fullfile(main_dir,'val_resize256_phsAmp_allPW_processed');
    c_todo = {'amp'};
    net_architectures_todo = {'VGG_ILSVRC_19_layers'};

elseif strcmp(dataset,'phsAmp_PW_resnet')
    subdir_temp = fullfile(main_dir,'val_resize256_phsAmp_allPW_resnet_processed');
    c_todo = {'amp'};  
    net_architectures_todo = {'ResNet_152'};

elseif strcmp(dataset,'5050_PW_resnet')
     subdir_temp = fullfile(main_dir,'val_resize256_5050_allPW_resnet_processed');
    c_todo = {'phs'};  
    net_architectures_todo = {'ResNet_152'};

else
    subdir_temp = fullfile(main_dir,'val_resize256_Catagories_human_phsamp_processed');
    c_todo = {'amp'};
    net_architectures_todo = {'VGG_ILSVRC_19_layers'};

end

dir_labels = fullfile(main_dir,'RonInfra\Databases\ImageNet_ILSVRC2012\ILSVRCLabels\synset_labels.txt');
% dir_labels = 'W:\liron\finalProject\RonInfra\Databases\ImageNet_ILSVRC2012\ILSVRCLabels\synset_labels.txt';
% dir_labels = 'W:\liron\finalProject\RonInfra\Databases\ImageNet_ILSVRC2012\ILSVRCLabels'; 
mapping_list2label = importdata(dir_labels);
for net_i = 1:numel(net_architectures_todo)
    for c_i = 1:numel(c_todo)
        curr_c_todo = c_todo{c_i};
        curr_net = [curr_c_todo,'_',net_architectures_todo{net_i},'.mat'];
        net_results = load(fullfile(subdir_temp,curr_net));
        imagePaths_netMix = net_results.used_image_paths;
    end
end

% get the indices of the catagories of our images: 
startIdx = cellfun(@(x) regexp(x,'n[01]'),imagePaths_netMix,'UniformOutput',false); 
image_catagories_1 = cellfun(@(x,y) y(x(1):(x(1)+8)),startIdx,imagePaths_netMix,'UniformOutput',false);
image_catagories_idx(:,1) = cellfun(@(x) find(strcmp(x,mapping_list2label.textdata)),image_catagories_1); 
image_name_1 = cellfun(@(x,y) y(x(2):(x(2)+17)),startIdx,imagePaths_netMix,'UniformOutput',false);
image_catagories_2 = cellfun(@(x,y) y(x(3):(x(3)+8)),startIdx,imagePaths_netMix,'UniformOutput',false);
image_catagories_idx(:,2) = cellfun(@(x) find(strcmp(x,mapping_list2label.textdata)),image_catagories_2); 
image_name_2= cellfun(@(x,y) y(x(4):(x(4)+17)),startIdx,imagePaths_netMix,'UniformOutput',false);

%% Creating the probabilities matrix 

subdir_temp = fullfile(main_dir,'val_resize256_Catagories_human_processed'); 
if strcmp(dataset,'5050_PW_resnet') || strcmp(dataset,'phsAmp_PW_resnet')
  subdir_temp = fullfile(main_dir,'val_resize256_Catagories_resnet'); 
end
c_todo = {'org'};
% net_architectures_todo = {'VGG_ILSVRC_19_layers'};
% dir_labels = 'X:\lirongr\liron\finalProject/RonInfra/Databases/ImageNet_ILSVRC2012/ILSVRCLabels/synset_labels.txt';
% dir_labels = 'Z:\lirongr\liron\finalProject\RonInfra\Databases\ImageNet_ILSVRC2012\ILSVRCLabels\synset_labels.txt';

mapping_list2label = importdata(dir_labels);
final_probs_all = cell(numel(net_architectures_todo), numel(c_todo)); 

for net_i = 1:numel(net_architectures_todo)
    for c_i = 1:numel(c_todo)
        curr_c_todo = c_todo{c_i};
        curr_net = [curr_c_todo,'_',net_architectures_todo{net_i},'.mat'];
        net_results = load(fullfile(subdir_temp,curr_net));
        top1_all(net_i,c_i) = net_results.top1_accuracy;
        top5_all(net_i,c_i) = net_results.top5_accuracy;
        final_probs_all{net_i,c_i} = net_results.found_probs;
        % save image paths once:
%        if strcmp(curr_net,[curr_c_todo,'_bvlc_reference_caffenet.mat']) && (strcmp(curr_c_todo,'phs') ||  strcmp(curr_c_todo,'org'))
        imagePaths_org = net_results.used_image_paths;
%        end
    end
end

startIdx_org = cellfun(@(x) regexp(x,'n[01]'),imagePaths_org,'UniformOutput',false); 
image_name_org = cellfun(@(x,y) y(x(2):(x(2)+17)),startIdx_org,imagePaths_org,'UniformOutput',false);

%% Now create the matrix of indices: 
if ~strcmp(dataset,'5050_PW')
for pair_i =1:numel(image_name_1)
    im_net_idx(pair_i,1) = find(cellfun(@(x) strcmp(x,image_name_1{pair_i}),image_name_org)); 
    im_net_idx(pair_i,2) = find(cellfun(@(x) strcmp(x,image_name_2{pair_i}),image_name_org)); 
    
end
end
end