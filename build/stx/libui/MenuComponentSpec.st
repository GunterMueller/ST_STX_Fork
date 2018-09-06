"
 COPYRIGHT (c) 1996 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libui' }"

NamedSpec subclass:#MenuComponentSpec
	instanceVariableNames:'menu performer'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!MenuComponentSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
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
    Not normally used by applications.

    Notice: 
        this class was implemented using protocol information
        from alpha testers, literature and by read public domain code
        - it may not be complete or compatible to
        the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [author:]
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"

! !

!MenuComponentSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"

    super addBindingsTo:env for:anInstance channel:aChannel.

    self 
        adaptApects:
                    #(  
                        style
                     )
        to:env 
        for:anInstance 
        channel:aChannel.

    self 
        adaptApects:
                    #(  
                        menu
                        performer
                     )
        to:env 
        for:anInstance 
        channel:aChannel
        converter:#symbolOrNil.

    "Modified: / 26.10.1997 / 03:32:30 / cg"
! !

!MenuComponentSpec methodsFor:'accessing'!

menu
    "return the value of the instance variable 'menu' (automatically generated)"

    ^ menu
!

menu:something
    "set the value of the instance variable 'menu' (automatically generated)"

     menu := something
!

menuPerformer
    menu notNil ifTrue:[^ performer ].
    ^ nil
!

performer
    "return the value of the instance variable 'performer' (automatically generated)"

    ^ performer
!

performer:something
    "set the value of the instance variable 'performer' (automatically generated)"

    performer := something.
! !

!MenuComponentSpec methodsFor:'building'!

setAttributesIn:aView with:aBuilder
    "set my attributes to aView"

    super setAttributesIn:aView with:aBuilder.

    aBuilder isEditing ifFalse:[
        self setMenuIn:aView with:aBuilder.                             
    ]
! !

!MenuComponentSpec methodsFor:'converting'!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    menu      isNil ifTrue:[l add:#menu].
    performer isNil ifTrue:[l add:#performer].

    ^l

    "Modified: / 20.6.1998 / 13:41:10 / cg"
! !

!MenuComponentSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    style := aView font.
    super fromView:aView callBack:aBlock.
! !

!MenuComponentSpec methodsFor:'queries'!

menuSelector
    ^ menu

!

menuSelector:something
    menu := something

! !

!MenuComponentSpec methodsFor:'queries-UIDefiner'!

aspectSelectors
    "add more aspect selectors (these generate aspect methods in the definer)"

    |more|

    more := super aspectSelectors.
    menu notNil ifTrue:[more add:menu].
    ^ more

    "Modified: / 10.2.2000 / 01:25:00 / cg"
! !

!MenuComponentSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/MenuComponentSpec.st,v 1.32 2013-03-10 16:28:12 cg Exp $'
! !

