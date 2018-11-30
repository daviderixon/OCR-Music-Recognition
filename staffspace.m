function [HalfNoteHeight, NumStaffSegs, peaks] = staffspace(grayimg)
    % Pre-Processing
    BW = grayimg > graythresh(grayimg);
    SE_horline = strel('line', 20, 0);
    BW = imopen(BW, SE_horline);
    SE_rectum = strel('rectangle', [3,15]);
    BW2 = imopen(BW, SE_rectum);
    BW = BW - BW2;
    
    % Horizontal Projection
    HorizontalSum = sum(BW, 2);
    HorizontalSumSmooth = smoothdata(HorizontalSum,'movmean', length(HorizontalSum)/12);
    [pks] = findpeaks(HorizontalSumSmooth);
    NumStaffSegs = length(pks);
    NumStaffLines = NumStaffSegs*5;
    
    % Select the number of peaks we have staff lines and store in "peaks"
    [pks, locs] = findpeaks(HorizontalSum);
    pks_sorted = sort(pks, 'descend');
    map = pks>=pks_sorted(NumStaffLines);
    locs_result = locs .* map;
    peaks = locs_result(locs_result ~= 0);
    
    % Calculate average distance for a half note from first segment
    HalfNoteHeight = ((peaks(5,1) - peaks(1,1)))/8;
    
end