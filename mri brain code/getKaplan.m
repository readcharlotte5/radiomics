function [pVals, figs, stats] = getKaplan(avgMatrix) 

    KMs = size(avgMatrix,2);

    set(0,'DefaultFigureVisible','off');

    figs = cell(KMs, 1); 
    stats = figs; 
    pVals = zeros(KMs, 1); 
    caught = pVals; 
    for k = 1:KMs 
        try
            [pVals(k), figs{k}, stats{k}] = MatSurv(pfs, outcomes, avgMatrix(:,k)); 

        catch
            caught(k) = k; 
            k = k+1;
        end

    end

end
