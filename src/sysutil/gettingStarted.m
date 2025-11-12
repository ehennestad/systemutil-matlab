function gettingStarted()
    % GETTINGSTARTED Open the getting started guide for the toolbox
    %
    %   GETTINGSTARTED() opens the getting started guide for the toolbox.
    %
    %   Example:
    %       sysutil.gettingStarted()
    %
    %   See also sysutil.toolboxdir, sysutil.toolboxversion

    % Display welcome message
    fprintf('Welcome to System Utility Toolbox!\n\n');
    fprintf('A set of system utilities for MATLAB\n\n');
    
    % Display version information
    fprintf('Version: %s\n', sysutil.toolboxversion());
    
    % Display directory information
    fprintf('Toolbox directory: %s\n\n', sysutil.toolboxdir());
    
    % Display available functions
    fprintf('Available functions:\n');
    fprintf('  - sysutil.toolboxdir\n');
    fprintf('  - sysutil.toolboxversion\n');
    fprintf('  - sysutil.gettingStarted\n\n');
    
    % Display examples
    fprintf('Examples:\n');
    examplesDir = fullfile(sysutil.toolboxdir(), 'code', 'examples');
    if exist(examplesDir, 'dir')
        exampleFiles = dir(fullfile(examplesDir, '*.m'));
        if ~isempty(exampleFiles)
            for i = 1:length(exampleFiles)
                fprintf('  - %s\n', exampleFiles(i).name);
            end
        else
            fprintf('  No examples found.\n');
        end
    else
        fprintf('  Examples directory not found.\n');
    end
    
    % Display documentation
    fprintf('\nDocumentation:\n');
    docsDir = fullfile(sysutil.toolboxdir(), 'docs');
    if exist(docsDir, 'dir')
        fprintf('  Documentation is available in the docs directory:\n');
        fprintf('  %s\n', docsDir);
    else
        fprintf('  Documentation directory not found.\n');
    end
    
    fprintf('\nFor more information, see the README.md file in the toolbox directory.\n');
end
