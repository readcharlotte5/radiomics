function getClusters(mapM, mClusters, seed, svdTag)
    
    set(0,'DefaultFigureVisible','off');

    figNum = mClusters - 1; 

    seed; 

    mapThis = cell(mClusters, 1); 

    mapM = mapM'; 

    clustM = kmeans(mapM', mClusters); 

    for m = 1:mClusters
        
        mapThis{m} = [mapM(:, clustM == m)]; 

    end

    mapM = [mapThis{1} mapThis{2:end}]; 

    mapM = mapM'; 

    fig = figure(figNum);
    imagesc(mapM); 
    colormap hot
    colorbar
    axis off
    axis square 
     

    if svdTag == 1
        title("SVD Patient Cluster of " + string(mClusters));
        clim([-1 1])
        titleM = "SVD Patient Cluster of " + string(mClusters) + ".tif"; 
    else
        titleM = "Patient Cluster of " + string(mClusters) + ".tif"; 
        clim([-2 2])
        title("Patient Cluster of " + string(mClusters));
    end

    %titleM = ["Patient Cluster of ", string(mClusters), ".tif"]; 
    %temp = ['/Users/breylonriley/Desktop/figures/figure ', num2str(f), '.tif'];
    %fig = figure(mClusters-1); 
    cd resultsBR; 
    
    saveas(fig, titleM); 
    cd ..

end