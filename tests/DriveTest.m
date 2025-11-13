classdef DriveTest < matlab.unittest.TestCase
% DriveTest - Unit tests for sysutil.drive functions

    methods (Test)
        function testListMountedDrives(testCase)
            % Test that listMountedDrives returns a valid table
            
            infoTable = sysutil.drive.listMountedDrives();
            
            % Verify output is a table
            testCase.verifyClass(infoTable, 'table');
            
            % Verify table has expected columns
            expectedVars = {'DeviceID', 'VolumeName', 'SerialNumber', ...
                           'FileSystem', 'Size', 'SizeUnit', 'DriveType'};
            testCase.verifyEqual(infoTable.Properties.VariableNames, expectedVars);
            
            % Verify at least one drive is returned
            testCase.verifyGreaterThan(height(infoTable), 0, ...
                'At least one drive should be mounted');
        end
        
        function testDeviceIDFormat(testCase)
            % Test that DeviceID format is correct for each platform
            
            infoTable = sysutil.drive.listMountedDrives();
            
            if ismac
                % Mac format: /dev/diskX
                for i = 1:height(infoTable)
                    testCase.verifyTrue(startsWith(infoTable.DeviceID(i), '/dev/disk'), ...
                        'Mac DeviceID should start with /dev/disk');
                end
            elseif ispc
                % Windows format: C:, D:, etc.
                for i = 1:height(infoTable)
                    testCase.verifyTrue(endsWith(infoTable.DeviceID(i), ':'), ...
                        'Windows DeviceID should end with colon');
                    testCase.verifyEqual(strlength(infoTable.DeviceID(i)), 2, ...
                        'Windows DeviceID should be two characters (e.g., C:)');
                end
            elseif isunix
                % Linux format: /dev/sdX, /dev/nvmeXnY, etc.
                for i = 1:height(infoTable)
                    testCase.verifyTrue(startsWith(infoTable.DeviceID(i), '/dev/'), ...
                        'Linux DeviceID should start with /dev/');
                end
            end
        end
        
        function testSizeIsNumeric(testCase)
            % Test that Size is numeric and positive
            
            infoTable = sysutil.drive.listMountedDrives();
            
            testCase.verifyClass(infoTable.Size, 'double');
            testCase.verifyTrue(all(infoTable.Size > 0), ...
                'All drive sizes should be positive');
        end
        
        function testSizeUnitIsValid(testCase)
            % Test that SizeUnit contains valid units
            
            infoTable = sysutil.drive.listMountedDrives();
            
            validUnits = {'kB', 'MB', 'GB', 'TB'};
            for i = 1:height(infoTable)
                testCase.verifyTrue(ismember(string(infoTable.SizeUnit(i)), validUnits), ...
                    'SizeUnit should be kB, MB, GB, or TB');
            end
        end
        
        function testDriveTypeIsString(testCase)
            % Test that DriveType is a string
            
            infoTable = sysutil.drive.listMountedDrives();
            
            testCase.verifyClass(infoTable.DriveType, 'string');
            testCase.verifyTrue(all(strlength(infoTable.DriveType) > 0), ...
                'DriveType should not be empty');
        end
        
        function testWindowsDriveTypes(testCase)
            % Test Windows-specific drive types
            
            if ~ispc
                return; % Skip on non-Windows
            end
            
            infoTable = sysutil.drive.listMountedDrives();
            
            validTypes = {'Unknown', 'Removable', 'Fixed', 'Network', 'CD-ROM'};
            for i = 1:height(infoTable)
                testCase.verifyTrue(ismember(infoTable.DriveType(i), validTypes), ...
                    sprintf('DriveType "%s" should be one of: %s', ...
                    infoTable.DriveType(i), strjoin(validTypes, ', ')));
            end
        end
        
        function testWindowsFileSystem(testCase)
            % Test that Windows returns FileSystem information
            
            if ~ispc
                return; % Skip on non-Windows
            end
            
            infoTable = sysutil.drive.listMountedDrives();
            
            % At least some drives should have a known filesystem
            knownFS = {'NTFS', 'FAT32', 'exFAT', 'ReFS'};
            hasKnownFS = false;
            for i = 1:height(infoTable)
                if ismember(upper(infoTable.FileSystem(i)), knownFS)
                    hasKnownFS = true;
                    break;
                end
            end
            testCase.verifyTrue(hasKnownFS, ...
                'At least one drive should have a recognized filesystem');
        end
        
        function testMacDeviceNumbers(testCase)
            % Test that Mac device numbers are valid
            
            if ~ismac
                return; % Skip on non-Mac
            end
            
            infoTable = sysutil.drive.listMountedDrives();
            
            % Extract disk numbers (e.g., /dev/disk0 -> 0)
            diskNumbers = [];
            for i = 1:height(infoTable)
                deviceID = char(infoTable.DeviceID(i));
                numStr = regexp(deviceID, '\d+', 'match', 'once');
                if ~isempty(numStr)
                    diskNumbers(end+1) = str2double(numStr); %#ok<AGROW>
                end
            end
            
            testCase.verifyTrue(all(diskNumbers >= 0), ...
                'Disk numbers should be non-negative');
        end
        
        function testLinuxFileSystem(testCase)
            % Test that Linux returns FileSystem information
            
            if ~isunix || ismac
                return; % Skip on non-Linux
            end
            
            infoTable = sysutil.drive.listMountedDrives();
            
            % Common Linux filesystems
            knownFS = {'ext2', 'ext3', 'ext4', 'xfs', 'btrfs', 'vfat', 'ntfs'};
            hasKnownFS = false;
            for i = 1:height(infoTable)
                if ismember(lower(infoTable.FileSystem(i)), knownFS)
                    hasKnownFS = true;
                    break;
                end
            end
            testCase.verifyTrue(hasKnownFS, ...
                'At least one drive should have a recognized filesystem');
        end
    end
end
