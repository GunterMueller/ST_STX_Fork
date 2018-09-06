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
"{ Package: 'stx:libview2' }"

ValueModel subclass:#IndirectValue
	instanceVariableNames:'valueHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Models'
!

!IndirectValue class methodsFor:'documentation'!

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
    IndirectValue refers to another valueHolder and presents that holder's value
    as my own value.
    However, the holder can be changed, which results in a change message from myself.
    Can be used if a valueHolder is needed which represents different values over
    time, for example, a line/column holder for a notebook-like multi-codeView 
    application, where the line/col holder is switched whenever the tab is switched.
    (use an IndirectValue as holder of the line/col labels).
    Another possible use is to synchronize two notebools via a common valueHolder,
    which is used as indirect-value for the two individual indirect-selection-valueholders.

    [author:]
        Claus Gittinger
"
!

examples
"
    a label alternatively showing the value of 2 other valueHolders:
                                                                        [exBegin]
        |holder1 holder2 indirVal lbl|

        holder1 := '1' asValue.
        holder2 := '2' asValue.
        indirVal := IndirectValue for:holder1.

        lbl := Label new.
        lbl labelChannel:indirVal.
        lbl open.
        lbl waitUntilVisible.
        
        Delay waitForSeconds:2.
        indirVal valueHolder:holder2.

        Delay waitForSeconds:2.
        indirVal valueHolder:holder1.
                                                                        [exEnd]
"
! !

!IndirectValue class methodsFor:'instance creation'!

for:aValueHolder
    "return a new IndirectValue presenting aValueHolder"

    ^ self new setValueHolder:aValueHolder
! !

!IndirectValue methodsFor:'accessing'!

setValue:newValue 
    "physically set my value, without change notifications"

    valueHolder 
        value:newValue
        withoutNotifying:self
!

setValueHolder:aValueHolder
    "change my holder"

    valueHolder notNil ifTrue:[
        valueHolder removeDependent:self.
    ].
    valueHolder := aValueHolder.
    valueHolder notNil ifTrue:[
        valueHolder addDependent:self.
    ].
!

value 
    "return my value"

    ^ valueHolder value
!

valueHolder 
    "return my valueHolder"

    ^ valueHolder
!

valueHolder:aValueHolder
    "change my holder"

    |oldValue|

    oldValue := valueHolder value.
    self setValueHolder:aValueHolder.
    oldValue ~~ valueHolder value ifTrue:[
        self changed:#value
    ].
! !

!IndirectValue methodsFor:'change & update'!

update:something with:aParameter from:someone
    "the holder I depend on has changed - send a change notification to my dependents"

    self changed:something with:aParameter
! !

!IndirectValue class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/IndirectValue.st,v 1.9 2014-03-26 21:59:54 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libview2/IndirectValue.st,v 1.9 2014-03-26 21:59:54 cg Exp $'
! !

