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

ClassChange subclass:#ClassInitializeChange
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!ClassInitializeChange class methodsFor:'documentation'!

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
    Change for class initialization chunk. Unlike DoItChange, 
    ClassInitializeChange handles namespaces and private classes
    properly.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!ClassInitializeChange methodsFor:'accessing'!

source
    "return the source of the change"

    source isNil ifTrue:[
        ^ String streamContents:[ :s | 
            (nameSpaceName notNil and:[ nameSpaceName ~= 'Smalltalk' ]) ifTrue:[ 
                s nextPutAll: '"{ NameSpace: '; nextPutAll: nameSpaceName; nextPutAll: ' }"'; cr; cr.
                s nextPutAll: self className; nextPutAll: ' initialize!!'; cr.   
            ].
        ]
    ].
    ^ source

    "Created: / 21-03-2014 / 17:43:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassInitializeChange methodsFor:'applying'!

apply
    "apply the change"

    | class |

    class := self changeClass.
    class isNil ifTrue:[ 
        self error:('Class %1 does not (yet?) exists' bindWith: self fullClassName).
        ^ self.
    ].
    class initialize.

    "Created: / 21-03-2014 / 17:38:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassInitializeChange methodsFor:'comparing'!

sameAs:changeB
    "return true, if the given change represents the same change as the receiver."

    ^ (changeB isKindOf: self class) 
        and:[ self fullClassName  = changeB fullClassName ]

    "Created: / 26-03-2014 / 17:41:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassInitializeChange methodsFor:'printing & storing'!

printOn:aStream
    aStream nextPutAll:self source
! !

!ClassInitializeChange methodsFor:'testing'!

isClassInitializeChange
    ^ true
! !

!ClassInitializeChange class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic3/ClassInitializeChange.st,v 1.3 2014-12-11 20:47:09 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic3/ClassInitializeChange.st,v 1.3 2014-12-11 20:47:09 cg Exp $'
! !

