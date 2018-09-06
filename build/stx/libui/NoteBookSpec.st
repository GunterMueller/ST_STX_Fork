"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1997 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libui' }"

"{ NameSpace: Smalltalk }"

UISpecification subclass:#NoteBookSpec
	instanceVariableNames:'model tabable secondModel binderWidth rightInset isOpaque'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!NoteBookSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
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
        from alpha testers, literature and by reading public domain code
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

!NoteBookSpec class methodsFor:'interface-painter'!

addBindingsTo:env for:anInstance channel:aChannel 
    "add bindings as required to allow the GUI Painter to operate on an instance of me"
    "This must be redefined in each subclass which adds more state, 
     to add its own aspects (but do not forget the super aspects)."

    super addBindingsTo:env for:anInstance channel:aChannel. 

    self 
        adaptApects:
                    #(  
                        isOpaque
                     )
        to:env 
        for:anInstance 
        channel:aChannel.
! !

!NoteBookSpec methodsFor:'accessing'!

binderWidth
    "return the value of the instance variable 'binderWidth' (automatically generated)"

    ^ binderWidth

    "Created: 25.1.1997 / 18:56:43 / cg"
!

binderWidth:something
    "set the value of the instance variable 'binderWidth' (automatically generated)"

    binderWidth := something.

    "Created: 25.1.1997 / 18:56:43 / cg"
!

isOpaque
    "return the value of the instance variable 'isOpaque' (automatically generated)"

    ^ isOpaque ? true

    "Created: 25.1.1997 / 18:44:59 / cg"
!

isOpaque:something
    "set the value of the instance variable 'isOpaque' (automatically generated)"

    isOpaque := something.

    "Created: 25.1.1997 / 18:44:59 / cg"
!

model
    "return the value of the instance variable 'model' (automatically generated)"

    ^ model

    "Created: 25.1.1997 / 18:55:55 / cg"
!

model:something
    "set the value of the instance variable 'model' (automatically generated)"

    model := something.

    "Created: 25.1.1997 / 18:55:55 / cg"
!

rightInset
    "return the value of the instance variable 'rightInset' (automatically generated)"

    ^ rightInset

    "Created: 25.1.1997 / 18:57:01 / cg"
!

rightInset:something
    "set the value of the instance variable 'rightInset' (automatically generated)"

    rightInset := something.

    "Created: 25.1.1997 / 18:57:01 / cg"
!

secondModel
    "return the value of the instance variable 'secondModel' (automatically generated)"

    ^ secondModel

    "Created: 25.1.1997 / 18:56:19 / cg"
!

secondModel:something
    "set the value of the instance variable 'secondModel' (automatically generated)"

    secondModel := something.

    "Created: 25.1.1997 / 18:56:19 / cg"
!

tabable
    "return the value of the instance variable 'tabable' (automatically generated)"

    ^ tabable

    "Created: 25.1.1997 / 18:56:06 / cg"
!

tabable:something
    "set the value of the instance variable 'tabable' (automatically generated)"

    tabable := something.

    "Created: 25.1.1997 / 18:56:06 / cg"
! !

!NoteBookSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    self basicFromLiteralArrayEncoding:aSpecArray.

    layout notNil ifTrue:[
        layout isAssociation ifFalse:[
            layout := layout decodeAsLiteralArray.
        ] ifTrue:[
            layout := #extent->(layout value decodeAsLiteralArray)
        ]
    ].

    "
        UISpecification from:
             #(#FullSpec 
                #window: 
                    #(#WindowSpec 
                        #label: 'Unlabeled Canvas' 
                        #min: #(#Point 50 50 ) 
                        #bounds: #(#Rectangle 448 407 648 607 ) ) 
                #component: 
                    #(#SpecCollection
                        #collection: 
                            #(
                                #(#LabelSpec 
                                    #layout: #(#Point 0 2 ) 
                                    #label: 'Classes:' )
                                #(#SequenceViewSpec 
                                    #layout: #(#LayoutFrame 0 0 27 0 0 1 0 1 ) 
                                    #model: #classChoice 
                                    #tabable: false ) 
                                #(#InputFieldSpec 
                                    #layout: #(#LayoutFrame 70 0 2 0 0 1 25 0 )   
                                    #model: #classPattern ) ) ) )
    "

    "Modified: / 30.1.2000 / 01:15:36 / cg"
!

skippedInLiteralEncoding
    "define the inst-slots which are skipped when generating a literalArrayEncoding;
     (to skip the ones with default values.)"

    |l|

    l := super skippedInLiteralEncoding asOrderedCollection.

    isOpaque isNil      ifTrue:[l add:#isOpaque].
    activeHelpKey isNil ifTrue:[l add:#activeHelpKey].
    self flags == 0     ifTrue:[l add:#flags].

    ^ l

    "Modified: / 24.1.1998 / 14:18:27 / av"
    "Modified: / 3.2.1998 / 19:06:24 / cg"
! !

!NoteBookSpec methodsFor:'defaults'!

viewClass
    "return the corresponding view class of the spec"

    ^ NoteBookView
                  
! !

!NoteBookSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitNoteBookSpec:self
! !

!NoteBookSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/NoteBookSpec.st,v 1.9 2015-05-05 11:13:40 cg Exp $'
! !

