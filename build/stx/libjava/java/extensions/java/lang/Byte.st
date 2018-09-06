"{ Package: 'stx:libjava' }"

!

!(Java classForName:'java.lang.Byte') class methodsFor:'* proxies *'!

javaWrap: object
	|inst|
    inst := self basicNew.
    inst perform: #'<init>(B)V' with: object.
	^ inst.
! !
!(Java classForName:'java.lang.Byte') class methodsFor:'* proxies *'!

javaWrapRequired
    "Returns true, if a #javaWrap: has to be called
     prior an instance of Smalltalk object is passed 
     as an argument to Java method, whoose formal tyoe
     is the receiver."

    ^true
! !
