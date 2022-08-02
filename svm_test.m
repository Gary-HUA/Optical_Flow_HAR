                              % classification test
% clear variable
clear;
clc;

% multi-SVM model.  model path: libsvm-3.25
addpath('libsvm-3.25\matlab')
addpath('libsvm-3.25\matlab');


% load train, test data and model.
test = load(".\features\daria_wave2_T.csv");
PS = load(".\model\PS");
svm_model = load(".\model\svm_model");
svmModel = svm_model.model;
PS = PS.PST;

% test train 
test_matrix = test(:,1:168);
test_label = test(:,169);

% test data normalization.
test_matrix = mapminmax('apply',test_matrix', PS);
test_matrix = test_matrix';

% simulation to test
[predict_label_1,accuracy_1,dec_value] = svmpredict(test_label,test_matrix,svmModel,'-b 1'); % version ,match parameters
%drawing figure 
figure
plot(test_label,'b o');
hold on 
plot(predict_label_1,'r *');
 
grid on 
xlabel('samp_num');
ylabel('type');
legend('type_T');
set(gca,'fontsize',12)
