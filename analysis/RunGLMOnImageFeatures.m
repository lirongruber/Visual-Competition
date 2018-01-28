function [B_reg,FitInfo,best_acc_train,best_acc_test,acc_train_all,acc_test_all] = RunGLMWithOnAllCombsImageFeatures(X,responses,all_combs,testSingleParams)
%% This function trains a generlized linear model on the image features to predict the human/net choices 
% It runs on all feature combinations (all pairs/all trios... ) and for
% each  feature subset, trains a model for 50 train-test divisions. 

best_acc_test =[]; best_acc_train = []; 
nRep =50;
nExamples = size(X,1);
train_size = ceil(2*nExamples/3);
FitInfo = []; 
mdl = []; 
for rep_i = 1:nRep
    perm_idx = randperm(nExamples);
    train_idx{rep_i} = perm_idx(1:train_size);
    test_idx{rep_i} = perm_idx((train_size+1):end);
    for comb_i= 1:numel(all_combs)
        curr_comb = all_combs{comb_i};

        if testSingleParams
            FitInfo{rep_i,comb_i} = fitglm(X(train_idx{rep_i},curr_comb),responses(train_idx{rep_i},:),'Distribution','binomial');
            B_reg{rep_i,comb_i} =  FitInfo{rep_i,comb_i}.Coefficients.Estimate;
            
            preds_train{rep_i,comb_i} = FitInfo{rep_i,comb_i}.Fitted.response;
            preds_test{rep_i,comb_i} = FitInfo{rep_i,comb_i}.predict(X(test_idx{rep_i},curr_comb));
            y_train = round( preds_train{rep_i,comb_i});
            y_test = round( preds_test{rep_i,comb_i});
            acc_train_all(rep_i,1,comb_i) = 1- sum(abs(sum(y_train-responses(train_idx{rep_i}),2)))/length(y_train);
            acc_test_all(rep_i,1,comb_i) = 1- sum(abs(sum(y_test-responses(test_idx{rep_i}),2)))/length(y_test);
            
        else
            [B_reg{rep_i,comb_i},FitInfo{rep_i,comb_i}] = lassoglm(X(train_idx{rep_i},curr_comb),responses(train_idx{rep_i},:),'binomial','Alpha',1);
            for lambda_i = 1:100
                
                cnst = FitInfo{rep_i,comb_i}.Intercept(lambda_i);
                %             cnst = FitInfo{rep_i}.Intercept(i);
                B1 = [0 ; B_reg{rep_i,comb_i}(:,lambda_i)];
                preds_train_all = glmval(B1,X(train_idx{rep_i},curr_comb),'logit');
                preds_test_all= glmval(B1,X(test_idx{rep_i},curr_comb),'logit');
                y_train = round(preds_train_all);
                y_test = round(preds_test_all);
                acc_train_all(rep_i,lambda_i,comb_i) = 1- sum(abs(sum(y_train-responses(train_idx{rep_i}),2)))/length(y_train);
                acc_test_all(rep_i,lambda_i,comb_i) = 1- sum(abs(sum(y_test-responses(test_idx{rep_i}),2)))/length(y_test);
           
            end
            
        end
 
        
    end
end

end