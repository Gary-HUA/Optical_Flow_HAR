                              % model training...
% clear variable
clear;
clc;

% multi-SVM model.  model path: libsvm-3.25
addpath('libsvm-3.25\matlab');

% load train and test data.
disp("train data loading...")
train = load ('.\features\SED_Train.csv');
test = load(".\features\daria_walk_T.csv");

%training set 
train_matrix = train(:,1:168); % training data 1-152,
train_label = train(:,169); % train label at 153 column.

% test train 
test_matrix = test(:,1:168);
test_label = test(:,169);

% data normalization
disp("data normalization...")
[train_matrix, PS] = mapminmax(train_matrix');
PST = PS;
train_matrix = train_matrix';

test_matrix = mapminmax('apply',test_matrix', PS);
test_matrix = test_matrix';

% model training
disp("model training...")
model = svmtrain(train_label,train_matrix,'-s 0 -t 2 -c 1.2 -g 2.8 -b 1'); % -s svm type, -t kernel func type, 
save(".\model\svm_model","model");  % save model 
save(".\model\PS", "PST")  % normalization parameter.

% simulation to test
[predict_label_1,accuracy_1,dec_value] = svmpredict(test_label,test_matrix,model,'-b 1'); % version ,match parameters

%drawing figure 
% figure
% plot(test_label,'b o');
% hold on 
% plot(predict_label_1,'r *');
% grid on 
% xlabel('samp_num');
% ylabel('type');
% legend('type_T');
% set(gca,'fontsize',12)
