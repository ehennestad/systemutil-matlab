classdef ToolboxTest <  matlab.unittest.TestCase
% ToolboxTest - Unit test for testing the toolbox functions.

    methods (Test)
        function testToolboxDir(testCase)
            pathStr = sysutil.toolboxdir();
            testCase.verifyClass(pathStr, 'char')
            testCase.verifyTrue(isfolder(pathStr))
        end

        function testToolboxVersion(testCase)
            versionStr = sysutil.toolboxversion();
            testCase.verifyClass(versionStr, 'char')
            testCase.verifyTrue(startsWith(versionStr, 'Version'))
        end
    end
end
