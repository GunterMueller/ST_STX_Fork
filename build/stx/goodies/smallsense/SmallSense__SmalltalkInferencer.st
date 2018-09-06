"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
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

Object subclass:#SmalltalkInferencer
	instanceVariableNames:'type class classInfo source parser parserClass tree environment
		manager'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Smalltalk-Types-Inference'
!

SmalltalkParseNodeVisitor subclass:#Phase1
	instanceVariableNames:'classInfo sends types'
	classVariableNames:''
	poolDictionaries:'SmallSense::SmalltalkInferencerParameters'
	privateIn:SmalltalkInferencer
!

SmalltalkParseNodeVisitor subclass:#Phase2
	instanceVariableNames:'classInfo'
	classVariableNames:''
	poolDictionaries:''
	privateIn:SmalltalkInferencer
!

SmalltalkParseNodeVisitor subclass:#Phase3
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:SmalltalkInferencer
!

!SmalltalkInferencer class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
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
!

documentation
"
    A heart of SmallSense - a type inferencer. For given class
    and method source, instance of inferences walks the parse tree
    and annotate each node with inferred type.


    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!SmalltalkInferencer class methodsFor:'instance creation'!

forClass: class expression: source

    ^self new class: class expression: source.

    "Created: / 13-11-2017 / 22:21:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forClass: class methodSource: source

    ^self new class: class source: source

    "Created: / 26-11-2011 / 12:45:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forClass: class selector: selector

    ^self new class: class selector: selector.

    "Created: / 26-11-2011 / 12:44:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forMethod: method

    ^self new method: method.

    "Created: / 26-11-2011 / 12:45:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkInferencer methodsFor:'accessing'!

environment
    ^ environment
!

environment:something
    environment := something.
!

klass
    ^ class

    "Created: / 26-11-2011 / 17:30:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

manager
    manager isNil ifTrue:[
        manager := Manager instance
    ].
    ^ manager

    "Created: / 27-11-2011 / 16:16:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2015 / 14:32:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

manager: aManager
    manager := aManager

    "Created: / 21-08-2015 / 14:32:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parser
    ^ parser
!

parserClass
    ^ parserClass
!

parserClass:aClass
    parserClass := aClass.
!

source
    ^ source
!

tree
    ^ tree
! !

!SmalltalkInferencer methodsFor:'initialization'!

class: klass expression: expression

    type := #expression.
    self class: klass source: expression.

    "Created: / 13-11-2017 / 22:22:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

class: cls selector: sel

    | m |
    m := cls >> sel.
    m isNil ifTrue:[
        self error: 'No method found'.
    ].
    self method: m.

    "Created: / 26-11-2011 / 12:47:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

class: cls source: src

    type isNil ifTrue:[
        "/ Guess...
        type := cls notNil ifTrue:[ #method ] ifFalse:[ #expression ]
    ].
    class := cls ? UndefinedObject.
    classInfo := self manager infoForClass: class.
    source := src.

    "Created: / 26-11-2011 / 14:46:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-10-2013 / 08:31:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

method: method

    type := #method.
    self class: method mclass source: method source.

    "Created: / 26-11-2011 / 12:48:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-10-2013 / 08:13:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkInferencer methodsFor:'private'!

infer
    Phase1 process:tree in:class manager:manager.
    Phase2 process:tree in:class manager:manager.
    Phase3 process:tree in:class manager:manager.

    "
     (SmallSenseParseNodeInspector new node: tree source: source) open"

    "Created: / 26-11-2011 / 12:51:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-07-2017 / 16:21:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parse

    parserClass isNil ifTrue:[
        parserClass := class parserClass.
    ].
    type == #method ifTrue:[
        parser := parserClass
                    parseMethod: source in: class
                    ignoreErrors:true
                    ignoreWarnings:true.
        tree := parser tree.
    ] ifFalse:[
        type == #expression ifTrue:[
            parser := parserClass for: source.
            tree := parser
                        parseExpressionWithSelf:nil
                        notifying:nil
                        ignoreErrors:false
                        ignoreWarnings:false
                        inNameSpace:nil.
            parser tree: tree.
        ].
    ].

    "Created: / 26-11-2011 / 12:51:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-10-2013 / 08:15:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkInferencer methodsFor:'processing'!

process

    "Actually infer types. Returns an annotated method tree.
     The tree is also stored in an instance variable, so it
     may be obtained form receiver any time by asking for #tree."

    [
        self parse.
    ] on: Error do:[:ex|
        Transcript showCR: ex description.
        ^ nil.
    ].
    tree notNil ifTrue:[
        self infer.
    ].
    ^tree

    "Created: / 26-11-2011 / 12:50:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2015 / 14:35:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkInferencer::Phase1 class methodsFor:'documentation'!

documentation
"
    Inferencing phase 1: guess type of variables based on message sends
    (idea taken from RoelTyper).

    Also, assign types for known variables (globals, literals, pseudo variables)

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!SmalltalkInferencer::Phase1 methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    sends := Dictionary new.
    types := Dictionary new.

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 21-08-2015 / 15:44:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkInferencer::Phase1 methodsFor:'private'!

rootsUnderstanding: selectors
    "When the set of selectors is not empty, answer a set of the highest possible classes in the system that implement all the selectors.
     When the set of selectors is empty, return the empty set."

    | initialClasses nextClasses traverseStack next |
    selectors isEmpty ifTrue: [^OrderedCollection new].
    nextClasses := OrderedCollection with: Object.
    traverseStack := OrderedCollection new: 1000.

    selectors
        do:
            [:selector |
            initialClasses := nextClasses.
            nextClasses := OrderedCollection new.
            initialClasses
                do:
                    [:initialClass |
                    "inline canUnderstand: for performance"
                    |cl|
                    cl := initialClass.
                    [(cl == nil) or: [(cl methodDictionary includesKey: selector)]] whileFalse: [cl := cl superclass].
                    (cl == nil)
                        ifFalse: [nextClasses addLast: initialClass]
                        ifTrue:
                            [|size|
                            traverseStack reset.
                            traverseStack addLast: initialClass.
                            size := 1.
                            "(traverseStack isEmpty) removed for performance"
                            [size = 0]
                                whileFalse:
                                    [
                                    "(traverseStack removeFirst) removed for performance"
                                    next := traverseStack removeFirst.
                                    size := size -1.
                                    next
                                        subclassesDo:
                                            [:subcl |
                                            "(subcl includesSelector: selector) removed for performance"
                                            (subcl methodDictionary includesKey: selector)
                                                ifTrue: [nextClasses addLast: subcl]
                                                ifFalse: [traverseStack addLast: subcl. size := size + 1]]]]]].
    ^nextClasses

    "Modified: / 24-11-2010 / 14:39:35 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 26-11-2011 / 14:01:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 18-09-2013 / 01:22:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkInferencer::Phase1 methodsFor:'processing'!

process: tree in: cls info: clsInfo

     | i c def prereqs |

    class := cls.
    classInfo := clsInfo.

    "/ Do not process if class is troublesome
    classInfo isErrorneous ifTrue:[ 
        ^ self.
    ].
    "Fill types with cached data..."

    c := class.
    i := classInfo.
    [ c notNil and:[i notNil] ] whileTrue:[
        c instVarNames do:[:nm|
            types at: nm put: (i infoForInstvar: nm)
        ].
        c := c superclass.
        i := i superclassInfo.
    ].

    self visit:tree.


    prereqs := nil.
    def := ProjectDefinition definitionClassForPackage: class package createIfAbsent: false.
    def notNil ifTrue:[
        prereqs := def effectivePreRequisites.
    ].


    "Now, infer variable types based on collected sends"
    sends keysAndValuesDo:[:varName :sentSelectors|
        (types includesKey: varName) ifTrue:[
            | classes union |
            classes := (self rootsUnderstanding: sentSelectors) collect:[:each |  ClassType new klass: each ].

            prereqs notNil ifTrue:[
                "/ Make classes in packages on which method's package does **NOT** depend
                "/ less likely to be correct (by lowering their trustfullness)
                classes do:[:each |
                    (prereqs includes: each klass package) ifTrue:[
                        each trustfullnessAdd: -20
                    ].
                ]
            ].
            union := UnionType new.
            union addType: (types at: varName) type.
            union addTypes: classes.
            (types at: varName) type: union
        ].
    ].

    "Created: / 27-11-2011 / 16:22:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 21-11-2014 / 17:19:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

process:tree in:cls manager:manager 
    self 
        process:tree
        in:cls
        info:(manager infoForClass:cls)

    "Modified: / 21-08-2015 / 15:44:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkInferencer::Phase1 methodsFor:'visiting'!

visitBlockNode:anObject
    | type |

    super visitBlockNode:anObject.
    type := Type withClass: Block.
    type trustfullness: 100.
    anObject inferedType: type.

    "Created: / 26-11-2011 / 14:46:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitConstantNode:anObject
    "Type of a constant is trivially its value class"

    | type |

    super visitConstantNode: anObject.
    type := (Type withClass: anObject value class).
    type trustfullness: 100.
    anObject inferedType: type.

    "Created: / 26-11-2011 / 13:55:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitMessageNode:anObject

    | rec |

    super visitMessageNode: anObject.

    (rec := anObject receiver) isVariableNode ifTrue:[
        "We don't have to infer types for global/class variables"
        (rec isGlobalVariable or:[rec isClassVariable]) ifTrue:[
            "/ Check for pattern: `Smalltalk at: #ClassName`
            (rec name = 'Smalltalk' and:[anObject arguments conform:[:node | node isConstant ] ]) ifTrue:[
                | result |

                "Here, evaluate the node, but only for certain known selectors!!
                 (think of selector #exit :-) - you'll laugh, but it hit me back hard
                 couple times...
                "
                (#(	at:
                	classNamed:
                	"/ add more...
                ) includes:anObject selector) ifTrue:[
                	[
		                result := anObject evaluate.
	                	result notNil ifTrue:[
		                    anObject inferedType: ((Type withClass: result class) trustfullness: 100)
		                ]
	                ] on: Error do:[
	                	"/pass
	                ]
	            ]
            ].
        ] ifFalse:[
            (sends at: rec name ifAbsentPut:[Set new]) add: anObject selector.
        ].
    ].

    "Created: / 26-11-2011 / 13:02:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-10-2013 / 07:56:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitSelfNode:anObject
    | type |

    super visitSelfNode:anObject.
    type := Type withClass: class.
    type trustfullness: 100.
    anObject inferedType:type

    "Created: / 26-11-2011 / 14:43:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-09-2013 / 01:25:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitSuperNode:anObject
    | superclass type |

    super visitSuperNode:anObject.
    superclass := class superclass.    
    type := superclass notNil ifTrue:[ Type withClass: class superclass ] ifFalse:[ Type unknown ].
    type trustfullness: 100.
    anObject inferedType:type

    "Created: / 26-11-2011 / 14:44:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-11-2014 / 22:17:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitVariableNode:anObject

    | t |

    "Following code ensures, that all variable nodes refering same
     variable shares the inferred type"
    t := types at: anObject name ifAbsentPut:[Type unknown].
    anObject inferedType: t.

    anObject isGlobalVariable ifTrue:[
        | globalName global globalClass |

        globalName := anObject name asSymbolIfInterned.
        globalName notNil ifTrue:[
            global := Smalltalk at: globalName.

            "/ Special hack for JAVA - its actually a JavaPackage...
            global == (Smalltalk at: #JAVA) ifTrue:[
                global := JavaPackage
            ].
            globalClass := global class.

            global notNil ifTrue:[
                t addClass:  globalClass.
                t trustfullness: 100.
            ].
        ].
        ^self.
    ].
    anObject isClassVariable ifTrue:[
        t addClass: (class theNonMetaclass classVarAt: anObject name asSymbol) class.
        t trustfullness: 100.
        ^self.
    ].

    "Created: / 26-11-2011 / 13:31:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-12-2014 / 22:06:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkInferencer::Phase2 class methodsFor:'documentation'!

documentation
"
    Inferencing phase 2: Guess types based on 'known' selectors, like #==, #=, #class, #new: and so on...

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!SmalltalkInferencer::Phase2 methodsFor:'visiting'!

visitMessageNode:aMessageNode

    | selector |

    super visitMessageNode: aMessageNode.  

    selector := aMessageNode selector.
    "/ Some selectors are known / expected  to return boolean
    (#( #== #~~ #= #~= #< #<= #=> #> #contains: includes: includesKey: #anySatisfy: #allSatisfy:) includes: selector) ifTrue:[
        aMessageNode inferedType: (Type withClass: Boolean).
        ^ self.
    ].

    "/ Some selectors are known / expected  to return some numerical values
    (#( #+ #- #* #/ #// #\\ ) includes: selector) ifTrue:[
        aMessageNode inferedType: (Type withClass: Number).
        ^ self.
    ].


    "/ #new / #basicNew: conventionally returns an instance of the class, if receiver is a class.
    (#(#new: #basicNew:) includes: selector) ifTrue:[
        | rec type |
        rec := aMessageNode receiver.
        (rec isSelf and:[class isMetaclass]) ifTrue:[
            type := Type withClass: class theNonMetaclass.
            type trustfullnessAdd: 50.
            aMessageNode inferedType: type.
            ^self.
        ].

        type := aMessageNode receiver inferedType instanceSide.
        aMessageNode inferedType: type.
        ^self.
    ].

    "Created: / 05-08-2014 / 14:03:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-09-2014 / 11:20:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitUnaryNode:anObject

    | type sel rec classes |

    super visitUnaryNode:anObject.

    sel := anObject selector.

    "/ #class should always return a class of the receiver...
    sel == #class ifTrue:[
        type := anObject receiver inferedType classSide.
        anObject inferedType: type.
        ^self.
    ].

    "/ #new / #basicNew: conventionally returns an instance of the class, if receiver is a class.
    (sel == #new or:[sel == #basicNew]) ifTrue:[
        rec := anObject receiver.
        (rec isSelf and:[class isMetaclass]) ifTrue:[
            type := Type withClass: class theNonMetaclass.
            type trustfullnessAdd: 50.
            anObject inferedType: type.
            ^self.
        ].

        type := anObject receiver inferedType instanceSide.
        anObject inferedType: type.
        ^self.
    ].

    rec := anObject receiver.
    classes := rec inferedType classes.
    classes size == 1 ifTrue:[
        "/ Special hack for Java, when code is like
        "/ `JAVA java lang reflect`
        classes anElement == JavaPackage class ifTrue:[
            (JAVA notNil and:[anObject selector first isUppercase]) ifTrue:[
                | jclass |

                "/ fetch an accessor...
                [
                    jclass := anObject evaluate.
                    "/ fetch the class...
                    jclass := JavaVM classNamed: jclass fullName definedBy: JavaVM systemClassLoader.
                    jclass notNil ifTrue:[
                        anObject inferedType: (Type withClass: jclass class).
                    ] ifFalse:[
                        anObject inferedType: (Type withClass: JavaClass class).
                    ].
                ] on: Error do:[
                    "/ ignore...
                ]
            ] ifFalse:[
                anObject inferedType: (Type withClass: JavaPackage class).
            ].
        ].
    ].

    "Created: / 27-11-2011 / 15:49:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-10-2013 / 11:07:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 05-08-2014 / 13:56:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkInferencer::Phase3 class methodsFor:'documentation'!

documentation
"
    Phase 3: guess types based on naming conventions. This is mainly to process
    parameters in form of aString or aStringOrBoolean...

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!SmalltalkInferencer::Phase3 methodsFor:'visiting'!

visitVariableNode:anObject
    | name className |

    name := anObject name.
    (name size > 1 and:[name first == $a]) ifTrue:[ 
        (name size > 2 and: [name second == $n and:[ name third isUppercase ]]) ifTrue:[ 
            className := (name copyFrom: 3) asSymbolIfInterned.
        ] ifFalse:[ name second isUppercase ifTrue:[
            className := (name copyFrom: 2) asSymbolIfInterned.
        ]].
        className notNil ifTrue:[
            | cls |
            cls := Smalltalk at: className.
            cls notNil ifTrue:[ 
                anObject inferedType type: (Type withClass: cls) type
            ].
        ].

    ].

    "Created: / 06-07-2017 / 16:15:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-10-2017 / 23:39:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkInferencer class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

