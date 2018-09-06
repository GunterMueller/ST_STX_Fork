"
 COPYRIGHT (c) 1994 by Claus Gittinger
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

Method variableSubclass:#WrappedMethod
	instanceVariableNames:''
	classVariableNames:'AllWrappedMethods'
	poolDictionaries:''
	category:'Kernel-Methods'
!

!WrappedMethod class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    support for MessageTracer

    notice: remembers wrappers in a weak classvar, because finding the wrapper for a
    method is required for single stepping, and used to take a long time when using allInstances.
    Therefore, wrappers are remembered.

    [author:]
        Claus Gittinger

    [see also:]
        MessageTracer
"
! !

!WrappedMethod class methodsFor:'registration'!

allInstancesDo:aBlock
    self allWrappedMethodsDo:aBlock
!

allWrappedMethods
    AllWrappedMethods isNil ifTrue:[^ #() ].
    ^ AllWrappedMethods 
        select:[:m |
            "/ must double check - as this is a weak set, it gets cleaned up with a delay.
            m mclass notNil 
        ]    
        as:OrderedCollection

    "
     self allWrappedMethods
    "
!

allWrappedMethodsDo:aBlock
    AllWrappedMethods isNil ifTrue:[^ self ].
    self allWrappedMethods do:aBlock
!

register:aWrappedMethod
    AllWrappedMethods isNil ifTrue:[
        AllWrappedMethods := WeakIdentitySet new.
    ].
    AllWrappedMethods add:aWrappedMethod

    "Created: / 01-07-2011 / 09:44:56 / cg"
!

unregister:aWrappedMethod
    AllWrappedMethods notNil ifTrue:[
        AllWrappedMethods remove:aWrappedMethod ifAbsent:[]
    ].

    "Created: / 01-07-2011 / 10:03:55 / cg"
! !

!WrappedMethod methodsFor:'accessing'!

basicLiterals
    "return my literals"

    ^ super literals

    "Modified: 24.6.1996 / 14:10:34 / stefan"
!

category:newCategory
    super category:newCategory.
    self originalMethod category:newCategory
!

literals
    "return the wrapped method's literals"

    ^ self originalMethod literals
!

literalsDetect:aBlock ifNone:exceptionBlock
    "access the wrapped method's literals"

    ^ self originalMethod literalsDetect:aBlock ifNone:exceptionBlock

    "Created: / 23.1.1998 / 13:23:15 / stefan"
!

literalsDo:aBlock
    "access the wrapped method's literals"

    ^ self originalMethod literalsDo:aBlock

    "Created: / 23.1.1998 / 13:09:36 / stefan"
    "Modified: / 23.1.1998 / 13:22:38 / stefan"
!

methodArgAndVarNames
    "return the names of the args and locals of the wrapped method."

    ^ self originalMethod methodArgAndVarNames
!

methodArgAndVarNamesInContext: context
    "return the names of the args and locals of the wrapped method.
     in given context (for Java, as in java local names differ by 
     actual program counter)"

    ^ self originalMethod methodArgAndVarNamesInContext: context

    "Created: / 18-12-2012 / 18:16:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodVarNames
    "return the names of the locals of the wrapped method."

    ^ self originalMethod methodVarNames 
!

numVars
    "return the number of locals in the wrapped method."

    ^ self originalMethod numVars

    "Created: 4.11.1996 / 21:40:10 / cg"
!

originalMethod
    "return the method the receiver is wrapping"

    "a kludge: it must be in my literal array somewhere"
    super literalsDo:[:aLiteral |
        aLiteral isMethod ifTrue:[
            ^ aLiteral
        ]
    ].
    ^ nil

    "Modified: / 23.1.1998 / 13:08:25 / stefan"
!

originalMethodIfWrapped
    "return the method the receiver is wrapping"

    ^ self originalMethod

    "Created: / 22-10-2010 / 11:45:42 / cg"
!

package:aSymbol
    super package:aSymbol.
    self originalMethod package:aSymbol
!

privacy
    "return the wrapped method's privacy"

    ^ self originalMethod privacy

    "Created: / 23.1.1998 / 13:09:17 / stefan"
    "Modified: / 23.1.1998 / 13:20:59 / stefan"
!

privacy:aSymbol
    "set the wrapped method's privacy"

    ^ self originalMethod privacy:aSymbol
!

programmingLanguage
    ^ (self originalMethod ? self mclass ? Smalltalk) programmingLanguage

    "Modified: / 29-08-2013 / 10:59:20 / cg"
!

replaceOriginalMethodWith:aNewMethod
    "change the original method which is going to be invoked by this wrapper.
     The only place where this makes sense is when the original method has to be 
     replaced by a recompiled breakpointed method (in the debugger)."

    "a kludge: it is in my literal array somewhere"
    1 to:(super numLiterals) do:[:i |
        (super literalAt:i) isMethod ifTrue:[
            super literalAt:i put:aNewMethod.
            ^ self.
        ]
    ].
    ^ self
!

restricted:aBoolean
    ^ self originalMethod restricted:aBoolean
!

setPrivacy:aSymbol
    "set the wrapped method's privacy"

    ^ self originalMethod setPrivacy:aSymbol

    "Modified: / 23.1.1998 / 13:21:26 / stefan"
    "Created: / 23.1.1998 / 15:26:26 / stefan"
!

shadowedMethod
    ^ self originalMethod shadowedMethod

    "Created: / 03-10-2014 / 15:23:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

source
    "return the source of the method"

    ^ self originalMethod source
!

sourceFilename
    "return the sourcefilename if source is extern; nil otherwise"

    ^ self originalMethod sourceFilename

    "Created: / 16-10-2013 / 00:05:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourcePosition
    "return the sourceposition if source is extern; nil otherwise"

    ^ self originalMethod sourcePosition

    "Created: / 16-10-2013 / 00:05:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WrappedMethod methodsFor:'accessing-annotations'!

annotateWith: annotation
    "add a (hidden) annotation"

    ^ self originalMethod annotateWith: annotation

    "Created: / 24-02-2014 / 22:47:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

annotationAt: key
    ^ self originalMethod annotationAt: key

    "Created: / 24-02-2014 / 22:49:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

annotations
    "return the wrapped method's annotations"

    ^ self originalMethod annotations

    "Created: / 04-12-2011 / 11:22:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

annotations: anObject
    self originalMethod annotations: anObject

    "Created: / 24-02-2014 / 22:49:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

annotationsAt: key
    ^ self originalMethod annotationAt: key

    "Created: / 24-02-2014 / 22:49:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

annotationsAt: key1 orAt: key2
    ^ self originalMethod annotationsAt: key1 orAt: key2

    "Created: / 24-02-2014 / 22:50:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

annotationsAt: key1 orAt: key2 do: block
    ^ self originalMethod annotationsAt: key1 orAt: key2 do: block

    "Created: / 24-02-2014 / 22:50:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

annotationsDo: aBlock
    ^ self originalMethod annotationsDo: aBlock

    "Created: / 24-02-2014 / 22:50:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WrappedMethod methodsFor:'misc'!

makeLocalStringSource

    self originalMethod makeLocalStringSource

    "Created: / 11-02-2012 / 19:09:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

register
    self class register:self

    "Created: / 01-07-2011 / 10:03:26 / cg"
!

unregister
    self class unregister:self

    "Created: / 01-07-2011 / 10:03:32 / cg"
! !

!WrappedMethod methodsFor:'printing & storing'!

selectorPrintStringInBrowserFor:selector
    ^ [
        self originalMethod perform:  #selectorPrintStringInBrowserFor: with: selector
    ] on: Object messageNotUnderstoodSignal do:[
        super selectorPrintStringInBrowserFor:selector
    ].

    "Created: / 16-10-2013 / 01:04:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectorPrintStringInBrowserFor:selector class: class
    ^ [
        self originalMethod perform:  #selectorPrintStringInBrowserFor:class: with: selector with: class
    ] on: Object messageNotUnderstoodSignal do:[
        super selectorPrintStringInBrowserFor:selector class: class
    ].

    "Created: / 16-10-2013 / 01:04:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WrappedMethod methodsFor:'printing and storing'!

printOn:aStream
    "put a printed representation of the receiver onto aStream.
     Since methods do not store their class/selector, we have to search
     for it here."

    self basicPrintOn:aStream."/ aStream nextPutAll:(self classNameWithArticle).
    aStream nextPutAll:'(for '.
    aStream nextPutAll:self originalMethod whoString.
    aStream nextPutAll:')'.
! !

!WrappedMethod methodsFor:'private'!

annotationAtIndex: index
    "return annotation at given index.
     any raw annotation array is lazily initialized"

    ^self originalMethod annotationAtIndex: index

    "Created: / 16-12-2011 / 19:54:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

annotationIndexOf: key

    "Returns index of annotation with given key
     or nil if there is no such annotation"

    ^self originalMethod annotationIndexOf: key

    "Created: / 16-12-2011 / 19:53:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WrappedMethod methodsFor:'queries'!

argSignature
    ^ self originalMethod argSignature

    "Created: / 27.1.1999 / 20:23:17 / cg"
!

hasAnnotation
    "Return true iff the method has any annotation"

    ^ self originalMethod hasAnnotation
!

hasResource
    "return the wrapped methods hasResource"

    ^ self originalMethod hasResource
!

isBreakpointed
    "return true, if the receiver is a wrapped method for a breakpoint.
     Ask the messageTracer, since I don't know if its a break or trace"

    ^ (MessageTracer isTrapped:self)

    "Created: 7.4.1997 / 17:25:40 / cg"
!

isMocked
    "Return true, if the method has been mocked (by means of MessageTracer>>mockMethod:do:"

    ^ MessageTracer isMocking: self.

    "Created: / 29-07-2014 / 09:50:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTimed
    "return true, if the receiver is a wrapped method for a time measurement.
     Ask the messageTracer, since I don't know if its a break or trace"

    ^ (MessageTracer isTiming:self)

    "Created: 11.4.1997 / 17:06:14 / cg"
!

isTraced
    "return true, if the receiver is a wrapped method for a trace point.
     Ask the messageTracer, since I don't know if its a break or trace"

    ^ (MessageTracer isTrapped:self) not

    "Created: 7.4.1997 / 17:25:54 / cg"
!

isWrapped
    "return true, if the receiver is a wrapped method.
     True is returned here, since the receiver is always a wrapped one"

    ^ true
!

messagesSent
    "return a collection of message selectors sent by this method"

    ^ self originalMethod messagesSent 
!

messagesSentToSelf
    "return a collection of message selectors sent to self by this method"

    ^ self originalMethod messagesSentToSelf 
!

messagesSentToSuper
    "return a collection of message selectors sent to super by this method"

    ^ self originalMethod messagesSentToSuper 
!

parse:parseSelector with:arg2 return:accessSelector or:valueIfNoSource
    |m|

    (m := self originalMethod) notNil ifTrue:[
        ^ m parse:parseSelector with:arg2 return:accessSelector or:valueIfNoSource
    ].
    ^ valueIfNoSource

    "Created: / 02-08-2013 / 10:57:02 / cg"
!

refersToLiteral: anObject
    ^ self originalMethod refersToLiteral: anObject
!

resources
    "return the wrapped methods resources"

    ^ self originalMethod resources
!

signature
    ^ self originalMethod signature

    "Created: / 14.11.1998 / 00:01:50 / cg"
!

signatureNameWithoutReturnType
    ^ self originalMethod signatureNameWithoutReturnType

    "Created: / 27.1.1999 / 20:52:25 / cg"
! !

!WrappedMethod class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

