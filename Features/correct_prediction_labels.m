%Incomplete function to correct the prediction labels based on the output
%numbers used for predicting the class accuracy.
function [output_label] = correct_prediction_labels(input_label, probability_distribution)
for i=2:length(input_label)
    %If there is a transition, check if the transition should happen or not
   if(input_label(i)~=input_label(i-1))
       
   end
       
end
end