function osFuncDependencies(function_path)

% Adopted from https://www.mathworks.com/matlabcentral/answers/216500-how-to-show-the-inputs-to-a-function-from-within
% function_path: the full path of the function m file
% Ex: fsysDisplayInputs('C:\Users\qluu\Downloads\Dropbox\Trung\3_Workspace\cplex_matlab\carp\fCalCapacity.m')


[flist, plist] = matlab.codetools.requiredFilesAndProducts(function_path);
% flist: cell array: all internal functions with full path
% plist: struct data (.Name, .Version, .ProductNumber, .Certain): all used programs

nfun = length(flist);
fname = strings;

for i = 1:nfun
    dash_id = find(flist{i} == '\');
    fname(i) = extractAfter(flist{i}, dash_id(end));
end


for i = 1:nfun
    fprintf('(%d) %s\n', i, fname{i}); 
    
    % Obtain inputs of each function
    code = fileread(flist{i});
    [~, func_name] = fileparts(flist{i});
    argin = regexp(code, sprintf('(?<=function.*?%s\\s*\\(\\s*)[a-zA-Z0-9_]+(?:\\s*,\\s*[a-zA-Z0-9_]+)*(?=\\s*\\))', ...
                 func_name), 'match', 'once');
             
             
    argout = regexp(code, sprintf('(?>function.*?%s\\s*\\(\\s*)[a-zA-Z0-9_]+(?:\\s*,\\s*[a-zA-Z0-9_]+)*(?=\\s*\\))', func_name), 'match', 'once');
    argout = extractBetween(argout, 'function', '=');
    
    if ~isempty(argout)
        argout = argout{1};
        if contains(argout, '[')
            argout(argout == '[') = '';
            argout(argout == ']') = '';
        end
        argout = strsplit(argout, ',');
    end
    
    argin = strsplit(argin, ',');
    
    % fprintf('\n%s was called with the following inputs:\n', func_name);
    if ~isempty(argin{1})
        fprintf('\tinput: ');
        for j = 1:length(argin)-1
            fprintf('%s,', argin{j});
        end
        fprintf('%s\n', argin{end});
    end
    
    if ~isempty(argout)
        fprintf('\toutput: ');
        for j = 1:length(argout)-1
            fprintf('%s,', argout{j});
        end
        fprintf('%s\n', argout{end});
    end
end
    



    
end