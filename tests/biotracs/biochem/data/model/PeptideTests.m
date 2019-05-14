classdef PeptideTests < matlab.unittest.TestCase

    properties (TestParameter)
    end
    
    methods (Test)
        function testDefaultConstructor(testCase)
            c =  biotracs.biochem.data.model.Peptide();
            testCase.verifyClass(c, 'biotracs.biochem.data.model.Peptide');
        end
        
        
        
        function testPeptide(testCase)
            peptide =  biotracs.biochem.data.model.Peptide( 'DEKNSVSVDLPGEM' );
            testCase.verifyClass(peptide, 'biotracs.biochem.data.model.Peptide');
            
            testCase.verifyEqual(  peptide.getFormula(), [62 102 16 26 1] );
            testCase.verifyEqual(  peptide.label, 'biotracs.biochem.data.model.Peptide' );
            
            MD =[
               1519.6944646741                       100
              1520.69701601421          75.9330587185868
              1521.69833716913          38.3000166574044
              1522.69967401236          14.4550498469202
              1523.70103757925          4.45290012708241
              1524.70249733416          1.16543505807008
              1525.70404089765         0.266712445312407
              1526.70565964928        0.0544291357120497
              1527.70733994039        0.0100531002039501
              1528.70907096344       0.00169977989780046
              1529.71084349136      0.000265483234683717];
            testCase.verifyEqual( peptide.getIsotopicDistribution('charge', 1), MD, 'RelTol', 1e-9 ); 
            
            try
                peptide2 =  biotracs.biochem.data.model.Peptide( [62 102 16 26 1] );
                error('An error was expected');
                %testCase.verifyEqual( peptide.formula, peptide2.formula ); 
                %testCase.verifyEqual(  peptide2.label, 'peptide' );
            catch err
                testCase.verifyEqual(  err.message, 'Invalid sequence; a string is required' );
            end
            
            %peptide3 =  Peptide( 'C62H102N16O26S1' );
            %testCase.verifyEqual( peptide.formula, peptide3.formula ); 
            %testCase.verifyEqual(  peptide3.label, 'C62H102N16O26S1' );
        end

    end
    
end
