
function y = conv_stereo(a, b);

% y = conv_stereo(a, b)
% Convolution with stereo input(s)

if size(a,2)==2
    % signal a is stereo
    if size(b,2) == 2 
         % signal b is stereo
         yL = conv(a(:,1), b(:,1));
         yR = conv(a(:,2), b(:,2));
    else
        % signal b is mono
        yL = conv(a(:,1), b);
        yR = conv(a(:,2), b);
    end
elseif size(b,2)==2
    % signal b is stereo
    yL = conv(a, b(:,1));
    yR = conv(a, b(:,2));
end

y = [yL yR];