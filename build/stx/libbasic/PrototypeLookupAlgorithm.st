"{ Package: 'stx:libbasic' }"

Object subclass:#PrototypeLookupAlgorithm
	instanceVariableNames:''
	classVariableNames:'TheOneAndOnlyInstance'
	poolDictionaries:''
	category:'Kernel-Extensions'
!

!PrototypeLookupAlgorithm class methodsFor:'documentation'!

documentation
"
    this is a dummy lookupAlgorithm class to demonstrate the meta-object-protoocol support.
    Create a sumclass of me, redefine the lookupmethod to return a method proper.
    If it returns nil, a doesNotUnderstand will be sent, as usual.

    This class does nothing real - it duplicates the algorithm as found in the VM.

    obsoleted by Lookup

    [author:]
        cg (cg@CG-PC)

    [see also:]
        jan Vrany's paper on Smalltalk's Meta-Object-Protocol proposal.
"
!

examples
"
    this is only a test for the lookup; when installed as a class's lookupObject,
    the lookup will be called from the VM for instances of that class.

    |mthd|

    mthd := self new
                lookupMethodForSelector:#squared 
                directedTo:nil 
                for:100 
                withArguments:nil 
                from:nil.
    mthd valueWithReceiver:100 arguments:#().     
"
! !

!PrototypeLookupAlgorithm class methodsFor:'instance creation'!

new
    TheOneAndOnlyInstance isNil ifTrue: [
        TheOneAndOnlyInstance := super new.
    ].
    ^ TheOneAndOnlyInstance
! !

!PrototypeLookupAlgorithm methodsFor:'lookup'!

lookupMethodForSelector:aSelector directedTo:searchClass for:aReceiver withArguments:argArrayOrNil from:sendingContext
    "invoked by the VM to ask me for a method to call.
     The arguments are: the selector, receiver and arguments,
     the class to start the search in (for here-, super and directed sends)
     the sending context.

     The returned method object will be put into the inline- and polyCache
     at the call site; it might therefore be called more than once for the
     same receiver-class/selector combination (once for each call site).
     If I return nil, a doesNotUnderstand will be invoked."

     |cls md method|

     cls := searchClass.
     cls isNil ifTrue:[ cls := aReceiver class ].
     [ cls notNil ] whileTrue:[
        md := cls methodDictionary.
        method := md at:aSelector ifAbsent:nil.
        method notNil ifTrue:[^ method ].
        cls := cls superclass.
     ].
     ^ nil
! !

!PrototypeLookupAlgorithm class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/PrototypeLookupAlgorithm.st,v 1.5 2011-06-28 11:58:00 cg Exp $'
! !
