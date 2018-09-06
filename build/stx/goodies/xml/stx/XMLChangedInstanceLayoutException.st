"{ Package: 'stx:goodies/xml/stx' }"

XML::InvalidSignal subclass:#XMLChangedInstanceLayoutException
	instanceVariableNames:'instVarName valueToBeStored'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-Presentation'
!

!XMLChangedInstanceLayoutException class methodsFor:'documentation'!

documentation
"
    Raised by the decoder if an instance variable is no longer present, 
    when reading an object's description. 
    If proceeded, the decoder assumes that the handler somehow fixed the situation.

    [parameters:]
        classOfObject           
        instVarName
        valueToBeStored

    [author:]
        Claus Gittinger

    [see also:]
        XMLStandardDecoder
"
! !

!XMLChangedInstanceLayoutException methodsFor:'accessing'!

instVarName
    ^ instVarName
!

instVarName:something
    instVarName := something.
!

parent
    ^ parameter

    "Created: / 09-11-2007 / 14:29:48 / cg"
!

parent:something
    parameter := something.

    "Created: / 09-11-2007 / 14:29:36 / cg"
!

parent:parentArg instVarName:instVarNameArg valueToBeStored:valueToBeStoredArg 
    parameter := parentArg.
    instVarName := instVarNameArg.
    valueToBeStored := valueToBeStoredArg.

    "Created: / 09-11-2007 / 14:30:20 / cg"
!

valueToBeStored
    ^ valueToBeStored
!

valueToBeStored:something
    valueToBeStored := something.
! !

!XMLChangedInstanceLayoutException class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/stx/XMLChangedInstanceLayoutException.st,v 1.1 2007-11-09 13:33:09 cg Exp $'
! !
