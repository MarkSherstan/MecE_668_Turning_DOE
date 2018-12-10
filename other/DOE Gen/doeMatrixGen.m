%% Define inputs
doe.factors = {'x-pos', 'y-pos', 'length', 'thickness', 'turn radius', 'road surf'};
FileName = 'Completed Experiments.csv';
% road surf: smooth concrete, tile, carpet
doe.levels = [-1 1];
doe.factStr = 'a b c d e f';
doe.runs = 16;
doe.res = 4;
numCenter = 3;

%% Create generators and construct DOE matrix
genStr = fracfactgen(doe.factStr,length(factor(doe.runs)),doe.res);
doe.mat = fracfact(genStr);
expNum = 1:(doe.runs+numCenter);

[rows,col] = size(doe.mat);
mattable = zeros(rows+numCenter,col+1);
mattable(:,1) = expNum';
mattable(1:doe.runs,2:end) = doe.mat;

%% Begin searching algorithem
k = 1;
completeExp = []; % iniciates a vector of completed experiments
firstLoad = 1; % indentifies whether the program has been run for the first time or is in a loop
redTable = mattable; % initiates a matrix equal to mattable. This table will be reduced
propMat = redTable; % initiates a matrix to act as a searchable database of experiments
while length(completeExp) < doe.runs+numCenter
    
    %% Evaluate this section if some experiments have already been completed
    %  and saved in file FileName
    if isfile(FileName) && firstLoad == 1
        completeExp = csvread(FileName);
        fprintf('Already completed experiments are: \n')
        
        for k = 1:length(completeExp)
            ind(k) = find(mattable(:,1) == completeExp(k));
        end
        
        redTable(ind,:) = [];

        fprintf('\nThe reduced experimental design table is: \n')
        disp(redTable)
        k = length(completeExp)+1;
        firstLoad = 0;
    end
    
    %% Begin user input secttion
    % A numberic input indicates a completed experiment to remove from
    % redTable matrix. 'testing' indicates the user wishes to search
    % through the set of incomplete experiments. A 0 indicates the user
    % wishes to exit the program.
    expInput = input('Input completed experiment numbers, ''testing'', or 0 to finish: ');
    
    if expInput == 0
        % When the user input is "0" this indicates the intend to save the
        % current state to FileName and exit the program.
        fprintf('The completed experiments are: \n')
        disp(completeExp)
        csvwrite(FileName,completeExp)
        break
        
    elseif strcmp(expInput,'testing')
        % Begin matrix searching algorithem
        % 'testing' input indicates the user wishes to search the
        % incomplete experiments for a specific set of factor levels.
        reduce = 1;
        propMat = redTable;
        
        while reduce == 1
            % reduce allows the user to continue to search through the set 
            % of incomplete experiments until they are satisfied. 
            fact = input('Enter factor of interest or 0 to finish: ');
            
            if fact == 0
                % Input of "0" indicates the user intends to exit the 
                % searching algorithem
                reduce = 0;
                k = k -1;
                break
            end
            
            levelStr = input('Enter level as ''high'' or ''low'': ');
            % Factors are identified based on length of the input while
            % levels are identified with a string comparison
            if strcmp(levelStr,'low')
                level = -1;
            else
                level = 1;
            end

            if length(fact)<=4
                
                if strcmp(fact,'xdir')
                    col = 2;
                else
                    col = 3;
                end

            elseif length(fact) == 6
                col = 4;
            elseif length(fact) == 9
                col = 5;
            elseif length(fact) == 11
                col = 6;
            else
                col = 7;
            end
            
            % Reduces propMatrix to include only experiments of interest 
            propExp = find(propMat(:,col) ~= level);
            propMat(propExp,:) = [];
            
            % Displays the relevant experiments for further reduction or
            % reference for setting up experiments
            clc
            fprintf('expNum  x-pos   y-pos   length   thickness   turn radius   road surf\n')
            fprintf('%d       %+d      %+d      %+d       %+d          %+d            %+d\n',propMat')
        end
        
    else
        % All input other than 0 or testing are evaluated here
        if ~isempty(intersect(expInput,completeExp))
            % Identifies the row index of expInput in completeExp
            disp('Error that experiment has been completed, enter a different experiment number')
            expInput = input('Input completed experiment numbers or 0 to finish: ');
            
            if expInput == 0
                % Saves the vector completeExp to FileName
                fprintf('The completed experiments are: \n')
                disp(completeExp)
                csvwrite(FileName,completeExp)
                break
            end
        end
        
        % Adds the user input to the end of completeExp and sorts the
        % vector in ascending order
        completeExp(k) = expInput;
        completeExp = sort(completeExp);
        
        % Finds and eliminates the row index of expInput indicating that
        % experiment has been completed.
        ind = find(expInput == redTable(:,1));
        redTable(ind,:) = [];
        
        % Displays the experiments which have yet to be completed. 
        clc
        fprintf('expNum  x-pos   y-pos   length   thickness   turn radius   road surf\n')
        fprintf('%d       %+d      %+d      %+d       %+d          %+d            %+d\n',redTable')
    end
    
    k = k+1;
end

