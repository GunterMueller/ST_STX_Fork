"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Number subclass:#MetaNumber
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magnitude-Numbers'
!

!MetaNumber class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
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
    Common behavior for metaNumbers (INF, NaN).

    [author:]
        Claus Gittinger

    [see also:]
        Number Infinity NotANumber
        Float ShortFloat Fraction FixedPoint Integer Complex
        FloatArray DoubleArray                                                                         
"
! !

!MetaNumber class methodsFor:'queries'!

isAbstract
    ^ self == MetaNumber
! !

!MetaNumber methodsFor:'coercing & converting'!

asFloat
    ^ self class
        raise:#domainErrorSignal
        receiver:self
        selector:#asFloat
        arguments:#()
        errorString:'Cannot represent non-finite as float'.
!

asFraction
    ^ self class
        raise:#domainErrorSignal
        receiver:self
        selector:#asFraction
        arguments:#()
        errorString:'Cannot represent non-finite as fraction'.
!

asInteger
    ^ self class
        raise:#domainErrorSignal
        receiver:self
        selector:#asInteger
        arguments:#()
        errorString:'Cannot represent non-finite as integer'.
!

asLargeFloat
    ^ self class
        raise:#domainErrorSignal
        receiver:self
        selector:#asLargeFloat
        arguments:#()
        errorString:'Cannot represent non-finite as float'.
!

asLongFloat
    ^ self class
        raise:#domainErrorSignal
        receiver:self
        selector:#asLongFloat
        arguments:#()
        errorString:'Cannot represent non-finite as float'.
!

asShortFloat
    ^ self class
        raise:#domainErrorSignal
        receiver:self
        selector:#asShortFloat
        arguments:#()
        errorString:'Cannot represent non-finite as float'.
!

coerce:aNumber
    "convert the argument aNumber into an instance of the receiver's class and return it."

    ^ aNumber asMetaNumber
!

generality
    "NaN, INF etc. are more general than scalars, but not more general than
     vectors (e.g. Points)"

    ^ 105
! !

!MetaNumber class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '$Id: MetaNumber.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !



