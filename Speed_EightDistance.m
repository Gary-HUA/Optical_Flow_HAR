close all 
clear;
clc;
% feature extraction function from Weizmann datasets, KTH datasets.
% ACTION: WALK, BEND, JACK, PJUMP, RUN, SIDE, SKIP, WAVE1, WAVE2.
% trainset root :F:\dataset\datasets\KTH\KTH_TrainSet\Hand_clapping\*.avi
% testset root: F:\dataset\datasets\KTH\KTH_TestSet\Boxing
root = dir("F:\dataset\datasets\Weizmann\Test_Datasets\wave2\*.avi"); % dataset are weizmann and KTH dataset.
%disp(root);
len = length(root);
for v = 1:len
    
%read video frames from files(train or test)
    %[file,path] = uigetfile(video_name.folder(v));
    %filename=fullfile(path,file);
    str=strcat("F:\dataset\datasets\Weizmann\Test_Datasets\wave2\", root(v).name);
    outname_split = (strsplit(root(v).name, "."));
    out_name = outname_split{1,1};
    obj = VideoReader(str);
    numFrames = obj.NumFrames;% frame id
    save_resx = zeros(1,144); % feature vector 


    width = obj.Width;
    height =obj.Height; 
    Threshold = 0.003; CloseSize = 13;  % key parameter for proper features vector.values in parameter.txt
    desiredAngles = 5:5:360;
    DisAngles = 15:15:360;
    heiwid = numel(obj);
    boundary = ones(height,width);
    label = 9; % label of data 0 to 9


    % Guassian mixture model :foreground
    %creat a detector object
    detector = vision.ForegroundDetector( ...
        'NumTrainingFrames',3, 'InitialVariance', 10*10);
    % Perform blob analysis.
    blob = vision.BlobAnalysis(...
           'CentroidOutputPort', false, 'AreaOutputPort', false, ...
           'BoundingBoxOutputPort', true, ...
           'MinimumBlobAreaSource', 'Property', 'MinimumBlobArea', 100,...
      'MaximumCount',1);
    % insert a bounder
    shapeInserter = vision.ShapeInserter('BorderColor','Custom');
    opticFlow = opticalFlowHS('Smoothness',8, 'MaxIteration', 10, 'VelocityDifference', 0);
    opticalBG = ones(height, width)*255;
    % frameLogical 
    frameLogical = ones(height,width);
    for k = 1 : numFrames 
         if mod(k,3)==0
              frame = read(obj,k);
              frameGray = rgb2gray(frame);
              flow = estimateFlow(opticFlow, frameGray);
              for i = 1:height
                for j = 1:width
                    if(sqrt(flow.Vx(i, j)^2 + flow.Vy(i, j)^2) <= Threshold)%threshold=0.02
                        frameLogical(i, j) = 0;
                    else
                        frameLogical(i, j) = 255;% flow.Vx()...>threshold 
                    end
                end
              end
                se = strel('square', CloseSize);% morphlogical
        % frameLogical = logical(frameLogical);% binarize frame logical type

                frameLogical = imclose(frameLogical, se); % close operating
                frameLogical =logical(frameLogical);
                bbox = step(blob, frameLogical); % boundary
                out = insertShape(frameGray,'Rectangle',bbox,'color','red');% output with boundary on frame
                % calculate center of gravity of the foreground
                [labelImage, numberOfImage] = bwlabel(frameLogical, 8);
                blobMeasurements = regionprops(labelImage, 'Centroid');
                try
                    yCenter = blobMeasurements(1).Centroid(1);
                    xCenter = blobMeasurements(1).Centroid(2);
                catch 
                    warning("the object on %d frames wasn't detected...", k);
                    continue

                end
                [B,L] = bwboundaries(frameLogical,'noholes');
        boundaries=B;% shape's boundaries coordinate 

        boundaries = boundaries{1};
        Boun_num = size(boundaries);
        % boundaries of shapes all 
        xb = boundaries(:,1);
        yb = boundaries(:,2);



        % calculate angle of every boundaries point and distance 
        angles = atan2d((yb-yCenter),(xb-xCenter))+180;% every angles of boundaries point 
        position_coordinate = [xb,yb,angles];
        %distances = sqrt((xb-xCenter).^2+(yb-yCenter).^2);
        % fusion distance features 




        % maybe more than 1 index point with the same angle
        [uniqueAngles, ia, ic]= unique(angles);% ia index of original vector,
        uniquexb= xb(ia);
        uniqueyb = yb(ia);
        %uniqueDistances = distances(ia);
        uniqueAngles = [uniqueAngles(end)-360; uniqueAngles; uniqueAngles(1) + 360];
        uniquexb = [uniquexb(end); uniquexb; uniquexb(1)];
        uniqueyb = [uniqueyb(end); uniqueyb; uniqueyb(1)];
        desiredxb = interp1(uniqueAngles, uniquexb,desiredAngles);
        desiredyb = interp1(uniqueAngles, uniqueyb,desiredAngles);
        eightxb = interp1(uniqueAngles, uniquexb,DisAngles);
        eightyb = interp1(uniqueAngles, uniqueyb,DisAngles);
        allcoordinate(:,1) = desiredxb;
        allcoordinate(:,2) = desiredyb;


    xc=round(xCenter);
    yc=round(yCenter);%(x,y)
    xe=round(desiredxb);
    ye=round(desiredyb);% desiredyb
    eixe = round(eightxb);
    eiye = round(eightyb);

    Result_Ed = sqrt((eixe-xCenter).^2+(eiye-yCenter)).^2; % distance features.



    result =[];
    for inx = 1:72
            intersection_space = zeros(1,2);
            intersection_space(1,1)= xe(inx);
            intersection_space(1,2)= ye(inx);
            result = [result,intersection_space];
    end 

    result_speed = result - save_resx;
    save_resx = result;

    result_final = [result_speed,Result_Ed];
    result_final_L = [result_final,label];

    % write out feature vector.
    features_root = strcat(".\features\", out_name,"_T",".csv");
    dlmwrite(features_root,result_final_L,'-append');


    % drawing result.
        subplot(2,2,1),imshow(out),title('frame_Box');
        subplot(2,2,2),imshow(opticalBG),title('OpF');
        hold on ;
        plot(flow, 'DecimationFactor', [2 2], 'ScaleFactor', 20)% FLOW VECTOR
        drawnow
        hold off 
        subplot(2, 2, 3), imshow(frameLogical), title('logicalFrame'); 
        hold on 
        plot(yCenter,xCenter, 'r+', 'MarkerSize', 5, 'LineWidth', 2);
        hold off 
        subplot(2,2,4), imshow(boundary),title('boundaries');
        hold on 
        plot(yb,xb,'b-','markerSize',10,'lineWidth',2);
        %plot(y,x,'color','r','markerSize',10);
        plot(yCenter,xCenter,'r.','markerSize',10);
        plot(ye,xe,'r-');
        for len = 1:length(xe)
            plot([yCenter,ye(len)],[xCenter,xe(len)],'r-');
        end
        hold off  



         else
             continue;
         end




    end
end
