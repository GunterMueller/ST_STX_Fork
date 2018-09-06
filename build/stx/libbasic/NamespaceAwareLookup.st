"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
 COPYRIGHT (c) 2010 Jan Vrany
 COPYRIGHT (c) 2016 Jan Vrany
	      All Rights Reserved

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the 'Software'), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Lookup subclass:#NamespaceAwareLookup
	instanceVariableNames:''
	classVariableNames:'Instance'
	poolDictionaries:''
	category:'Kernel-Extensions'
!

!NamespaceAwareLookup class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
 COPYRIGHT (c) 2010 Jan Vrany
 COPYRIGHT (c) 2016 Jan Vrany
	      All Rights Reserved

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the 'Software'), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
"
! !

!NamespaceAwareLookup class methodsFor:'initialization'!

initialize

    Instance := self basicNew

    "Created: / 10-07-2010 / 21:12:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NamespaceAwareLookup class methodsFor:'accessing'!

instance

    ^Instance

    "Created: / 20-05-2010 / 11:18:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-07-2010 / 21:12:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NamespaceAwareLookup class methodsFor:'lookup'!

lookupMethodForSelector: selector directedTo: initialSearchClass for: receiver withArguments: argArrayOrNil from: sendingContext ilc: ilc

    "JV @ 2010-07-24
     Following C code is just a performance optimization.
     It is not necessary, however it speeds things in most
     cases. Such optimization significantly speeds up the IDE
     since class browser involves dozens of super-polymorphic
     sends (> 1000 receiver classes per send-site).
        "

%{
    OBJ sendingMthd = nil;
    OBJ ctx = sendingContext;
    while ( ctx && 
          (__isLazy(ctx) 
                ? __isLazyBCon(ctx) 
                : __qIsBlockContextLike(ctx))) {
        ctx = __ContextInstPtr(ctx)->c_home;
    }
    if ( (ctx != nil) &&
	 (((INT)(__ContextInstPtr(ctx)->c_flags) & __MASKSMALLINT(__METHOD_VALID))) ) {
        sendingMthd = __ContextInstPtr(sendingContext)->c_method;	 
    }
	          
    if (__Class(sendingMthd) == Method &&
            __MethodInstPtr(sendingMthd)->m_annotation == nil) {
            OBJ m = __lookup(initialSearchClass, selector);
            if (m != nil) RETURN ( m );
    }
%}.

    ^Instance lookupMethodForSelector: selector directedTo: initialSearchClass
                          for: receiver withArguments: argArrayOrNil
                          from: sendingContext
			  ilc: ilc
! !

!NamespaceAwareLookup methodsFor:'lookup'!

lookupMethodForSelector: selector directedTo: initialSearchClass for: receiver withArguments: argArrayOrNil from: sendingContext ilc: ilcCache
    "Invoked by the VM to ask me for a method to fire.
     For details, see comment inLookup>>lookupMethodForSelector:directedTo:for:withArguments:from:"

    | sendingNs sendingMthd queue seen namespaces methods imports numMethods|

    "JV @ 2010-07-24
     Following C code is just a performance optimization.
     It is not necessary, however it speeds things in most
     cases. Such optimization significantly speeds up the IDE
     since class browser involves dozens of super-polymorphic
     sends (> 1000 receiver classes per send-site).
    "
    
%{    
    OBJ ctx = sendingContext;
    sendingMthd = nil;
    while ( ctx && 
          (__isLazy(ctx) 
                ? __isLazyBCon(ctx) 
                : __qIsBlockContextLike(ctx))) {
        ctx = __ContextInstPtr(ctx)->c_home;
    }
    if ( (ctx != nil) &&
	 (((INT)(__ContextInstPtr(ctx)->c_flags) & __MASKSMALLINT(__METHOD_VALID))) ) {
        sendingMthd = __ContextInstPtr(ctx)->c_method;	 
    }

    if (__Class(sendingMthd) == Method &&
            __MethodInstPtr(sendingMthd)->m_annotation == nil) {
            OBJ m = __lookup(initialSearchClass, selector);
            if (m != nil) {
                if (ilcCache != nil) __ilcBind(ilcCache, initialSearchClass, m, selector);
                RETURN ( m );
            }
    }
%}.
    "If you remove C code above, uncomment the line below."
    "sendingMthd := sendingContext method."
    sendingNs := sendingMthd isNil
            ifTrue:[nil]
            ifFalse:[sendingMthd nameSpace].

        "Second chance to speed up things (in case sending method
         has resource or so)"
%{
    if (sendingNs == nil) {
        OBJ m = __lookup(initialSearchClass, selector);
        if (m != nil) {
            if (ilcCache != nil) __ilcBind(ilcCache, initialSearchClass, m, selector);
            RETURN ( m );
        }
    }
%}.
    "
    Stderr
            show: 'sel='; show: selector; show: ' ns='; show: sendingNs printString;
            show: ' method=', sendingMthd printString; cr.
        "
    sendingNs notNil ifTrue: [
        seen := Set new.
        namespaces := Array with: sendingNs.

        [namespaces notEmpty] whileTrue:[
            methods := self
                        lookupMethodsForSelector: selector
                        directedTo: initialSearchClass
                        inNamespaces: namespaces.
            numMethods := methods size.
            numMethods == 1 ifTrue:[
                ^ methods anyOne
            ].
            numMethods > 1 ifTrue:[
                ^self ambiguousMessageSend: selector withArgs: argArrayOrNil
            ].
            "No method found"
            seen addAll: namespaces.
            imports := Set new.
            namespaces do:[:namespace|
                namespace notNil ifTrue:[
                    namespace imports do:[:import|
                        (seen includes: import) ifFalse: [
                            imports add: import
                        ]
                    ]
                ]
            ].
            namespaces := imports
        ].
    ].

    methods := self lookupMethodsForSelector: selector
                        directedTo: initialSearchClass.
    methods size == 1 ifTrue:[
        | m |

        m := methods anyOne.
        ilcCache notNil ifTrue:[ ilcCache bindTo: m forClass: initialSearchClass ].
        ^ m
    ].

    ^nil

    "Created: / 19-02-2014 / 21:49:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-06-2016 / 07:32:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NamespaceAwareLookup methodsFor:'lookup - helpers'!

lookupMethodsForSelector: selector directedTo: initialSearchClass
    "Searches initialSearchClass for a methods with in any namespace"

    ^self
	lookupMethodsForSelector: selector
	directedTo: initialSearchClass
	suchThat:[:sel :mthd|true].

    "Created: / 19-07-2010 / 15:37:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lookupMethodsForSelector: selector directedTo: initialSearchClass inNamespaces: namespaces
    "Searches initialSearchClass for a methods with given selector in given namespaces."

    ^self
	lookupMethodsForSelector: selector
	directedTo: initialSearchClass
	suchThat:[:sel :mthd|namespaces includes: mthd nameSpace].

    "Created: / 19-07-2010 / 15:13:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lookupMethodsForSelector: selector directedTo: initialSearchClass suchThat: block
    "Searches initialSearchClass for a method with given selector in given nameSpace.

     if no method in given namespace is found, returns nil"

    | searchClass methods seen |

    searchClass := initialSearchClass.
    methods := Set new.
    seen := OrderedCollection new.
    [ searchClass notNil ] whileTrue:[
        searchClass selectorsAndMethodsDo:[:sel :mthd|
            (sel selectorWithoutNameSpace = selector
              and:[ (seen includes: mthd nameSpace) not
              and:[ block value: sel value: mthd]]
            ) ifTrue:[
                methods add: mthd.
                seen add: mthd nameSpace
            ]
        ].
        searchClass := searchClass superclass
    ].
    ^methods

    "Created: / 19-07-2010 / 15:34:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-06-2016 / 00:25:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NamespaceAwareLookup methodsFor:'trampolines'!

ambiguousMessageSend

    ^self ambiguousMessage:
	(Message
	    selector: #__placeholder__
	    arguments: #()
	)

    "Created: / 19-08-2010 / 22:05:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ambiguousMessageSend: selector withArgs: argArrayOrNil

    | trampoline |

    trampoline := self class methodDictionary at:
		     (#(" 0"ambiguousMessageSend
			" 1"ambiguousMessageSendWith:
			" 2"ambiguousMessageSendWith:with:
			" 3"ambiguousMessageSendWith:with:with:
			" 4"ambiguousMessageSendWith:with:with:with:
			" 5"ambiguousMessageSendWith:with:with:with:with:
			" 6"ambiguousMessageSendWith:with:with:with:with:with:
			" 7"ambiguousMessageSendWith:with:with:with:with:with:with:
			" 8"ambiguousMessageSendWith:with:with:with:with:with:with:with:
			)
			at: argArrayOrNil size + 1).
    trampoline := trampoline asByteCodeMethod.
    1 to: trampoline numLiterals do: [:litNr|
	(trampoline literalAt: litNr) == #__placeholder__ ifTrue:[
	    (trampoline literalAt: litNr put: selector)
	]
    ].
    ^trampoline

    "Created: / 19-08-2010 / 22:09:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ambiguousMessageSendWith: a1

    ^self ambiguousMessage:
	(Message
	    selector: #__placeholder__
	    arguments: (Array with: a1)
	)

    "Created: / 19-08-2010 / 22:06:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ambiguousMessageSendWith: a1 with: a2

    ^self ambiguousMessage:
	(Message
	    selector: #__placeholder__
	    arguments: (Array with: a1 with: a2)
	)

    "Created: / 19-08-2010 / 22:06:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ambiguousMessageSendWith: a1 with: a2 with: a3

    ^self ambiguousMessage:
	(Message
	    selector: #__placeholder__
	    arguments: (Array with: a1 with: a2 with: a3)
	)

    "Created: / 19-08-2010 / 22:06:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ambiguousMessageSendWith: a1 with: a2 with: a3 with: a4

    ^self ambiguousMessage:
	(Message
	    selector: #__placeholder__
	    arguments: (Array with: a1 with: a2 with: a3 with: a4)
	)

    "Created: / 19-08-2010 / 22:06:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ambiguousMessageSendWith: a1 with: a2 with: a3 with: a4
		    with: a5

    ^self ambiguousMessage:
	(Message
	    selector: #__placeholder__
	    arguments: (Array with: a1 with: a2 with: a3 with: a4
			      with: a5)
	)

    "Created: / 19-08-2010 / 22:07:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ambiguousMessageSendWith: a1 with: a2 with: a3 with: a4
		    with: a5 with: a6

    ^self ambiguousMessage:
	(Message
	    selector: #__placeholder__
	    arguments: (Array with: a1 with: a2 with: a3 with: a4
			      with: a5 with: a6)
	)

    "Created: / 19-08-2010 / 22:07:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ambiguousMessageSendWith: a1 with: a2 with: a3 with: a4
		    with: a5 with: a6 with: a7

    ^self ambiguousMessage:
	(Message
	    selector: #__placeholder__
	    arguments: (Array with: a1 with: a2 with: a3 with: a4
			      with: a5 with: a6 with: a7)
	)

    "Created: / 19-08-2010 / 22:07:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ambiguousMessageSendWith: a1 with: a2 with: a3 with: a4
		    with: a5 with: a6 with: a7 with: a8

    ^self ambiguousMessage:
	(Message
	    selector: #__placeholder__
	    arguments: (Array with: a1 with: a2 with: a3 with: a4
			      with: a5 with: a6 with: a7 with: a8)
	)

    "Created: / 19-08-2010 / 22:08:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NamespaceAwareLookup class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !


NamespaceAwareLookup initialize!
