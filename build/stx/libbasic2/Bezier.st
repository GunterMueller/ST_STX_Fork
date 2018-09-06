"{ Package: 'stx:libbasic2' }"

Geometric subclass:#Bezier
	instanceVariableNames:'start end controlPoint1 controlPoint2'
	classVariableNames:'ScaledFlatness'
	poolDictionaries:''
	category:'Graphics-Geometry-Objects'
!

!Bezier class methodsFor:'documentation'!

documentation
"
    Beziers represent parametric cubic curvea.

    [instance variables:]
        start                   <Point>         startPoint of the curve.
        end                     <Point>         endPoint of the curve.
        controlPoint1           <Point>         control point.
        controlPoint2           <Point>         control point.

    [class variables:]
        ScaledFlatness          <Integer>       curves flatness parameter

    [author:]
        unknown (based upon the PD path package)
"
!

examples
"
  bezier:
                                                                        [exBegin]
    |v s|

    v := (View extent:110@110) openAndWait.

    s := Bezier
            start:10@10
            end:100@100
            controlPoint1:50@50
            controlPoint2:10@80.

    v paint:Color red.
    s displayStrokedOn:v.

    v paint:Color black.
    v displayPoint:10@10.
    v displayPoint:100@100.
    v displayPoint:50@50.
    v displayPoint:10@80.
                                                                        [exEnd]
"
! !

!Bezier class methodsFor:'instance creation'!

start:startPoint end:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2
    "create & return a new bezier curve"

    ^ self basicNew 
        setStart:startPoint end:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2

    "Created: 12.2.1997 / 11:33:19 / cg"
    "Modified: 12.2.1997 / 14:25:59 / cg"
! !

!Bezier class methodsFor:'class initialization'!

initialize
    "initialize class constants"

    ScaledFlatness := (0.5 * Scale) rounded.

    "
     Bezier initialize
    "

    "Modified: 12.2.1997 / 14:26:26 / cg"
! !

!Bezier methodsFor:'accessing'!

controlPoint1
    "return the first controlPoint"

    ^ controlPoint1

    "Modified: 12.2.1997 / 14:27:01 / cg"
!

controlPoint2
    "return the second controlPoint"

    ^ controlPoint2

    "Created: 12.2.1997 / 11:33:18 / cg"
    "Modified: 12.2.1997 / 14:27:12 / cg"
!

end
    "return the endPoint"

    ^ end

    "Created: 12.2.1997 / 11:33:18 / cg"
    "Modified: 12.2.1997 / 14:27:42 / cg"
!

start
    "return the startPoint"

    ^ start

    "Modified: 12.2.1997 / 14:27:32 / cg"
! !

!Bezier methodsFor:'comparing'!

= anObject 
    "return true, if the receiver and the arg represent the same bezier curve"

    self species == anObject species ifTrue:[
        start = anObject start ifTrue:[
            end = anObject end ifTrue:[
                controlPoint1 = anObject controlPoint1 ifTrue:[
                    controlPoint2 = anObject controlPoint2 ifTrue:[
                        ^ true
                    ]
                ]
            ]
        ]
    ].
    ^ false.

    "Modified: 12.2.1997 / 14:29:38 / cg"
!

hash
    "return an integer useful as hashKey;
     redefined, since = is redefined"

    ^ start hash + end hash + controlPoint1 hash + controlPoint2 hash

    "Modified: 12.2.1997 / 14:30:11 / cg"
! !

!Bezier methodsFor:'converting'!

asLine
    "return a line from the startPoint to the endPoint"

    ^ LineSegment from:start to:end

    "Created: 12.2.1997 / 11:33:19 / cg"
    "Modified: 12.2.1997 / 14:31:01 / cg"
!

asPolyline
    "return a polygon which approximates the curve"

    ^ Polygon vertices:(self computePoints)

    "Modified: 12.2.1997 / 14:31:28 / cg"
! !

!Bezier methodsFor:'displaying'!

displayFilledOn: aGraphicsContext
    "report an error: cannot be filled."

    self shouldNotImplement

    "Modified: 12.2.1997 / 14:31:49 / cg"
!

displayStrokedOn: aGraphicsContext
    "display the curve as an outline"

    aGraphicsContext displayPolygon:(self computePoints)

    "Modified: 12.2.1997 / 14:33:09 / cg"
! !

!Bezier methodsFor:'private'!

addPointsFromStartX:p1X y:p1Y control1X:p2X y:p2Y control2X:p3X y:p3Y endX:p4X y:p4Y to:aCollection
    "actual workHorse for point computation"

    |x1 y1 x2 y2 x3 y3 t d dist dx3 dy3
     midX12 midY12 midX23 midY23 x1p y1p xm ym|

%{  /* OPTIONAL */

    /*
     * easy inlining; all math is done in smallIntegers
     */
    if (__bothSmallInteger(p1X, p1Y)
     && __bothSmallInteger(p2X, p2Y)
     && __bothSmallInteger(p3X, p3Y)
     && __bothSmallInteger(p4X, p4Y)
     && __isSmallInteger(@global(ScaledFlatness))
     && __isFloat(@global(InverseScale))
    ) {
        int _x1 = __intVal(p1X);
        int _y1 = __intVal(p1Y);
        int _x2 = __intVal(p2X);
        int _y2 = __intVal(p2Y);
        int _x3 = __intVal(p3X);
        int _y3 = __intVal(p3Y);
        int _p4X = __intVal(p4X);
        int _p4Y = __intVal(p4Y);
        int _flatness = __intVal(@global(ScaledFlatness));
        double _flatnessD = (double)_flatness;
        double _invScaleD = __floatVal(@global(InverseScale));

        for (;;) {
            int _midX12, _midY12, _midX23, _midY23;
            int _x1p, _y1p, _xm, _ym;
            extern double sqrt(), ceil(), floor();
#           define round(x)     (((x) < 0) ? ceil((x) - 0.5) : floor((x) + 0.5))

            if (_p4X == _x1) {
                int _dX1, _dX2;

                _dX1 = _x2 - _x1; if (_dX1 < 0) _dX1 = -_dX1;
                _dX2 = _x3 - _x1; if (_dX2 < 0) _dX2 = -_dX2;
                if ((_dX1 <= _flatness) && (_dX2 <= _flatness)) break;
            } else {
                int _dX3, _dY3, _dX3Abs, _dY3Abs;

                _dX3 = _dX3Abs = (_p4X - _x1); if (_dX3 < 0) _dX3Abs = -_dX3Abs;
                _dY3 = _dY3Abs = (_p4Y - _y1); if (_dY3 < 0) _dY3Abs = -_dY3Abs;

                if (_dX3Abs >= _dY3Abs) {
                    double _slope = (double)_dY3 / (double)_dX3;
                    double _t;
                    int _d, _dist;

                    _t = _slope*_slope + 1.0;
                    _t = sqrt(_t) * _flatnessD;
                    _t = round(_t);
                    _d = _t;

                    _t = _slope * (_x2-_x1);
                    _t = round(_t);
                    _dist = _t;
                    _dist -= (_y2-_y1);
                    if ((_dist >= 0) ? (_dist <= _d) : ((_dist + _d) >= 0)) {
                        _t = _slope * (_x3-_x1);
                        _t = round(_t);
                        _dist = _t;
                        _dist -= (_y3-_y1);
                        if ((_dist >= 0) ? (_dist <= _d) : ((_dist + _d) >= 0)) break;
                    }
                } else {
                    double _slope = (double)_dX3 / (double)_dY3;
                    double _t;
                    int _d, _dist;

                    _t = _slope*_slope + 1.0;
                    _t = sqrt(_t) * _flatnessD;
                    _t = round(_t);
                    _d = _t;

                    _t = _slope * (_y2-_y1);
                    _t = round(_t);
                    _dist = _t;
                    _dist -= (_x2-_x1);
                    if ((_dist >= 0) ? (_dist <= _d) : ((_dist + _d) >= 0)) {
                        _t = _slope * (_y3-_y1);
                        _t = round(_t);
                        _dist = _t;
                        _dist -= (_x3-_x1);
                        if ((_dist >= 0) ? (_dist <= _d) : ((_dist + _d) >= 0)) break;
                    }
                }
            }

#           undef round

            _midX12 = (_x1 + _x2) / 2;  
            _midY12 = (_y1 + _y2) / 2;
            _midX23 = (_x2 + _x3) / 2;  
            _midY23 = (_y2 + _y3) / 2;

            _x3 = (_x3 + _p4X) / 2;  
            _y3 = (_y3 + _p4Y) / 2;
            _x1p = (_midX12 + _midX23) / 2;  
            _y1p = (_midY12 + _midY23) / 2;
            _x2 = (_midX23 + _x3) / 2;  
            _y2 = (_midY23 + _y3) / 2;
            _xm = (_x1p + _x2) / 2;  
            _ym = (_y1p + _y2) / 2;

            {
                static struct inlineCache addPoints = __ILC9(@line);

                (*addPoints.ilc_func)(self, 
                                      @symbol(addPointsFromStartX:y:control1X:y:control2X:y:endX:y:to:), 
                                      nil, 
                                      &addPoints, 
                                      __MKSMALLINT(_x1), __MKSMALLINT(_y1),
                                      __MKSMALLINT(_midX12), __MKSMALLINT(_midY12),
                                      __MKSMALLINT(_x1p), __MKSMALLINT(_y1p),
                                      __MKSMALLINT(_xm), __MKSMALLINT(_ym),
                                      aCollection
                                     );
            }    

            _x1 = _xm;  
            _y1 = _ym;
        }
        {
            static struct inlineCache add = __ILC1(@line);
            OBJ newPoint;
            double d_x, d_y;

            d_x = _p4X * _invScaleD;
            d_y = _p4Y * _invScaleD;
            newPoint = __MKPOINT_DOUBLE( d_x, d_y);

            (*add.ilc_func)(aCollection,
                            @symbol(add:),
                            nil,
                            &add,
                            newPoint
                           );
        }
        RETURN (self);
    }  
%}.

    x1 := p1X.  y1 := p1Y.
    x2 := p2X.  y2 := p2Y.
    x3 := p3X.  y3 := p3Y.

    [
        p4X = x1 ifTrue:[
            "p4X = x1, i.e. dx = 0"
            (x2 - x1) abs <= ScaledFlatness 
	    and: [(x3 - x1) abs <= ScaledFlatness]
        ] ifFalse:[
            dx3 := p4X - x1.
            dy3 := p4Y - y1.

            (dx3 abs >= dy3 abs) ifTrue:[
                t := dy3 asFloat / dx3.
                d := ((1.0 + (t * t)) sqrt * ScaledFlatness) rounded.
                dist := (t * (x2 - x1)) rounded - (y2 - y1).

                (dist >= 0 ifTrue: [dist <= d] ifFalse: [dist + d >= 0]) 
                and:[dist := (t * (x3 - x1)) rounded - (y3 - y1).
                     dist >= 0 ifTrue: [dist <= d] ifFalse: [dist + d >= 0]]
            ] ifFalse:[
                t := dx3 asFloat / dy3.
                d := ((1.0 + (t * t)) sqrt * ScaledFlatness) rounded.
                dist := (t * (y2 - y1)) rounded - (x2 - x1).
                (dist >= 0 ifTrue: [dist <= d] ifFalse: [dist + d >= 0]) 
                and:[dist := (t * (y3 - y1)) rounded - (x3 - x1).
                     dist >= 0 ifTrue: [dist <= d] ifFalse: [dist + d >= 0]]
            ]
        ]
    ] whileFalse:[
        midX12 := (x1 + x2) // 2.  
        midY12 := (y1 + y2) // 2.
        midX23 := (x2 + x3) // 2.  
        midY23 := (y2 + y3) // 2.

        x3 := (x3 + p4X) // 2.  
        y3 := (y3 + p4Y) // 2.
        x1p := (midX12 + midX23) // 2.  
        y1p := (midY12 + midY23) // 2.
        x2 := (midX23 + x3) // 2.  
        y2 := (midY23 + y3) // 2.
        xm := (x1p + x2) // 2.  
        ym := (y1p + y2) // 2.

        self
            addPointsFromStartX:x1 y:y1
                      control1X:midX12 y:midY12
                      control2X:x1p y:y1p
                           endX:xm y:ym
                             to:aCollection.
        x1 := xm.  
        y1 := ym.
    ].

    aCollection add: (p4X asFloat * InverseScale) @ (p4Y asFloat  * InverseScale)

    "Created: 12.2.1997 / 15:05:52 / cg"
    "Modified: 12.2.1997 / 15:10:34 / cg"
!

computeBounds
    "return the reactngle which encloses the curve."

    ^ self class boundingRectangleForPoints:(self computePoints).

    "Modified: 12.2.1997 / 14:33:45 / cg"
!

computePoints
    "compute the points along the bezier - return a collection of points"

    |pointCollection|

    pointCollection := OrderedCollection new.
    pointCollection add:start.

    self 
        addPointsFromStartX: (start x * Scale) rounded
                          y: (start y * Scale) rounded
                  control1X: (controlPoint1 x * Scale) rounded
                          y: (controlPoint1 y * Scale) rounded
                  control2X: (controlPoint2 x * Scale) rounded
                          y: (controlPoint2 y * Scale) rounded
                       endX: (end x * Scale) rounded
                          y: (end y * Scale) rounded
                         to: pointCollection.
    ^ pointCollection

    "Modified: 12.2.1997 / 15:04:07 / cg"
!

setStart:startPoint end:endPoint controlPoint1:cp1 controlPoint2:cp2
    start := startPoint.
    end := endPoint.
    controlPoint1 := cp1.
    controlPoint2 := cp2

    "Modified: 12.2.1997 / 14:48:19 / cg"
! !

!Bezier methodsFor:'testing'!

outlineIntersects:aRectangle
    "return true, if the curve intersects a rectangle"

    ^ self class vertices:(self computePoints) intersectsRectangle:aRectangle

    "Created: 12.2.1997 / 11:33:18 / cg"
    "Modified: 12.2.1997 / 14:50:35 / cg"
! !

!Bezier methodsFor:'transforming'!

scaledBy:scaleFactor 
    "return a copy of the receiver, which is scaled by some amount"

    ^ self species
        start:(start * scaleFactor)
        end:(end * scaleFactor)
        controlPoint1:(controlPoint1 * scaleFactor)
        controlPoint2:(controlPoint2 * scaleFactor)

    "Created: 12.2.1997 / 11:33:18 / cg"
    "Modified: 12.2.1997 / 14:51:34 / cg"
!

translatedBy:translation 
    "return a copy of the receiver, which is translated by some amount"

    ^ self species
            start:(start + translation)
            end:(end + translation)
            controlPoint1:(controlPoint1 + translation)
            controlPoint2:(controlPoint2 + translation)

    "Modified: 12.2.1997 / 14:52:12 / cg"
! !

!Bezier class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/Bezier.st,v 1.5 2003-08-29 17:31:58 cg Exp $'
! !

Bezier initialize!
