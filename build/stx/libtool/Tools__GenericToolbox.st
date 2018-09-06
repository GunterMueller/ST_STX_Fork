"
 COPYRIGHT (c) 2014 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

Toolbox subclass:#GenericToolbox
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools'
!

!GenericToolbox class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2014 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.

"
!

documentation
"
    A generic toolbox for languages that compiles into Smalltalk/X bytecode.
    Although it's a good idea to provide specialized toolbox each of those
    languages, GenericToolbox is a good basis.

    A GenericToolbox is also a default toolbox if ProgrammingLanguage does
    not specify one.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        Tools::Toolbox
        Tools::SmalltalkToolbox
        Tools::JavaToolbox
        ProgrammingLanguage
"
! !

!GenericToolbox methodsFor:'accessing-methods'!

globalsReferencedByMethods: methods
    "Returns a list of globals (classes) referenced by given methods"

    | detector globals |

    detector := [ :literal :method :recurse | 
        literal isSymbol ifTrue:[
            | cls ns |

            ns := method mclass nameSpace.
            (ns notNil and:[ (cls := environment at: literal) notNil]) ifTrue:[ 
                globals add: cls.
            ] ifFalse:[ 
                (cls := environment at: literal) notNil ifTrue:[ 
                    globals add: cls.
                ].
            ].
        ] ifFalse:[ 
            (recurse and:[ literal isArray ]) ifTrue:[ 
                literal do:[:each | detector value: each value: method value: recurse ].
            ].
        ].
    ].

    globals := Set new.
    methods do:[:m |  
        | recurse |

        "/ If the method is method spec, the do recurse into
        "/ literal array when searching for globals, otherwise
        "/ do not.
        recurse := m resourceType == #canvas.
        m literalsDo:[:each | detector value: each value: m value: recurse ].
    ].

    ^ globals.

    "Created: / 24-02-2014 / 16:25:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GenericToolbox class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

