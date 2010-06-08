function [avgHue,avgSat,avgInt] = calcAvgHSV(image)
        if size(image,3) == 3
            hsv = cvlib_mex('color',image,'rgb2hsv');
            means = mean(mean(hsv));
            avgHue = means(1);
            avgSat = means(2);
            avgInt = means(3);

        elseif size(image,3) == 1
            avgHue = 0;
            avgSat = 0;
            avgInt = mean(mean(image(:,:,1)));
        else
            % OR SOMETHING ELSE?
            avgHue = 0;
            avgSat = 0;
            avgInt = 0;
        end
end