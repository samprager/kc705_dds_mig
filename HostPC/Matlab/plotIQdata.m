filename = '../outputs/single_chirp.bin'; bitformat = 'uint32';
%filename = '../outputs/adc_chirp.bin'; bitformat = 'uint32';
%filename = '../outputs/chirp_shifted.bin'; bitformat = 'uint32';
%filename = '../C/Listener/outdata.bin'; bitformat = 'uint32';
byteoffset = 0;
packetsize = 496;
headersize = 16;
if (strcmp(bitformat,'uint8')||strcmp(bitformat,'int8'))
    bytesperword = 1;
elseif (strcmp(bitformat,'uint16')||strcmp(bitformat,'int16'))
    bytesperword = 2;
elseif (strcmp(bitformat,'uint32')||strcmp(bitformat,'int32'))
    bytesperword = 4;
end
fileID = fopen(filename,'r');
fseek(fileID,byteoffset,'bof');
A=fread(fileID,bitformat);
fclose(fileID);
size(A)
numbytes = (packetsize-headersize)/bytesperword;
format long;

% find beginning of first 512 bit sub-packet
subp_found = 0; 
ind = 1;

% First case: counter is upper 32 bits of each 64 bit word
if A(1) == A(2*8-1)+7
    subp_found = 1;
    ind = 1;
else
    subp_found = 0; ind = 3;
    while (subp_found ==0 && ind <= 64/bytesperword)
        temp = A(ind);
        if ((A(ind) ~= A(ind-2)-1)&&(A(ind+2) == A(ind)-1))
            subp_found = 1;
        else
            ind = ind+2;
        end
    end
end

% counter offset supports counter in either lower or upper 32b of 64b word 
if (subp_found == 1)
    counter_offset = 0;
% Second case: counter is lower 32 bits of each 64 bit word    
else 
    counter_offset = 1;
    if A(2) == A(2*8)+7
        subp_found = 1;
        ind = 2;
    else 
        subp_found = 0;
        ind = 4;
        while (subp_found ==0 && ind <= 64/bytesperword)
            temp = A(ind);
            if ((A(ind) ~= A(ind-2)-1)&&(A(ind+2) == A(ind)-1))
                subp_found = 1;
            else
                ind = ind+2;
            end
        end
    end
end

% get rid of partial sub-packets at beginning
A_round = A(ind-counter_offset:end);
% now get rid of partial sub-packets at end -- assume 512b sub-packets
shave_end = mod(numel(A_round),64/(bytesperword));

% divide 64 bit words into 32 bit counter and 32 bit samples
data = A_round(2-counter_offset:2:end-shave_end-counter_offset);
counter = A_round(1+counter_offset:2:end-shave_end-1+counter_offset);

% ordering correction: reshape sub-packets to be sequential
counter = reshape(flipud(reshape(counter(1:end),8*(8/(2*bytesperword)),[])),[],1);
data = reshape(flipud(reshape(data(1:end),8*(8/(2*bytesperword)),[])),[],1);

% Add sub-packets to data -- currently unused. Due to current byte ordering
% inclusion of sub-packets causes jump discontinuities 

% % Create vectors for partial sub-packets at front and back of transmission
% Apart_front = []; 
% Apart_back = [];
% 
% % Require at least 2 32b words in front
% if (ind-counter_offset > 2)
%     Apart_front = A(1:ind-counter_offset-1);
%     if (mod(numel(Apart_front),2) == 1)
%         Apart_front = Apart_front(2:end);
%     end
% end
% 
% % Require at least 2 32b words at end
% if (shave_end>1)
%     Apart_back = A(end-shave_end+1:end);
%     if (mod(numel(Apart_back),2)==1)
%         Apart_back = Apart_back(1:end-1);
%     end
% end
% counter_front = flipud(Apart_front(1+counter_offset:2:end));
% data_front = flipud(Apart_front(2-counter_offset:2:end));
% counter_back = flipud(Apart_back(1+counter_offset:2:end));
% data_back = flipud(Apart_back(2-counter_offset:2:end));
% 
% counter = [counter_front;counter;counter_back];
% data = [data_front;data;data_back];


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
%chirpmin = 1; chirpmax = 5000; 
chirpmin = counter_jumps(1); chirpmax = counter_jumps(2);

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
