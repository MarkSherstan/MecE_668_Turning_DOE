doe.factors = {'x-pos', 'y-pos', 'length', 'thickness', 'turn radius', 'road surf'};
%road surf: smooth concrete, tile, carpet
doe.levels = [-1 1];
doe.factStr = 'a b c d e f';
doe.runs = 16;
doe.res = 4;
numCenter = 3;

genStr = fracfactgen(doe.factStr,length(factor(doe.runs)),doe.res);
doe.mat = fracfact(genStr);
expNum = 1:(doe.runs+numCenter);

[rows,col] = size(doe.mat);
mattable = zeros(rows+numCenter,col+1);
mattable(:,1) = expNum';
mattable(1:doe.runs,2:end) = doe.mat;

k = 1;
completeExp = [];
firstLoad = 1;
redTable = mattable;
propMat = redTable;
while length(completeExp) < doe.runs+numCenter
    
    if isfile('Completed Experiments.csv') && firstLoad == 1
        completeExp = csvread('Completed Experiments.csv');
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
    
    expInput = input('Input completed experiment numbers, ''testing'', or 0 to finish: ');
    
    if expInput == 0
        
        fprintf('The completed experiments are: \n')
        disp(completeExp)
        csvwrite('Completed Experiments.csv',completeExp)
        break
        
    elseif strcmp(expInput,'testing')
        
        reduce = 1;
        propMat = redTable;
        
        while reduce == 1
%             fprintf('The possible factors are: \n')
%             fprintf('
            fact = input('Enter factor of interest or 0 to finish: ');
            
            if fact == 0
                reduce = 0;
                k = k -1;
                break
            end
            
            levelStr = input('Enter level as ''high'' or ''low'': ');
            
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

            propExp = find(propMat(:,col) ~= level);
            propMat(propExp,:) = [];
            clc
            fprintf('expNum  x-pos   y-pos   length   thickness   turn radius   road surf\n')
            fprintf('%d       %+d      %+d      %+d       %+d          %+d            %+d\n',propMat')
        end
        
    else
        
        if ~isempty(intersect(expInput,completeExp))
            
            disp('Error that experiment has been completed, enter a different experiment number')
            expInput = input('Input completed experiment numbers or 0 to finish: ');
            
            if expInput == 0
                
                fprintf('The completed experiments are: \n')
                disp(completeExp)
                csvwrite('Completed Experiments.csv',completeExp)
                break
            end
        end
        
        completeExp(k) = expInput;
        completeExp = sort(completeExp);
        
        ind = find(expInput == redTable(:,1));
        redTable(ind,:) = [];
        clc
        fprintf('expNum  x-pos   y-pos   length   thickness   turn radius   road surf\n')
        fprintf('%d       %+d      %+d      %+d       %+d          %+d            %+d\n',redTable')
    end
    
    k = k+1;
end

