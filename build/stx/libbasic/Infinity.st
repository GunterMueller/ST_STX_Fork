"
 This is a Manchester Goodie.  It is distributed freely on condition
 that you observe these conditions in respect of the whole Goodie, and on
 any significant part of it which is separately transmitted or stored:
	* You must ensure that every copy includes this notice, and that
	  source and author(s) of the material are acknowledged.
	* These conditions must be imposed on anyone who receives a copy.
	* The material shall not be used for commercial gain without the prior
	  written consent of the author(s).

 For more information about the Manchester Goodies Library (from which 
 this file was distributed) send e-mail:
	To: goodies-lib@cs.man.ac.uk
	Subject: help 

 This is an additional goody-class, which is NOT covered by the
 ST/X license. It has been packaged with the ST/X distribution to
 make your live easier instead. NO WARRANTY.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

MetaNumber subclass:#Infinity
	instanceVariableNames:''
	classVariableNames:'InfNeg InfPos'
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

Infinity subclass:#NegativeInfinity
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Infinity
!

Infinity subclass:#PositiveInfinity
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Infinity
!

Infinity comment:'I have two instances representing positive and negative infinity.

Instance Variables :-
	positive <Boolean>      :       if true the instance represents positive
					infinity. if false, negative infinity'
!

!Infinity class methodsFor:'documentation'!

copyright
"
 This is a Manchester Goodie.  It is distributed freely on condition
 that you observe these conditions in respect of the whole Goodie, and on
 any significant part of it which is separately transmitted or stored:
	* You must ensure that every copy includes this notice, and that
	  source and author(s) of the material are acknowledged.
	* These conditions must be imposed on anyone who receives a copy.
	* The material shall not be used for commercial gain without the prior
	  written consent of the author(s).

 For more information about the Manchester Goodies Library (from which 
 this file was distributed) send e-mail:
	To: goodies-lib@cs.man.ac.uk
	Subject: help 

 This is an additional goody-class, which is NOT covered by the
 ST/X license. It has been packaged with the ST/X distribution to
 make your live easier instead. NO WARRANTY.
"
!

documentation
"
    I have two instances representing positive and negative infinity.

    Claus: fixed some minor bugs (args to errorUndefinedResult:) and some wrong comments.
           Changed retry:coercing: to match ST/X's way of doing this

    Instance Variables :-
        positive <Boolean>      :       if true the instance represents positive
                                        infinity. if false, negative infinity
"
!

examples
"
    1 + Infinity positive   
    Infinity positive + 1     
    Infinity positive + Infinity positive     

    Infinity negative - 1                   
    Infinity negative + Infinity negative   
    Infinity negative + Infinity negative   

    Infinity negative negated              
    Infinity positive negated              

    Infinity positive > Infinity negative  
    Infinity negative > Infinity positive  

    Infinity negative + Infinity positive   -> raises an error
    Infinity negative - Infinity negative   -> raises an error

"
!

info
"       
    NAME            infinity
    AUTHOR          manchester
    FUNCTION        Provides a class of infinities
    ST-VERSION      2.2
    PREREQUISITES   
    CONFLICTS
    DISTRIBUTION    world
    VERSION         1
    DATE            22 Jan 1989
    SUMMARY
        This is a set of changes that implements infinity in the Number hierarchy.  
        I obtained the original changes from the author of an article in comp.lang.smalltalk.
        I have just installed it in my image and I have found two small omissions
        which are corrected in what is below; there might be others.  Arithmetic
        between infinities is not defined but magnitude comparisons are implemented.
"
! !

!Infinity class methodsFor:'instance creation'!

negative
    "Return the unique instance of negative infinity"

    ^InfNeg
!

negative:aBoolean
    "Return either instance of negative infinity"

    ^ aBoolean ifTrue:[InfNeg] ifFalse:[InfPos].
!

new
    "only my two singleton instances are allowed;
      get either via Infinity positive or Infinity negative"

    self shouldNotImplement
!

positive
    "Return the unique instance of positive infinity"

    ^InfPos
! !

!Infinity class methodsFor:'class initialization'!

initialize
    "initialize my two singleton instances"

    InfPos := PositiveInfinity basicNew.
    InfNeg := NegativeInfinity basicNew.

    "
     Infinity initialize
    "
! !

!Infinity class methodsFor:'queries'!

isAbstract
    ^ self == Infinity
! !

!Infinity methodsFor:'arithmetic'!

* aNumber
    "Multiply the receiver by the argument and answer with the result."

    aNumber isInfinite ifTrue: [
	self errorUndefinedResult: #*.
	^ self class NaN.
    ].
    ^self
!

+ aNumber
    "Add the receiver and the argument and answer with the result."

    (aNumber isInfinite and:[aNumber sign ~~ self sign]) ifTrue: [
	self errorUndefinedResult: #+.
	^ self class NaN
    ].
    ^self
!

- aNumber
    "Subtract aNumber from the receiver and answer the result."

    (aNumber isInfinite and:[aNumber sign == self sign]) ifTrue: [
        self errorUndefinedResult: #-.
        ^ self class NaN
    ].
    ^self
!

/ aNumber
    "Divide the receiver by the argument and answer the result."

    (aNumber isInfinite or: [aNumber = 0]) ifTrue: [
	self errorUndefinedResult: #/.
	^ self class NaN.
    ].
    ^self
! !

!Infinity methodsFor:'coercing'!

generality
    "Infinities are more general than scalars, but not more general than
     vectors (e.g. Points)"

    ^ 105
! !

!Infinity methodsFor:'comparing'!

< aNumber
    "Positive infinity is greater than any number other than positive infinity.
     Analogously, negative infinity is less than any other number other
     than negative infinity"

    aNumber == self ifTrue: [^false].
    ^ self positive not

    "
     Infinity positive < 0              
     Infinity positive < 1000           
     Infinity positive < -1000          

     Infinity positive < Infinity positive 
     Infinity positive < Infinity negative 

     0 < Infinity positive                 
     1000 < Infinity positive              
     -1000 < Infinity positive             
     Infinity negative < Infinity positive 

     Infinity negative < 0                     
     Infinity negative < 1000                  
     Infinity negative < -1000                 

     Infinity negative < Infinity negative     
     Infinity negative < Infinity positive     

     0 < Infinity negative                     
     1000 < Infinity negative                  
     -1000 < Infinity negative                 
     Infinity negative < Infinity positive     
    "
!

= aNumber
    "return true, if the argument represents the same numeric value
     as the receiver, false otherwise."

    aNumber == self ifTrue:[^ true].
    aNumber isNumber ifFalse:[^ false].
    "could be another infinity..."
    aNumber isFinite ifTrue:[^ false].
    ^ aNumber sign == self sign
!

> aNumber
    "Positive infinity is greater than any number other than positive infinity.
     Analogously, negative infinity is less than any other number other
     than negative infinity"

    aNumber == self ifTrue: [^false].
    ^ self positive

    "
     Infinity positive > 0                     
     Infinity positive > 1000                  
     Infinity positive > -1000                 

     Infinity positive > Infinity positive     
     Infinity positive > Infinity negative     

     0 > Infinity positive                     
     1000 > Infinity positive                  
     -1000 > Infinity positive                 
     Infinity negative > Infinity positive     

     Infinity negative > 0                     
     Infinity negative > 1000                  
     Infinity negative > -1000                 

     Infinity negative > Infinity negative     
     Infinity negative > Infinity positive     

     0 > Infinity negative                     
     1000 > Infinity negative                  
     -1000 > Infinity negative                 
     Infinity negative > Infinity positive     
    "
! !

!Infinity methodsFor:'double dispatching'!

differenceFromSomeNumber:aNumber
    "Sent from aNumber-self, if aNumber does not know how to handle this"

    ^ self negated
!

equalFromSomeNumber:aNumber
    "Sent from aNumber = self, if aNumber does not know how to handle this.
     Return true if aNumber = self."

    ^ aNumber isInfinite and:[self sign == aNumber sign]
!

lessFromSomeNumber:aNumber
    "Sent from aNumber < self, if aNumber does not know how to handle this.
     Return true if aNumber < self."

    aNumber isFinite ifTrue:[
        ^ self positive.
    ].

    ^ Number
        raise: #undefinedResultSignal
        receiver: self
        selector: #lessFromSomeNumber:
        errorString: 'Cannot compare against NaN'
!

productFromSomeNumber:aNumber
    "Sent from aNumber*self, if aNumber does not know how to handle this"

    aNumber sign >= 0 ifTrue:[
        ^ self
    ].
    ^ self negated
!

quotientFromSomeNumber:aNumber
    "Return the quotient of the argument, aNumber and the receiver.
     Sent when aNumber does not know how to divide by the receiver."

    aNumber sign > 0 ifTrue:[
	^ self
    ].
    aNumber sign < 0 ifTrue:[
	^ self negated
    ].
    ^ aNumber realNumber
!

sumFromSomeNumber:aNumber
    "Sent from aNumber+self, if aNumber does not know how to handle this"

    ^ self
! !

!Infinity methodsFor:'errors'!

errorUndefinedResult: messageName
    ^ Number
	raise: #undefinedResultSignal
	receiver: self
	selector: #lessFromSomeNumber:
	errorString: 'Undefined result in an Infinity ', messageName
! !

!Infinity methodsFor:'testing'!

isFinite
    ^false
!

isInfinite
    ^true
! !

!Infinity::NegativeInfinity methodsFor:'arithmetic'!

negated
    ^ InfPos
!

negative
    ^ true
! !

!Infinity::NegativeInfinity methodsFor:'comparing'!

hash
    "return an Integer useful as a hash key for the receiver."

    ^ 17467     "/ any arbitrary value
! !

!Infinity::NegativeInfinity methodsFor:'printing'!

printOn: aStream
    aStream nextPutAll:'-INF'
! !

!Infinity::NegativeInfinity methodsFor:'testing'!

sign
    "return the sign of the receiver (1)"

    ^ -1
! !

!Infinity::PositiveInfinity methodsFor:'arithmetic'!

negated
    ^ InfNeg
!

negative
    ^ false
! !

!Infinity::PositiveInfinity methodsFor:'comparing'!

hash
    "return an Integer useful as a hash key for the receiver."

    ^ 17471     "/ any arbitrary value
! !

!Infinity::PositiveInfinity methodsFor:'printing'!

printOn: aStream
    aStream nextPutAll:'INF'
! !

!Infinity::PositiveInfinity methodsFor:'testing'!

sign
    "return the sign of the receiver (-1)"

    ^ 1
! !

!Infinity class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


Infinity initialize!
