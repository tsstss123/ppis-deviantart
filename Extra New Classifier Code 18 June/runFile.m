    % Experiment 1 Cognitive
    disp(['Experimento1']);
    names={'all'};
    experiments={
                  {'salEntropy',
                  'salMapCEntropy',
                  'salMapIEntropy',
                  'salMapOEntropy',
                  'salMapKEntropy',
                  'salHistDev',
                  'salPoints',
                  'salSkin'}
                };
    autoselect=0;
    optimalselect=0;
    
    R=ArtistExperiment('artists', names, experiments, autoselect, optimalselect);
    save('ExperimentDone/ExperimentallCognitive', 'R');
    
    % Experiment 1 Auto
    disp(['Experimento2']);
    names={'all'};
    experiments={
                  {'salEntropy',
                  'salMapCEntropy',
                  'salMapIEntropy',
                  'salMapOEntropy',
                  'salMapKEntropy',
                  'salHistDev',
                  'salPoints',
                  'salSkin'}
                };      
    autoselect=1;
    optimalselect=0;
    
    R=ArtistExperiment('artists', names, experiments, autoselect, optimalselect);
    save('ExperimentDone/ExperimentallCognitive_auto', 'R');    
    
    % Experiment 1 Statistic
    disp(['Experimento3']);
    names={'all'};
    experiments={
                  {'numFaces',
                  'intEntropy',
                  'intVariance',
                  'edgeRatio',
                  'gridEdgeRatio',
                  'medianHue',
                  'avgSat',
                  'avgInt',
                  'medHueCells',
                  'avgSatCells',                 
                  'avgIntCells',
                  'cornerRatio',
                  'cornerRatioGrid',
                  'avgR',
                  'avgG',
                  'avgB',
                  'avgRCells',
                  'avgGCells',
                  'avgBCells'}
                };      
    autoselect=0;
    optimalselect=0;
    
    R=ArtistExperiment('artists', names, experiments, autoselect, optimalselect);
    save('ExperimentDone/ExperimentallStatistic', 'R');
    
    % Experiment 1 Statistic auto
    disp(['Experimento4']);
    names={'all'};
    experiments={
                  {'numFaces',
                  'intEntropy',
                  'intVariance',
                  'edgeRatio',
                  'gridEdgeRatio',
                  'medianHue',
                  'avgSat',
                  'avgInt',
                  'medHueCells',
                  'avgSatCells',                 
                  'avgIntCells',
                  'cornerRatio',
                  'cornerRatioGrid',
                  'avgR',
                  'avgG',
                  'avgB',
                  'avgRCells',
                  'avgGCells',
                  'avgBCells'}
                };      
    autoselect=1;
    optimalselect=0;
    
    R=ArtistExperiment('artists', names, experiments, autoselect, optimalselect);
    save('ExperimentDone/ExperimentallStatistic_auto', 'R');    
    
    % Experiment 1 all Features Seperate
    disp(['Experimento5']);
    names={'all'};
    experiments={
                  {'numFaces'};
                  {'intEntropy'};
                  {'intVariance'};
                  {'edgeRatio'};
                  {'gridEdgeRatio'};
                  {'medianHue'};
                  {'avgSat'};
                  {'avgInt'};
                  {'medHueCells'};
                  {'avgSatCells'};                 
                  {'avgIntCells'};
                  {'cornerRatio'};
                  {'cornerRatioGrid'};
                  {'avgR'};
                  {'avgG'};
                  {'avgB'};
                  {'avgRCells'};
                  {'avgGCells'};
                  {'avgBCells'};
                  {'salEntropy'};
                  {'salMapCEntropy'};
                  {'salMapIEntropy'};
                  {'salMapOEntropy'};
                  {'salMapKEntropy'};
                  {'salHistDev'};
                  {'salPoints'};
                  {'salSkin'};
                };      
    autoselect=0;
    optimalselect=0;
    
    R=ArtistExperiment('artists', names, experiments, autoselect, optimalselect);
    save('ExperimentDone/ExperimentSeperate', 'R');    
    
    % Some All Artist Tests
    
    % Experiment 2
    disp(['Experimento6']);
    names={'all'};
    experiments={{'all'}};
    autoselect=0;
    optimalselect=0;
    
    R=ArtistExperiment('artists', names, experiments, autoselect, optimalselect);
    save('ExperimentDone/Experiment_all_no_auto', 'R');
    
    % Experiment 3
    disp(['Experimento7']);
    names={'all'};
    experiments={{'all'}};
    autoselect=1;
    optimalselect=0;
    
    R=ArtistExperiment('artists', names, experiments, autoselect, optimalselect);
    save('ExperimentDone/Experiment_all_auto_optimal', 'R');    
    
    % Experiment 5
    disp(['Experimento8']);
    names={'all'};
    experiments={{'all'}};
    autoselect=1;
    optimalselect=3;
    
    R=ArtistExperiment('artists', names, experiments, autoselect, optimalselect);
    save('ExperimentDone/Experiment_all_auto_3', 'R');    
    
    % Experiment 6
    disp(['Experimento9']);
    names={'all'};
    experiments={{'all'}};
    autoselect=1;
    optimalselect=2;
    
    R=ArtistExperiment('artists', names, experiments, autoselect, optimalselect);
    save('ExperimentDone/Experiment_all_auto_2', 'R');
    
    % Personal Combo
    disp(['Experimento10']);
    names={'all'};
    experiments={{'intEntropy',
                  'intVariance'}};
    autoselect=0;
    optimalselect=0;
    
    R=ArtistExperiment('artists', names, experiments, autoselect, optimalselect);
    save('ExperimentDone/Experiment_entropy_variance', 'R');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Experiment 1 Cognitive
    disp(['Experimento11']);
    names={'all'};
    experiments={
                  {'salEntropy',
                  'salMapCEntropy',
                  'salMapIEntropy',
                  'salMapOEntropy',
                  'salMapKEntropy',
                  'salHistDev',
                  'salPoints',
                  'salSkin'}
                };      
    autoselect=0;
    optimalselect=0;
    
    R=ArtistExperiment('category1', names, experiments, autoselect, optimalselect);
    save('ExperimentDone/ExperimentallCognitive_cats', 'R')
    
    % Experiment 1 Auto
    disp(['Experimento12']);
    names={'all'};
    experiments={
                  {'salEntropy',
                  'salMapCEntropy',
                  'salMapIEntropy',
                  'salMapOEntropy',
                  'salMapKEntropy',
                  'salHistDev',
                  'salPoints',
                  'salSkin'}
                };      
    autoselect=1;
    optimalselect=0;
    
    R=ArtistExperiment('category1', names, experiments, autoselect, optimalselect);
    save('ExperimentDone/ExperimentallCognitive_auto_cats', 'R');    
    
    % Experiment 1 Statistic
    disp(['Experimento13']);
    names={'all'};
    experiments={
                  {'numFaces',
                  'intEntropy',
                  'intVariance',
                  'edgeRatio',
                  'gridEdgeRatio',
                  'medianHue',
                  'avgSat',
                  'avgInt',
                  'medHueCells',
                  'avgSatCells',                 
                  'avgIntCells',
                  'cornerRatio',
                  'cornerRatioGrid',
                  'avgR',
                  'avgG',
                  'avgB',
                  'avgRCells',
                  'avgGCells',
                  'avgBCells'}
                };      
    autoselect=0;
    optimalselect=0;
    
    R=ArtistExperiment('category1', names, experiments, autoselect, optimalselect);
    save('ExperimentDone/ExperimentallStatistic_cats', 'R');   
    
    % Experiment 1 Statistic auto
    disp(['Experimento14']);
    names={'all'};
    experiments={
                  {'numFaces',
                  'intEntropy',
                  'intVariance',
                  'edgeRatio',
                  'gridEdgeRatio',
                  'medianHue',
                  'avgSat',
                  'avgInt',
                  'medHueCells',
                  'avgSatCells',                 
                  'avgIntCells',
                  'cornerRatio',
                  'cornerRatioGrid',
                  'avgR',
                  'avgG',
                  'avgB',
                  'avgRCells',
                  'avgGCells',
                  'avgBCells'}
                };      
    autoselect=1;
    optimalselect=0;
    
    R=ArtistExperiment('category1', names, experiments, autoselect, optimalselect);
    save('ExperimentDone/ExperimentallStatistic_auto_cats', 'R');  
    
    % Experiment 1 all Features Seperate
    disp(['Experimento15']);
    names={'all'};
    experiments={
                  {'numFaces'};
                  {'intEntropy'};
                  {'intVariance'};
                  {'edgeRatio'};
                  {'gridEdgeRatio'};
                  {'medianHue'};
                  {'avgSat'};
                  {'avgInt'};
                  {'medHueCells'};
                  {'avgSatCells'};                 
                  {'avgIntCells'};
                  {'cornerRatio'};
                  {'cornerRatioGrid'};
                  {'avgR'};
                  {'avgG'};
                  {'avgB'};
                  {'avgRCells'};
                  {'avgGCells'};
                  {'avgBCells'};
                  {'salEntropy'};
                  {'salMapCEntropy'};
                  {'salMapIEntropy'};
                  {'salMapOEntropy'};
                  {'salMapKEntropy'};
                  {'salHistDev'};
                  {'salPoints'};
                  {'salSkin'};
                };      
    autoselect=0;
    optimalselect=0;
    
    R=ArtistExperiment('category1', names, experiments, autoselect, optimalselect);
    save('ExperimentDone/ExperimentSeperate_cats', 'R');   
    
    % Experiment 2
    disp(['Experimento16']);
    names={'all'};
    experiments={{'all'}};
    autoselect=0;
    optimalselect=0;
    
    R=ArtistExperiment('category1', names, experiments, autoselect, optimalselect);
    save('ExperimentDone/Experiment_all_no_auto_cats', 'R');
    
    % Experiment 2
    disp(['Experimento17']);
    names={'all'};
    experiments={{'all'}};
    autoselect=1;
    optimalselect=0;
    
    R=ArtistExperiment('category1', names, experiments, autoselect, optimalselect);
    save('ExperimentDone/Experiment_all_auto_optimal_cats', 'R');    