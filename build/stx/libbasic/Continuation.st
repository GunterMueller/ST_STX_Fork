"
 COPYRIGHT (c) 2004 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

Object subclass:#Continuation
	instanceVariableNames:'process id suspendContext'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Processes'
!

Continuation comment:'declared from: ..\..\..\stx\libbasic\abbrev.stc'
!

!Continuation class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
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
    Initial attempt - Unfinished.
    Continuations do not work yet - there is more support needed in the VM.

    [Instance variables:]

	id                     <SmallInteger>   a unique continuation-id;
						Used to identify a corresponding
						data-structure in the VM.

	process                <Process>        the process which created this continuation.

    [Class variables:]

    [see also:]
	Process Context Block

    [author:]
	Claus Gittinger
"
!

supported
    ^ false
! !

!Continuation class methodsFor:'instance creation'!

current
    "this is called current-continuation in scheme"

    |cont id|

    cont := self basicNew.
%{
    int __cId;
    extern int __continuationCreate();

    __cId = __continuationCreate(cont);
    if (__cId > 0) {
        id = __mkSmallInteger(__cId);
    }
%}.
    id isNil ifTrue:[
        self error:'could not create continuation' mayProceed:true.
        ^ nil.
    ].
    cont setId:id process:(Processor activeProcess).
    ^ cont

    "
     self current
    "

    "Modified: / 25-07-2013 / 11:37:27 / cg"
!

currentDo: aBlock
    "this is is called call/cc in scheme"

    ^ aBlock value:self current

    "Modified: / 29-11-2006 / 10:14:03 / cg"
    "Modified (comment): / 25-07-2013 / 11:37:00 / cg"
!

new
    self error:'continuations must be created with #current'

    "Modified: / 29-11-2006 / 10:13:19 / cg"
! !

!Continuation methodsFor:'invocation'!

argumentCount
    "VisualAge/ANSI compatibility"

    ^ 1
!

numArgs
	^ 1
!

value
	self value: nil
!

value: v
    |cID|

    (cID := id) notNil ifTrue:[
%{
        __continuationResume(__intVal(cID));
%}
    ].
    self shouldImplement. 

"/        self terminate: thisContext.
"/        self restoreValues.
"/        thisContext swapSender: values first.
"/        ^v
!

valueWithArguments: v
	v size == 1 ifFalse: [^self error: 'continuations can only be resumed with one argument'].
	self value: v first
! !

!Continuation methodsFor:'private'!

terminate: aContext
    self shouldImplement. 
"/        | context |
"/        context _ aContext.
"/        [context notNil] whileTrue: [context _ context swapSender: nil]
! !

!Continuation methodsFor:'private accessing'!

finalize
    |cId|

    (cId := id) notNil ifTrue:[
	id := nil.
%{
	__continuationDestroy(__intVal(cId));
%}
    ].
!

setId:idArg process:aProcess
    id := idArg.
    process := aProcess.
    self registerForFinalization.
! !

!Continuation methodsFor:'restoration'!

restoreValues
    self shouldImplement. 
"/        | valueStream context |
"/
"/        valueStream _ values readStream.
"/        [valueStream atEnd] whileFalse:
"/                [context _ valueStream next.
"/                1 to: context class instSize do: [:i | context instVarAt: i put: valueStream next].
"/                1 to: context localSize do: [:i | context localAt: i put: valueStream next]]
! !

!Continuation class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/Continuation.st,v 1.16 2013-07-25 09:37:35 cg Exp $'
!

version_SVN
    ^ '$Id: Continuation.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !

