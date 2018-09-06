"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava' }"

"{ NameSpace: Smalltalk }"

Context variableSubclass:#JavaContext
	instanceVariableNames:'exArg exPC byteCode constPool acqrMonitors'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Support'
!

Object subclass:#FinallyToken
	instanceVariableNames:'context exception selector value'
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaContext
!

!JavaContext class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
! !

!JavaContext class methodsFor:'accessing'!

finallyTokenClass
    ^FinallyToken

    "Created: / 18-04-2013 / 23:46:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaContext methodsFor:'* As yet uncategorized *'!

markForException
    "set the exception handler flag in the receiver.
     The JVM needs this to enter an exception handler instead of restarting
     from the beginning (when the context is restarted).
     - a highly internal mechanism and not for public use."
"
%{  /* NOCONTEXT */
#ifdef __JAVA_EX_PEND
     /* actually no longer - only a non-nil exPC is now used as marker */
     __INST(flags) = (OBJ)((INT)__INST(flags) | __MASKSMALLINT(__JAVA_EX_PEND));
#endif
%}
"

    "Modified: / 13-12-1995 / 19:05:22 / cg"
    "Modified: / 25-10-2010 / 17:19:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shouldExecuteFinallyOnUnwind
    "Return true, if a finally block should be executed
     upon force unwind"

    | m pc |

    m := self method.
    pc := self pc.
    self assert: m notNil.
    m hasFinally ifFalse:[ ^ false ].
    ^(method handlerFor: nil at: pc) notNil.

    "Created: / 10-04-2012 / 11:09:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaContext methodsFor:'ST context mimicri'!

arg1Index
    "the java stack contains the receiver in a non-static
     method, as slot 0. Therefore, the first arg is found at slot2
     if this is for a non-static method"

    self method isStatic ifTrue:[
	^ 1
    ].
    ^ 2
!

argAt:n
    "return the i'th argument (1..nArgs)"

    ^ self at:(self arg1Index - 1 + n)

    "Created: / 2.1.1998 / 17:54:13 / cg"
    "Modified: / 2.1.1998 / 21:39:30 / cg"
!

argAt:n put:value
    "change the i'th argument (1..nArgs)"

    ^ super argAt:(self arg1Index - 1 + n) put:value

    "Created: / 2.1.1998 / 17:54:34 / cg"
    "Modified: / 2.1.1998 / 21:35:19 / cg"
!

args
    "return an array filled with the arguments of this context"

    |n|

    n := self numArgs.
    n == 0 ifTrue:[
	"/ little optimization here - avoid creating empty containers
	^ #()
    ].

    ^ (Array new:n) replaceFrom:1 to:n with:self startingAt:(self arg1Index).

    "Created: / 2.1.1998 / 17:54:57 / cg"
    "Modified: / 2.1.1998 / 21:34:44 / cg"
!

lineNumber
    |nr pc|

    pc := self pc.

"/ 'ask line for pc:' print. pc printCR.
    pc isNil ifTrue:[
	nr := self lineNumberFromMethod.
	nr notNil ifTrue:[
	    ^ nr
	].
	" '-> 0 [a]' printCR. "
	^0
    ].

    nr := self method lineNumberForPC:pc.
    nr isNil ifTrue:[
	nr := self lineNumberFromMethod.
	nr notNil ifTrue:[
	    ^ nr
	].
	" '-> 0 [b]' printCR. "
	^ 0
    ].
"/ '-> ' print. nr printCR.
     ^ nr.

    "Created: / 1.5.1996 / 15:05:47 / cg"
    "Modified: / 15.1.1998 / 15:25:29 / cg"
!

lineNumberFromMethod
    |m|

    m := self method.
    m notNil ifTrue:[
	^ m lineNumber
    ].
    ^ nil

    "Created: / 4.1.1998 / 23:34:45 / cg"
    "Modified: / 4.1.1998 / 23:35:55 / cg"
!

method
    "the method may be found in the interpreter temps ..."

    method isJavaMethod ifTrue:[^ method].
    ^ super method

    "Created: / 1.5.1996 / 15:03:43 / cg"
    "Modified: / 25.9.1999 / 23:26:40 / cg"
!

numArgs
    "return the number of args.
     Redefined since Java keeps the receiver of a non-static method
     at local slot 1."

    |n|

    n := super numArgs.
    self method isStatic ifFalse:[
	n := n - 1
    ].
    ^ n

    "Created: / 2.1.1998 / 22:21:24 / cg"
!

numTemps
    "return the number of temporary variables of the Method.
     Redefined since Java keeps the receiver of a non-static method
     at local slot 1."

    |n|

    n := self size - super numVars - super numArgs.
    ^ n

    "Created: / 13.1.1998 / 16:52:32 / cg"
    "Modified: / 13.1.1998 / 17:23:27 / cg"
!

pc
    lineNr isNil ifTrue:[^ nil].
    ^ lineNr bitAnd:16rFFFF

    "Created: / 4.1.1998 / 23:33:48 / cg"
    "Modified: / 10.11.1998 / 13:20:12 / cg"
!

selector
    "the selector can be extracted from the method.
     the method may be found in the interpreter temps ..."

    |s m|

    selector isNil ifTrue:[
	m := self method.
	m notNil ifTrue:[
	    ^ m name
	]
    ].
    ^ super selector

    "Modified: / 30.12.1997 / 17:22:06 / cg"
    "Created: / 30.12.1997 / 17:23:47 / cg"
!

setPC:newPC
    lineNr := newPC

    "Created: / 5.1.1998 / 00:09:02 / cg"
!

temporaries
    "return an array filled with the arguments and variables of this context"

    |n nSkipped|

    "/ the flas-numVars includes the receiver and args
    nSkipped := super numVars "self numArgs + self numVars".
    "/ but my context setup is args+numvars.
    nSkipped := super numArgs + super numVars.

    n := self size - nSkipped.
    n == 0 ifTrue:[
	"/ little optimization here - avaoid creating empty containers
	^ #()
    ].

    ^ (Array new:n) replaceFrom:1 to:n with:self startingAt:nSkipped+1.

    "Created: / 13.1.1998 / 15:44:12 / cg"
    "Modified: / 13.1.1998 / 17:22:54 / cg"
!

vars
    "return an array filled with the local variables of this context"

    |nonVars mySize|

    mySize := self numVars.
    mySize == 0 ifTrue:[
	"/ little optimization here - avaoid creating empty containers
	^ #()
    ].
    nonVars := (self arg1Index-1) + self numArgs.
    ^ (Array new:mySize) replaceFrom:1 to:mySize with:self startingAt:nonVars+1

    "Created: / 13.1.1998 / 16:48:16 / cg"
! !

!JavaContext methodsFor:'accessing'!

acquiredMonitors
    ^acqrMonitors

    "Created: / 08-11-2011 / 12:23:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 27-08-2012 / 16:46:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

acquiredMonitorsDo: aBlock 
"/    acqrMonitors isNil ifTrue: [ ^self ].
"/    acqrMonitors copy reverseDo: aBlock.
    aBlock value: self receiver.

    "Created: / 08-11-2011 / 15:03:31 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 26-08-2012 / 19:28:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addMonitor:mon 
    self assert:(acqrMonitors isNil or:[ acqrMonitors isOrderedCollection ]).
    acqrMonitors isNil ifTrue:[
        acqrMonitors := Stack new
    ].
    acqrMonitors push:mon.
    self markForUnwind.

    "Created: / 08-11-2011 / 14:19:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 17-11-2011 / 19:13:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 04-08-2014 / 15:54:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

argsAndVars
    "return an array filled with the arguments and variables of this context"

    |rawArgsAndVars|

    rawArgsAndVars := self method originalMethodIfWrapped methodArgAndVarValuesInContext: self.
"/    self method isStatic ifFalse:[^ rawArgsAndVars copyFrom:2].
    ^ rawArgsAndVars

    "Created: / 04-11-2013 / 18:45:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-08-2014 / 23:04:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodFromClass
    "Return the up-to-date method. Actyally, it fetches the method
     from receiver's class"

    |c sender sendersSelector m|

    "mhmh - maybe I am a context for an unbound method (as generated by doIt);
     look in the sender's context. Consider this a kludge.
     Future versions of ST/X's message lookup may store the method in
     the context.
    "
    sender := self sender.
    sender notNil ifTrue:[
        sendersSelector := sender selector.
        sendersSelector notNil ifTrue:[
            (sendersSelector startsWith:'valueWithReceiver:') ifTrue:[
                m := sender receiver.
                m isMethod ifTrue:[
                    method := m.
                    ^ m
                ]
            ]
        ]
    ].

    c := self searchClass.
    "
     the below cannot happen in normal circumstances
     (added to avoid recursive errors in case of a broken sender chain)
    "
    c isBehavior ifFalse:[
        'Context [error]: non class in searchClass' errorPrintCR.
        '      selector: ' errorPrint. selector errorPrint.
        ' receiver: ' errorPrint. receiver errorPrintCR.
        ^ nil
    ].

    c := c whichClassIncludesSelector:selector.
    c notNil ifTrue:[
        method := c compiledMethodAt:selector.
        ^ method
    ].

    ^ nil

    "Created: / 09-08-2013 / 02:25:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

programmingLanguage

    ^JavaLanguage instance

    "Created: / 17-03-2011 / 10:17:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removeMonitor: mon 
    | poppedObject |
    acqrMonitors isNil ifTrue: [
        Logger 
            log: ('removeMonitor: called but no monitors in acqrMonitors (%1)' 
                    bindWith: self)
            severity: Logger severityWARN
            facility: #JVM.
        self breakPoint: #mh.
        ^ self.
    ].
    poppedObject := acqrMonitors top.
    self assert: (poppedObject == mon).
    acqrMonitors remove: mon
        ifAbsent: [
            Logger 
                log: ('removeMonitor: called but no such monitor in acqrMonitors (%1)' 
                        bindWith: self)
                severity: Logger severityWARN
                facility: #JVM.
            self breakPoint: #mh.
            ^ self.
        ].
        acqrMonitors isEmpty ifTrue: [self unmarkForUnwind].

    "Created: / 08-11-2011 / 14:19:58 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 17-11-2011 / 19:14:29 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-03-2015 / 14:07:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaContext methodsFor:'exception handler support'!

exceptionArg:aJavaException
    exArg := aJavaException.

    "Created: / 7.1.1998 / 21:36:56 / cg"
!

exceptionArg:aJavaException pc:newPc
    exArg := aJavaException.
    exPC := newPc.

    "Created: / 7.1.1998 / 21:36:56 / cg"
! !

!JavaContext methodsFor:'non local control flow'!

restart
    "Update the bytecode before restarting so
     bytecode interpreter can execute new code, if any"

    | m |

    m := self methodFromClass.
    m notNil ifTrue:[
         byteCode := m byteCode.
         constPool := m constantPool.
    ].
    ^super restart.

    "Created: / 19-04-2013 / 13:33:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-08-2013 / 02:33:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

return
    selector last == $V ifTrue:[ ^ self return:nil  ].
    selector last == $; ifTrue:[ ^ self return:nil  ].
    selector last == $D ifTrue:[ ^ self return:0.0  ].
    selector last == $F ifTrue:[ ^ self return:0.0 asShortFloat  ].
    ^self return: 0

    "Created: / 18-04-2013 / 23:52:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unwindAndRestartForJavaException

    "Called by JavaVM>>throwException: unwinds the stack
     up to this context and restarts it so an exception handler
     executes"

    | con wasMarked |

    "Each context that has a monitor acquired has
     and unwind action that release all monitors acquired.
     However, we DONT want my monitors to be released,
     so we temporarily unmark this context for unwind and
     then mark it again, eventually"

    wasMarked := self isUnwindContext.
    wasMarked ifTrue:[self unmarkForUnwind].    
    self senderIsNil ifFalse:[
        con := thisContext evaluateUnwindActionsUpTo:self.
    ].
    wasMarked ifTrue:[self markForUnwind].

    "oops, if nil, I am not on the calling chain;
     (bad bad, unwind action have already been performed.
      should we check for this situation first and NOT evaluate
      the unwind actions in this case ?)
    "
    con isNil ifTrue:[
        "
         tried to return to a context which is already dead
         (i.e. the method/block has already executed a return)
        "
        ^ self invalidReturnOrRestartError:#'unwindAndRestart:' with:nil
    ].
    "
     now, that all unwind-actions are done, I can use the
     low-level restart ...
    "
    ^ self restart

    "Created: / 08-11-2011 / 22:00:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaContext methodsFor:'printing & storing'!

printOn:aStream
    "append a brief description (excl. arguments) of the receiver onto aStream"

    self printReceiverOn:aStream.
    "/ aStream nextPutAll:' '.
    aStream nextPutAll:' >> '.

    aStream bold.
    self selector printOn:aStream.    "show as string (as symbol looks too ugly in browser ...)"
    "/ self selector storeOn:aStream.    "show as symbol"
    aStream normal.
    aStream space.
    (method notNil and:[method isWrapped]) ifTrue:[
        aStream nextPutAll:'(wrapped) '
    ].
    aStream nextPutAll:' ['; nextPutAll:(self method lineNumberForPC0: lineNr) printString; nextPutAll:']' .

    "Created: / 12-09-2013 / 23:02:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

receiverPrintString
    "return a string describing the receiver of the context"

    |receiverClass receiverClassName newString implementorClass searchClass|

"/ %{
"/     /*
"/      * special handling for (invalid) free objects.
"/      * these only appear if some primitiveCode does not correctly use SEND macros,
"/      * which may lead to sends to free objects. In normal operation, this 'cannot' happen.
"/      */
"/     if (__isNonNilObject(__INST(receiver)) && (__qClass(__INST(receiver))==nil)) {
"/         receiverClassName = __MKSTRING("FreeObject");
"/     }
"/ %}.
"/    receiverClassName notNil ifTrue:[^ receiverClassName].

    receiverClass := receiver class.
    "/ java has no class-methods ...
    receiverClass := receiverClass theNonMetaclass.

    receiverClassName := receiverClass nameInBrowser.
    (receiverClass == SmallInteger) ifTrue:[
	newString := '(' , receiver printString , ') ' , receiverClassName
    ] ifFalse:[
	newString := receiverClassName
    ].

    "
     kludge to avoid slow search for containing class
    "
    (selector ~~ #doIt and:[selector ~~ #doIt:]) ifTrue:[
	implementorClass := self methodClass.
    ].
    implementorClass notNil ifTrue: [
	(implementorClass ~~ receiverClass) ifTrue: [
	    newString := newString , '>>>',
			 implementorClass nameInBrowser printString
	]
    ] ifFalse:[
	searchClass := self searchClass.
	searchClass ~~ receiverClass ifTrue:[
	    newString := newString , '>>>' , searchClass nameInBrowser
	].
"/        "
"/         kludge for doIt - these unbound methods are not
"/         found in the classes methodDictionary
"/        "
"/        (selector ~~ #doIt and:[selector ~~ #doIt:]) ifTrue:[
"/            newString := newString , '>>>**NONE**'
"/        ]
    ].

    ^ newString
! !

!JavaContext methodsFor:'queries'!

hasStackToShow
    "private interface to the debugger.
     Smalltalk contexts return false here - other language frames
     (i.e. Java frames) may want to show the evaluation stack"

    ^ true

    "Modified: / 13.5.1997 / 16:31:12 / cg"
    "Created: / 7.5.1998 / 01:23:57 / cg"
!

isJavaContext
    "return true, if this is a javaContext."

    ^ true

    "Created: / 8.5.1998 / 21:23:47 / cg"
!

stackFrame
    "private interface to the debugger."

    ^ (1 to:self size) collect:[:i | self at:i]

    "Created: / 7.5.1998 / 01:26:19 / cg"
! !

!JavaContext::FinallyToken methodsFor:'accessing'!

context
    ^ context
!

context:something
    context := something.
!

exception
    ^ exception
!

exception:something
    exception := something.
!

selector
    ^ selector
!

selector:something
    selector := something.
!

value
    ^ value
!

value:something
    value := something.
! !

!JavaContext::FinallyToken methodsFor:'actions'!

pass

    selector == #return ifTrue:[
        thisContext evaluateUnwindActionsUpTo:context.    
        context return
    ].
    selector == #return: ifTrue:[
        thisContext evaluateUnwindActionsUpTo:context.    
        context return: value
    ].

    self error:'Should never be reached'.

    "Created: / 04-04-2012 / 20:24:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-10-2013 / 10:13:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaContext class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/JavaContext.st,v 1.45 2015-03-20 12:08:00 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaContext.st,v 1.45 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

