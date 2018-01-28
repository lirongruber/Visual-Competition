function  [final_probs_all,top1_all,top5_all,image_paths,layer_activities_allIm] = LoadNetResults(net_architectures_todo,subdir)
%% This functions gets a network name and the full path for the .mat file containing its outputs and load the accuracy, 
%% output probabilities and layer activities. 

final_probs_all = cell(numel(net_architectures_todo)); 

for net_i = 1:numel(net_architectures_todo)
    curr_net = [net_architectures_todo{net_i},'.mat'];
    net_results = load(fullfile(subdir,curr_net));
    top1_all(net_i) = net_results.top1_accuracy;
    top5_all(net_i) = net_results.top5_accuracy;
    final_probs_all{net_i} = net_results.found_probs;
    image_paths{net_i} = net_results.used_image_paths;
    if isfield(net_results,'layer_activities_allIm')
        layer_activities_allIm = net_results.layer_activities_allIm;
    else
        layer_activities_allIm=[];
    end
    
end



end
