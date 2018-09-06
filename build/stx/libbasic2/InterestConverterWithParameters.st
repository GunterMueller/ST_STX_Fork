"
 COPYRIGHT (c) 2002 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

InterestConverter subclass:#InterestConverterWithParameters
	instanceVariableNames:'defaultParameters'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Models'
!

!InterestConverterWithParameters class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
    like a normal interestconverter, but passes the change parameter(s).
    Especially useful to simulate the dolphin event trigger mechanism.

    [author:]
        Claus Gittinger
"
! !

!InterestConverterWithParameters methodsFor:'accessing'!

defaultParameters:something
    defaultParameters := something.
! !

!InterestConverterWithParameters methodsFor:'change & update'!

update:something with:parameters from:someObject
    (aspect isNil or:[aspect == something]) ifTrue:[
        destination perform:selector withArguments:(parameters ? defaultParameters)
    ]
! !

!InterestConverterWithParameters class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/InterestConverterWithParameters.st,v 1.3 2013-02-08 17:25:44 cg Exp $'
! !

