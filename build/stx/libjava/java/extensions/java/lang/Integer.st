"{ Package: 'stx:libjava' }"

!

!(Java classForName:'java.lang.Integer') class methodsFor:'queries'!

javaWrap: object
	|inst|
    inst := self basicNew.
	inst perform: #'<init>(I)V' with: object.
	^ inst.
! !
!(Java classForName:'java.lang.Integer') class methodsFor:'queries'!

javaWrapRequired
    "Returns true, if a #javaWrap: has to be called
     prior an instance of Smalltalk object is passed 
     as an argument to Java method, whoose formal tyoe
     is the receiver."

    ^true
! !
