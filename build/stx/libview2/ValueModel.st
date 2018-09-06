"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

Model subclass:#ValueModel
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Models'
!

!ValueModel class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    abstract superclass for ValueHolders and Adaptors.
    It does not itself know how and where the value is stored,
    but knows about interested objects (which get informed, whenever
    the value changes) and keeps track if the value was ever accepted.

    Notice: 
        this class was implemented using protocol information
        from alpha testers - it may not be complete or compatible to
        the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    subclasses must redefine: #setValue: and #value
    (and optionally redefine #value:)

    [author:]
        Claus Gittinger
"
! !

!ValueModel class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!ValueModel methodsFor:'accessing'!

setValue:newValue 
    "physically set my value, without change notifications"

    ^ self subclassResponsibility
!

triggerValue:newValue
    "set my value & send change notifications to my dependents.
     Send the change message even if the value didn't change."

    self setValue:newValue.
    self changed:#value

    "Modified: 27.3.1997 / 15:14:04 / cg"
!

value 
    "return my value"

    ^ self subclassResponsibility
!

value:newValue
    "set my value & send change notifications to my dependents
     if it changed."

"/    "/ mhmh - that seems to be what VW does ...
"/    "/ (i.e. always send a change message)
"/    self setValue:newValue.
"/    self changed:#value

    |oldValue|

    oldValue := self value.
    oldValue ~~ newValue ifTrue:[
        self setValue:newValue.
        self changed:#value with:newValue
    ]

    "Modified: 27.3.1997 / 15:14:04 / cg"
!

value:newValue withoutNotifying:someOne
    "like #value, but temporarily retract all interests for someOne
     (i.e. the value-change will NOT directly send ANY change notification
      to someOne; we cannot guarantee indirect notifications, though.)
     Useful if someone is itself depending on the receiver,
     and wants to avoid recursive update notifications."

    |oldInterests wasDependent|

    [
        oldInterests := self retractInterestsFor:someOne.
        wasDependent := self dependents includes:someOne.
        wasDependent ifTrue:[
            self removeDependent:someOne.
        ].
        
        self value:newValue.
    ] ensure:[
        wasDependent ifTrue:[self addDependent:someOne].
        oldInterests do:[:i |
            self addInterest:i
        ].
    ].

    "Modified: / 30.1.1998 / 14:14:01 / cg"
! !

!ValueModel methodsFor:'converting'!

asValue
    "return the receiver - it is already a valueHolder"

    ^ self
!

compute:aBlock
    "return a BlockValue on the receiver, which computes aBlock"

    ^ BlockValue with:aBlock arguments:(Array with:self)
! !

!ValueModel methodsFor:'misc'!

deccrement
    self value:(self value + 1)

    "Created: / 27-04-2012 / 14:51:54 / cg"
!

increment
    self value:(self value + 1)

    "Created: / 27-04-2012 / 14:51:51 / cg"
! !

!ValueModel methodsFor:'queries'!

isBuffering
    "return true, if the receiver is buffering something.
     For compatibility with BufferedValueHolder, false is returned here"

    ^ false

    "Created: / 27.1.1998 / 12:12:08 / cg"
!

isValueModel
    "return true, if the receiver is some kind of valueModel;
     true returned here - redefined from Object"

    ^ true
! !

!ValueModel class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

