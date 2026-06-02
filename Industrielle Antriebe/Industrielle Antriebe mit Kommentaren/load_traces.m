function [synchronized_ms_signals, names] = load_traces(filename)
% This function loads the data from a "*.trace"-file saved by Machine Expert.
%
% input arguments:
%
%   filename:                   string, trace file to load
%
%
% output arguments:
%   
%   synchronized_ms_signals:    nx(N+1)-matrix of the form
%                                 [time_0 [ms]    sample_0 of signal 1    sample_0 of signal 2  ...  sample_0 of signal N ]
%                                 [time_1 [ms]    sample_1 of signal 1    sample_1 of signal 2  ...  sample_1 of signal N ]
%                                 [    .                  .                        .             .             .          ]
%                                 [    .                  .                        .             .             .          ]
%                                 [    .                  .                        .             .             .          ]
%                                 [time_n [ms]    sample_n of signal 1    sample_n of signal 2  ...  sample_n of signal N ]
%
%   names:                      cell array of string with names of trace signals
%

%% START OF CODE

% open file
try
    xml_contents = xmlread(filename);
catch
    error(['Could not open file ',filename,'!']);
end;

% read number of trace variables
    N=get(xml_contents.getElementsByTagName('TraceVariable'),'Length');
% allocate memory for output data
    var_struct(N) = struct( 'name', [], 'timestamps', [], 'values',[]);
    try
        %% read trace variables
        for ii=0:N-1
            contents = xml_contents.getElementsByTagName('TraceVariable').item(ii);
            % find variable name
            var_struct(ii+1).name = char((contents.getAttribute('VarName').getBytes)');
            if isempty(var_struct(ii+1).name)
                warning(['Could not read name of trace variable ',num2str(ii),'!']);
            end;
            var_struct(ii+1).values = [];
            var_struct(ii+1).timestamps = [];
            for jj=0:get(contents,'Length')-1
                if strcmp(get(contents.item(jj),'NodeName'),'Values')
                    var_struct(ii+1).values = str2num(get(contents.item(jj),'TextContent'));
                elseif strcmp(get(contents.item(jj),'NodeName'),'Timestamps')
                    var_struct(ii+1).timestamps = str2num(get(contents.item(jj),'TextContent'));
                end;
            end;
            if isempty(var_struct(ii+1).values)
                warning(['Could not read values of trace variable ',num2str(ii),'!']);
            end;
            if isempty(var_struct(ii+1).timestamps)
                warning(['Could not read timestamps of trace variable ',num2str(ii),'!']);
            end;
        end;

        %% synchronize start and end times
        max_start_time=-1e20;
        min_end_time=1e20;

        % find largest sample time of first sample and smallest time of last
        % sample
        for ii=1:N
            if var_struct(ii).timestamps(1)>max_start_time
                max_start_time=var_struct(ii).timestamps(1);
            end;
            if var_struct(ii).timestamps(end)<min_end_time
                min_end_time=var_struct(ii).timestamps(end);
            end;
        end;

        % delete all samples with smaller times than <max_start_time>-400 and
        % larger times than <min_end_time>+400
        for ii=1:N
            ind_to_del=find(var_struct(ii).timestamps<max_start_time-400 | var_struct(ii).timestamps>min_end_time+400);
            var_struct(ii).timestamps(ind_to_del)=[];
            var_struct(ii).values(ind_to_del)=[];
        end;

        %% delete all entries which are not present in all signals
        curr_ind=1;
        ready=false;
        while ~ready
            smallest_dev_ind=1e20;
            % search next entry where the absolute time difference is larger than 400mus
            for ii=2:N
                dev_ind=find(abs(var_struct(ii).timestamps(curr_ind:min(length(var_struct(ii).timestamps),length(var_struct(1).timestamps)))-var_struct(1).timestamps(curr_ind:min(length(var_struct(ii).timestamps),length(var_struct(1).timestamps))))>400,1,'first')+curr_ind-1;
                if ~isempty(dev_ind) && dev_ind<smallest_dev_ind
                    smallest_dev_ind=dev_ind;
                end;
            end;
            if smallest_dev_ind<1e20
                % there are still entries with deviations

                % find largest time entry at deviation point
                max_time=-1e20;
                for ii=1:N
                    if var_struct(ii).timestamps(smallest_dev_ind)>max_time
                        max_time=var_struct(ii).timestamps(smallest_dev_ind);
                    end;
                end;
                subready=false;
                while ~subready
                    % find for all signals next entry with time >= max_time-400
                    synch_ind_cand=zeros(1,N);
                    for ii=1:N
                        synch_ind_cand(ii)=find(var_struct(ii).timestamps(curr_ind:end)>=max_time-400,1,'first')+curr_ind-1;
                    end;
                    % search maximum entry at synchronization point candidate
                    max_time=-1e20;
                    for ii=1:N
                        if var_struct(ii).timestamps(synch_ind_cand(ii))>max_time
                            max_time=var_struct(ii).timestamps(synch_ind_cand(ii));
                        end;
                    end;                
                    % check if all entries coincided up to 400mus
                    subready=true;
                    ii=1;
                    while subready && ii<=N
                        if abs(var_struct(ii).timestamps(synch_ind_cand(ii))-max_time)>400
                            subready=false;
                        end;
                        ii=ii+1;
                    end;
                end;
                % delete all entries with deviations
                for ii=1:N
                    var_struct(ii).timestamps(smallest_dev_ind:synch_ind_cand(ii)-1)=[];
                    var_struct(ii).values(smallest_dev_ind:synch_ind_cand(ii)-1)=[];
                end;
                curr_ind=smallest_dev_ind+1;
            else
                % no further entries with deviations -> ready
                ready=true;
            end;
        end; %while

        %% create output matrix
        
        % allocate memory
        synchronized_ms_signals=zeros(length(var_struct(1).timestamps),N+1);
        % create time scale
        synchronized_ms_signals(:,1)=cumsum([0;round((var_struct(1).timestamps(2:end)-var_struct(1).timestamps(1:end-1))/1000)']);
        % create cell array for signal names
        names=cell(N,1);
        % write signals and signal names
        for ii=1:N
            names{ii}=var_struct(ii).name;
            synchronized_ms_signals(:,ii+1)=var_struct(ii).values';
        end;
         
     catch
         error(['Could not read data from file ',filename,'!']);
     end;
   
end % end of function

