"
 Copyright (c) 2010-2011 Jan Vrany, Jan Kurs & Marcel Hlopko,
                         SWING Research Group, Czech Technical University 
                         in Prague

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
"{ Package: 'stx:libjava' }"

"{ NameSpace: Smalltalk }"

Lookup subclass:#JavaLookup
	instanceVariableNames:'j2j j2s s2j'
	classVariableNames:'Instance InvokeRSelectors'
	poolDictionaries:''
	category:'Languages-Java-Interop'
!

Lookup subclass:#JVM
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaLookup
!

JavaLookup::JVM subclass:#J2S
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaLookup
!

JavaLookup::JVM subclass:#J2J
	instanceVariableNames:''
	classVariableNames:'NoSuchMethodErrorSelector'
	poolDictionaries:''
	privateIn:JavaLookup
!

JavaLookup::JVM subclass:#S2J
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaLookup
!

!JavaLookup class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2010-2011 Jan Vrany, Jan Kurs & Marcel Hlopko,
                         SWING Research Group, Czech Technical University 
                         in Prague

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

!JavaLookup class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    InvokeRSelectors := 
        #(
            " 0" #'_INVOKEVIRTUAL_R:_:'
            " 1" #'_INVOKEVIRTUAL_R:_:_:'
            " 2" #'_INVOKEVIRTUAL_R:_:_:_:'
            " 3" #'_INVOKEVIRTUAL_R:_:_:_:_:'
            " 4" #'_INVOKEVIRTUAL_R:_:_:_:_:_:'
            " 5" #'_INVOKEVIRTUAL_R:_:_:_:_:_:_:'
            " 6" #'_INVOKEVIRTUAL_R:_:_:_:_:_:_:_:'
            " 7" #'_INVOKEVIRTUAL_R:_:_:_:_:_:_:_:_:'
            " 8" #'_INVOKEVIRTUAL_R:_:_:_:_:_:_:_:_:_:'
            " 9" #'_INVOKEVIRTUAL_R:_:_:_:_:_:_:_:_:_:_:'
            "10" #'_INVOKEVIRTUAL_R:_:_:_:_:_:_:_:_:_:_:_:'
            "11" #'_INVOKEVIRTUAL_R:_:_:_:_:_:_:_:_:_:_:_:_:'
            "12" #'_INVOKEVIRTUAL_R:_:_:_:_:_:_:_:_:_:_:_:_:_:'
            "13" #'_INVOKEVIRTUAL_R:_:_:_:_:_:_:_:_:_:_:_:_:_:_:'

            " 0" #'_INVOKEINTERFACE_R:_:'
            " 1" #'_INVOKEINTERFACE_R:_:_:'
            " 2" #'_INVOKEINTERFACE_R:_:_:_:'
            " 3" #'_INVOKEINTERFACE_R:_:_:_:_:'
            " 4" #'_INVOKEINTERFACE_R:_:_:_:_:_:'
            " 5" #'_INVOKEINTERFACE_R:_:_:_:_:_:_:'
            " 6" #'_INVOKEINTERFACE_R:_:_:_:_:_:_:_:'
            " 7" #'_INVOKEINTERFACE_R:_:_:_:_:_:_:_:_:'
            " 8" #'_INVOKEINTERFACE_R:_:_:_:_:_:_:_:_:_:'
            " 9" #'_INVOKEINTERFACE_R:_:_:_:_:_:_:_:_:_:_:'
            "10" #'_INVOKEINTERFACE_R:_:_:_:_:_:_:_:_:_:_:_:'
            "11" #'_INVOKEINTERFACE_R:_:_:_:_:_:_:_:_:_:_:_:_:'
            "12" #'_INVOKEINTERFACE_R:_:_:_:_:_:_:_:_:_:_:_:_:_:'
            "13" #'_INVOKEINTERFACE_R:_:_:_:_:_:_:_:_:_:_:_:_:_:_:'
        )

    "Modified (format): / 20-01-2014 / 13:50:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLookup class methodsFor:'instance creation'!

cleanup

    Instance := nil.

    "Modified: / 25-02-2011 / 14:45:03 / kursjan <kursjan@fit.cvut.cz>"
    "Created: / 19-09-2011 / 23:25:08 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Modified: / 15-12-2011 / 23:05:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

instance

    Instance isNil ifTrue:[
        Instance := self basicNew initialize
    ].
    ^Instance

    "Modified: / 25-02-2011 / 14:45:03 / kursjan <kursjan@fit.cvut.cz>"
    "Created: / 19-09-2011 / 23:20:49 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Modified: / 15-12-2011 / 23:05:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new
    ^ self shouldNeverBeSent.

    "Created: / 25-02-2011 / 14:44:43 / kursjan <kursjan@fit.cvut.cz>"
    "Modified: / 29-08-2011 / 21:10:12 / Jan Kurs <kursjan@fit.cvut.cz>"
! !

!JavaLookup methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    j2j := J2J new.
    j2s := J2S new. 
    s2j := S2J new.

    "Modified: / 22-03-2016 / 22:39:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLookup methodsFor:'lookup'!

lookupMethodForSelector:selector directedTo:initialSearchClass for:aReceiver withArguments:argArrayOrNil from:sendingContext ilc: ilcCache

    "Invoked by the VM to ask me for a method to call.
     The arguments are: the selector, receiver and arguments,
     the class to start the search in (for here-, super and directed sends)
     the sending context and the inline/poly cache (instance of
     PolymorphicInlineCache). "


     "JV@2012-08-21: Following C code speeds up Java<->Smalltalk interop by
      order of 2 magnitudes. However, it breaks Java reflection. 

      This is because it does not handle package private methods correctly.
      On the other hand, PP methods are not handled correctly when not using 
      reflection anyway, so lets keep the optimization here.

      Once we will have functinal JIT compiler, we can remove it and Java
      package-private method will be supported correctly in all cases.
     "

     | sender |

%{
    OBJ method;
    method = __lookup(initialSearchClass, selector);
    if ( method ) {
        if ( ilcCache ) {
            __ilcBind(ilcCache, initialSearchClass, method, selector);
        }
        RETURN (method);
    }
%}.
    "/ Sigh, here we have to care about different code paths. The new JIT compilation scheme
    "/ sends JavaVM>>_INVOKE*R:... for sends whose methodref is not yet resolved. Thus the stack
    "/ (starting with sendingContext) may look like:
    "/ 
    "/ (0) real sending context - whoever it is
    "/ 
    "/ for resolved/interpreted sends or:
    "/ 
    "/ (0) performWith:withArguments:
    "/ (1) _INVOKEVIRTUAL_R:* / _INVOKEINTERFACE_R:*
    "/ (2) real sending context - whoever it is
    "/ 
    "/ for unresolved sends from JIT-compiled code.
    "/ In tha latter case we have to skip those 2 'implementation' contexts:
    sender := sendingContext.
    sender selector == #perform:withArguments: ifTrue:[
        sender := sender sender.
        (sender receiver == JavaVM and: [ InvokeRSelectors includes: sender selector ]) ifTrue:[
            sender := sender sender.
        ] ifFalse:[
            sender := sendingContext.
        ].
    ].

    sender programmingLanguage isSmalltalk ifTrue:[
        aReceiver class theNonMetaclass programmingLanguage isJavaLike ifTrue:[
            ^s2j lookupMethodForSelector:selector directedTo:initialSearchClass for:aReceiver withArguments:argArrayOrNil from:sendingContext ilc: ilcCache.
        ].
    ].

    sender programmingLanguage isJavaLike ifTrue:[
        initialSearchClass programmingLanguage isSmalltalk ifTrue:[
            "Java to Smalltalk send"
            ^j2s lookupMethodForSelector:selector directedTo:initialSearchClass for:aReceiver withArguments:argArrayOrNil from:sendingContext ilc: ilcCache.
        ].
        initialSearchClass programmingLanguage isJavaLike ifTrue:[
            "Java to Java send"
            ^j2j lookupMethodForSelector:selector directedTo:initialSearchClass for:aReceiver withArguments:argArrayOrNil from:sendingContext ilc: ilcCache.
        ].
        self breakPoint: #jv.
    ].

    ^super lookupMethodForSelector:selector directedTo:initialSearchClass for:aReceiver withArguments:argArrayOrNil from:sendingContext ilc: ilcCache.

    "Created: / 01-10-2011 / 13:18:40 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Created: / 15-12-2011 / 23:11:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-03-2016 / 22:44:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLookup::JVM methodsFor:'lookup'!

lookupMethodForSelector: selector directedTo: c
    "This method performs standard Java lookup as required JVM 8 spec, 6.5 invokevirtual.
     NOTE: This method only handles Java method, i.e., it never returns a Smalltak
     (or other language's) extension method."

    | m s |

    "Let C be the class of objectref. The actual method to be invoked is selected by the 
     following lookup procedure:

     1. If C contains a declaration for an instance method m that
        overrides (§5.4.5) the resolved method, then m is the method
        to be invoked.
     2. Otherwise, if C has a superclass, a search for a declaration
        of an instance method that overrides the resolved method
        is performed, starting with the direct superclass of C and
        continuing with the direct superclass of that class, and so forth,
        until an overriding method is found or no further superclasses
        exist. If an overriding method is found, it is the method to be
        invoked."

    m := super lookupMethodForSelector: selector directedTo: c.
    m isJavaMethod ifTrue:[
        m notNil ifTrue:[
            [ (s := super lookupMethodForSelector: selector directedTo: m mclass superclass) notNil ] whileTrue:[
                (m overrides: s) ifFalse:[
                    m := s
                ].
            ].
        ].
    ].
    "3. Otherwise, if there is exactly one maximally-specific method
        (§5.4.3.3) in the superinterfaces of C that matches the resolved
        method's name and descriptor and is not abstract , then it is
        the method to be invoked.
    "
    m isNil ifTrue:[ 
        | class interfaces superinterfaces interfaceMethod |

        class := c.
        interfaces := Set new.
        "/ Collect interfaces from all superclasses. 
        "/ We cannot use JavaClass>>allInterfaces as it also
        "/ returns superinterfaces of interfaces, flattened."
        [ class notNil ] whileTrue:[ 
            interfaces addAll: c interfaces.
            class := class superclass.
        ].
        [ interfaces notEmpty ] whileTrue:[
            interfaces do:[ :interface|
                | interfaceMethod superinterfaces |

                interfaceMethod := interface compiledMethodAt: selector.
                "/ We must also test whether found is a JavaMethod. It could
                "/ be a Smalltalk extension in the interface - such methods
                "/ are not handled here (no such thing in JVM spec)
                (interfaceMethod notNil and: [interfaceMethod isJavaMethod]) ifTrue:[
                    m := interfaceMethod.
                    "/ To terminate the loop
                    interfaces := superinterfaces := #().
                ] ifFalse:[
                    superinterfaces isNil ifTrue:[ 
                        superinterfaces := Set new.
                    ].
                    superinterfaces addAll: interface interfaces.
                ].
                interfaces := superinterfaces.
            ]
        ]
    ].
    ^ m

    "Created: / 05-07-2012 / 11:06:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-03-2016 / 20:42:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLookup::J2S methodsFor:'lookup'!

lookupMethodForSelector:selector directedTo:initialSearchClass for:receiver withArguments:argArrayOrNil from:sendingContext ilc: ilc

    | d m |

    d := JavaDescriptor readFrom: (selector readStream skipThrough: $(; backStep; yourself).
    m := self lookupMethodForSelector: selector directedTo: initialSearchClass numArguments: d numArgs.
    m notNil ifTrue: [
        m := self compileProxyWithSelector: selector descriptor: d in: receiver class calling: m.
        ilc notNil ifTrue:[ilc bindTo: m forClass: receiver class].
        ^m.
    ] ifFalse:[
        ^ nil
    ]

    "Created: / 06-09-2011 / 22:04:04 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Modified: / 09-10-2011 / 22:59:18 / kursjan <kursjan@fit.cvut.cz>"
    "Created: / 19-11-2011 / 12:37:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lookupMethodForSelector:jselector directedTo:initialSearchClass numArguments: nArgs

    | name cls |

    name := jselector upTo: $(.

    "Pass 1: Search for explicitly annotated method"
    cls := initialSearchClass.
    [ cls notNil ] whileTrue:[
        cls methodDictionary keysAndValuesDo:[:sel :mthd|
            | jdescriptor |

            mthd numArgs == nArgs ifTrue:[
                (jdescriptor := mthd annotationAt: #javaselector:) notNil ifTrue:[
                    jdescriptor arguments first == jselector ifTrue: [
                        ^mthd    
                    ]
                ].
            ]
        ].
        cls := cls superclass.
    ].

    "Pass 2: Search for method with matching name"
    cls := initialSearchClass.
    [ cls notNil ] whileTrue:[
        cls methodDictionary keysAndValuesDo:[:sel :mthd|
            mthd numArgs == nArgs ifTrue:[
                (sel startsWith: name) ifTrue:[
                    ^mthd
                ]
            ]
        ].
        cls := cls superclass.
    ].

    ^nil

    "Created: / 16-12-2011 / 00:00:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLookup::J2S methodsFor:'utilities'!

addSelector:selector withMethod:proxy toClass:class 

    ProxyMethod installProxies ifTrue:[
        Class withoutUpdatingChangesDo:[
            class addSelector:selector withMethod:proxy.
        ]
    ]

    "Modified: / 23-12-2011 / 13:09:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compileProxyWithSelector:selector descriptor:descriptor in:class calling:callee 
    |compiler proxy body|

    compiler := ProxyMethodCompiler new.
    body := compiler newJavaMethodInvocation: callee.
    body descriptor:descriptor.
    proxy := compiler 
                compile:body 
                arguments:callee numArgs 
                selector: selector.
"/    JK: do nod add here
"/    JV: Why?
    self 
        addSelector:selector
        withMethod:proxy
        toClass:class.
    ^ proxy

    "Created: / 14-12-2011 / 20:48:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-01-2012 / 19:33:45 / kursjan <kursjan@fit.cvut.cz>"
    "Modified: / 24-02-2012 / 20:36:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLookup::J2J class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    NoSuchMethodErrorSelector := #(
            " 0" #'throwNoSuchMethodError'
            " 1" #'throwNoSuchMethodError_:'
            " 2" #'throwNoSuchMethodError_:_:'
            " 3" #'throwNoSuchMethodError_:_:_:'
            " 4" #'throwNoSuchMethodError_:_:_:_:'
            " 5" #'throwNoSuchMethodError_:_:_:_:_:'
            " 6" #'throwNoSuchMethodError_:_:_:_:_:_:'
            " 7" #'throwNoSuchMethodError_:_:_:_:_:_:_:'
            " 8" #'throwNoSuchMethodError_:_:_:_:_:_:_:_:'
            " 9" #'throwNoSuchMethodError_:_:_:_:_:_:_:_:_:'
            "10" #'throwNoSuchMethodError_:_:_:_:_:_:_:_:_:_:'
            "11" #'throwNoSuchMethodError_:_:_:_:_:_:_:_:_:_:_:'
            "12" #'throwNoSuchMethodError_:_:_:_:_:_:_:_:_:_:_:_:'
            "13" #'throwNoSuchMethodError_:_:_:_:_:_:_:_:_:_:_:_:_:'
            "14" #'throwNoSuchMethodError_:_:_:_:_:_:_:_:_:_:_:_:_:_:'
            "15" #'throwNoSuchMethodError_:_:_:_:_:_:_:_:_:_:_:_:_:_:_:'
    ).

    "Modified (comment): / 29-03-2016 / 21:07:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLookup::J2J methodsFor:'lookup'!

lookupMethodForSelector:selector directedTo:initialSearchClass for:aReceiver withArguments:argArrayOrNil from:sendingContext ilc: ilcCache
    | method |

    method := self lookupMethodForSelector: selector directedTo: initialSearchClass.
    "/ No method found. Return a trampoline that will throw NoSuchMethodError
    method isNil ifTrue:[ 
        method := JavaVM class >> (NoSuchMethodErrorSelector at: argArrayOrNil size + 1)
    ].
    ilcCache notNil ifTrue:[
        ilcCache bindTo: method forClass: initialSearchClass.
    ].
    ^ method.

    "Created: / 22-03-2016 / 22:43:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-03-2016 / 20:45:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLookup::S2J methodsFor:'lookup'!

lookupMethodForSelector: selector directedTo: initialSearchClass for: receiver withArguments: argArrayOrNil from: sendingContext ilc: ilc 
    "
     As a courtesy to a Smalltalker, try to map smalltalk selectors to a java ones.
     Returns a method or nil"
    
    | name candidates method |

    "/ First, handle the simple case when Smalltalk 'performs' a Java selector,
    "/ i.e., something like:
    "/ 
    "/     system perform: #'initializeSystemClass()V'.     
    "/ 
    "/ we have to distinguish between static method lookup (when a message
    "/ is sent to the class) and instance method lookup since static methods
    "/ are not inherited!!
    receiver isBehavior ifTrue:[ 
        "/ Lookup static method
        method := receiver methodDictionary at: selector ifAbsent:[ nil ].
        method notNil ifTrue:[ 
            "/ Must ensure the class is initialized here!! See documentation
            "/ for INVOKESTATIC
            method javaClass classInit.          
            ^ method 
        ].
    ] ifFalse:[ 
        "/ Lookup instance method
        method := self lookupMethodForSelector: selector directedTo: receiver class.
        method notNil ifTrue:[ ^ method ].
    ].

        
    "/ OK - assuming a Java object has been sent a smalltalk(ish) selector,
    "/ try to map that selector to a Java selector...this is where the magic
    "/ happens.
    name := selector upTo: $:.
    candidates := OrderedCollection new.

    candidates := self lookupMethodsForSelector: selector in: initialSearchClass ? receiver class static: receiver isBehavior.
    candidates notEmpty ifTrue: [
        "/ If candidates contains only one method that is not Java method,
        "/ then return this method. It's either a smalltalk extension or
        "/ ambiguous method trampoline...
        (candidates size == 1 and:[ (method := candidates anElement) isJavaMethod not]) ifTrue:[ 
            ilc notNil ifTrue: [ ilc bindTo: method forClass: receiver class ].
            ^ method.
        ].
        method := self 
                compileProxyWithSelector: selector
                in: receiver class
                candidates: candidates.
        ilc notNil ifTrue: [ ilc bindTo: method forClass: receiver class ].
         "Install the proxy"
        self 
            addSelector: selector
            withMethod: method
            toClass: receiver class.
        ^ method.
    ].
     "Hmm, hmm, maybe a public field?"
    (argArrayOrNil size < 2) ifTrue: [
        | field |
        field := initialSearchClass theNonMetaclass 
                lookupFieldFor: name
                static: initialSearchClass isMetaclass.
        "/ Disallow interop access to non-public fields.
        (field notNil and:[field isPublic not]) ifTrue:[
            field := nil
        ].
        field notNil ifTrue: [
            method := self 
                    compileProxyWithSelector: selector
                    in: receiver class
                    accessing: field.
            ilc notNil ifTrue: [ ilc bindTo: method forClass: receiver class ].
             "Install the proxy"
            self 
                addSelector: selector
                withMethod: method
                toClass: receiver class.
            ^ method.
        ]
    ].
    ^ nil

    "Created: / 21-02-2011 / 13:38:55 / kursjan <kursjan@fit.cvut.cz>"
    "Modified: / 29-08-2011 / 20:38:21 / kursjan"
    "Modified: / 20-09-2011 / 00:03:48 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Modified (format): / 25-09-2011 / 21:08:45 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Created: / 19-11-2011 / 13:03:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-01-2012 / 19:58:59 / kursjan <kursjan@fit.cvut.cz>"
    "Modified (comment): / 02-01-2012 / 10:35:25 / kursjan <kursjan@fit.cvut.cz>"
    "Modified: / 18-11-2012 / 18:17:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-12-2012 / 13:59:55 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 26-07-2016 / 20:48:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lookupMethodsForSelector: selector in: initialSearchClass static: static
    "Lookup all matching methods for given (Smalltalk) selector starting with
     `initialSearchClass`. If `static` is true, then search for static methods,
     otherwise for search instance methods.

     Returns a list of method candidates that match given selector.
    "
    
    | name nameSizePlusOne numArgs candidates  finder1 finder2  cls ifacesQ ifacesSeen |

    name := selector upTo: $:.
    nameSizePlusOne := name size + 1.
    numArgs := selector numArgs.
    candidates := OrderedCollection new.
    ifacesSeen := Set new.

    "/ Method finder to lookup extension methods in interfaces...
    finder1 := [:cls |
        cls interfaces notEmptyOrNil ifTrue:[
            ifacesQ := OrderedCollection with: (cls interfaces).
            [ ifacesQ notEmpty ] whileTrue:[
                | ifaces newIfaces extension |

                ifaces := ifacesQ removeFirst.
                extension := nil.
                ifaces do:[:iface |
                    (ifacesSeen includes: iface) ifFalse:[
                        | m |

                        ifacesSeen add: iface.
                        m := iface compiledMethodAt: selector.
                        m notNil ifTrue:[
                            extension notNil ifTrue:[
                                "/ Ambiguous, return error trampoline
                                | sel |

                                sel :=
                                    #(  ambiguousMessageSend
                                        ambiguousMessageSendWith:
                                        ambiguousMessageSendWith:With:
                                        ambiguousMessageSendWith:With:With:
                                        ambiguousMessageSendWith:With:With:With:
                                        ambiguousMessageSendWith:With:With:With:With:
                                        ambiguousMessageSendWith:With:With:With:With:With:
                                        ambiguousMessageSendWith:With:With:With:With:With:With:
                                        ambiguousMessageSendWith:With:With:With:With:With:With:With:
                                    ) at: selector numArgs + 1.
                                ^ Array with: (self class compiledMethodAt: sel).
                            ] ifFalse:[
                                extension := m.
                            ].
                        ].
                    ].
                ].
                extension notNil ifTrue:[ ^ Array with: extension ].
                newIfaces := Set new.
                ifaces do:[:iface| newIfaces addAll: iface interfaces ].
                newIfaces notEmpty ifTrue:[
                    ifacesQ add: newIfaces.
                ].        
            ].
        ].
    ]. 

    "/ Method finder to map Java methods to smalltalk selectors...
    finder2 := [:cls |
        cls methodDictionary keysAndValuesDo: [:sel :mthd | 
            "candidates may contain a method with same selector ->
             do not add super-class's method"
            (candidates contains: [:each | each selector == sel ]) ifFalse: [
                (mthd mclass ~~ ProxyMethod 
                    and: [
                        ((sel size >= nameSizePlusOne) 
                            and: [ (sel at: nameSizePlusOne) == $( and: [ (sel startsWith: name) ] ]) 
                                and: [ mthd descriptor numArgs == numArgs ]
                    ]) 
                        ifTrue: [ candidates add: mthd ]
            ]
        ]
    ].
    "Search class for method candidates"
    cls := initialSearchClass theNonMetaclass.
    static ifTrue: [ 
        finder2 value: cls 
    ] ifFalse: [
        [ cls notNil and: [ cls ~~ JavaObject ] ] whileTrue: [
            finder1 value: cls.
            finder2 value: cls.
            cls := cls superclass.
        ]
    ].

    candidates notEmpty ifTrue:[ 
        "because java compiler generates synthetic method, when overriden
         method has narrows return type than method from superclass/interface,
         we don't take these particular synthetic methods as candidates, they just
         delegate to overridden methods."
        ((candidates size > 1) and:[candidates anySatisfy:[:each|each isSynthetic]]) ifTrue:[
            | candidatesPerNameAndArg |

            candidatesPerNameAndArg := Dictionary new.
            candidates do:[:each|
                | nameAndArgs |

                nameAndArgs := each selector upTo:$).
                candidatesPerNameAndArg at: nameAndArgs ifAbsentPut:[each]. 
            ].
            candidates := candidatesPerNameAndArg values.
        ].        
    ].

    ^ candidates.

    "Created: / 19-03-2014 / 16:24:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLookup::S2J methodsFor:'lookup (old)'!

old_lookupMethodForSelector:selector directedTo:initialSearchClass for:receiver withArguments:argArrayOrNil from:sendingContext ilc: ilc
    "
    As a courtesy to a Smalltalker, try to map smalltalk selectors to a java ones.
    Returns JavaMethodDescriptor or nil.
    "
    |descriptor candidate static cls m |

    static := receiver isBehavior.
    descriptor := JavaMethodDescriptor 
            name: (selector upTo:$:) 
            parameters: (argArrayOrNil ? #() collect:[:a|
                (a class isString and: [JavaVM booted]) ifTrue:[
                    JavaFieldDescriptorWithUnionType new
                        addDescriptor: (JavaFieldDescriptor javaClass: a class);
                        addDescriptor: (JavaFieldDescriptor javaClass: (JavaVM classForName: 'java.lang.String'));
                        yourself.
                ] ifFalse:[
                    JavaFieldDescriptor javaClass: a class
                ]
            ]).
    cls := initialSearchClass theNonMetaclass.
    [ cls notNil and:[cls ~~ JavaObject] ] whileTrue:[
        cls methodsDo:[:mthd|
            "/(mthd selector startsWith: 'foo') ifTrue:[self breakPoint: #jv]. 
            (mthd class ~~ ProxyMethod and:[mthd isStatic == static and:[descriptor match: mthd descriptor]]) ifTrue:[
                candidate isNil ifTrue:[
                    candidate := mthd
                ] ifFalse:[
                    candidate descriptorSymbol ~~ mthd descriptorSymbol ifTrue:[
                        "Hm, hm, two matching methods with different descriptors means
                         ambiguity...raise an error"

                        "Bit hacky - NamespaceAwareLookup already has method to generate
                         ambigouous send trampouline..."
                        ^NamespaceAwareLookup instance ambiguousMessageSend: selector withArgs: argArrayOrNil
                    ]
                ].
            ]                                                                 
        ].
        cls := cls superclass.                
    ].
    candidate notNil ifTrue:[
        m := self compileProxyWithSelector: selector descriptor: descriptor in: receiver class calling: candidate.
        ilc notNil ifTrue:[ilc bindTo: m forClass: receiver class].
        ^m.
    ].
    ^nil

    "Created: / 21-02-2011 / 13:38:55 / kursjan <kursjan@fit.cvut.cz>"
    "Modified: / 11-04-2011 / 20:19:50 / kursjan <kursjan@fit.cvut.cz>"
    "Modified: / 29-08-2011 / 20:38:21 / kursjan"
    "Modified: / 20-09-2011 / 00:03:48 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Modified (format): / 25-09-2011 / 21:08:45 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Created: / 16-12-2011 / 23:05:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-05-2013 / 11:19:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLookup::S2J methodsFor:'matching'!

descriptorForJavaSelector:arg
    ^ MessageDescription new 
        parserClass: JavaSelectorParser;
        selector: arg;
        yourself.

    "Created: / 29-08-2011 / 20:41:48 / Jan Kurs <kursjan@fit.cvut.cz>"
!

descriptorForSmalltalkSelector:selector arguments: args
    ^ MessageDescription new 
        parserClass: SmalltalkSelectorParser;
        runtimeArguments: args;
        selector: selector;
        yourself.

    "Created: / 29-08-2011 / 21:44:06 / Jan Kurs <kursjan@fit.cvut.cz>"
!

findBestMatchOf: smalltalkMethod in: javaMethods
    | methods |
    javaMethods size = 1 ifTrue: [
        ^ javaMethods first.    
    ].
    javaMethods size = 0 ifTrue: [
        ^ nil
    ].

    methods := javaMethods select: [:m |
        m argSize = smalltalkMethod argSize.
    ].
    methods size = 1 ifTrue: [
        ^ methods first.    
    ].

    methods := methods select: [:m |
        self javaMatches: m argTypes to: smalltalkMethod args.
    ].
    methods size = 1 ifTrue: [
        ^ methods first.
    ].

    methods size = 0 ifTrue: [
        ^ nil.
    ].

    ^ Error raiseErrorString: 'Ambiguous selector: ', smalltalkMethod name.

    "Created: / 29-08-2011 / 20:50:14 / Jan Kurs <kursjan@fit.cvut.cz>"
!

javaMatches: jArgs to: sArgs
    
    1 to: jArgs size do: [ :i |
        ((JavaTypeBox typeBoxForJava: (jArgs at: i)) smalltalkType = ((sArgs at: i) className)) ifFalse: [ ^ false ].
    ].
    ^ true.

    "Created: / 29-08-2011 / 21:21:37 / Jan Kurs <kursjan@fit.cvut.cz>"
!

javaSelectorsFor:class
    | selectors cls static |
    cls := class.
    selectors := IdentitySet new.
    self breakPoint: #jk info: 'determine static based on class'.
    static := false.

    [cls = JavaObject] whileFalse: [
        cls methodDictionary keysAndValuesDo: [:k :v |
            (v isJavaMethod and: [v isStatic = static]) ifTrue: [
                selectors add: k.
            ].
        ].
        cls := cls superclass.
    ].
    ^ selectors.

    "Created: / 06-09-2011 / 22:20:34 / Jan Kurs <kursjan@fit.cvut.cz>"
! !

!JavaLookup::S2J methodsFor:'trampolines'!

ambiguousMessageSend

    ^self ambiguousMessage:
        (Message 
            selector: thisContext selector
            arguments: #()
        )

    "Created: / 19-08-2010 / 22:05:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ambiguousMessageSendWith: a1

    ^self ambiguousMessage:
        (Message 
            selector: thisContext selector
            arguments: (Array with: a1)
        )

    "Created: / 19-08-2010 / 22:06:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ambiguousMessageSendWith: a1 with: a2

    ^self ambiguousMessage:
        (Message 
            selector: thisContext selector
            arguments: (Array with: a1 with: a2)
        )

    "Created: / 19-08-2010 / 22:06:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ambiguousMessageSendWith: a1 with: a2 with: a3

    ^self ambiguousMessage:
        (Message 
            selector: thisContext selector
            arguments: (Array with: a1 with: a2 with: a3)
        )

    "Created: / 19-08-2010 / 22:06:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ambiguousMessageSendWith: a1 with: a2 with: a3 with: a4

    ^self ambiguousMessage:
        (Message 
            selector: thisContext selector
            arguments: (Array with: a1 with: a2 with: a3 with: a4)
        )

    "Created: / 19-08-2010 / 22:06:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ambiguousMessageSendWith: a1 with: a2 with: a3 with: a4
                    with: a5

    ^self ambiguousMessage:
        (Message 
            selector: thisContext selector
            arguments: (Array with: a1 with: a2 with: a3 with: a4
                              with: a5)
        )

    "Created: / 19-08-2010 / 22:07:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ambiguousMessageSendWith: a1 with: a2 with: a3 with: a4
                    with: a5 with: a6

    ^self ambiguousMessage:
        (Message 
            selector: thisContext selector
            arguments: (Array with: a1 with: a2 with: a3 with: a4
                              with: a5 with: a6)
        )

    "Created: / 19-08-2010 / 22:07:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ambiguousMessageSendWith: a1 with: a2 with: a3 with: a4
                    with: a5 with: a6 with: a7

    ^self ambiguousMessage:
        (Message 
            selector: thisContext selector
            arguments: (Array with: a1 with: a2 with: a3 with: a4
                              with: a5 with: a6 with: a7)
        )

    "Created: / 19-08-2010 / 22:07:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ambiguousMessageSendWith: a1 with: a2 with: a3 with: a4
                    with: a5 with: a6 with: a7 with: a8

    ^self ambiguousMessage:
        (Message 
            selector: thisContext selector
            arguments: (Array with: a1 with: a2 with: a3 with: a4
                              with: a5 with: a6 with: a7 with: a8)
        )

    "Created: / 19-08-2010 / 22:08:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLookup::S2J methodsFor:'utilities'!

addSelector:selector withMethod:proxy toClass:class 

    ProxyMethod installProxies ifTrue:[
        Class withoutUpdatingChangesDo:[
            class addSelector:selector withMethod:proxy.
            proxy mclass: class.
        ]
    ]

    "Created: / 01-01-2012 / 17:41:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compileProxyWithSelector:selector in:class accessing: field
    "For given field, create a proxy getter/setter"

    
    |compiler proxy body isSetter |

    class theNonMetaclass classInit.
    isSetter := selector last == $:.
    compiler := ProxyMethodCompiler new.
    isSetter ifTrue:[
        body := compiler newJavaFieldSetter: field.
        proxy := compiler 
                compile:body
                arguments: 1
                selector:selector.
    ] ifFalse:[
        body := compiler newJavaFieldGetter: field.
        proxy := compiler 
                compile:body
                arguments: 0
                selector:selector.

    ].

    ^ proxy

    "Modified: / 30-12-2011 / 14:44:11 / kursjan <kursjan@fit.cvut.cz>"
    "Created: / 17-03-2012 / 16:54:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compileProxyWithSelector:selector in:class candidates:candidates 
    "For given set of methods, create a dispatching proxy with given selector.
     This method performs typechecks on arguments and dispatch to proper method"
    
    |compiler proxy body fallback|

    compiler := ProxyMethodCompiler new.
    fallback := self 
                fallbackWithSelector:selector
                in:class
                compiler:compiler.
     "Generate and install dispatching tree..."
    selector numArgs == 0 ifTrue:[
        "If method has no arguments, no dynamic method dispatch is
         required (method cannot be overloaded)  Therefore, no fallback is 
         needed. In theory, there is no need for proxy method at all..."
        self assert:candidates size == 1.
        body := compiler newJavaMethodInvocation:candidates anyOne.
    ] ifFalse:[
        "JV@2012-01-01: Based on discussion with JK, if there is no overloaded method
         DO NOT compile guard, call the method directly. We'll see..."
        "JV@2014-03-19: NO, DON'T DO THAT, that's fundamentally wrong.
         A new overloaded method may come in future, for example
         a new subclass may get loaded or a new method is added to
         some class along the chain..."
"/        methods size == 1 ifTrue:[
"/            body := (compiler newJavaMethodInvocation:methods anElement).
"/        ] ifFalse:[
            "For every method, create a guard and add it"
            body := fallback.
"/        ]
    ].
    
    "/Create and install proxy
    
    proxy := compiler 
                compile:body
                arguments:selector numArgs
                selector:selector.
    
"/    self halt.
"/    JK: do NOT install here, just compile and return the proxy. Let someone else to install
"/    self 
"/        addSelector:selector
"/        withMethod:proxy
"/        toClasS:class.
    
    ^ proxy

    "Created: / 19-03-2014 / 17:28:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compileProxyWithSelector: selector in: class receiver: receiver arguments: arguments
    "For given receiver and arguments, selects apropriate method from methods
     and compile guard"

    | compiler candidates method proxy condition invocation fallback guard |

    compiler := ProxyMethodCompiler new.    

    proxy := class compiledMethodAt: selector.
    proxy notNil ifTrue:[
        fallback := proxy body    
    ] ifFalse:[
        fallback := self fallbackWithSelector: selector in: class compiler: compiler.
    ].

    candidates := self lookupMethodsForSelector: selector in: receiver class static: receiver isBehavior.    
    method := self selectMethodFrom: candidates arguments: arguments.
    invocation := compiler newJavaMethodInvocation:method.

    condition := nil.
    arguments withIndexDo:[:arg :index|
        condition isNil ifTrue:[
            condition := compiler newTypeCheck: arg class argument: index.
        ] ifFalse:[
            condition := condition and: (compiler newTypeCheck: arg class argument: index).
        ].
    ].

    guard := compiler newGuard
                condition: condition;
                action: invocation; 
                fallback: fallback;
                yourself.

    proxy := compiler 
                compile:guard
                arguments:selector numArgs
                selector:selector.

    self 
        addSelector:selector
        withMethod:proxy
        toClass:receiver class.

    "Created: / 19-03-2014 / 17:27:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fallbackWithSelector:selector in:class compiler:compiler 
    ^ compiler 
        newJavaBlockInvocation:[:receiver :arguments | 
            self 
                compileProxyWithSelector:selector
                in:class
                receiver:receiver
                arguments:arguments.
            "/self breakPoint:#jv.
            receiver perform:selector withArguments:arguments.
        ]

    "Created: / 19-03-2014 / 17:25:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectMethodFrom: methods arguments: arguments

    | candidates |

    methods size == 1 ifTrue:[ 
        ^ methods anElement.
    ].

    candidates := methods.
    arguments withIndexDo:[:arg :index|
        | cls |

        cls := arg class.
        candidates := candidates select:[:m|
            self breakPoint:#mh.
            self type: cls matches: (m descriptor parameters at: index) javaClass
        ].
    ].

    candidates size == 0 ifTrue:[
        self halt: 'Unfinished - no matching method'        
    ].
    candidates size == 1 ifTrue:[
        ^candidates anElement
    ].
    self breakPoint: #jv."/ This is a timed bomb...
    ^ candidates first

    "Created: / 03-01-2012 / 21:40:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-04-2012 / 13:59:13 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 19-03-2014 / 16:41:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

type: actual matches: formal 
    "Return true, if actual (parameter) type matches given formal (parameter) type"
    
    formal isJavaPrimitiveType ifTrue: [
        actual == SmallInteger ifTrue: [
            ^ formal == Integer or: [ actual == formal ].
        ].
        formal == Boolean ifTrue: [
            ^ actual == True or: [ actual == False or: [ actual == Boolean ] ].
        ].
        ^ actual == formal.
    ].
     "nil matches any formal type (to follow undocumented
     feature of JVM (also seen in CHECKCAST instruction :))" 
    actual == UndefinedObject ifTrue: [ ^ true ].

    "char[] matches smalltal string..."
    formal == Unicode16String ifTrue:[
        ^ actual inheritsFrom: CharacterArray
    ].

    actual isJavaPrimitiveType ifTrue: [
        ^ formal isJavaWrapperClass and: [ formal == actual javaWrapperClass ]
    ].
    (actual includesBehavior: String) ifTrue: [
        ^ formal binaryName == #'java/lang/String'
    ].

    (actual includesBehavior: Unicode16String) ifTrue: [
        ^ formal binaryName == #'java/lang/String'
    ].

    (actual includesBehavior: Unicode32String) ifTrue: [
        ^ formal binaryName == #'java/lang/String'
    ].

    ^ JavaVM canCast: actual to: formal

    "Created: / 03-01-2012 / 22:36:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-04-2012 / 13:59:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-12-2012 / 11:44:17 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 21-01-2014 / 14:42:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLookup::S2J methodsFor:'utilities (old)'!

old_compileProxyWithSelector: selector descriptor: descriptor in: class calling: callee

    | proxy invocation fallback |

    "This method might (indirectly) be invoked by guarded method itself,
     when all guards fails and method gets recompiled during fallback action.
     In that case, we should not throw away existing proxy, but just extend it."

    proxy := class compiledMethodAt: selector.
    proxy isNil ifTrue:[
        "No method exists, create one..."
        proxy := ProxyMethod new.
        proxy numberOfArgs: callee descriptor numPhysicalArgs.
        proxy source:'I''m a proxy method, please inspect my body'.
        "Create default fallback"
        fallback := ProxyMethod newJavaBlockInvocation: [ self halt: 'Launch recompile, not yet implemented'].
        "Install it..."
        Class withoutUpdatingChangesDo:[
            class addSelector: selector withMethod: proxy.        
        ]
    ] ifFalse:[
        "Method already exists, then the fallback is currently 
         installed body"
        fallback := proxy body.
    ].

    "Now, create and install a node that invokes given method"   
    callee numArgs == 0 ifTrue:[
        "If method has no arguments, no dynamic method dispatch is
        required. Therefore, no fallback is needed. In theory, there is
        no need for proxy method at all..."
        self assert: descriptor numArgs size == 0.
        invocation := ProxyMethod newJavaMethodInvocation: callee.
        "Install it"
        proxy body: invocation
    ] ifFalse:[
        "Create a guard"
        invocation := ProxyMethod newGuard.
        invocation condition: callee descriptor guardCondition.
        invocation action: (ProxyMethod newJavaMethodInvocation: callee).
        invocation fallback: fallback.
        "Install it"
        proxy addGuard: invocation.
    ].
    "/Finally, return the method                                
    ^ proxy

    "Created: / 16-12-2011 / 23:06:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLookup class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaLookup.st,v 1.8 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


JavaLookup initialize!
JavaLookup::J2J initialize!
