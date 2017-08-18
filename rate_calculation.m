function [T_x,T_y,T_z] = rate_calculation(SNR,nSamples,theta,nArrayElements,nAlgorithm,nEvents,nSources,DifferenceDrop,DifferenceDeviation)
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
%% --- Code ---
% --- Samples ---
n = 0:nSamples-1;                               % Number of samples
% --- Evaluation of T metric ---
if nAlgorithm == 1    
    T_x = zeros(1,nEvents);                     % Sucess Rate
    T_y = zeros(1,nEvents);                     % Wrong angle Error Rate
    T_z = zeros(1,nEvents);                     % Number of sources Error Rate
    
    %DifferenceDrop = 2;
    for ll = 1:nEvents        
        %% --- Recalculating Music at each event ---
        signal = cos(theta*pi*n);                   % Defining the signal
        % --- Received Sigal ---
        noise = signal + awgn(signal,SNR);          % Signal with additive noise
        
        X = corrmtx(noise,nArrayElements);      % Matrix for autocorrelation matrix estimation
        [S_pow, w] = pmusic(X,2);               % Music Algorithm
        S_db = pow2db(S_pow);
        
        %% --- Parameters for search
        theta_w = theta * pi;                   % Normalized value
        %DifferenceDeviation =  pi/60;                     % Deviation is 6 degres
        
        % --- Function to find peaks in the spectrum ---
        [x,y] = findpeaks(S_db,w,'MinPeakProminence',DifferenceDrop);
        
        % --- Increasing rate value ---
        
        if(size(x) == nSources)
            if((y > theta_w-DifferenceDeviation) && (y <= theta_w+DifferenceDeviation)) 
                T_x(ll) = T_x(ll) + 1;  % Right angle and number of sources
                disp(['Events - ' num2str(ll) ' - Right angle and number of sources Detection = ' num2str(sum(T_x)) ])
            else
                T_y(ll) = T_y(ll) + 1;  % Right number of sources and wrong angle
                disp(['Events - ' num2str(ll) ' - Right number of sources and wrong angle Detection = ' num2str(sum(T_y)) ])
            end
        else
            T_z(ll) = T_z(ll) + 1;      % Wrong number of sources
            disp(['Events - ' num2str(nEvents) ' - Wrong number of sources = ' num2str(sum(T_z)) ])
        end
    end
end

disp(['  Total Right angle and number of sources Detection = ' num2str((sum(T_x)/nEvents)*100) '%' ])
disp(['  Total Right number of sources and wrong angle Detection = ' num2str((sum(T_y)/nEvents)*100) '%' ])
disp(['  Toral Wrong number of sources = ' num2str((sum(T_z)/nEvents)*100) '%' ])
end

