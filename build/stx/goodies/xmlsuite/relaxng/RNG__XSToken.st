"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

DataType subclass:#XSToken
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-XS Data types'
!


!XSToken class methodsFor:'accessing'!

typename
    "Superclass says that I am responsible to implement this method"

    ^'token'

    "Created: / 13-05-2005 / 11:13:55 / masca"
! !

!XSToken class methodsFor:'private'!

ensureIsToken:aString


    | foundSpace |
    (aString trimSeparators = aString) ifFalse:[DataConversionError raiseErrorString:'Token must not contain trailing spaces'].
    foundSpace := false.
    aString do:[:c|
        c = Character lf ifTrue:[DataConversionError raiseErrorString:'Token must not contain linefeed'].
        c = Character return ifTrue:[DataConversionError raiseErrorString:'Token must not contain carrige return'].
        c = Character tab ifTrue:[DataConversionError raiseErrorString:'Token must not contain tab'].
        c = Character space ifTrue:[
            foundSpace 
                ifTrue:[DataConversionError raiseErrorString:'Token must not contain sequences of two or more spaces']
                ifFalse:[foundSpace := true]                
        ] ifFalse:[
            foundSpace := false
        ]
    ].
    ^aString

    "Created: / 13-05-2005 / 11:27:09 / masca"
! !

!XSToken methodsFor:'instance creation'!

createObjectFromString:aString 

    ^(self class ensureIsToken:aString) asSymbol

    "Created: / 13-05-2005 / 11:13:55 / masca"
    "Modified: / 16-05-2005 / 14:20:59 / masca"
!

createStringFromObject:aSymbol


    ^(self class ensureIsToken:aSymbol asString)

    "Created: / 13-05-2005 / 11:13:55 / masca"
! !

!XSToken class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__XSToken.st,v 1.1.1.1 2005-11-01 22:07:17 vranyj1 Exp $'
! !
