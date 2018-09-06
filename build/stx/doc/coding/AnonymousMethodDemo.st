"{ Package: 'stx:doc/coding' }"

Object subclass:#AnonymousMethodDemo
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Programming'
!

AnonymousMethodDemo class instanceVariableNames:'fooName'

"
 No other class instance variables are inherited by this class.
"
!

!AnonymousMethodDemo class methodsFor:'documentation'!

documentation
"
    Well, in some paper I read, that Smalltalk would not support
    anonymous methods (messages with a secret selector).
    So, here is an example of how this is done;
    this class defines a method called #foo:, which cannot be called
    directly via a message send (try it).
    However, the name of the method is exported by the #makeFooSecret
    class method to some caller, which can then invoke it via #perform:.
    Another application is via an anonymous function (aka. a block),
    this is demonstrated in the #secretMethodExample2 method.

    How it works:
        pretty simple: it installs a method under a non-symbolic key
        Actually, a unique string is used as selector, which is remembered
        in the fooName class variable.

    PS:
        I dont think of any practical use - although its a neat trick.


    [author:]
         (cg@funkfix)
"
! !

!AnonymousMethodDemo class methodsFor:'secrets'!

addSelector:sel with:aMethod
    sel = fooName ifTrue:[
        self methodDictionary removeKey:fooName.
        fooName := nil.
    ].
    ^ super addSelector:sel withMethod:aMethod
!

makeFooSecret
    |m|

    fooName isNil ifTrue:[
        fooName := 'foo:' copy.

        m := self methodDictionary removeKey:#foo:.
        self methodDictionary at:fooName put:m.
    ].
    ^ fooName.
! !

!AnonymousMethodDemo methodsFor:'example'!

secretMethodExample1
    "call my secret method..."

    |name|

    name := self class makeFooSecret.
    self perform:name with:'dummyArgument'.

    "
     self new secretMethodExample1

     self new foo:'willNotWork'          
     self new perform:#'foo:' with:'willNotWork'
     self new perform:'foo:' with:'willNotWork'
    "
!

secretMethodExample2
    "let someone call my secret method..."

    |name block|

    name := self class makeFooSecret.
    block := [:arg | self perform:name with:arg].

    (EnterBox
        title:'Enter argument for secret message:' 
        action:block) 
        initialText:'hello'; 
        show.

    "
     self new secretMethodExample2
    "
! !

!AnonymousMethodDemo methodsFor:'misc'!

fooCalledWith:argument
    Transcript show:'fooCalledWith:' ; showCR:argument
! !

!AnonymousMethodDemo methodsFor:'secret method'!

foo:arg
    "this will be a non-callable (secret) method,
     after a call to makeFooSecret"

    ^ self fooCalledWith:arg

    "Created: / 31.7.2002 / 10:20:12 / cg"
!

foo:arg
    "this will be a non-callable (secret) method,
     after a call to makeFooSecret"

    ^ self fooCalledWith:arg
! !

!AnonymousMethodDemo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/AnonymousMethodDemo.st,v 1.1 2002-07-31 11:59:59 cg Exp $'
! !
