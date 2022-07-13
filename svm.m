                              % classification test
% clear variable
clear;
clc;

% multi-SVM model.  model path: libsvm-3.25
addpath('libsvm-3.25\matlab')
addpath('libsvm-3.25\matlab');


% load train and test data.
train = load ('Speed_EightDis_Train.csv');
test = load ('Speed_EightDis_TestSIDE.csv');

% generate random number for divide data into training and test set.
%n = randperm(size(data,1));
%t = randperm(size(test,1));
%training set 
train_matrix = train(:,1:152); % training data 1-152,
train_label = train(:,153); % training label at 153 column.

% test train 
test_matrix = test(:,1:152);
test_label = test(:,153);

% data normalization
[train_matrix, PS] = mapminmax(train_matrix');
train_matrix = train_matrix';
test_matrix = mapminmax('apply',test_matrix', PS);
test_matrix = test_matrix';

model = svmtrain(train_label,train_matrix,'-s 0 -t 2 -c 1.2 -g 2.8 -b 1'); % -v-s 0 -t 2 -c 1.2 -g 2.8'


% simulation to test
[predict_label_1,accuracy_1,dec_value] = svmpredict(test_label,test_matrix,model,'-b 1'); % version ,match parameters

% drawing figure 
figure
plot(test_label,'b o');
hold on 
plot(predict_label_1,'r *');
 
grid on 
xlabel('samp_num');
ylabel('type');
legend('type_T');
set(gca,'fontsize',12)