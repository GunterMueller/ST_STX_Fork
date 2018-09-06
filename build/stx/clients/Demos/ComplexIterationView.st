"{ Package: 'stx:clients/Demos' }"

"{ NameSpace: Demos }"

View subclass:#ComplexIterationView
	instanceVariableNames:'rMin rMax iMin iMax backingStore colorMap computationProcess dX0
		dY0 dX1 dY1 areaHistory maxCount threshold synchronousUpdate
		colorMode computationCache'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Graphics'
!

!ComplexIterationView class methodsFor:'documentation'!

documentation
"
    Display the mandelbrot-Set.

    [author:]
        Claus Gittinger

    [start with:]
        Demos::ComplexIterationView new open
"
!

examples
"
    self new open
"
! !

!ComplexIterationView class methodsFor:'menu specs'!

menu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Demos::ComplexIterationView andSelector:#menu
     (Menu new fromLiteralArrayEncoding:(Demos::ComplexIterationView menu)) startUp
    "

    <resource: #menu>

    ^
     
       #(#Menu
          
           #(
             #(#MenuItem
                #label: 'Reset area'
                #translateLabel: true
                #value: #resetArea
            )
             #(#MenuItem
                #label: 'Previous area'
                #translateLabel: true
                #value: #previousArea
                #enabled: #hasPreviousArea
            )
             #(#MenuItem
                #label: '-'
            )
             #(#MenuItem
                #label: 'More iterations'
                #translateLabel: true
                #value: #moreIterations
                #shortcutKeyCharacter: #i
            )
             #(#MenuItem
                #label: 'Less iterations'
                #translateLabel: true
                #value: #lessIterations
                #enabled: #lessIterationsEnabled
                #shortcutKeyCharacter: #I
            )
             #(#MenuItem
                #label: '-'
            )
             #(#MenuItem
                #label: 'Higher threshold'
                #translateLabel: true
                #value: #higherThreshold
            )
             #(#MenuItem
                #label: 'Lower threshold'
                #translateLabel: true
                #value: #lowerThreshold
            )
             #(#MenuItem
                #label: '-'
            )
             #(#MenuItem
                #label: 'Toggle color'
                #translateLabel: true
                #value: #toggleColor
                #shortcutKeyCharacter: #c
            )
          ) nil
          nil
      )
! !

!ComplexIterationView class methodsFor:'startup'!

isVisualStartable
    "returns whether this application class can be started via #open
     (i.e. via a double click on the class in the browser)"

    ^ true

    "Modified: / 9.7.1998 / 10:33:21 / cg"
!

open
    |top v|

    top := StandardSystemView new.
    top label:'Mandelbrot Set'.
    top extent:300@300.
    v := self origin:0.0@0.0 corner:1.0@1.0 in:top.
    top open.
    ^ v

    "Created: / 9.7.1998 / 10:32:57 / cg"
! !

!ComplexIterationView methodsFor:'computation'!

compute
    colorMode ifTrue:[
        self computeCLR
    ] ifFalse:[
        self computeBW
    ]

    "Modified: / 8.7.1998 / 20:49:32 / cg"
!

computeBW
    |stepR stepI r i cnt zR zI nR nI cR cI stop pixel tS  
     cacheIdx "{ Class: SmallInteger }"
     x        "{ Class: SmallInteger }"
     y        "{ Class: SmallInteger }"|

    self paint:Color black on:Color white.

    stepR := ((rMax-rMin)/height) asFloat.
    stepI := ((iMax-iMin)/width) asFloat.                

    tS := (threshold * threshold) asFloat.

    cacheIdx := 1.
    computationCache size ~~ (width*height) ifTrue:[self halt].

    y := 0.
    r := rMin asFloat.
    [y < height] whileTrue:[
        x := 0.
        i := iMin asFloat.
        [x < width] whileTrue:[
%{
            double _cR, _cI, _zR, _zI, _nR, _nI;
            double _zR2, _zI2;
            double _tS, _absSquared;
            int _cnt, _oldCnt, _maxCount;
            int _cacheIdx = __intVal(cacheIdx)-1;
            int *_cachePtr = &(((int *)(__ArrayInstPtr(__INST(computationCache))->a_element))[_cacheIdx]);
            _oldCnt = *_cachePtr;
            _maxCount = __intVal(__INST(maxCount));
            _cnt = _oldCnt;
            if (_cnt == -1) {
                /* must re-iterate */
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
            }
            if (_cnt < _maxCount) {
                if (_oldCnt == _cnt) {
                    pixel = nil;
                } else {
                    pixel = __MKSMALLINT(_cnt & 1);
                    *_cachePtr = _cnt;
                }
            } else {
                if (_oldCnt == -1) {
                    pixel = nil;
                } else {
                    pixel = __MKSMALLINT(1);
                    *_cachePtr = -1;
                }
            }
%}.

            pixel notNil ifTrue:[backingStore atX:x y:y put:pixel].
            cacheIdx := cacheIdx + 1.    
            i := i + stepI.
            x := x + 1.
        ].
        synchronousUpdate ifTrue:[
            self copyFrom:backingStore x:0 y:y toX:0 y:y width:width height:1.
            "/ device flush.
        ].
        r := r + stepR.
        y := y + 1.
    ].
    synchronousUpdate ifFalse:[
        self invalidate.
        "/ self copyFrom:backingStore x:0 y:0 toX:0 y:0 width:width height:height.
        "/ device flush.
    ].

    "Created: / 8.7.1998 / 12:36:03 / cg"
    "Modified: / 8.7.1998 / 13:48:05 / cg"
!

computeCLR
    |stepR stepI r i cnt zR zI nR nI cR cI stop pixel tS nClr blackPix
     cacheIdx "{ Class: SmallInteger }"
     x        "{ Class: SmallInteger }"
     y        "{ Class: SmallInteger }"
     w "{ Class: SmallInteger }"
     h "{ Class: SmallInteger }"|

    stepR := ((rMax-rMin)/height) asFloat.
    stepI := ((iMax-iMin)/width) asFloat.                

    tS := (threshold * threshold) asFloat.
    nClr := 1 bitShift:device depth.

    nClr > 256 ifTrue:[
        self computeUsingColors:(Color colorCubeWithRed:8 green:8 blue:5).
        ^ self.
    ].
    w := width.
    h := height.
    blackPix := device blackpixel.

    cacheIdx := 1.
    computationCache size ~~ (width*height) ifTrue:[self halt].

    y := 0.
    r := rMin asFloat.
    [y < h] whileTrue:[
        x := 0.
        i := iMin asFloat.
        [x < w] whileTrue:[
%{
            double _cR, _cI, _zR, _zI, _nR, _nI;
            double _zR2, _zI2;
            double _tS, _absSquared;
            int _cnt, _oldCnt, _maxCount;
            int _cacheIdx = __intVal(cacheIdx)-1;
            int *_cachePtr = &(((int *)(__ArrayInstPtr(__INST(computationCache))->a_element))[_cacheIdx]);
            _oldCnt = *_cachePtr;
            _maxCount = __intVal(__INST(maxCount));
            _cnt = _oldCnt;
            if (_cnt == -1) {
                /* must re-iterate */
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
            }
            if (_cnt < _maxCount) {
                if (_oldCnt == _cnt) {
                    pixel = nil;
                } else {
                    pixel = __MKSMALLINT(_cnt & (__intVal(nClr)-1));
// printf("%d -> %06x\n", cnt, pixel);
                    *_cachePtr = _cnt;
                }
            } else {
                if (_oldCnt == -1) {
                    pixel = nil;
                } else {
                    pixel = blackPix;
                    *_cachePtr = -1;
                }
            }
%}.

            pixel notNil ifTrue:[backingStore atX:x y:y put:pixel].
            cacheIdx := cacheIdx + 1.    
            i := i + stepI.
            x := x + 1.
        ].
        synchronousUpdate ifTrue:[
            self copyFrom:backingStore x:0 y:y toX:0 y:y width:width height:1.
            "/ device flush.
        ].
        r := r + stepR.
        y := y + 1.
    ].
    synchronousUpdate ifFalse:[
        self invalidate.
        "/ self copyFrom:backingStore x:0 y:0 toX:0 y:0 width:width height:height.
        "/ device flush.
    ].

    "Created: / 8.7.1998 / 12:36:03 / cg"
    "Modified: / 8.7.1998 / 13:48:05 / cg"
!

computeUsingColors:colorCube
    |stepR stepI r i cnt zR zI nR nI cR cI stop pixel tS nClr blackPix
     cacheIdx "{ Class: SmallInteger }"
     x        "{ Class: SmallInteger }"
     y        "{ Class: SmallInteger }"
     pixelColors
     w "{ Class: SmallInteger }"
     h "{ Class: SmallInteger }"|

    stepR := ((rMax-rMin)/height) asFloat.
    stepI := ((iMax-iMin)/width) asFloat.                

    tS := (threshold * threshold) asFloat.
    nClr := 1 bitShift:device depth.
    w := width.
    h := height.

    pixelColors := colorCube collect:[:clr | clr rgbValue].
    nClr := pixelColors size.
    blackPix := device blackpixel.

    cacheIdx := 1.
    computationCache size ~~ (width*height) ifTrue:[self halt].

    y := 0.
    r := rMin asFloat.
    [y < h] whileTrue:[
        x := 0.
        i := iMin asFloat.
        [x < w] whileTrue:[
%{
            double _cR, _cI, _zR, _zI, _nR, _nI;
            double _zR2, _zI2;
            double _tS, _absSquared;
            int _cnt, _oldCnt, _maxCount;
            int _cacheIdx = __intVal(cacheIdx)-1;
            int *_cachePtr = &(((int *)(__ArrayInstPtr(__INST(computationCache))->a_element))[_cacheIdx]);
            _oldCnt = *_cachePtr;
            _maxCount = __intVal(__INST(maxCount));
            _cnt = _oldCnt;
            if (_cnt == -1) {
                /* must re-iterate */
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
            }
            if (_cnt < _maxCount) {
                if (_oldCnt == _cnt) {
                    pixel = nil;
                } else {
                    pixel = __ArrayInstPtr(pixelColors)->a_element[(_cnt & (__intVal(nClr)-1))];
                    *_cachePtr = _cnt;
                }
            } else {
                if (_oldCnt == -1) {
                    pixel = nil;
                } else {
                    pixel = blackPix;
                    *_cachePtr = -1;
                }
            }
%}.

            pixel notNil ifTrue:[backingStore atX:x y:y put:pixel].
            cacheIdx := cacheIdx + 1.    
            i := i + stepI.
            x := x + 1.
        ].
        synchronousUpdate ifTrue:[
            self copyFrom:backingStore x:0 y:y toX:0 y:y width:width height:1.
            "/ device flush.
        ].
        r := r + stepR.
        y := y + 1.
    ].
    synchronousUpdate ifFalse:[
        self invalidate.
        "/ self copyFrom:backingStore x:0 y:0 toX:0 y:0 width:width height:height.
        "/ device flush.
    ].

    "Created: / 8.7.1998 / 12:36:03 / cg"
    "Modified: / 8.7.1998 / 13:48:05 / cg"
!

flushCache
    computationCache := SignedIntegerArray new:(width * height) withAll:-1.
    backingStore depth > 1 ifTrue:[
        backingStore paint:Color black.
        backingStore fillRectangleX:0 y:0 width:width height:height.
    ] ifFalse:[
        backingStore paint:(Color colorId:1).
        backingStore fillRectangleX:0 y:0 width:width height:height.
    ].

    "Created: / 8.7.1998 / 21:02:06 / cg"
    "Modified: / 15.7.1998 / 22:29:46 / cg"
!

startComputationProcess
    computationProcess notNil ifTrue:[
        self stopComputationProcess.
    ].
    computationProcess := [
                                |t|

                                Transcript 
                                    show:'count:'; show:maxCount;
                                    show:' limit:'; show:threshold;
                                    show:' range:'; show:rMin; show:'..'; show:rMax; 
                                    show:' ['; show:(rMax-rMin); show:'] ';
                                    show:' / '; show:iMin; show:'..'; show:iMax;
                                    show:' ['; show:(rMax-rMin); showCR:'] '.

                                self withCursor:(Cursor execute) do:[
                                    t := Time millisecondsToRun:[self compute].
                                    Transcript show:'Time: '; show:t; showCR:' ms'.
                                ]
                          ] forkAt:7

    "Created: / 8.7.1998 / 11:15:42 / cg"
    "Modified: / 15.7.1998 / 22:30:39 / cg"
!

stopComputationProcess
    computationProcess notNil ifTrue:[
        computationProcess terminate.
        computationProcess := nil.
        self cursor:Cursor normal.
    ].

    "Created: / 8.7.1998 / 11:16:20 / cg"
    "Modified: / 8.7.1998 / 14:08:06 / cg"
! !

!ComplexIterationView methodsFor:'computation-obsolete'!

compute1
    |stepR stepI x y r i cnt z c stop|

    self withCursor:(Cursor execute) do:[
    stepR := (rMax-rMin)/height.
    stepI := (iMax-iMin)/width.                

    y := 0.
    r := rMin.
    [r <= rMax] whileTrue:[
        x := 0.
        i := iMin.
        [i <= iMax] whileTrue:[

            c := Complex real:r imaginary:i.
            z := 0.0.

            "/ iterate the complex function
            stop := false.
            cnt := 1.
            [stop] whileFalse:[
                cnt > 30 ifTrue:[
                    stop := true
                ] ifFalse:[
                    z := z * z + c.
                    z abs > 100 ifTrue:[
                        stop := true
                    ].
                    cnt := cnt + 1.
                ]                
            ].
            cnt < 30 ifTrue:[
                backingStore atX:x y:y put:0.
            ] ifFalse:[
                backingStore atX:x y:y put:1.
            ].
            x := x + 1.
            i := i + stepI.
        ].
        self copyFrom:backingStore x:0 y:y toX:0 y:y width:width height:1.
        device flush.
        y := y + 1.
        r := r + stepR.
    ]
]

    "Modified: / 8.7.1998 / 13:09:46 / cg"
    "Created: / 8.7.1998 / 13:41:22 / cg"
!

compute2
    |stepR stepI x y r i cnt zR zI nR nI cR cI stop|

    self withCursor:(Cursor execute) do:[
    stepR := (rMax-rMin)/height.
    stepI := (iMax-iMin)/width.                

    y := 0.
    r := rMin.
    [r <= rMax] whileTrue:[
        x := 0.
        i := iMin.
        [i <= iMax] whileTrue:[

            cR := r.
            cI := i.
            zR := zI := 0.0.

            "/ iterate the complex function
            stop := false.
            cnt := 1.
            [stop] whileFalse:[
                cnt > 30 ifTrue:[
                    stop := true
                ] ifFalse:[
                    nR := (zR * zR) - (zI * zI).   "/ z := z*z.
                    nI := zR * zI * 2.0.

                    zR := nR + cR.                 "/ z := z + c.
                    zI := nI + cI.

                    (zR*zR + (zI*zI)) > (100.0*100.0) "/ z abs > 100
                    ifTrue:[
                        stop := true
                    ].
                    cnt := cnt + 1.
                ]                
            ].
            cnt < 30 ifTrue:[
                backingStore atX:x y:y put:0.
            ] ifFalse:[
                backingStore atX:x y:y put:1.
            ].
            x := x + 1.
            i := i + stepI.
        ].
        self copyFrom:backingStore x:0 y:y toX:0 y:y width:width height:1.
        device flush.
        y := y + 1.
        r := r + stepR.
    ]
]

    "Modified: / 8.7.1998 / 13:09:46 / cg"
    "Created: / 8.7.1998 / 13:48:40 / cg"
!

compute3
    |stepR stepI x y r i cnt zR zI nR nI cR cI stop pixel tS|

    Transcript 
        show:'count:'; show:maxCount;
        show:' limit:'; show:threshold;
        show:' range:'; show:rMin; show:'..'; show:rMax; 
        show:' ['; show:(rMax-rMin); show:'] ';
        show:' / '; show:iMin; show:'..'; show:iMax;
        show:' ['; show:(rMax-rMin); showCR:'] '.

    self withCursor:(Cursor execute) do:[
        stepR := ((rMax-rMin)/height) asFloat.
        stepI := ((iMax-iMin)/width) asFloat.                

        tS := (threshold * threshold) asFloat.

        y := 0.
        r := rMin asFloat.
        [r <= rMax] whileTrue:[
            x := 0.
            i := iMin asFloat.
            [i <= iMax] whileTrue:[
%{
                double _cR, _cI, _zR, _zI, _nR, _nI;
                double _zR2, _zI2;
                double _tS;
                int _cnt, _maxCount;

                _tS = __floatVal(tS);
                _maxCount = __intVal(__INST(maxCount));
                _cR = __floatVal(r);
                _cI = __floatVal(i);
                _zR = _zR2 = 0.0;
                _zI = _zI2 = 0.0;
                for (_cnt=1; _cnt<=_maxCount; _cnt++) {
                    _nR = _zR2 - _zI2;
                    _nI = _zR * _zI * 2.0;

                    _zR = _nR + _cR;
                    _zI = _nI + _cI;

                    _zR2 = _zR * _zR;
                    _zI2 = _zI * _zI;
                    if ((_zR2 + _zI2) > _tS) {
                        break;
                    }
                }
                if (_cnt < _maxCount) {
                    pixel = __MKSMALLINT(0);
                } else {
#if 0
                    pixel = __MKSMALLINT(_cnt & 1);
#else
                    pixel = __MKSMALLINT(1);
#endif
                }
%}.
"/                cR := r.
"/                cI := i.
"/                zR := zI := 0.0.
"/
"/                "/ iterate the complex function
"/                stop := false.
"/                cnt := 1.
"/                [stop] whileFalse:[
"/                    cnt > maxCount ifTrue:[
"/                        stop := true
"/                    ] ifFalse:[
"/                        nR := (zR * zR) - (zI * zI).   "/ z := z*z.
"/                        nI := zR * zI * 2.0.
"/                
"/                        zR := nR + cR.                 "/ z := z + c.
"/                        zI := nI + cI.
"/
"/                        (zR*zR + (zI*zI)) > tS "/ z abs > 100
"/                        ifTrue:[
"/                            stop := true
"/                        ].
"/                        cnt := cnt + 1.
"/                    ]                
"/                ].
"/                cnt < maxCount ifTrue:[
"/                    pixel := 0.
"/                ] ifFalse:[
"/                    pixel := 1.
"/                ].

                backingStore atX:x y:y put:pixel.
                x := x + 1.
                i := i + stepI.
            ].
            synchronousUpdate ifTrue:[
                self invalidate:(0@y corner:width@(y+1)).
                "/ self copyFrom:backingStore x:0 y:y toX:0 y:y width:width height:1.
                "/ device flush.
            ].
            y := y + 1.
            r := r + stepR.
        ].
        synchronousUpdate ifFalse:[
            self invalidate.
            "/ self copyFrom:backingStore x:0 y:0 toX:0 y:0 width:width height:height.
            "/ device flush.
        ].
]

    "Created: / 8.7.1998 / 12:36:03 / cg"
    "Modified: / 8.7.1998 / 13:48:05 / cg"
!

compute4
    |stepR stepI x y r i cnt zR zI nR nI cR cI stop pixel tS|

    stepR := ((rMax-rMin)/height) asFloat.
    stepI := ((iMax-iMin)/width) asFloat.                

    tS := (threshold * threshold) asFloat.

    y := 0.
    r := rMin asFloat.
    [r <= rMax] whileTrue:[
        x := 0.
        i := iMin asFloat.
        [i <= iMax] whileTrue:[
%{
            double _cR, _cI, _zR, _zI, _nR, _nI;
            double _zR2, _zI2;
            double _tS, _absSquared;
            int _cnt, _maxCount;

            _tS = __floatVal(tS);
            _maxCount = __intVal(__INST(maxCount));
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
                _nR = _zR2 - _zI2;
                _nI = _zR * _zI * 2.0;

                if ((_absSquared) > _tS) {
                    break;
                }
            }
            if (_cnt < _maxCount) {
                pixel = __MKSMALLINT(0);
            } else {
#if 0
                pixel = __MKSMALLINT(_cnt & 1);
#else
                pixel = __MKSMALLINT(1);
#endif
            }
%}.
"/                cR := r.
"/                cI := i.
"/                zR := zI := 0.0.
"/
"/                "/ iterate the complex function
"/                stop := false.
"/                cnt := 1.
"/                [stop] whileFalse:[
"/                    cnt > maxCount ifTrue:[
"/                        stop := true
"/                    ] ifFalse:[
"/                        nR := (zR * zR) - (zI * zI).   "/ z := z*z.
"/                        nI := zR * zI * 2.0.
"/                
"/                        zR := nR + cR.                 "/ z := z + c.
"/                        zI := nI + cI.
"/
"/                        (zR*zR + (zI*zI)) > tS "/ z abs > 100
"/                        ifTrue:[
"/                            stop := true
"/                        ].
"/                        cnt := cnt + 1.
"/                    ]                
"/                ].
"/                cnt < maxCount ifTrue:[
"/                    pixel := 0.
"/                ] ifFalse:[
"/                    pixel := 1.
"/                ].

            backingStore atX:x y:y put:pixel.
            x := x + 1.
            i := i + stepI.
        ].
        synchronousUpdate ifTrue:[
            self copyFrom:backingStore x:0 y:y toX:0 y:y width:width height:1.
            "/ device flush.
        ].
        y := y + 1.
        r := r + stepR.
    ].
    synchronousUpdate ifFalse:[
        self invalidate.
        "/ self copyFrom:backingStore x:0 y:0 toX:0 y:0 width:width height:height.
        "/ device flush.
    ].

    "Created: / 8.7.1998 / 12:36:03 / cg"
    "Modified: / 8.7.1998 / 13:48:05 / cg"
! !

!ComplexIterationView methodsFor:'dragging'!

doRectangleDragAtX:x y:y
    |ratio dX dY|

    self invertDragRectangle.

    dX1 := x.
    dY1 := y.

"/    ratio := width / height.
"/    dX := x - dX0.
"/    dY := y - dY0.
"/    dY1 := dY0 + (dX / ratio) rounded.
    self invertDragRectangle.

    "Created: / 8.7.1998 / 12:58:27 / cg"
    "Modified: / 8.7.1998 / 19:13:18 / cg"
!

invertDragRectangle
    self xoring:[
        self displayRectangleX:dX0 y:dY0 width:(dX1-dX0) height:(dY1-dY0).
    ]

    "Created: / 8.7.1998 / 13:03:10 / cg"
    "Modified: / 8.7.1998 / 13:05:44 / cg"
!

startRectangleDragAtX:x y:y
    dX0 := dX1 := x.
    dY0 := dY1 := y.
    self invertDragRectangle.

    "Created: / 8.7.1998 / 12:57:05 / cg"
    "Modified: / 8.7.1998 / 13:02:30 / cg"
!

stopRectangleDragAtX:x y:y
    |rStep iStep|

    self invertDragRectangle.

    (dX1 <= dX0 or:[dY1 <= dY0]) ifTrue:[^ self].

    rStep := (rMax-rMin) / height.
    iStep := (iMax-iMin) / width.

    self 
        newRmin:(rMin + (dY0 * rStep))
        rMax:(rMin + (dY1 * rStep)) 
        iMin:(iMin + (dX0 * iStep))
        iMax:(iMin + (dX1 * iStep)).

    "Created: / 8.7.1998 / 12:57:31 / cg"
    "Modified: / 15.7.1998 / 20:33:38 / cg"
! !

!ComplexIterationView methodsFor:'drawing'!

newRmin:newRmin rMax:newRmax iMin:newImin iMax:newImax
    |oldRMin oldRMax oldIMin oldIMax|

    self rememberArea.

    oldRMin := rMin.
    oldRMax := rMax.
    oldIMin := iMin.
    oldIMax := iMax.

    rMin := newRmin asFloat.
    rMax := newRmax asFloat.
    iMin := newImin asFloat.
    iMax := newImax asFloat.

    self flushCache.

    self startComputationProcess.

    "Modified: / 8.7.1998 / 21:25:16 / cg"
    "Created: / 15.7.1998 / 20:31:33 / cg"
!

redrawX:x y:y width:w height:h
    self paint:Color black on:Color white.
    self copyFrom:backingStore x:x y:y toX:x y:y width:w height:h

    "Created: / 8.7.1998 / 11:12:44 / cg"
    "Modified: / 8.7.1998 / 13:33:07 / cg"
! !

!ComplexIterationView methodsFor:'event handling'!

buttonMotion:state x:x y:y
    state ~~ 0 ifTrue:[
        dX0 notNil ifTrue:[
            ^ self doRectangleDragAtX:x y:y
        ].
    ] ifFalse:[
        ^ super buttonMotion:state x:x y:y
    ]

    "Created: / 8.7.1998 / 12:58:17 / cg"
    "Modified: / 8.7.1998 / 13:13:07 / cg"
!

buttonPress:b x:x y:y
    b == 1 ifTrue:[
        ^ self startRectangleDragAtX:x y:y
    ].
    super buttonPress:b x:x y:y

    "Created: / 8.7.1998 / 12:56:18 / cg"
    "Modified: / 8.7.1998 / 13:08:51 / cg"
!

buttonRelease:b x:x y:y
    b == 1 ifTrue:[
        dX0 notNil ifTrue:[
            ^ self stopRectangleDragAtX:x y:y
        ].
    ].
    ^ super buttonRelease:b x:x y:y

    "Created: / 08-07-1998 / 12:57:17 / cg"
    "Modified: / 10-05-2010 / 20:02:26 / cg"
!

createBackingForm
    |d|

    d := colorMode ifTrue:[device depth] ifFalse:[1].

    backingStore := Form width:width height:height depth:d onDevice:device.
    backingStore clear.

    "Created: / 15.7.1998 / 22:22:19 / cg"
!

destroy
    self stopComputationProcess.
    super destroy.

    "Created: / 8.7.1998 / 11:16:53 / cg"
!

keyPress:key x:x y:y
    |rStep iStep rHalf iHalf rQuart iQuart|

    rStep := (rMax-rMin) / height.
    iStep := (iMax-iMin) / width.
    rHalf := (rMax-rMin) / 2.
    iHalf := (iMax-iMin) / 2.
    rQuart := (rMax-rMin) / 4.
    iQuart := (iMax-iMin) / 4.

    key == #CursorDown ifTrue:[
        ^ self 
            newRmin:(rMin + rQuart)
            rMax:(rMax + rQuart) 
            iMin:iMin
            iMax:iMax.
    ].
    key == #CursorUp ifTrue:[
        ^ self 
            newRmin:(rMin - rQuart)
            rMax:(rMax - rQuart) 
            iMin:iMin
            iMax:iMax.
    ].
    key == #CursorRight ifTrue:[
        ^ self 
            newRmin:rMin
            rMax:rMax 
            iMin:(iMin + iQuart)
            iMax:(iMax + iQuart).
    ].
    key == #CursorLeft ifTrue:[
        ^ self 
            newRmin:rMin
            rMax:rMax 
            iMin:(iMin - iQuart)
            iMax:(iMax - iQuart).
    ].
    key == $z ifTrue:[
        ^ self 
            newRmin:(rMin + rQuart)
            rMax:(rMax - rQuart)
            iMin:(iMin + iQuart)
            iMax:(iMax - iQuart).
    ].
    key == $Z ifTrue:[
        ^ self 
            newRmin:(rMin - rHalf)
            rMax:(rMax + rHalf)
            iMin:(iMin - iHalf)
            iMax:(iMax + iHalf).
    ].
    key == $+ ifTrue:[
        maxCount := maxCount + 2.
        self startComputationProcess.
        ^ self
    ].
    key == $- ifTrue:[
        maxCount := maxCount - 2.
        self startComputationProcess.
        ^ self
    ].
    key == $i ifTrue:[
        ^ self moreIterations
    ].
    key == $I ifTrue:[
        ^ self lessIterations
    ].
    key == $b ifTrue:[
        ^ self previousArea
    ].
    key == $c ifTrue:[
        ^ self toggleColor
    ].

    "Created: / 15.7.1998 / 20:28:45 / cg"
    "Modified: / 15.7.1998 / 22:55:27 / cg"
!

sizeChanged:how
    super sizeChanged:how.
    self createBackingForm.
    self flushCache.
    self fill:Color white.
    self startComputationProcess.

    "Modified: / 15.7.1998 / 22:22:35 / cg"
! !

!ComplexIterationView methodsFor:'initialization'!

initialize
    super initialize.

    colorMap := nil.
    rMin := -4.
    rMax := 4.
    iMin := -4.
    iMax := 4.
    maxCount := 60.
    threshold := 100.0.
    synchronousUpdate := true.
    colorMode := true.

    self menuHolder:self; menuMessage:#menu; menuPerformer:self

    "Created: / 8.7.1998 / 11:10:48 / cg"
    "Modified: / 8.7.1998 / 20:48:47 / cg"
! !

!ComplexIterationView methodsFor:'menu'!

hasPreviousArea
    ^ areaHistory size ~~ 0

    "Created: / 8.7.1998 / 13:17:20 / cg"
    "Modified: / 8.7.1998 / 13:21:34 / cg"
!

higherThreshold
    threshold := threshold * 1.5.
    self flushCache.
    self startComputationProcess

    "Created: / 8.7.1998 / 14:50:49 / cg"
    "Modified: / 8.7.1998 / 21:02:39 / cg"
!

lessIterations
    maxCount := maxCount // 1.5.
    maxCount := maxCount max:30.
    self startComputationProcess

    "Created: / 8.7.1998 / 14:47:16 / cg"
    "Modified: / 8.7.1998 / 15:18:58 / cg"
!

lessIterationsEnabled
    ^ maxCount > 30

    "Created: / 8.7.1998 / 21:28:06 / cg"
!

lowerThreshold
    threshold := threshold / 1.5.
    threshold := threshold max:10.
    self flushCache.
    self startComputationProcess

    "Created: / 8.7.1998 / 14:51:29 / cg"
    "Modified: / 8.7.1998 / 21:02:51 / cg"
!

menu
    |m|

    m := self class menu decodeAsLiteralArray.
    m receiver:self.
    ^ m

    "Created: / 8.7.1998 / 13:11:39 / cg"
    "Modified: / 8.7.1998 / 20:49:00 / cg"
!

moreIterations
    maxCount := (maxCount * 1.5) asInteger.
    self startComputationProcess

    "Created: / 8.7.1998 / 14:47:37 / cg"
    "Modified: / 8.7.1998 / 15:19:16 / cg"
!

previousArea
    |entry|

    areaHistory notEmpty ifTrue:[
        entry := areaHistory removeLast.
        rMin := entry at:1.
        rMax := entry at:2.
        iMin := entry at:3.
        iMax := entry at:4.
        self flushCache.
        self startComputationProcess.
    ]

    "Created: / 8.7.1998 / 13:19:05 / cg"
    "Modified: / 8.7.1998 / 21:25:46 / cg"
!

rememberArea
    areaHistory isNil ifTrue:[
        areaHistory := OrderedCollection new
    ].
    areaHistory add:(Array with:rMin with:rMax with:iMin with:iMax).

    "Created: / 8.7.1998 / 13:27:42 / cg"
!

resetArea
    (rMin ~= -4
    or:[rMax ~= 4
    or:[iMin ~= -4
    or:[iMax ~= 4]]]) ifTrue:[
        self rememberArea.

        rMin := -4.
        rMax := 4.
        iMin := -4.
        iMax := 4.
        self flushCache.
        self startComputationProcess.
    ].

    "Created: / 8.7.1998 / 13:19:31 / cg"
    "Modified: / 8.7.1998 / 21:25:57 / cg"
!

toggleColor
    self stopComputationProcess.
    colorMode == true ifTrue:[
        colorMode := false
    ] ifFalse:[
        colorMode := true
    ].
    self createBackingForm.
    self flushCache.
    self startComputationProcess

    "Created: / 15.7.1998 / 22:18:19 / cg"
    "Modified: / 15.7.1998 / 22:30:50 / cg"
! !

!ComplexIterationView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/ComplexIterationView.st,v 1.13 2010-05-10 18:05:21 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/clients/Demos/ComplexIterationView.st,v 1.13 2010-05-10 18:05:21 cg Exp $'
! !
