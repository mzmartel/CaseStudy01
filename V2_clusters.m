
clear all;
close all;

%% In this script, you need to implement three functions as part of the k-means algorithm.
% These steps will be repeated until the algorithm converges:

  % 1. initialize_centroids
  % This function sets the initial values of the centroids
  
  % 2. assign_vector_to_centroid
  % This goes through the collection of all vectors and assigns them to
  % centroid based on norm/distance
  
  % 3. update_centroids
  % This function updates the location of the centroids based on the collection
  % of vectors (handwritten digits) that have been assigned to that centroid.


%% Initialize Data Set
% These next lines of code read in two sets of MNIST digits that will be used for training and testing respectively.

% training set (1500 images)
train=csvread('mnist_train_1500.csv');
trainsetlabels = train(:,785);
train=train(:,1:784);
train(:,785)=zeros(1500,1);

% testing set (200 images with 11 outliers)
test=csvread('mnist_test_200_woutliers.csv');
% store the correct test labels
correctlabels = test(:,785);
test=test(:,1:784);

% now, zero out the labels in "test" so that you can use this to assign
% your own predictions and evaluate against "correctlabels"
% in the 'cs1_mnist_evaluate_test_set.m' script
test(:,785)=zeros(200,1);

%% After initializing, you will have the following variables in your workspace:
% 1. train (a 1500 x 785 array, containins the 1500 training images)
% 2. test (a 200 x 785 array, containing the 200 testing images)
% 3. correctlabels (a 200 x 1 array containing the correct labels (numerical
% meaning) of the 200 test images

%% To visualize an image, you need to reshape it from a 784 dimensional array into a 28 x 28 array.
% to do this, you need to use the reshape command, along with the transpose
% operation.  For example, the following lines plot the first test image

figure;
colormap('gray'); % this tells MATLAB to depict the image in grayscale
testimage = reshape(test(1,[1:784]), [28 28]);
% we are reshaping the first row of 'test', columns 1-784 (since the 785th
% column is going to be used for storing the centroid assignment.
imagesc(testimage'); % this command plots an array as an image.  Type 'help imagesc' to learn more.

%% After importing, the array 'train' consists of 1500 rows and 785 columns.
% Each row corresponds to a different handwritten digit (28 x 28 = 784)
% plus the last column, which is used to index that row (i.e., label which
% cluster it belongs to.  Initially, this last column is set to all zeros,
% since there are no clusters yet established.

%% This next section of code calls the three functions you are asked to specify

k= 20; % set k
max_iter= 250; % set the number of iterations of the algorithm

%% The next line initializes the centroids.  Look at the initialize_centroids()
% function, which is specified further down this file.

centroids=initialize_centroids(train,k);

%% Initialize an array that will store k-means cost at each iteration

cost_iteration = zeros(max_iter, 1);

%% This for-loop enacts the k-means algorithm


for iter=1:max_iter 
    
    % assign cluster value for each image and add to the data 
    for image=1:1500
        %use results from function to assign these values
        train(image,785) = assign_vector_to_centroid((train(image,:)),centroids);
    
    end
    
    %once we have all images assigned, we can 
    %   reassign centroids
    centroids = update_Centroids(train,k);

end


%% This section of code plots the k-means cost as a function of the number
% of iterations

%figure;
%cost_iteration

% the function below returns vec_distance and index 
% cost function is the sum of all vec distance in a cluster?? 
% ^^not sure
%assign_vector_to_centroid(data,centroids) 


%% This next section of code will make a plot of all of the centroids
% Again, use help <functionname> to learn about the different functions
% that are being used here.

figure;
colormap('gray');

plotsize = ceil(sqrt(k));

for ind=1:k
    
    centr=centroids(ind,[1:784]);
    subplot(plotsize,plotsize,ind);
    
    imagesc(reshape(centr,[28 28])');
    title(strcat('Centroid ',num2str(ind)))

end

%% Function to initialize the centroids
% This function randomly chooses k vectors from our training set and uses them to be our initial centroids
% There are other ways you might initialize centroids.
% ***Feel free to experiment.***
% Note that this function takes two inputs and emits one output (y).

function y=initialize_centroid(data,num_centroids)

%option 1
    random_index=randperm(size(data,1));

    centroids=data(random_index(1:num_centroids),:);

    y=centroids;
%     
% %option 2
%     %create own centroids (outside values are usually 0)
%     %make the area smaller (125-625 of the 785 data size) (
%     integer_set = randi([(size(data,1)*0.15) (size(data,1)*0.80)],1,size(data,1));
%     centroids=data(integer_set(1:num_centroids),:);
%     centroids(1,1:48) = 0;
%     centroids(1,700:784) = 0;
%     y=centroids;

% % option 3
% %set each on manually based on past iterations found
% c1 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,171,253,133,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,253,252,215,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,253,252,241,78,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,108,232,252,190,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,47,232,252,252,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,109,252,252,252,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,109,252,252,252,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,109,252,252,252,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,110,253,253,253,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,109,252,252,252,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,109,252,252,231,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,109,252,252,108,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,110,253,253,108,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,233,252,252,108,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,253,252,246,92,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,253,252,215,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,145,255,253,232,47,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,144,253,252,252,108,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,41,253,252,246,92,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,170,252,132,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1]
% c2 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,60,157,157,157,157,32,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,135,252,252,252,252,210,59,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,111,252,252,252,252,252,36,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,145,252,252,252,252,252,36,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,181,240,167,228,252,224,24,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,36,31,0,181,252,167,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,44,246,252,116,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,93,121,167,241,241,242,241,241,243,252,252,48,0,0,0,0,0,0,0,0,0,0,0,0,7,88,213,253,253,253,253,253,253,255,253,253,253,253,253,213,19,0,0,0,0,0,0,0,0,0,0,7,206,252,252,246,193,148,228,176,108,253,252,252,252,252,252,252,114,3,0,0,0,0,0,0,0,0,0,88,252,252,245,107,0,0,14,37,151,253,252,247,193,125,226,252,252,41,0,0,0,0,0,0,0,0,0,132,252,252,146,0,38,49,184,252,252,251,204,118,0,0,73,252,252,143,0,0,0,0,0,0,0,0,0,190,252,252,238,181,235,252,252,252,194,69,0,0,0,0,21,218,252,169,3,0,0,0,0,0,0,0,0,99,252,252,252,252,252,252,190,71,3,0,0,0,0,0,0,113,252,252,138,0,0,0,0,0,0,0,0,3,117,167,167,167,133,48,7,0,0,0,0,0,0,0,0,57,240,252,252,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,31,144,155,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2]
% c3 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,60,166,250,255,255,182,121,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12,39,129,192,221,254,225,129,125,125,200,254,241,122,0,0,0,0,0,0,0,0,0,0,0,0,0,0,169,244,174,174,127,66,11,0,0,0,2,35,162,251,145,1,0,0,0,0,0,0,0,0,0,0,0,0,158,41,0,0,0,0,0,0,0,0,0,0,0,117,254,85,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,23,224,145,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,197,179,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,197,106,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,94,245,106,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,11,60,184,253,195,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,17,121,190,190,190,251,254,254,171,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,111,254,254,205,189,189,189,226,223,74,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,11,11,3,0,0,0,27,190,249,88,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,163,254,62,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,185,217,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,48,253,59,0,0,0,0,0,0,0,0,0,0,0,0,0,0,64,0,0,0,0,0,0,0,0,0,0,0,191,128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,168,224,183,75,0,0,0,0,0,0,0,0,219,62,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,37,161,245,182,57,1,0,0,0,0,80,253,53,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,34,173,254,176,91,22,0,9,191,221,11,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,91,202,254,219,152,193,254,65,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3]
% c4 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,32,229,253,114,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,57,252,252,88,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10,172,252,164,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,29,252,252,90,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,13,204,253,106,0,0,0,0,63,255,222,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,113,253,240,43,0,0,0,19,194,234,65,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,200,231,43,0,0,0,0,123,252,137,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,126,249,225,0,0,0,0,26,222,202,13,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,198,253,114,0,0,0,4,179,253,140,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,197,252,138,0,0,0,29,252,252,65,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,110,252,235,85,19,0,66,252,148,6,0,0,0,0,48,28,0,0,0,0,0,0,0,0,0,0,0,0,10,178,253,252,231,225,241,252,231,225,226,225,225,225,229,47,0,0,0,0,0,0,0,0,0,0,0,0,0,0,13,138,225,238,254,253,253,253,239,225,137,63,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,113,247,121,84,84,38,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,200,225,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,225,175,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,226,114,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,38,237,38,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,225,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,175,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4]
% c5 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,118,134,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,231,237,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,35,254,229,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,93,254,226,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,164,254,192,34,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,207,254,109,84,131,119,24,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,60,250,254,254,254,254,254,237,47,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,204,254,254,254,254,254,254,182,22,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,92,248,230,125,98,72,34,16,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,174,254,93,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,247,254,40,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,36,239,254,230,123,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,86,224,245,254,175,28,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,37,143,254,203,26,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,60,243,205,24,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16,0,0,0,0,0,0,73,243,254,49,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,101,143,0,0,0,0,38,142,244,254,246,38,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,94,250,161,148,195,230,245,254,254,247,85,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,158,254,254,254,254,254,255,220,36,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,17,106,171,171,249,200,143,29,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5]
% c6 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,17,195,255,100,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,30,234,253,253,253,70,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,13,90,240,253,226,231,243,56,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12,169,253,253,136,35,177,150,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,215,253,226,66,5,8,216,164,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,129,253,253,127,0,0,0,31,51,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,177,249,252,82,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,173,253,251,137,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,76,243,252,137,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,50,239,253,164,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,72,253,253,38,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,170,253,253,156,95,95,95,67,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,102,248,253,253,253,253,253,253,246,231,231,110,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,171,253,208,124,124,134,241,241,241,246,253,253,235,53,4,0,0,0,0,0,0,0,0,0,0,0,0,0,171,253,164,0,0,0,0,0,0,40,213,224,241,253,84,0,0,0,0,0,0,0,0,0,0,0,0,0,171,253,181,6,0,0,0,0,0,0,0,0,71,253,231,35,0,0,0,0,0,0,0,0,0,0,0,0,141,253,253,141,34,0,0,0,0,0,0,0,61,253,253,53,0,0,0,0,0,0,0,0,0,0,0,0,11,164,253,253,228,201,201,173,138,84,191,201,232,253,163,11,0,0,0,0,0,0,0,0,0,0,0,0,0,10,76,242,253,253,253,253,253,253,253,253,242,130,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,20,135,135,190,135,135,28,17,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6]
% c7 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,92,255,255,172,130,130,130,130,130,191,130,24,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,80,253,253,253,253,253,253,253,253,253,253,253,253,207,19,0,0,0,0,0,0,0,0,0,0,0,0,0,9,123,235,244,247,253,253,253,253,253,253,253,253,253,207,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,52,70,128,228,228,228,228,128,208,250,253,253,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,217,253,253,94,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,217,253,253,63,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,217,253,253,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,217,253,253,79,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,225,253,253,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,88,253,253,227,14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,121,253,253,148,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,24,223,253,253,112,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,81,253,253,222,17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,81,253,253,154,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,187,253,253,154,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,30,224,253,253,45,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,75,253,253,214,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,190,253,253,160,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,141,253,253,103,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,39,169,150,19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7]
% c8 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,21,132,253,254,213,92,31,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,62,203,253,252,253,252,253,192,41,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,152,253,254,253,102,20,82,243,234,112,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,152,252,213,50,0,0,0,122,253,252,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,152,253,203,0,0,0,0,102,254,253,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,152,252,203,0,0,0,62,162,253,212,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,152,253,203,0,0,82,254,253,244,81,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,152,252,243,40,62,223,253,252,162,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,21,223,254,213,254,253,254,131,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,122,253,252,253,252,131,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,51,233,254,253,254,253,21,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,82,233,252,253,252,253,252,102,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,113,253,254,253,142,203,254,253,173,10,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,193,252,253,130,0,20,172,252,253,91,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,193,253,203,0,0,0,21,162,254,213,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,152,252,203,0,0,0,0,102,253,252,82,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,153,253,214,10,0,0,0,0,255,253,163,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,51,192,253,212,102,20,0,41,253,252,203,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,163,243,255,253,255,253,255,253,142,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,81,213,252,253,252,253,252,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8]
% c9 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,13,145,254,255,223,133,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,11,93,220,249,243,243,251,220,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,36,135,253,252,165,49,0,0,84,246,104,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,127,238,253,214,92,0,0,0,0,88,253,64,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,90,253,242,178,3,0,0,0,0,8,162,243,85,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,193,253,112,0,0,0,0,0,0,88,253,220,26,0,0,0,0,0,0,0,0,0,0,0,0,0,0,147,253,158,4,0,0,0,0,0,124,246,253,86,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12,218,237,71,0,0,0,0,26,130,249,253,194,9,0,0,0,0,0,0,0,0,0,0,0,0,0,0,97,253,147,0,0,0,19,136,232,253,227,110,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,58,238,228,50,144,149,249,253,253,245,76,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,204,253,253,253,253,253,253,252,77,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,28,94,94,94,177,253,252,109,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,125,244,234,139,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,124,249,227,86,17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,154,246,253,120,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,24,208,253,154,47,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,19,240,253,169,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,26,182,253,231,43,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,174,252,222,27,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,218,246,48,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9]
% c10 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,118,134,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,231,237,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,35,254,229,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,93,254,226,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,164,254,192,34,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,207,254,109,84,131,119,24,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,60,250,254,254,254,254,254,237,47,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,204,254,254,254,254,254,254,182,22,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,92,248,230,125,98,72,34,16,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,174,254,93,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,40,247,254,40,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,36,239,254,230,123,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,86,224,245,254,175,28,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,37,143,254,203,26,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,60,243,205,24,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16,0,0,0,0,0,0,73,243,254,49,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,101,143,0,0,0,0,38,142,244,254,246,38,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,94,250,161,148,195,230,245,254,254,247,85,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,158,254,254,254,254,254,255,220,36,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,17,106,171,171,249,200,143,29,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10]
% 
% y = [c1,c2,c3,c4,c5,c6,c7,c8,c9,c10]


%other ideas:
%   search for spots that have gaps - repeated rows of bright dark bright
%   create our own?
%   

%

end

%% Function to pick the Closest Centroid using norm/distance
% This function takes two arguments, a vector and a set of centroids
% It returns the index of the assigned centroid and the distance between
% the vector and the assigned centroid.

%TOP FUNCTION IS ORIGINAL -- CHANGED TO ONLY RETURN INDEX FOR TESTING THE
%ASSIGNING INDEX PORTION
% function [index, vec_distance] = assign_vector_to_centroid(data,centroids)
function index = assign_vector_to_centroid(data,centroids)
    % find distance from piece of data to each centroid
    
    %iterate through each centroid
    for centroid=1:length(centroids(:,785))
        
       %find total distance between each point of the current centroid and
       %the image being assigned
       difference =  data(1:784) - centroids(centroid,1:784); 

       sq_difference = difference.^2;
       
       % holds the norm value for the current centroid and current image
       distance = sum(sq_difference);
            
       %compare the norm value to get the assigned cluster
       
       %if we are on the first cluster being checked, 
       %assign that value and set the current shortest distance
       if(centroid == 1)
           shortest_distance=distance;
           assigned_cluster=centroid; 
       %otherwise we can compare the distances computed
       %from each cluster and keep track of shortest
       elseif (distance < shortest_distance)
           shortest_distance=distance;
           assigned_cluster=centroid;
       end  
    end
    
    %assign the return values for the function
    index = assigned_cluster;
    vec_distance = shortest_distance;

end
%% Function to compute new centroids using the mean of the vectors currently assigned to the centroid.
% This function takes the set of training images and the value of k.
% It returns a new set of centroids based on the current assignment of the
% training images.

%CHECK WITH INSTRUCTOR ABOUT CHANGING OUTPU HERE
function new_centroids= update_Centroids(data,K)
    %create empty set to store new centroid values
    new_centroids = zeros(K,785);
    %get average from each set:
    %find all entries in data with last column as each centroid value
    for each=1:K %go through centroids
        count = 0;
        total = zeros(1,785);
        
       for element=1:1500 %go through all images
           if (data(element,785)==each) %if the image is in the current centroid
               count = count + 1;
               total = total(1:784) + data(element,1:784);
               %now after the loop has run through we will have the total
               %from each centroid
           end
       new_centroid = total/count; %new vector for current centroid
       %^^ a 784 dimensional vector
       
       %update the return value of the function to give the new centroid
       new_centroids(each,1:784)=new_centroid(1:784); 

       end
       new_centroids(each,785)=each;
    end

end