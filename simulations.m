% --- READ ME ---
% SNR is the signal-noise relation
% nSamples is the number of samples to be considered
% theta is direction of arrival 
% nArrayElements is the number of antennas in the array
% nAlgorithm is the number that identify the algorithm under analysis
% nEvents is the number of times to running the algorithm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- AUTHOR(S) ---
% Lucas, Carlos, Matheus, Vicente, Danilo 
% --- Labsim/Gppcom ---
% DEPARTAMENTO DE COMUNICAÇÕES - DCO UFRN

%% --- Paramenters ---
DoaPar.SNR = [-20:10];                         % Values of SNR

DoaPar.nSamples = 200; %inside                         % Number of samples

DoaPar.theta = 0.257;                           % Number of theta

DoaPar.DifferenceDeviation = [pi/30];           % Error deviation

DoaPar.nArrayElements = 10;                     % Number of elements in the array

DoaPar.nAlgorithm = 1;                          % Number of algorithm

DoaPar.nEvents = 1000;                          % Number of events

DoaPar.nSources = 1;                            % Number of sources

DoaPar.DifferenceDrop = 2;                      % Used for findpeaks

%% --- Folder to save results ---
folderName = 'results';

mkdir(folderName);

homeDir = pwd;

save([folderName filesep 'DoaPar_' folderName '.mat'], 'DoaPar');

%% --- Code ---
 for SNR = DoaPar.SNR
     for theta = DoaPar.theta
         for deviation = DoaPar.DifferenceDeviation
             for array = DoaPar.nArrayElements
                for algorithms = DoaPar.nAlgorithm
                    for sources = DoaPar.nSources
                        for peak_factor = DoaPar.DifferenceDrop
                            for events = DoaPar.nEvents
                                %% --- Calling Function --- 
                                [T_x,T_y,T_z] = rate_calculation(SNR,DoaPar.nSamples,theta,array,algorithms,events,sources,peak_factor,deviation);
                                
                                %% Save folder
                                save([folderName filesep 'T_x_detection_' num2str(algorithms) '_SNR_' num2str(SNR) '_Deviation_' num2str((deviation*180)/pi) '_nEvents_'  num2str(events) '.mat'],'T_x', 'SNR');
                                save([folderName filesep 'T_y_detection_' num2str(algorithms) '_SNR_' num2str(SNR) '_Deviation_' num2str((deviation*180)/pi) '_nEvents_'  num2str(events) '.mat'],'T_y','SNR');
                                save([folderName filesep 'T_z_detection_' num2str(algorithms) '_SNR_' num2str(SNR) '_Deviation_' num2str((deviation*180)/pi) '_nEvents_'  num2str(events) '.mat'],'T_z','SNR');
                                disp(['Saved in T_x_detection_' num2str(algorithms) '_SNR_' num2str(SNR) '_Deviation_' num2str((deviation*180)/pi) '_nEvents_'  num2str(events) '.mat'])
                                clear V
                             
                            end
                        end
                    end
                end
             end
         end
     end
 end
 
 save([folderName filesep 'DoaPar_' folderName '.mat'], 'DoaPar');
 



                  
                       
        
