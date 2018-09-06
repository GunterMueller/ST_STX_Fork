"{ Encoding: utf8 }"

"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

Object subclass:#SystemVersion
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!

!SystemVersion class methodsFor:'documentation'!

documentation
"
     DO NOT DIRECTLY REFER TO THIS CLASS OR USE IT OTHERWISE IN YOUR CODE:
 
     SQUEAK compatibility class.
     This may be required when existing code has to be filed into to ST/X;
     especially, when applying changes from a changeSet or monticello file.
     However, it may not be complete and more protocol may be added in the future.
     The code here was created by reasoning 'what the original class could probably do there'.
 
     This is currently not used by ST/X itself.
"
! !

!SystemVersion class methodsFor:'queries'!

current
    ^ self new
! !

!SystemVersion methodsFor:'queries'!

dottedMajorMinor
    "Pharo returns something like '6.0' here"

    ^ '%1.%2' bindWith:Smalltalk majorVersionNr
                  with:Smalltalk minorVersionNr
!

type
    "Pharo returns 'Pharo' here"

    ^ 'SmalltalkX'
!

version
    "Pharo returns 'Pharo' here"
    "Squeak returns 'Squeak' here"

    ^ 'SmalltalkX'

    "Created: / 27-08-2018 / 10:42:50 / Claus Gittinger"
! !

!SystemVersion class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/SystemVersion.st,v 1.2 2018-08-27 08:43:00 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/SystemVersion.st,v 1.2 2018-08-27 08:43:00 cg Exp $'
! !

