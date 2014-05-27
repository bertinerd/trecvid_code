function [list, numericList] = readList(listFile, onlyQueryFile)
% list = readList(listFile, onlyQueryFile)
%
% Read a list of images (i.e. retrieve.txt or matching_pairs.txt)
%
% - numel(list) returns the number of queries (or pairs)
% - numel(list{n}) returns the number of images contained in the query n (2
%   for simple pairs)
% - list{n}{i} gives the name of the image i of the query n
%
% If the optional onlyQueryFile is true the function reads only the first
% image of each rows.
%
% if listFile contains only numbers and numericListis requested in output
% then numericList will contain a cell of the same size of list but each
% element will be a vector of numeric values instead of a cell of strings

if ~exist(listFile, 'file')
    error(['File ' listFile ' not found']);
end

if nargin < 2
    onlyQueryFile = 0;
end

text = fileread(listFile);

if ~isempty(text)
    c = textscan(text, '%s', 'Delimiter', '\n', 'BufSize', 10000000);
    
    list = cell(size(c{1}));
    for i=1:numel(c{1})
        
        % Lettura della riga dell'annotazione
        texts = textscan(c{1}{i}, '%s', 'Delimiter', ' 	', 'BufSize', 65536);
        
        if onlyQueryFile
            list(i) = {texts{1}(1);};
        else
            list(i) = texts;
        end
    end
    
    % Per le semplici liste
    if size(list{1},1) == 1
        for i=1:numel(list)
            list(i) = list{i};
        end
    end
    
else
    list = {};
end

if nargout > 1
    
    numericList = cell(size(list));
    for i=1:numel(list)
        numericList{i} = str2double(list{i});
    end
    
end
    
return