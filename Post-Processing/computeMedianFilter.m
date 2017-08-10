%Compute the median of the values and predict the class labels based on
%median/mode of the values

function [y] = computeMedianFilter(predict_label, window_size)
%window_size = 10;
y = zeros(length(predict_label),1);
for i=1:length(predict_label)
    if i<=window_size
        y(i) = getClassLabelForMaxCount(predict_label(1:i),1,2);
    else
        y(i) = getClassLabelForMaxCount(predict_label((i-window_size):i),1,2);
    end   

end
end

function label = getClassLabelForMaxCount(x,label1,label2)
count_label1 = 0;
count_label2 = 0;
for j=1:length(x)
    if(x(j) == label1)
        count_label1 = count_label1+1;
    elseif(x(j) == label2)
        count_label2 = count_label2+1;
    end
end
if(count_label1 >= count_label2)
    label = label1;
else
    label = label2;
end    
end