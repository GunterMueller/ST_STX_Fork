"{ NameSpace: Demos }"

Object subclass:#MandelbrotAlgorithm
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Graphics'
!


!MandelbrotAlgorithm methodsFor:'processing'!

computeRowAtR:rIn iFrom:iMin to:iMax n:nI threshold:threshold iterations:maxCount
    "compute (some) rows"

    |stepI x y r i cnt zR zI cR cI stop  tS  
     resultIdx result|

    stepI := ((iMax-iMin)/nI) asFloat.                

    result := Array new:nI.

    tS := (threshold * threshold) asFloat.

    resultIdx := 1.

    r := rIn asFloat.
        x := 0.
        i := iMin asFloat.
        [x < nI] whileTrue:[
%{
            double _cR, _cI, _zR, _zI, _nR, _nI;
            double _zR2, _zI2;
            double _tS, _absSquared;
            int _cnt, _oldCnt, _maxCount;
            int _oldPix = -1;

            _maxCount = __intVal(maxCount);

            _tS = __floatVal(tS);
            _cR = __floatVal(r);
            _cI = __floatVal(i);
            _zR = _zR2 = 0.0;
            _zI = _zI2 = 0.0;
            _nR = _zR2 - _zI2;
            _nI = _zR * _zI * 2.0;
            for (_cnt=1; _cnt<=_maxCount; _cnt++) {

                _zR = _nR + _cR;
                _zI = _nI + _cI;

                _zR2 = _zR * _zR;
                _zI2 = _zI * _zI;

                _absSquared = _zR2 + _zI2;
                _nI = _zR * _zI * 2.0;

                if ((_absSquared) > _tS) {
                    break;
                }
                _nR = _zR2 - _zI2;
            }

            if (_cnt < _maxCount) {
                ((__ArrayInstPtr(result)->a_element))[__intVal(resultIdx)-1] = __MKSMALLINT(_cnt);
            } else {
                ((__ArrayInstPtr(result)->a_element))[__intVal(resultIdx)-1] = __MKSMALLINT(-1);
            }
%}.

            resultIdx := resultIdx + 1.    
            i := i + stepI.
            x := x + 1.
        ].
    ^ result

    "
        self new computeRowAtR:-2 
                        iFrom:-4 to:4 n:100
                        threshold:100
                        iterations:40
    "



!

speedTest
    |t speed|

    'Mandel [info]: speedTest request ...' infoPrintCR.

    "/ make certain that required methods are compiled.
    self 
        computeRowAtR:-2 
        iFrom:-4 to:4 n:100
        threshold:100
        iterations:40.

    t := Time millisecondsToRun:[
        1000 timesRepeat:[
            self 
                computeRowAtR:-2 
                iFrom:-4 to:4 n:100
                threshold:100
                iterations:40
        ]
    ].

    "/ some arbitrary machine here req'd 240ms for that ..
    "/ base sped on that 
    "/ (could use any, since only relative speeds are required)

    speed := (240.0 / t) roundTo:0.1.

    'Mandel [info]: speedTest result: ' infoPrint. speed infoPrintCR.
    ^ speed

    "
     self new speedTest 
    "

    "Modified: / 20.7.1998 / 15:02:34 / cg"
! !

!MandelbrotAlgorithm class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/MandelbrotAlgorithm.st,v 1.2 1998-07-20 13:03:17 cg Exp $'
! !
