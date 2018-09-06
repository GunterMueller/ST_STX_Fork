"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Smalltalk }"

ClassChange subclass:#TraitClassTraitDefinitionChange
	instanceVariableNames:'baseTrait traitComposition'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!TraitClassTraitDefinitionChange class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    instances represent trait changes.
    These are not present or supported (currently) in st/x, but may be encountered
    when reading a monticello package containing traits.
    Mostly experimental.
"
! !

!TraitClassTraitDefinitionChange methodsFor:'accessing'!

baseTrait
    ^ baseTrait
!

baseTrait:something
    baseTrait := something.
!

source
    ^ String streamContents:[:s |
        s 
            nextPutAll: baseTrait;
            nextPutAll: ' classTrait '; cr;
            nextPutAll: '    uses: '. 
        traitComposition isEmptyOrNil ifTrue:[
            s nextPutAll: '{}'. 
        ] ifFalse:[
            s nextPutAll: traitComposition. 
        ].
    ]
!

traitComposition
    ^ traitComposition
!

traitComposition:something
    traitComposition := something.
! !

!TraitClassTraitDefinitionChange methodsFor:'printing & storing'!

printOn:aStream
    aStream nextPutAll:baseTrait; nextPutAll:' {class trait definition}'
! !

!TraitClassTraitDefinitionChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/TraitClassTraitDefinitionChange.st,v 1.2 2014-02-05 17:52:04 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic3/TraitClassTraitDefinitionChange.st,v 1.2 2014-02-05 17:52:04 cg Exp $'
! !

