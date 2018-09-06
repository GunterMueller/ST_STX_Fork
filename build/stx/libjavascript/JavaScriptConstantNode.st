"{ Package: 'stx:libjavascript' }"

ConstantNode subclass:#JavaScriptConstantNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-JavaScript-Framework'
!


!JavaScriptConstantNode methodsFor:'printing and storing'!

printOn:aStream indent:i
    self printValue:value on:aStream indent:i
!

printValue:value on:aStream indent:i
    value isArray ifTrue:[
        aStream nextPutAll:'['.
        value 
            do:[:eachValue |
                self printValue:eachValue on:aStream indent:i
            ]
            separatedBy:[
                aStream nextPutAll:', '
            ].
        aStream nextPutAll:']'.
        ^ self.
    ].
    value == nil ifTrue:[
        aStream nextPutAll:'null'.
        ^ self.
    ].

    value storeOn:aStream
! !

!JavaScriptConstantNode class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptConstantNode.st,v 1.2 2014-05-12 20:30:51 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjavascript/JavaScriptConstantNode.st,v 1.2 2014-05-12 20:30:51 cg Exp $'
! !

