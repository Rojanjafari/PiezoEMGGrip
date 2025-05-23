% Simulation Parameters
Fs = 1000;        % Sampling frequency (Hz)
t = 0:1/Fs:10;    % Time vector (10 seconds)

% Piezoelectric Sensor Signal
grip_force = 0.00001 + 0.000005 * sin(2*pi*0.5*t);  % Varying grip force
frequency_piezo = 5 + 5 * sin(2*pi*0.2*t);  % Frequency varies with time
amplitude_piezo = grip_force;             % Amplitude of piezoelectric signal

% Piezoelectric Sensor Signal (Sine Wave with variable amplitude and frequency)
piezo_signal = amplitude_piezo .* sin(2*pi*frequency_piezo .* t);

% Add noise to the Piezoelectric signal (Gaussian white noise)
noise_piezo = 0.000001 * randn(size(piezo_signal));  % Add noise with amplitude 0.05
piezo_signal_noisy = piezo_signal + noise_piezo;

% Add distortion to the Piezoelectric signal (nonlinear distortion)
distortion_piezo = 0.000003 * (piezo_signal_noisy).^3;  % Nonlinear distortion (cube the signal)
piezo_signal_distorted = piezo_signal_noisy + distortion_piezo;

% Surface EMG Signal (rest and action)
rest_duration = 3;  % Time during rest (seconds)
action_duration = 7; % Time during action (seconds)

% Generate the EMG signal for the rest and action periods
emg_rest = 3 * sin(2*pi*50*(0:1/Fs:rest_duration-1/Fs));  % Rest period (low activity)
emg_action = 15 * sin(2*pi*50*(0:1/Fs:action_duration-1/Fs));  % Action period (high activity)
emg_signal = [emg_rest, emg_action];  % Combine rest and action signals

% Create a time vector for the EMG signal that matches its length
t_emg = 0:1/Fs:(length(emg_signal)-1)/Fs;

% Add noise to the EMG signal (Gaussian white noise)
noise_emg = 0.2 * randn(size(emg_signal));  % Add noise with amplitude 0.02
emg_signal_noisy = emg_signal + noise_emg;

% Add distortion to the EMG signal (nonlinear distortion)
distortion_emg = 0.2 * (emg_signal_noisy).^2;  % Nonlinear distortion (square the signal)
emg_signal_distorted = emg_signal_noisy + distortion_emg;

% Plot the signals
figure;

subplot(2,1,1);
plot(t, piezo_signal_distorted);
title('Piezoelectric Sensor Signal with Noise and Distortion');
xlabel('Time (s)');
ylabel('Amplitude (V)');

subplot(2,1,2);
plot(t_emg, emg_signal_distorted);  % Use the correct time vector for EMG
title('Surface EMG Signal with Noise and Distortion');
xlabel('Time (s)');
ylabel('Amplitude (V)');

% Save the signals to a file for simulation in Proteus or PSpice
piezoelectric_data = [t', piezo_signal_distorted'];
emg_data = [t_emg', emg_signal_distorted'];
writematrix(piezoelectric_data, 'piezoelectric_signal.txt');
writematrix(emg_data, 'emg_signal.txt');
