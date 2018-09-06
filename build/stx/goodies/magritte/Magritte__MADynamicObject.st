"{ Package: 'stx:goodies/magritte' }"

"{ NameSpace: Magritte }"

MAProxyObject subclass:#MADynamicObject
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Model-Utility'
!

MADynamicObject comment:'A dynamic object can be used for almost any property within Magritte that is not static but calculated dynamically. This is a shortcut to avoid having to build context sensitive descriptions manually over and over again, however there are a few drawbacks: 
- Some messages sent to this proxy, for example ==#class== and ==#value==, might not get resolved properly.
- Raising an unhandled exception will not always open a debugger on your proxy, because tools are unable to properly work with the invalid object and might even crash your image.'
!


!MADynamicObject methodsFor:'accessing'!

realSubject
        ^ super realSubject on: NoHandlerError "UnhandledError" do: [ :err | nil ]
! !

!MADynamicObject class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/Magritte__MADynamicObject.st,v 1.2 2009-07-30 08:00:46 cg Exp $'
! !
