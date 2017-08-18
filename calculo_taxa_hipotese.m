%% --- Parametros ---
SNR = -10;
nSamples = 200;
theta = 0.257;
nArrayElements = 10;    %not change
nAlgorithm = 1; %not change
nEvents = 1000; %not change
nSources = 1;   %not change
DifferenceDrop = 2; %not change
DifferenceDeviation = pi/60;
%% --- Code ---
% --- Samples ---
n = 0:nSamples-1;                               % Number of samples
% --- Evaluation of T metric ---
if nAlgorithm == 1    
    T_x = zeros(1,nEvents);                     % Sucess Rate
    T_y = zeros(1,nEvents);                     % Wrong angle Error Rate
    T_z = zeros(1,nEvents);                     % Number of sources Error Rate
    
    DifferenceDrop = 2;
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
        deviation =  pi/60;                     % Deviation is 6 degres
        
        % --- Function to find peaks in the spectrum ---
        [x,y] = findpeaks(S_db,w,'MinPeakProminence',2);
        
        % --- Increasing rate value ---
        
        if(size(x) == nSources)
            if((y > theta_w-deviation) && (y <= theta_w+deviation)) 
                T_x(ll) = T_x(ll) + 1;  % Right angle and number of sources
            else
                T_y(ll) = T_y(ll) + 1;  % Right number of sources and wrong angle
            end
        else
            T_z(ll) = T_z(ll) + 1;      % Wrong number of sources
        end
    end
end

disp(['Events - ' num2str(nEvents) ' - Right angle and number of sources Detection = ' num2str(sum(T_x)) ])
disp(['Events - ' num2str(nEvents) ' - Right number of sources and wrong angle Detection = ' num2str(sum(T_y)) ])
disp(['Events - ' num2str(nEvents) ' - Wrong number of sources = ' num2str(sum(T_z)) ])

                     

