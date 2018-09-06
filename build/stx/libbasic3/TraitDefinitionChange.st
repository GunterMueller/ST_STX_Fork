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

ClassChange subclass:#TraitDefinitionChange
	instanceVariableNames:'baseTrait traitComposition category'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!TraitDefinitionChange class methodsFor:'documentation'!

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

!TraitDefinitionChange methodsFor:'accessing'!

baseTrait
    ^ baseTrait
!

baseTrait:something
    baseTrait := something.
!

category
    ^ category
!

category:something
    category := something.
!

source
    ^ String streamContents:[:s |
        s 
            nextPutAll: 'Trait named: ';
            nextPutAll: className; cr;
            nextPutAll: '    uses: '. 
        traitComposition isEmptyOrNil ifTrue:[
            s nextPutAll: '{}'. 
        ] ifFalse:[
            s nextPutAll: traitComposition. 
        ].
        s 
            cr; 
            nextPutAll: '    category: '.
        category asString storeOn:s.    
    ]
!

traitComposition
    ^ traitComposition
!

traitComposition:something
    traitComposition := something.
! !

!TraitDefinitionChange methodsFor:'printing & storing'!

printOn:aStream
    aStream nextPutAll:className; nextPutAll:' {trait definition}'

    "Modified: / 12-10-2006 / 17:48:28 / cg"
! !

!TraitDefinitionChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/TraitDefinitionChange.st,v 1.3 2014-02-05 17:52:06 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic3/TraitDefinitionChange.st,v 1.3 2014-02-05 17:52:06 cg Exp $'
! !

