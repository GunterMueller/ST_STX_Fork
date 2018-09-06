"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger
Copyright (C) 2017 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:goodies/smallsense' }"

"{ NameSpace: SmallSense }"

CompletionEngine subclass:#SmalltalkCompletionEngine
	instanceVariableNames:'collector'
	classVariableNames:'Debug'
	poolDictionaries:''
	category:'SmallSense-Smalltalk'
!

!SmalltalkCompletionEngine class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger
Copyright (C) 2017 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!SmalltalkCompletionEngine class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    Debug := false.

    "Modified: / 22-01-2014 / 09:08:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkCompletionEngine class methodsFor:'accessing'!

debug
    ^ Debug

    "Created: / 22-01-2014 / 09:08:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

debug: aBoolean
    Debug := aBoolean .
    "
    self debug: true.
    self debug: false.
    "

    "Created: / 22-01-2014 / 09:08:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 22-01-2014 / 19:42:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkCompletionEngine class methodsFor:'utilities'!

resultSetFor: mode source: source class: class line: line column: col
    | inferencer tree |

    mode == #method ifTrue:[
        inferencer := SmalltalkInferencer forClass: class methodSource: source asString.
        inferencer parserClass: SmalltalkParser.
        inferencer process.
    ] ifFalse:[
        self breakPoint: #jv.
        ^nil.
        inferencer := Parser for: (source asString readStream).
        "JV@2011-06-13: HACK, use polymorphism"
        tree := inferencer
            parseExpressionWithSelf:nil
            notifying:nil
            ignoreErrors:false
            ignoreWarnings:false
            inNameSpace:nil.
        inferencer tree: tree.
    ].
    ^ self new
        completeAtLine:line
        column:col
        collector:inferencer

    "Modified: / 07-04-2011 / 22:55:58 / Jakub <zelenja7@fel.cvut.cz>"
    "Created: / 26-11-2011 / 17:53:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-09-2013 / 14:43:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 02-10-2013 / 13:09:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkCompletionEngine methodsFor:'completion-helpers'!

javaClassesDo: aBlock
    | class loader loaders |

    class := collector klass.
    loaders := Set new.
    loader := (class notNil and:[class isJavaClass]) ifTrue:[class classLoader] ifFalse:[JavaVM systemClassLoader].
    [ loader notNil ] whileTrue:[
        loaders add: loader.
        loader := loader instVarNamed: #parent.
    ].
    loaders add: nil.

    JavaVM registry  allClassesDo:[:cls|
        (cls isAnonymous not and:[(loaders includes: cls classLoader)]) ifTrue:[

            aBlock value: cls.
        ].
    ].

    "Created: / 04-10-2013 / 13:10:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-08-2014 / 13:03:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkCompletionEngine methodsFor:'completion-individual'!

addClassVariables
    | class |

    class := collector klass theNonMetaclass.
    class classVarNames do:[:nm|
        result add:(VariablePO classVariable: nm in: class).
    ].

    "Created: / 24-07-2013 / 17:00:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-07-2013 / 23:32:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addGlobalsStartingWith: prefix

    | class namespace environment |
    class := collector klass.
    namespace := class nameSpace.
    environment := context environment.
    "nameSpace may return private class, sigh"
    [ namespace isNameSpace ] whileFalse:[ namespace := namespace nameSpace ].

    environment keysDo:[:name |
            | value |

            (self isGlobalKeyForClassVariable: name) ifFalse:[ 
                value := environment at: name.
                ((name startsWith: prefix) or:[(value isBehavior and:[(value nameWithoutPrefix startsWith: prefix) or:[value nameWithoutNameSpacePrefix startsWith: prefix]])]) ifTrue:[
                    (value notNil and:[value isBehavior]) ifTrue:[ 
                        "/ Check for aliases...
                        | clsnm |

                        clsnm := value name.
                        clsnm = name ifTrue:[ 
                            result add: (PO forClass: value)
                        ] ifFalse:[ 
                            result add: (PO forGlobalNamed: name)  
                        ].
                    ] ifFalse:[ 
                        result add: (PO forGlobalNamed: name)  
                    ].
                ]
            ].
        ].

    "Created: / 26-11-2011 / 17:29:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-07-2014 / 17:51:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addJavaClassesInPackage: prefix
    prefix isEmptyOrNil ifTrue:[
        self javaClassesDo: [:cls |
            result add: (ClassPO new klass: cls; showPrefix: true; yourself)
        ].
    ] ifFalse:[
        self javaClassesDo: [:cls |
            (cls binaryName startsWith: prefix) ifTrue:[
                result add: (ClassPO new klass: cls; showPrefix: true; yourself)
            ].
        ].

    ].

    "Created: / 04-10-2013 / 13:09:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-10-2013 / 02:42:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addMethodsForType: type
    ^ self addMethodsForType: type stripOff: nil

    "Created: / 26-11-2011 / 17:03:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-05-2014 / 12:51:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addMethodsForType: type prefix: prefix stripOff: stripprefix

    type isUnknownType ifFalse:[
        self addMethodsForType:type stripOff: stripprefix.

        "/ If the type is union of more than 6 types, then
        "/ assume that the inferencer is likely wrong.
        "/ then, if the prefix is at least 3 chars,
        "/ also add methods with that prefix.

        ((type classes size > 6) and:[ prefix size > 2 ]) ifTrue:[
            self addMethodsStartingWith:prefix stripOff: stripprefix
        ].
    ] ifTrue:[
        self addMethodsStartingWith:prefix stripOff: stripprefix
    ].

    "Created: / 08-04-2014 / 21:04:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-04-2014 / 09:31:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addMethodsForType: type stripOff: stripprefix
    | classes seen selector2classesMap |

    selector2classesMap := Dictionary new.
    classes := type classes.
    "/ Hack for Boolean: ifTrue:iFalse: etc are not defined
    "/ in Boolean ?!!?
    (classes size == 1 and:[classes anElement == Boolean ]) ifTrue:[
        classes := Array with: True with: False.
    ].
    classes size == 1 ifTrue:[
        classes anElement == JavaPackage class ifTrue:[
            "/ Special hack for JAVA: for pattern `JAVA java lang reflect`
            "/ complete all Java classes in that package
            | node |

            node := result context node.
            node isUnaryMessage ifTrue:[
                | package |
                "/ Compute package prefix...

                package := node selector.
                node := node receiver.
                [ node isUnaryMessage ] whileTrue:[
                    package := node selector , '/' , package.
                    node := node receiver.
                ].
                self addJavaClassesInPackage: package.
                ^ self.
            ]
        ]
    ].

    seen := Set new.
    classes do: [:each |
        | class selector2classMap |

        class := each.
        selector2classMap := Dictionary new.

        "/ Now, special care for Java classes, sigh...
        (class isMetaclass and:[class theNonMetaclass isJavaClass]) ifTrue:[
            seen add: class.
            class theNonMetaclass selectorsAndMethodsDo: [:selector :met |
                met isStatic ifTrue:[
                    result add: (PO forClass: met mclass selector: selector)
                ].
            ].
        ] ifFalse:[
            [ class notNil and:[(seen includes: class) not]] whileTrue: [
                class selectorsAndMethodsDo: [:selector :met |
                    met isSynthetic ifFalse:[
                        (stripprefix isNil or:[ selector size > stripprefix size and:[selector startsWith: stripprefix]]) ifTrue:[
                            selector2classMap at: selector put: class.
                        ].
                    ]
                ].
                class := class superclass.
            ]
        ].
        selector2classMap keysAndValuesDo:[:selector :class |
            | classes |

            classes := selector2classesMap at: selector ifAbsentPut: [ Set new ].
            classes add: class.
        ]
    ].

    selector2classesMap keysAndValuesDo: [:selector :classes|
        result add:(MethodPO forClasses: classes selector: selector prefix: stripprefix)
    ]

    "Created: / 08-04-2014 / 21:23:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-05-2014 / 10:47:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addPools
    | class |

    class := collector klass theNonMetaclass.
    class theNonMetaclass sharedPools do:[:pool|
        pool theNonMetaclass classVarNames do:[:nm|
            result add:(VariablePO classVariable: nm in: pool).
        ]
    ].

    "Created: / 24-07-2013 / 16:59:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-07-2013 / 23:32:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addVariablesFor: node

    | n klass |

    "Add Instance variables"
    klass := collector klass.
    [ klass notNil ] whileTrue:[
        | usedInstVars |

        usedInstVars := collector parser usedInstVars.
        klass instVarNames do:[:nm |
            | po |

            "/ Check for non-object instvars - they cannot be referenced
            "/ directly!!
            (nm last == $*) ifFalse:[
                po := VariablePO instanceVariable: nm in: klass.
                "/ Raise relevance if the instvar is already used in the code...
                (usedInstVars includes: nm) ifTrue:[
                    po relevance: (po relevance + 10).
                ].

                result add: po.
            ].
        ].
        "/ When on class side (i.e., in class method), do not complete
        "/ instance variables of Class / ClassDescription / Behaviour
        "/ as STC won't compile such code.
        klass := (klass isMetaclass and:[klass superclass == Class])
                    ifTrue:[nil]
                    ifFalse:[klass superclass].
    ].
    "Add pseudo variables"
    #(self super here thisContext) do:[:nm|
        result add: (VariablePO new name: nm).
    ].
    "Add arguments"
    collector parser methodArgs ? #() do:[:nm|
        result add: (VariablePO argument: nm).
    ].
    "Add temporaries"
    collector parser methodVars ? #() do:[:nm|
        result add: (VariablePO variable: nm).
    ].
    "Add literals"
    #(#true #false #nil ) do:[:nm|
        result add: (SnippetPO new value: nm).
    ].


    n := node.
    [ n notNil ] whileTrue:[
        n isBlockNode ifTrue:[
            n arguments ? #() do:[:barg|result add: (VariablePO variable: barg name)].
            n variables ? #() do:[:bvar|result add: (VariablePO variable: bvar name)].
        ].
        n := n parent.
    ]

    "Created: / 31-07-2013 / 00:32:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-08-2015 / 02:52:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkCompletionEngine methodsFor:'completion-private'!

complete
    "Compute completion for `codeView`, taking all the information
     from it. Returns a CompletionResult with computed completions"

    | class |

    textView := context textView.
    class := textView isCodeView2
                ifTrue: [ textView klass ]
                ifFalse: [ textView editedClass ].
    class isNil ifTrue:[
        class := UndefinedObject.
    ].
    ^ self complete: textView codeAspect source: textView contents string class: class line: textView cursorLine column: textView cursorCol

    "Created: / 02-10-2013 / 13:32:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-02-2015 / 23:53:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

complete: mode source: source class: class line: lineNrArg column: colNrArg
    | inferencer lineNr colNr |

    mode == #method ifTrue:[
        lineNr := lineNrArg.
        colNr := colNrArg.
        inferencer := SmalltalkInferencer forClass: class methodSource: source asString.
    ] ifFalse:[
        | line |

        lineNr := 1.
        colNr := colNrArg.
        line := textView list at: lineNrArg ifAbsent:[ nil ].
        line isEmptyOrNil ifTrue:[ ^ nil ].
        inferencer := SmalltalkInferencer forClass: class expression: line.
    ].
    inferencer parserClass: SmalltalkParser.
    inferencer process.

    ^ self
        completeAtLine:lineNr
        column:colNr
        collector:inferencer

    "Created: / 02-10-2013 / 13:23:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-11-2017 / 22:21:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

completeAfter:node
    "return collection of completion items after given node"

    | type |

    type := node inferedType.
    type isUnknownType ifFalse:[
        self addMethodsForType: node inferedType
    ].

    "Created: / 04-03-2011 / 15:45:28 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 08-04-2011 / 10:55:09 / Jakub <zelenja7@fel.cvut.cz>"
    "Created: / 26-11-2011 / 17:07:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-09-2013 / 02:15:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

completeAtLine:line column:col collector:coll
    "find most possible codeCompletion object"

    | nodeToPosition |

    collector := coll.
    (collector tree isNil or:[collector tree == #Error]) ifTrue:[
        ^ nil
    ].
    nodeToPosition := SmalltalkParseNodeFinder new
                        findNodeIn: collector source tree: collector tree comments: collector parser commentPositions
                        line: line column: col.
    context node: nodeToPosition key position: nodeToPosition value.

    context isAfterNode ifTrue:[
        self completeAfter:context node.
    ] ifFalse:[
    context isInNode ifTrue:[
        self completeIn:context node.
    ] ifFalse:[
    context isBeforeNode ifTrue:[
        self completeBefore:context node.
    ]]].

    result isEmpty ifTrue:[
        nil "/Only to set breakpoint here
    ].
    ^result.

    "Created: / 04-03-2011 / 13:01:14 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 08-04-2011 / 10:52:59 / Jakub <zelenja7@fel.cvut.cz>"
    "Created: / 26-11-2011 / 17:05:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-01-2014 / 10:36:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

completeBefore:node

    self breakPoint: #jv. "Not yet implemented"

    "Created: / 04-03-2011 / 15:45:28 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 08-04-2011 / 10:55:09 / Jakub <zelenja7@fel.cvut.cz>"
    "Created: / 26-11-2011 / 17:07:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

completeIn:node
    "return collection which can be afterNode"

    node isVariableNode ifTrue:[
        self completeInVariableNode:node.
        ^ self.
    ].
    node isMessage ifTrue:[
        self completeInMessageNode:node.
        ^ self
    ].
    node isSelf ifTrue:[  
        ^ self
    ]. 
    node isSuper ifTrue:[  
        ^ self
    ]. 
    node isConstant ifTrue:[ 
        ^ self
    ].

    "Created: / 07-03-2011 / 18:59:02 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 08-04-2011 / 09:31:51 / Jakub <zelenja7@fel.cvut.cz>"
    "Created: / 26-11-2011 / 17:07:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2015 / 22:53:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

completeInMessageNode:node
    | parent |


    self addMethodsForType: node receiver inferedType prefix: node selector stripOff: nil.
    parent := node parent.
    parent isMessage ifTrue:[
        self addMethodsForType: parent receiver inferedType prefix: node selector stripOff: parent selector.
    ].

    "Modified (format): / 08-04-2014 / 21:16:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

completeInVariableNode:node
    node name first isUppercase ifTrue:[
        self addGlobalsStartingWith:node name.
        self addClassVariables.
        self addPools.
    ] ifFalse:[
        self addVariablesFor:node
    ]

    "Modified: / 24-07-2014 / 19:11:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkCompletionEngine methodsFor:'queries'!

isGlobalKeyForClassVariable: aString
    | i |

    i := 0.
    [
        i := aString indexOf: $: startingAt: i + 1.
        i ~~ 0
    ] whileTrue:[
        aString size > i ifTrue:[
            (aString at: i + 1) ~~ $: ifTrue:[
                ^ true
            ].
        ].
        i := i + 1.
    ].
    ^ false

    "
    SmalltalkCompletionEngine new isGlobalKeyForClassVariable: 'AAA'
    SmalltalkCompletionEngine new isGlobalKeyForClassVariable: 'AAA:X'
    SmalltalkCompletionEngine new isGlobalKeyForClassVariable: 'BB::CC::AA'
    SmalltalkCompletionEngine new isGlobalKeyForClassVariable: 'BB::CC::AA:X'
    "

    "Created: / 09-04-2014 / 13:49:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkCompletionEngine class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !


SmalltalkCompletionEngine initialize!
