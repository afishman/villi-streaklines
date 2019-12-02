classdef FrameInterpolator < handle
    % classdef FrameInterpolator < handle
    % Temporally and spatially interpolate sim data
    % Frames are interpolated in order of their file name frame<#>.mat (e.g. frame0.mat)
    
    % Caches frames from a dataset to speedup loading
    properties
        cacheSize         % Max number of frames cached
        method            % Interplation method, 'linear', 'spline', ... (see interp3)
        timeDelta         % Time between frames
        refFrame          % Reference frame
        matDir            % Directory of mat files
        loopSpan          % [tMin, tMax] indicating loop start/end times. Defaults to span the full dataset
        looping           % Flag indicating if looping is active
    end
    
    properties(SetAccess=private)
        frames            % Cached Frames
        frameFiles        % Paths to frames
        frameLoadHistory  % History of loaded frames
    end
    
    methods
        function obj = FrameInterpolator(matDir, cacheSize, loopSpan)
            % function obj = FrameInterpolator(matDir, cacheSize, loopSpan)
            % INPUT
            %  matDir [] Directory of mat files (named frame<i>.mat)
            %  cacheSize [] Maximum number of frames cached at any one time
            %  loopSpan [] Loop Span
            %
            % OUTPUT
            %   [] FrameInterpolator instance
            %
            
            matDir = addTrailingSlash(matDir);
            obj.matDir = matDir;
            
            obj.method = 'linear';
            
            if ~exist('cacheSize', 'var')
                cacheSize = 20; % default cache size
            end
            obj.cacheSize = cacheSize;
            
            % Check for metadata file in matDir
            obj.timeDelta = 1;
            
            try
                metadata = load([matDir, 'metadata.mat']);
                obj.timeDelta = metadata.timeDelta;
            catch err
                % Hacky and halfway    
                simJsonPath = [matDir, 'sim.json'];
                if exist(simJsonPath, 'file')                    
                    text = fileread(simJsonPath);
                    json = jsondecode(text);
                    obj.timeDelta = json.step_size*json.delta;
                else
                    
                    warning(err.message)
                    warning('Failed to read metadata.mat for sim. Assuming timeDelta=%.2f', obj.timeDelta)
                end
            end
            
            % Sort frame files
            obj.frameFiles = listFiles(matDir, '*.mat');
            for i=length(obj.frameFiles):-1:1
                [~, name, ~] = fileparts(obj.frameFiles{i});
                if strcmp(name, 'metadata')
                    obj.frameFiles(i) = [];
                end
            end
            
            if isempty(obj.frameFiles)
                error('No .mat files found in %s', matDir)
            end
            
            obj.frameFiles = regexSort(obj.frameFiles, '(\d+).mat');
            
            % initialise cache
            obj.frames = cell(length(obj.frameFiles), 1);
            obj.frameLoadHistory = [];
            
            % Initialise looping
            if ~exist('loopSpan', 'var')
                loopSpan = [0, length(obj.frameFiles)-2]*obj.timeDelta;
            end
            obj.loopSpan = loopSpan;
            obj.looping = false;
            
            % Use the first frame as reference
            obj.refFrame = obj.getFrameByIndex(1);
        end
        
        function obj = clearCache(obj)
            % Remove all loaded frames from cache
            obj.frames(:) = {[]};
            obj.frameLoadHistory = [];
        end
        
        
        function t = loopAdjust(obj, t)
            % returns t relative to within the loop, if enabled
            if ~obj.looping
                return
            end
            
            if numel(obj.loopSpan)~=2
                error('loop span must be a 2 element array')
            end
            
            % Adjust time for loop
            t = obj.loopSpan(1) + mod(t, diff(obj.loopSpan));
        end
        
        function [tFrames, frames] = getFrames(obj, t, numFrames)
            % Return a number of frames with times centered around t
            t = obj.loopAdjust(t);
            
            % Try and center startIndex around t
            startIndex = round(1 + t/obj.timeDelta - numFrames/2);
            
            % Ensure startIndex is in bounds
            if startIndex <= 1
                startIndex = 1;
            end
            
            endIndex = startIndex + numFrames - 1;
            
            % Ensure end index is in bounds
            if endIndex > length(obj.frameFiles)
                endIndex = length(obj.frameFiles);
                startIndex = endIndex - numFrames+1;
            end
            
            % If start is now out of bounds, it's a fail
            if startIndex < 1
                error('Not enough frames for %i files', numFrames)
            end
            
            indices = startIndex:endIndex;
            
            % Get frames
            tFrames = obj.timeDelta*(indices-1);
            frames = cell(0,1);
            for i = indices
                frames{end+1} = obj.getFrameByIndex(i);
            end
        end
        
        function frame = getFrameByIndex(obj, index)
            % Retrieves a frame. Searches cache first, otherwise loads
            % from disk and stores to cache
            
            % Check index bound
            if index < 1 || index > length(obj.frames)
                error('Frame index (%s) out of bounds (%i frames)', index, length(obj.frames))
            end
            
            % Search cache first
            if ~isempty(obj.frames{index})
                frame = obj.frames{index};
                return
            end
            
            % Remove oldest frame from cache if full
            if length(obj.frameLoadHistory) >= obj.cacheSize
                obj.frames{obj.frameLoadHistory(1)} = [];
                obj.frameLoadHistory(1) = [];
            end
            
            % Load the new frame
            loaded = load(obj.frameFiles{index}, 'data');
            frame = loaded.data;
            
            % Add to cache
            obj.frameLoadHistory(end+1) = index;
            obj.frames{index} = frame;
        end
        
        function Vq = interp(obj, t, xq, yq, fieldname)
            % Interpolates the fieldname frame variable at time t with
            % positions xq, yq. Xq, Yq can be vector/matrix but must be the
            % same size
            
            % Determine size
            if size(xq)~=size(yq)
                error('Xq (%s), Yq (%s) must be the same size', mat2str(xq), mat2str(yq));
            end
            
            querySize = size(xq);
            
            % Get Frames
            switch (obj.method)
                case {'nearest', 'linear'}
                    [tFrames, frames] = obj.getFrames(t, 3);
                    
                otherwise
                    error('Unsupported interpolation method: %s', obj.method);
            end
            
            frameSize = size(frames{1}.X);
            
            % Concatenate frame data
            T = [];
            X = [];
            Y = [];
            V = [];
            for i=1:length(frames)
                frame = frames{i};
                
                T = cat(3, T, tFrames(i)*ones(frameSize));
                X = cat(3, X, frame.X);
                Y = cat(3, Y, frame.Y);
                V = cat(3, V, frame.(fieldname));
            end
            
            % Interpolate ... *ones(prod(querySize),1
            
            Vq = interp3(X, Y, T, V, ...
                xq, yq, obj.loopAdjust(t).*ones(querySize), ...
                obj.method ...
                );
        end
        
        function frame = interpFrame(obj, t)
            % Interpolate every variable in the frame
            frame = struct;
            
            % Interpolate each field in the frame
            fields = fieldnames(obj.refFrame);
            for i=1:length(fields)
                field = fields{i};
                
                frame.(field)  = obj.interp(t, obj.refFrame.X, obj.refFrame.Y, field);
            end
            
        end
        
        function t = tMax(obj)
            % End time in the dataset
            t = obj.timeDelta * (length(obj.frames)-1);
        end
        
        function s = frameSize(obj)
            % Dimensions of a frame
            s = size(obj.refFrame.X);
        end
        
        function x = xCoords(obj)
            frame = obj.getFrameByIndex(1);
            x = unique(frame.X);
        end
        
        function y = yCoords(obj)
            frame = obj.getFrameByIndex(1);
            y = unique(frame.Y);
        end
    end
    
end
