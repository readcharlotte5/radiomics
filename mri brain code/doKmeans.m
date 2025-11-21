function doKmeans(featMatrix, minCluster, nClusters)
    
    set(0,'DefaultFigureVisible','off');
 
    mClusters = (minCluster+1):nClusters; 

    fig = figure(1); 
    imagesc(featMatrix); 
    colormap hot
    colorbar 
    axis off
    axis square 

    if(size(featMatrix, 2) > 100)
        clim([-1 1])
        title("Z-score Distribution of Feature Matrix");
        titleM = ['Z-score Distribution of Feature Matrix', '.tif'];
    else
        clim([-2 2])
        title("Z-score Distribution of SVD Feature Matrix");
        titleM = ['Z-score Distribution of SVD Feature Matrix', '.tif'];
    end
     
    %temp = ['/Users/breylonriley/Desktop/figures/figure ', num2str(f), '.tif'];
    
    cd resultsBR;
    saveas(fig, titleM); 
    cd ../

    %%

    seed = rng(1);    
    clusterM = kmeans(featMatrix', minCluster); 
    mapM = cell(minCluster, 1); 

    for c = 1:minCluster 
        
        mapM{c} = [featMatrix(:, clusterM == c)]; 

    end

    mapM = [mapM{1} mapM{2:end}]; 

    fig = figure(2); 
    imagesc(mapM); 
    
    colormap hot
    colorbar
    axis off
    axis square 
    
    cd resultsBR

    if(size(featMatrix,2) < 10 )
        title("SVD Met Cluster of 3");
        clim([-1 1])
        titleM = ['SVD Met Cluster of 3', '.tif']; 
        svdTag = 1;
    else 
        title("Met Cluster of 3");
        clim([-2 2])
        titleM = ['Met Cluster of 3', '.tif']; 
        svdTag = 0;
    end

    saveas(fig, titleM); 
    cd ..

    %%
    
    for m = 1:length(mClusters)

            getClusters(mapM, mClusters(m), seed, svdTag); 

    end

%     
%     mapM = mapM'; 
% 
%     clustM = kmeans(mapM', 4); 
% 
%     mapM = [mapM(:, find(clustM == 1))...
%             mapM(:, find(clustM == 2))...
%             mapM(:, find(clustM == 3))...
%             mapM(:, find(clustM == 4))]; 
% 
%     mapM = mapM';
% 
%     figure(3)
%     imagesc(mapM); 
%     clim([-2 2])
%     colormap hot
%     colorbar
%     axis off
%     axis square 
%     
%     %%
% 
%         mapM = mapM'; 
% 
%     clustrM = kmeans(mapM', 5); 
% 
%     mapM = [mapM(:, find(clustrM == 1))...
%             mapM(:, find(clustrM == 2))...
%             mapM(:, find(clustrM == 3))...
%             mapM(:, find(clustrM == 4))...
%             mapM(:, find(clustrM == 5))]; 
% 
%     mapM = mapM';
% 
%     figure(4)
%     imagesc(mapM); 
%     clim([-2 2])
%     colormap hot
%     colorbar
%     axis off
%     axis square 
% 
%     %%
% 
%     mapM = mapM'; 
% 
%     clustrM2 = kmeans(mapM', 6); 
% 
%     mapM = [mapM(:, find(clustrM2 == 1))...
%             mapM(:, find(clustrM2 == 2))...
%             mapM(:, find(clustrM2 == 3))...
%             mapM(:, find(clustrM2 == 4))...
%             mapM(:, find(clustrM2 == 5))...
%             mapM(:, find(clustrM2 == 6))]; 
% 
%     mapM = mapM';
% 
%     figure(5)
%     imagesc(mapM); 
%     clim([-2 2])
%     colormap hot
%     colorbar
%     axis off
%     axis square
    
    %SVD , pull out first 5 of right/left matrix (singular) and do 
    %calc percentage of patients in each cluster
    %check association between pts+#ofmets+clusters
    
end