%filenameC = '../outputs/single_chirpC.bin';
%filenameIQ = '../outputs/single_chirpIQ.bin';
filenameC = '../outputs/adc_chirpC.bin';
filenameIQ = '../outputs/adc_chirpIQ.bin';


fileID_C = fopen(filenameC,'r');
fileID_IQ = fopen(filenameIQ,'r');
%fseek(fileID,2,'bof');
counter=fread(fileID_C,'uint32');
data = fread(fileID_IQ,'uint32');
size(counter)
size(data)
fclose(fileID_C);
fclose(fileID_IQ);

% Extract IQ data as signed 16 bit integers
data_iq = dec2hex(data);
I = double(typecast(uint16(hex2dec(data_iq(:,1:4))),'int16')); 
Q = double(typecast(uint16(hex2dec(data_iq(:,5:end))),'int16'));

% determine size and location of skips/drops
num_drops = counter(end)-counter(1)-numel(counter)+1;
counter_jumps = [];
for i=2:numel(counter)
    if (counter(i) ~= counter(i-1)+1)
        counter_jumps = [counter_jumps, i];
    end
end
counter_jumps = [counter_jumps, numel(counter)];

% Plot decoded counter
front_delay = 203; back_delay = 95; % samples that can be discarded

%chirpmin = 1; chirpmax = 5000; 
%chirpmin = counter_jumps(3); chirpmax = counter_jumps(4);
chirpmin = counter_jumps(3)+front_delay; chirpmax = counter_jumps(4)-back_delay;

figure; 
subplot(3,1,1); hold on; 
plot(counter); axis tight; title('Decoded 32 bit Counter');
y1=get(gca,'ylim'); x1 = [chirpmin,chirpmax];
line([x1;x1],[y1',y1'],'Color','r');hold off;
% Plot decoded data
subplot (3,1,2); plot(I(chirpmin:chirpmax)); 
axis tight; title('Decoded I'); 

subplot(3,1,3); plot(Q(chirpmin:chirpmax)); 
axis tight; title('Decoded Q');

% Plot a PSD with 90% Occupied BW of IQ data
Fs = 245.76e6;
x = I(chirpmin:chirpmax)+1i*Q(chirpmin:chirpmax);
figure; 
subplot(2,1,1); obw(real(x),Fs); 
title(['I Channel: ',get(get(gca,'title'),'string')]);

subplot(2,1,2);  obw(imag(x),Fs);
title(['Q Channel: ',get(get(gca,'title'),'string')]);

%figure; obw(x,Fs); title(['x = I+jQ: ',get(get(gca,'title'),'string')]);
%figure; plot(20*log10(abs(fftshift(fft(x))))); title('fft of I+i*Q');

% Plot complete data set with locations of counter jumps 
figure; 
subplot(3,1,1); hold on;
plot(counter); title('Counter jump/skip locations');
scatter(counter_jumps,counter(counter_jumps)); axis tight; hold off;

subplot (3,1,2); hold on; 
plot(I); title('Decoded I');
scatter(counter_jumps,I(counter_jumps)); axis tight; hold off;

subplot(3,1,3); hold on;
plot(Q); title('Decoded Q');
scatter(counter_jumps,Q(counter_jumps)); axis tight; hold off;

figure; hold on;
plot(I);plot(Q,'r');
title('I and Q Channels');legend('I','Q');axis tight; hold off;
