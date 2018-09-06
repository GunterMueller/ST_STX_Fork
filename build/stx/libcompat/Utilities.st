"
 COPYRIGHT (c) 1999 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

Object subclass:#Utilities
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!

!Utilities class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
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
    DO NOT DIRECTLY REFER TO THIS CLASS OR USE IT OTHERWISE IN YOUR CODE:

    This is a dummy, mimicry class to allow some squeak code to be filed in.
    Its protocol is neither complete, nor fully compatible with the corresponding
    squeak original class.
"
! !

!Utilities class methodsFor:'misc'!

bringFlapsToFront

    self currentWorld bringFlapTabsToFront
!

currentWorld
   |topView|

   topView := WindowGroup activeGroup mainView.
   topView withAllSubViewsDo:[:v |
        v class == MorphWorldView ifTrue:[^ v model].
   ].
   ^ nil
!

informUser:someMessage during:aBlock
    |v result|

    [   |l|

        v := PopUpView onDevice:Screen current.
        v addSubView:(l := Label origin:(0.0@0.0) extent:(1.0@1.0) label:someMessage).
        v extent:l preferredExtent + 5.
        v showAt:Screen current center.
    ] fork.
    Processor yield.
    result := aBlock ensure:[
        v notNil ifTrue:[
            v hide.
            v destroy
        ].
    ].

    "
     Utilities informUser:'wait two seconds' during:[Delay waitForSeconds:2]
    "
!

keyLike: aString satisfying: aBlock
    "Return a key like aString that satisfies aBlock.  The block should provide a test for acceptability -- typically the test is about whether the key is already in use.  aBlock should return a boolean.  8/11/96 sw"

    | stemAndSuffix suffix stem newKey |

    (aBlock value: aString) ifTrue: [^ aString].
    stemAndSuffix := aString stemAndNumericSuffix.
    suffix := stemAndSuffix last + 1.
    stem := stemAndSuffix first.
    [aBlock value: (newKey := stem, suffix printString)]
            whileFalse:
                    [suffix := suffix + 1].
    ^ newKey


! !

!Utilities class methodsFor:'miscellaneous'!

getterSelectorFor: aName
        "Utilities getterSelectorFor: #elvis"
        ^ ('get', (aName asString asUppercaseFirst)) asSymbol
! !

!Utilities class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/Utilities.st,v 1.12 2017-01-28 00:00:05 cg Exp $'
!

version_SVN
    ^ '$Id: Utilities.st,v 1.12 2017-01-28 00:00:05 cg Exp $'
! !

