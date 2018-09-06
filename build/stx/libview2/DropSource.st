"
 COPYRIGHT (c) 1998 by eXept Software AG / Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

Object subclass:#DropSource
	instanceVariableNames:'receiver argument dropObjectSelector displayObjectSelector
		startDragSelector dropFeedBackSelector'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-DragAndDrop'
!

!DropSource class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG / Claus Gittinger
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
    this class keeps the source from which the drag and drop operation is started.

    receiver                <Object>    the receiver of the drop feedBack; a widget or
                                        application or ....

    argument                <Object>    user defined argument

    startDragSelector       <Symbol>    send to the receiver to start a DragAndDropManager.
                                        If no selector is specified, the default drag & drop
                                        operation is performed. Thus the operator is able
                                        to set the cursor, .... before starting the operation.

    feedBackSelector        <Symbol>    send to the receiver to give a feedBack of the
                                        finished drag & drop operation

    dropObjectSelector      <Symbol>    used to get to get the list of draggable objects.

    displayObjectSelector   <Symbol>    used to get to get the list of display objects.
                                        In case of an empty or undefined list, the draggable
                                        objects are used as display objects.

    [see also:]
        DragAndDropManager
        DropObject
        DropTarget
        DropContext

    [author:]
        Claus Atzkern
"
! !

!DropSource class methodsFor:'instance creation'!

receiver:aReceiver
    ^ self new 
        receiver:aReceiver
!

receiver:aReceiver argument:anArgument
    ^ self new
        receiver:aReceiver 
        argument:anArgument
        dropObjectSelector:nil
        displayObjectSelector:nil
        dropFeedBackSelector:nil
!

receiver:aReceiver argument:anArgument dropObjectSelector:aSelector
    ^ self new 
        receiver:aReceiver 
        argument:anArgument
        dropObjectSelector:aSelector
        displayObjectSelector:nil
        dropFeedBackSelector:nil
!

receiver:aReceiver argument:anArgument dropObjectSelector:s1 displayObjectSelector:s2
    ^ self new 
        receiver:aReceiver 
        argument:anArgument
        dropObjectSelector:s1
        displayObjectSelector:s2
        dropFeedBackSelector:nil
!

receiver:aReceiver argument:anArgument dropObjectSelector:s1 displayObjectSelector:s2 dropFeedBackSelector:s3
    ^ self new 
        receiver:aReceiver 
        argument:anArgument
        dropObjectSelector:s1
        displayObjectSelector:s2
        dropFeedBackSelector:s3
! !

!DropSource methodsFor:'accessing'!

argument
    "returns the user defined argument"

    ^ argument
!

argument:anArgument
    "set the user defined argument"

    argument := anArgument
!

displayObjects
    "returns a collection of display objects or nil"

    displayObjectSelector isNil ifTrue:[
        ^ nil
    ].
    ^ receiver perform:displayObjectSelector withOptionalArgument:self
!

dropObjects
    "returns a collection of objects to drop"

    dropObjectSelector isNil ifTrue:[
        ^ nil
    ].

    ^ receiver perform:dropObjectSelector withOptionalArgument:self
!

receiver
    "return the value of the instance variable 'receiver' (automatically generated)"

    ^ receiver
!

receiver:something
    "set the value of the instance variable 'receiver' (automatically generated)"

    receiver := something.
! !

!DropSource methodsFor:'accessing-selectors'!

displayObjectSelector
    "selector to access the displayObjects; a sequence of String, Text, Icon or Image, LabelAndIcon ...
     If the selector is for a one-arg message, the argument will be the dropSource (self)"

    ^ displayObjectSelector
!

displayObjectSelector:aSelectorWithNoneOrOneArgs
    "selector to access the displayObjects; a sequence of String, Text, Icon or Image, LabelAndIcon ...
     If the selector is for a 1-arg message, the argument will be the dropSource (self)"

    displayObjectSelector := aSelectorWithNoneOrOneArgs.
!

dropFeedBackSelector
    "selector of a 1-arg message sent at end of a drop operation (to give a feedback); 
     the argument to the message is the dropContext"

    ^ dropFeedBackSelector
!

dropFeedBackSelector:aSelectorWithZeroOrOneArgs
    "selector of a 1-arg message sent at end of a drop operation (to give a feedback); 
     the argument to the message is the dropContext"

    dropFeedBackSelector := aSelectorWithZeroOrOneArgs.
!

dropObjectSelector
    "selector to access the draggable objects; a sequence of DropObjects.
     If the selector is for a 1-arg message, the argument will be the dropSource (self)"

    ^ dropObjectSelector
!

dropObjectSelector:aSelectorWithNoneOrOneArgs
    "selector to access the draggable objects; a sequence of DropObjects.
     If the selector is for a 1-arg message, the argument will be the dropSource (self)"

    dropObjectSelector := aSelectorWithNoneOrOneArgs.
!

startDragSelector
    "send to the receiver to start a DragAndDropManager. 
     If no selector is specified, the default drag & drop operation is performed.
     Thus the operator is able to set the cursor, .... before starting the operation.

     the (optional) arguments to the message are:
        1       dropSource (self)  
        2       dropSource (self)      Widget
        3       dropSource (self)      Widget    Point
    "

    ^ startDragSelector
!

startDragSelector:aTwoOrThreeArgSelector
    "send to the receiver to start a DragAndDropManager. If no selector is specified,
     the default drag & drop operation is performed.
     Thus the operator is able to set the cursor, .... before starting the operation.

     the (optional) arguments to the message are:
        1       dropSource (self)  
        2       dropSource (self)      Widget
        3       dropSource (self)      Widget    Point
    "

    startDragSelector := aTwoOrThreeArgSelector
! !

!DropSource methodsFor:'actions'!

dropFeedBackFrom:aDropContext
    "drop feedback to receiver"

    dropFeedBackSelector isNil ifTrue:[
        ^ self
    ].

    ^ receiver perform:dropFeedBackSelector withOptionalArgument:aDropContext
!

startDragIn:aView at:aPoint
    "start drag operation for a widget"

    startDragSelector notNil ifTrue:[
        ^ receiver perform:startDragSelector withOptionalArgument:self and:aView and:aPoint
    ].    

    "/
    "/ the default
    "/
    ^ DragAndDropManager startDragFrom:aView dropSource:self
! !

!DropSource methodsFor:'instance creation'!

receiver:aReceiver argument:anArgument dropObjectSelector:s1 displayObjectSelector:s2 dropFeedBackSelector:s3
    receiver              := aReceiver.
    argument              := anArgument.
    dropObjectSelector    := s1.
    displayObjectSelector := s2.
    dropFeedBackSelector  := s3.
! !

!DropSource methodsFor:'obsolete'!

feedBackSelector
    "selector called at end of a drop to give a feedback; the argument to
     the selector is the dropContext"

    <resource: #obsolete>    

    "/ self obsoleteMethodWarning:'use dropFeedBackSelector'.
    ^ self dropFeedBackSelector
!

feedBackSelector:aSelectorWithZeroOrOneArgs
    "selector called at end of a drop to give a feedback; the argument to
     the selector is the dropContext"

    <resource: #obsolete>    

    "/ self obsoleteMethodWarning:'use dropFeedBackSelector:'.
    self dropFeedBackSelector:aSelectorWithZeroOrOneArgs.
! !

!DropSource class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/DropSource.st,v 1.7 2008-03-20 12:17:56 ca Exp $'
! !
