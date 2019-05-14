classdef CompoundTests < matlab.unittest.TestCase

    properties (TestParameter)
    end
    
    methods (Test)
        function testDefaultConstructor(testCase)
            c =  biotracs.biochem.data.model.Compound();
            testCase.verifyClass(c, 'biotracs.biochem.data.model.Compound');
        end
        
        function testCompound_1(testCase)
            c =  biotracs.biochem.data.model.Compound( [62 103 16 26 1] );
            testCase.verifyClass(c, 'biotracs.biochem.data.model.Compound');
            
            testCase.verifyEqual(  c.formula, [62 103 16 26 1] );
            testCase.verifyEqual(  c.label, 'C62H103N16O26S1' );
            
            MD =[
               1519.6950132541         0.426185483294772
              1520.69756459421         0.323615673280312
              1521.69888574913         0.163229111093337
              1522.70022259236        0.0616053240505971
              1523.70158615925        0.0189776139272397
              1524.70304591416       0.00496691503472266
              1525.70458947765       0.00113668972406198
              1526.70620822928      0.000231969075087567
              1527.70788852039      4.28448536903125e-05
              1528.70961954344      7.24421517238825e-06
              1529.71139207136      1.13145100680339e-06 ];
            testCase.verifyEqual( c.getIsotopicDistribution( 'norm', false ), MD, 'RelTol', 1e-9 );
            
            
            MD =[
               1520.7022897062         0.426136510113865
              1521.70484156846          0.32362747193355
              1522.70616326775         0.163247534056076
              1523.70750046452        0.0616169982294049
              1524.70886434088        0.0189825110746754
              1525.71032435925       0.00496852472021228
              1526.71186816677        0.0011371298002327
              1527.71348714738      0.000232073027824449
              1528.71516765868       4.2866584813941e-05
              1529.71689889535      7.24830592686711e-06
              1530.71867163213      1.13215341819607e-06 ];
            testCase.verifyEqual( c.getIsotopicDistribution( 'charge', +1, 'norm', false ), MD, 'RelTol', 1e-9 );
            
            MD =[
               760.85478307915         0.426087542552951
              761.356059271278         0.323639263604149
              761.856720393083         0.163265956262863
              762.357389168229        0.0616286731849803
              762.858071261133         0.018987409001197
               763.35880140204       0.00497013478353461
              763.859573427819       0.00113757001082046
              764.360383032598      0.000232177019189532
              764.861223398339      4.28883253866638e-05
              765.362089123487      7.25239870860508e-06
              765.862975596203      1.13285621899467e-06 ];
            testCase.verifyEqual( c.getIsotopicDistribution( 'charge', +2, 'norm', false ), MD, 'RelTol', 1e-9 );
            
            
            c2 =  biotracs.biochem.data.model.Compound( 'C62H103N16O26S1' );
            testCase.verifyEqual(  c.formula, c2.formula );
            testCase.verifyEqual(  c.label, c2.label );
        end
        
        function testCompound_Percentage(testCase)
            c =  biotracs.biochem.data.model.Compound( [62 103 16 26 1] );
            testCase.verifyClass(c, 'biotracs.biochem.data.model.Compound');
            
            testCase.verifyEqual(  c.formula, [62 103 16 26 1] );
            testCase.verifyEqual(  c.label, 'C62H103N16O26S1' );
            
            MD =[
               1519.6950132541                       100
              1520.69756459421          75.9330587185868
              1521.69888574913          38.3000166574044
              1522.70022259236          14.4550498469202
              1523.70158615925          4.45290012708241
              1524.70304591416          1.16543505807008
              1525.70458947765         0.266712445312406
              1526.70620822928        0.0544291357120498
              1527.70788852039        0.0100531002039501
              1528.70961954344       0.00169977989780045
              1529.71139207136      0.000265483234683716];
            testCase.verifyEqual( c.getIsotopicDistribution(), MD, 'RelTol', 1e-9 );
        end
 
    end
    
end
