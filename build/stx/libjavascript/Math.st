"
 COPYRIGHT (c) 2008 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libjavascript' }"

"{ NameSpace: Smalltalk }"

Object subclass:#Math
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-JavaScript-Framework'
!

!Math class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2008 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    Simulates the javascript Math protocol

    allows for
        Math.sin(foo)
    or
        Math.atan2(a,b)
"
! !

!Math class methodsFor:'constants'!

E
    "Eulers constant, the base of the natural logarithm; approx 2.718"

    ^ Float e

    "
     JavaScriptParser 
        evaluate:'Math.E;'    
    "
!

LN10
    "natural logarithm of 10, approx 2.302"

    ^ 10 ln

    "
     JavaScriptParser 
        evaluate:'Math.LN10;'    
    "
!

LN2
    "natural logarithm of 2, approx 0.693"

    ^ Float ln2

    "
     JavaScriptParser 
        evaluate:'Math.LN2;'    
    "
!

LOG10E
    "base 10 logarithm of E; approx. 0.434"

    ^ Float e log

    "
     JavaScriptParser 
        evaluate:'Math.LOG10E;'    
    "
!

LOG2E
    "base2 logarithm of E; approx. 1.442"

    ^ Float e log / 2 log

    "
     JavaScriptParser 
        evaluate:'Math.LOG2E;'    
    "
!

NEGATIVE_INFINITY
    "-inf"

    ^ Infinity negative

    "
     JavaScriptParser evaluate:'Math.NEGATIVE_INFINITY;'    
    "
!

NaN
    "not a number"

    ^ Float NaN

    "
     JavaScriptParser evaluate:'Math.NaN;'    
    "
!

PI
    "pi; approx 3.14159"

    ^ Float pi

    "
     JavaScriptParser 
        evaluate:'Math.PI;'    
    "
!

POSITIVE_INFINITY
    "+Inf"

    ^ Infinity positive

    "
     JavaScriptParser evaluate:'Math.POSITIVE_INFINITY;'    
    "
!

SQRT1_2
    "square root of 1/2; approx 0.707"

    ^ 1 / Float sqrt2

    "
     JavaScriptParser 
        evaluate:'Math.SQRT1_2;'    
    "
!

SQRT2
    "square root of 2; approx. 1.414"

    ^ Float sqrt2

    "
     JavaScriptParser 
        evaluate:'Math.SQRT2;'    
    "
! !

!Math class methodsFor:'min & max'!

max
    "returns the largest of 0 to 5 args"

    ^ 0

    "
     JavaScriptParser 
        evaluate:'Math.max();'    

     JavaScriptParser 
        evaluate:'Math.max(1);'    

     JavaScriptParser 
        evaluate:'Math.max(10,2);'    

     JavaScriptParser 
        evaluate:'Math.max(10,5,20);'    
    "
!

max:n1
    "returns the largest of 0 to 5 args"

    ^ n1

    "
     JavaScriptParser 
        evaluate:'Math.max();'    
     JavaScriptParser 
        evaluate:'Math.max(1);'    
     JavaScriptParser 
        evaluate:'Math.max(10,2);'    
     JavaScriptParser 
        evaluate:'Math.max(10,5,20);'    
    "
!

max:n1 _:n2
    "returns the largest of 1 to 5 args"

    ^ n1 max:n2

    "
     JavaScriptParser 
        evaluate:'Math.max();'    
     JavaScriptParser 
        evaluate:'Math.max(1);'    
     JavaScriptParser 
        evaluate:'Math.max(10,2);'    
     JavaScriptParser 
        evaluate:'Math.max(10,5,20);'    
    "
!

max:n1 _:n2 _:n3
    "returns the largest of 0 to 5 args"

    ^ (n1 max:n2) max:n3

    "
     JavaScriptParser 
        evaluate:'Math.max();'    
     JavaScriptParser 
        evaluate:'Math.max(1);'    
     JavaScriptParser 
        evaluate:'Math.max(10,2);'    
     JavaScriptParser 
        evaluate:'Math.max(10,5,20);'    
    "
!

max:n1 _:n2 _:n3 _:n4
    "returns the largest of 0 to 5 args"

    ^ (n1 max:n2) max:(n3 max:n4)

    "
     JavaScriptParser 
        evaluate:'Math.max(10,5,20,3);'    
    "
!

max:n1 _:n2 _:n3 _:n4 _:n5
    "returns the largest of 0 to 5 args"

    ^ ((n1 max:n2) max:(n3 max:n4)) max:n5

    "
     JavaScriptParser 
        evaluate:'Math.max(10,5,20,3,17);'    
    "
!

min
    "returns the smallest of 0 to 5 args"

    ^ 0

    "
     JavaScriptParser 
        evaluate:'Math.min();'    
     JavaScriptParser 
        evaluate:'Math.min(1);'    
     JavaScriptParser 
        evaluate:'Math.min(10,2);'    
     JavaScriptParser 
        evaluate:'Math.min(10,5,20);'    
    "
!

min:n1
    "returns the smallest of 0 to 5 args"

    ^ n1

    "
     JavaScriptParser 
        evaluate:'Math.min();'    
     JavaScriptParser 
        evaluate:'Math.min(1);'    
     JavaScriptParser 
        evaluate:'Math.min(10,2);'    
     JavaScriptParser 
        evaluate:'Math.min(10,5,20);'    
    "
!

min:n1 _:n2
    "returns the smallest of 1 to 5 args"

    ^ n1 min:n2

    "
     JavaScriptParser 
        evaluate:'Math.min();'    
     JavaScriptParser 
        evaluate:'Math.min(1);'    
     JavaScriptParser 
        evaluate:'Math.min(10,2);'    
     JavaScriptParser 
        evaluate:'Math.min(10,5,20);'    
    "
!

min:n1 _:n2 _:n3
    "returns the smallest of 0 to 5 args"

    ^ (n1 min:n2) min:n3

    "
     JavaScriptParser 
        evaluate:'Math.min();'    
     JavaScriptParser 
        evaluate:'Math.min(1);'    
     JavaScriptParser 
        evaluate:'Math.min(10,2);'    
     JavaScriptParser 
        evaluate:'Math.min(10,5,20);'    
    "
!

min:n1 _:n2 _:n3 _:n4
    "returns the smallest of 0 to 5 args"

    ^ (n1 min:n2) min:(n3 min:n4)

    "
     JavaScriptParser 
        evaluate:'Math.min(10,5,20,3);'    
    "
!

min:n1 _:n2 _:n3 _:n4 _:n5
    "returns the smallest of 0 to 5 args"

    ^ ((n1 min:n2) min:(n3 min:n4)) min:n5

    "
     JavaScriptParser 
        evaluate:'Math.min(10,5,20,3,17);'    
    "
! !

!Math class methodsFor:'misc math'!

abs:aNumber
    "returns the absolute value of a number"

    ^ aNumber abs

    "
     JavaScriptParser evaluate:'Math.abs(-10);'    
    "

    "Modified (comment): / 21-08-2012 / 19:54:00 / cg"
!

binco:n _:k
    "returns the binomialcoefficient C(n,k) (n over k, choose k from n)"

    ^ n binomialCoefficient:k

    " Lotto:
     JavaScriptParser 
        evaluate:'Math.binco(49, 6);'               
    "
!

ceil:aNumber
    "returns the smallest integer greater than or equal to aNumber"

    ^ aNumber ceiling

    "
     JavaScriptParser evaluate:'Math.ceil(9.5);'    
    "
!

exp:aNumber
    "returns E^aNumber"

    ^ aNumber exp

    "
     JavaScriptParser evaluate:'Math.exp(1);'    

     JavaScriptParser 
        evaluate:'Math.log(Math.exp(1));'    
    "
!

fac:aNumber
    "returns the factorial of aNumber"

    ^ aNumber factorial

    "
     JavaScriptParser 
        evaluate:'Math.fac(10);'               
    "
!

floor:aNumber
    "returns the largest integer less than or equal to aNumber"

    ^ aNumber floor

    "
     JavaScriptParser evaluate:'Math.floor(9.5);'               
    "
!

gcd:a _:b
    "returns the greatest common divisor of a and b"

    ^ a gcd:b

    " 
     JavaScriptParser 
        evaluate:'Math.gcd(33, 6);'               
    "
!

log10:aNumber
    "returns the log base 10 of aNumber."

    ^ aNumber log10

    "
     JavaScriptParser 
        evaluate:'Math.log10(10);'              
    "
!

log:aNumber
    "returns the log base E of aNumber.
     ATTENTION: 
        JS log is a base E log
        ST log is a base 10 log (use ln for base E)
     in JS, better use log10 to make things explicit.
    "

    ^ aNumber ln

    "
     JavaScriptParser evaluate:'Math.log(Math.exp(1));'              
    "
!

pow:base _:exp
    "returns base^exp"

    ^ base raisedTo:exp

    "
     JavaScriptParser 
        evaluate:'Math.pow(10,2);'              
    "
!

random
    "returns a pseudo random number between 0 and 1"

    ^ Random nextBetween:0.0 and:1.0

    "
     JavaScriptParser 
        evaluate:'Math.random();'              
    "
!

random:min _:max
    "returns a pseudo random number between min and max"

    ^ Random nextBetween:min and:max

    "
     JavaScriptParser 
        evaluate:'Math.random(5, 7);'              
    "
!

randomInteger:min _:max
    "returns a pseudo random number between min and max"

    ^ Random nextIntegerBetween:min and:max

    "dice:
     JavaScriptParser 
        evaluate:'Math.randomInteger(1, 6);'              
    "
!

round:aNumber
    "returns the value of aNumber rounded to the nearest integer"

    ^ aNumber rounded

    "
     JavaScriptParser 
        evaluate:'Math.round(9.2);'

     JavaScriptParser 
        evaluate:'Math.round(9.7);'               
    "
!

sqrt:aNumber
    "returns the square root of aNumber"

    ^ aNumber sqrt

    "
     JavaScriptParser 
        evaluate:'Math.sqrt(2);'               
    "
! !

!Math class methodsFor:'queries'!

isUtilityClass
    ^ true
! !

!Math class methodsFor:'trigonometric'!

acos:aNumber
    "returns the arccosine (in radians) of a number"

    ^ aNumber arcCos

    "
     JavaScriptParser evaluate:'Math.acos(1);'    
    "
!

asin:aNumber
    "returns the arcsine (in radians) of a number"

    ^ aNumber arcSin

    "
     JavaScriptParser evaluate:'Math.asin(1);'         
    "
!

atan2:x _:y
    "returns the arctangent of the quotient of its arguments (in radians)"

    ^ x arcTan2:y

    "
     JavaScriptParser evaluate:'Math.atan2(1,10);'         
    "
!

atan:aNumber
    "returns the arctangent (in radians) of a number"

    ^ aNumber arcTan

    "
     JavaScriptParser evaluate:'Math.atan(1);'         
    "
!

cos:aNumber
    "returns the cosine of a number (given in radians)"

    ^ aNumber cos

    "
     JavaScriptParser evaluate:'Math.cos(3.14159);'    
    "
!

degreesToRadians:aNumber
    "converts degrees to radians"

    ^ aNumber degreesToRadians

    "
     JavaScriptParser evaluate:'Math.degreesToRadians(45);'    
    "
!

radiansToDegrees:aNumber
    "converts radians to degrees"

    ^ aNumber radiansToDegrees

    "
     JavaScriptParser evaluate:'Math.radiansToDegrees(Math.degreesToRadians(45));'    
    "
!

sin:aNumber
    "returns the sine of a number (given in radians)"

    ^ aNumber sin

    "
     JavaScriptParser evaluate:'Math.sin(3.14159);'          
    "
!

tan:aNumber
    "returns the tangent of a number (given in radians)"

    ^ aNumber tan

    "
     JavaScriptParser evaluate:'Math.tan(3.14159);'    
    "
! !

!Math class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/Math.st,v 1.6 2018-03-27 18:45:09 cg Exp $'
! !

