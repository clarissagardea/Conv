% Limpieza del espacio de trabajo
clc; clear; close all;

% Generación de señales
signal1 = [0.5, -1.2, 0.8]; % Señal fija con 3 coeficientes
signal2 = rand(1, 50) * 2 - 1; % Señal variable con 50 muestras en [-1, 1]

% Realización de la convolución
conv_result = conv(signal1, signal2);

% Cálculo del rango dinámico
dynamic_range = 20 * log10(max(abs(conv_result)) / min(abs(conv_result(conv_result~=0))));

% Cálculo dinámico de q_i y q_f
N = 16; % Total de bits para la representación

% Signal 1
max_val_signal1 = max(abs(signal1));
q_i_signal1 = ceil(log2(max_val_signal1)); % Bits para la parte entera
q_f_signal1 = N - q_i_signal1 - 1; % Bits para la parte fraccional

% Signal 2
max_val_signal2 = max(abs(signal2));
q_i_signal2 = ceil(log2(max_val_signal2)); % Bits para la parte entera
q_f_signal2 = N - q_i_signal2 - 1; % Bits para la parte fraccional

% Resultado de la Convolución
max_val_conv_result = max(abs(conv_result));
q_i_conv = ceil(log2(max_val_conv_result)); % Bits para la parte entera
q_f_conv = N - q_i_conv - 1; % Bits para la parte fraccional

% Cambio a punto fijo
scale_factor = 2^q_f_signal1;
signal1_fixed = round(signal1 * scale_factor) / scale_factor;

scale_factor = 2^q_f_signal2;
signal2_fixed = round(signal2 * scale_factor) / scale_factor;

conv_fixed = conv(signal1_fixed, signal2_fixed);

% Garantizar que el SQNR sea mayor a 50 dB
noise = conv_result - conv_fixed;
sqnr = 20 * log10(norm(conv_result) / norm(noise));
assert(sqnr > 50, 'El SQNR no supera los 50 dB, ajusta los parámetros.');

% Generar archivo .txt con TODOS los datos
fileID = fopen('convolucion_resultados_completos.txt', 'w');
fprintf(fileID, 'DATOS COMPLETOS DE LA CONVOLUCIÓN\n\n');

% Escribir señales originales
fprintf(fileID, 'Señal 1 (original, 3 coeficientes):\n');
fprintf(fileID, '%s\n', mat2str(signal1));
fprintf(fileID, 'q_i = %d, q_f = %d\n', q_i_signal1, q_f_signal1);

fprintf(fileID, '\nSeñal 2 (original, 50 muestras):\n');
fprintf(fileID, '%s\n', mat2str(signal2));
fprintf(fileID, 'q_i = %d, q_f = %d\n', q_i_signal2, q_f_signal2);

% Escribir señales en punto fijo
fprintf(fileID, '\nSeñal 1 (punto fijo):\n');
fprintf(fileID, '%s\n', mat2str(signal1_fixed));

fprintf(fileID, '\nSeñal 2 (punto fijo, 50 muestras):\n');
fprintf(fileID, '%s\n', mat2str(signal2_fixed));

% Resultados de la convolución
fprintf(fileID, '\nResultados de la Convolución:\n');
fprintf(fileID, 'Resultado Original:\n');
fprintf(fileID, '%s\n', mat2str(conv_result));
fprintf(fileID, 'q_i = %d, q_f = %d\n', q_i_conv, q_f_conv);

fprintf(fileID, '\nResultado Punto Fijo:\n');
fprintf(fileID, '%s\n', mat2str(conv_fixed));

% Parámetros adicionales
fprintf(fileID, '\nParámetros Adicionales:\n');
fprintf(fileID, 'Rango Dinámico: %.2f dB\n', dynamic_range);
fprintf(fileID, 'SQNR: %.2f dB\n', sqnr);

fclose(fileID);

% Mostrar mensaje de éxito
disp('La convolución y sus resultados completos se han guardado en "convolucion_resultados_completos.txt".');
