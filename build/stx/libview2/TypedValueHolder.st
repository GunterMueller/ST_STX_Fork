"
 COPYRIGHT (c) 2009 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

ValueHolder subclass:#TypedValueHolder
	instanceVariableNames:'types'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Models'
!

!TypedValueHolder class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by Claus Gittinger
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
    this is simply a valueHolder which checks new values against a given type.
    Useful to debug/trap invalid setters (such as those storing a true into a numeric holder)

    [author:]
        Claus Gittinger
"
!

examples 
"
                                                                        [exBegin]
        |v|

        v := (TypedValueHolder with:1) type:Number.

        (Delay forSeconds:3) wait.
        v value:nil.
                                                                        [exEnd]

                                                                        [exBegin]
        |v|

        v := (TypedValueHolder with:1) types:{UndefinedObject. Number}.

        (Delay forSeconds:3) wait.
        v value:nil.
        (Delay forSeconds:3) wait.
        v value:'huh'.
                                                                        [exEnd]
"
! !

!TypedValueHolder methodsFor:'accessing'!

type:aClass
    self types:(Array with:aClass)
!

types:aCollectionOfTypes
    types := aCollectionOfTypes.
!

value:newValue
    types notNil ifTrue:[
        (types contains:[:type | newValue isKindOf:type]) ifFalse:[
            self error:'Unvalid value stored in typed valueHolder' mayProceed:true
        ]
    ].
    ^ super value:newValue.
! !

!TypedValueHolder class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libview2/TypedValueHolder.st,v 1.2 2009-11-06 19:24:27 cg Exp $'
! !
