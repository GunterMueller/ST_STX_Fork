"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015 Jan Vrany

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
"{ Package: 'stx:goodies/smallsense/refactoring_custom' }"

"{ NameSpace: SmallSense }"

RBNamespace subclass:#CustomNamespace
	instanceVariableNames:'changeManager formatter classModelClass methodModelClass
		sourceCodeGeneratorClass'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom'
!

!CustomNamespace class methodsFor:'documentation'!

copyright
"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015 Jan Vrany

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

!CustomNamespace methodsFor:'accessing'!

at: aClassName

    ^ self classNamed: aClassName asSymbol

    "Created: / 15-11-2014 / 17:30:04 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

changeManager
    ^ changeManager
!

changeManager:something
    changeManager := something.
!

classModelClass
    "Returns class which represents Class in model in which we make changes (add class, rename class ...)."

    ^ classModelClass

    "Modified (comment): / 09-10-2014 / 11:14:51 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

classModelClass: aClass
    "see classModelClass"

    classModelClass := aClass.

    "Modified (comment): / 09-10-2014 / 11:15:18 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

formatter
    ^ formatter

    "Created: / 28-08-2014 / 23:19:02 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

formatter: aFormatter
    formatter := aFormatter

    "Created: / 28-08-2014 / 23:19:26 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

methodModelClass
    "Returns class which represents Method in model in which we make changes (add method, change method source ...)."

    ^ methodModelClass

    "Modified (comment): / 09-10-2014 / 11:17:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

methodModelClass: aClass
    "see methodModelClass"

    methodModelClass := aClass.

    "Modified (comment): / 09-10-2014 / 11:16:02 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

putModelClass: aModelClass 
    "Stores model class (e.g. RBClass) in this model so we can work further with 
    the given class and the modifications done to the given class 
    are reflected in this model (represented by CustomNamespace/RBNamespace)."
    | classIndex name isClassUndefined |

    classIndex := 1.
    name := aModelClass name.
    aModelClass isMeta ifTrue: [ 
        classIndex := 2.
        name := aModelClass theNonMetaclass name.
    ].

    isClassUndefined := true.
    newClasses at: name ifPresent: [ :classes |
        isClassUndefined := false.
        classes at: classIndex put: aModelClass  
    ].

    changedClasses at: name ifPresent: [ :classes |
        isClassUndefined := false.
        classes at: classIndex put: aModelClass  
    ].

    isClassUndefined ifTrue: [
        self error: 'Class has to be defined in the model - see defineClass: .'.
    ]

    "Created: / 04-11-2014 / 00:03:52 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 04-11-2014 / 01:07:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

sourceCodeGenerator
    "Returns initialized source code generator (CodeGenerator, CustomSourceCodeGenerator)"
    | sourceCodeGenerator |

    sourceCodeGenerator := self sourceCodeGeneratorClass new.
    sourceCodeGenerator formatter: formatter.
    ^ sourceCodeGenerator.

    "Created: / 19-09-2014 / 20:56:22 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 09-10-2014 / 11:35:24 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (comment): / 27-11-2014 / 19:32:07 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

sourceCodeGeneratorClass
    "Returns code generator class which supports search & replace in method source code and formatting"

    ^ sourceCodeGeneratorClass

    "Modified (comment): / 09-10-2014 / 11:34:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

sourceCodeGeneratorClass: aClass
    "see sourceCodeGeneratorClass"

    sourceCodeGeneratorClass := aClass.

    "Modified (comment): / 09-10-2014 / 11:34:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomNamespace methodsFor:'accessing-classes'!

classNamed: aName 
    "Returns an RBClass instance stored under given class name
    or nil if nothing found"

    ^ super classNamed: aName asSymbol

    "Created: / 19-11-2014 / 21:19:47 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

metaclassNamed: aName 
    "Returns an RBMetaclass instance stored under given class name
    or nil if nothing found"

    ^ super metaclassNamed: aName asSymbol

    "Created: / 19-11-2014 / 21:20:52 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomNamespace methodsFor:'changes'!

defineClass: aString
    "Defines a class withing this model by its definition string.
    Here is same behaviour as in RBNamespace, but we added private
    class support."
    | change |

    change := super defineClass: aString.
    change privateInClassName notNil ifTrue: [ 
        | class |

        class := self classNamed: change changeClassName.
        class owningClass: (self classNamed: change privateInClassName)
    ].

    ^ change

    "Created: / 29-11-2014 / 14:39:40 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomNamespace methodsFor:'code creation'!

createClass
    "Much like createMethod, but for class"

    ^ self classModelClass new
        model: self;
        superclass: (self classNamed: #Object);
        instanceVariableNames: #();
        classVariableNames: #();
        poolDictionaryNames: #();
        yourself.

    "Created: / 09-04-2014 / 21:38:20 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 05-02-2015 / 22:31:54 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

createMethod
    "
    Creates, returns method representation
    so code changes can be created withing this class as one undo change
    "

    ^ self methodModelClass new
        model: self;
        sourceCodeGenerator: self sourceCodeGenerator;
        yourself.

    "Created: / 09-04-2014 / 23:54:03 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 05-02-2015 / 22:32:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomNamespace methodsFor:'code creation - immediate'!

createClassImmediate: aClassName
    "Creates class immediately and returns the real class"

    ^ self createClassImmediate: aClassName superClassName: 'Object'

    "Created: / 27-07-2014 / 12:40:55 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

createClassImmediate: aClassName category: aCategoryName
    "Creates class immediately and returns the real class"

    ^ self 
        createClassImmediate: aClassName 
        superClassName: 'Object' 
        instanceVariableNames: '' 
        classVariableNames: ''
        poolDictionaries: ''
        category: aCategoryName

    "Created: / 19-10-2014 / 20:55:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

createClassImmediate: aClassName instanceVariableNames: instVarNames
    "Creates class immediately and returns the real class"

    ^ self 
        createClassImmediate: aClassName 
        superClassName: 'Object' 
        instanceVariableNames: instVarNames 
        classVariableNames: ''

    "Created: / 23-08-2014 / 22:25:08 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

createClassImmediate: aClassName superClassName: aSuperClassName
    "Creates class immediately and returns the real class"

    ^ self 
        createClassImmediate: aClassName 
        superClassName: aSuperClassName 
        instanceVariableNames: '' 
        classVariableNames: ''

    "Created: / 15-06-2014 / 15:59:21 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 23-08-2014 / 22:18:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

createClassImmediate: aClassName superClassName: aSuperClassName instanceVariableNames: instVarNames classVariableNames: classVarNames
    "Creates class immediately and returns the real class"

    ^ self createClassImmediate: aClassName 
        superClassName: aSuperClassName 
        instanceVariableNames: instVarNames 
        classVariableNames: classVarNames 
        poolDictionaries: '' 
        category: ''

    "Created: / 23-08-2014 / 22:18:07 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 19-10-2014 / 20:49:25 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

createClassImmediate: aClassName superClassName: aSuperClassName instanceVariableNames: instVarNames classVariableNames: classVarNames poolDictionaries: poolDict category: category
    "Creates class immediately and returns the real class"

    ^ self createClassImmediate: aClassName superClassName: aSuperClassName instanceVariableNames: instVarNames classVariableNames: classVarNames poolDictionaries: poolDict category: category privateIn: nil

    "Created: / 19-10-2014 / 20:47:51 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 30-10-2014 / 21:46:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

createClassImmediate: aClassName superClassName: aSuperClassName instanceVariableNames: instVarNames classVariableNames: classVarNames poolDictionaries: poolDict category: category privateIn: privateInClassName
    "Creates class immediately and returns the real class"
    | newClassName change |

    newClassName := aClassName.

    privateInClassName isNil ifTrue: [ 
        change := (InteractiveAddClassChange definition:
            aSuperClassName asString, ' subclass:#', aClassName asString, '
                instanceVariableNames:''', instVarNames asString, '''
                classVariableNames:''', classVarNames asString, '''
                poolDictionaries:''', poolDict asString, '''
                category:''', category asString, '''
        ')
    ] ifFalse: [ 
        change := (InteractiveAddClassChange definition:
            aSuperClassName asString, ' subclass:#', aClassName asString, '
                instanceVariableNames:''', instVarNames asString, '''
                classVariableNames:''', classVarNames asString, '''
                poolDictionaries:''', poolDict asString, '''
                privateIn:', privateInClassName asString, '
        ').

        newClassName := privateInClassName asString, '::', aClassName asString.
    ].

    changeManager performChange: change.  

    ^ Smalltalk classNamed: newClassName

    "Created: / 30-10-2014 / 21:28:40 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 02-11-2014 / 16:30:54 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

createClassImmediate: aClassName superClassName: aSuperClassName privateIn: privateInClassName
    "Creates class immediately and returns the real class"

    ^ self createClassImmediate: aClassName superClassName: aSuperClassName instanceVariableNames: '' classVariableNames: '' poolDictionaries: '' category: '' privateIn: privateInClassName

    "Created: / 30-10-2014 / 21:47:55 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

createMethodImmediate: aClass protocol: aProtocol source: aSource
    "Much like createClassImmediate:superClassName:, but for method"

    ^ self createMethodImmediate: aClass protocol: aProtocol source: aSource package: nil

    "Created: / 15-06-2014 / 16:06:00 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 17-10-2014 / 09:58:17 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

createMethodImmediate: aClass protocol: aProtocol source: aSource package: aPackageId
    "Much like createClassImmediate:superClassName:, but for method"

    | selector change |

    change := InteractiveAddMethodChange compile: aSource in: aClass classified: aProtocol.

    (aPackageId notNil and: [ (change class canUnderstand: #package:) ]) ifTrue: [ 
        change package: aPackageId  
    ].

    changeManager performChange: change.    

    selector := (Parser parseMethodSpecification: aSource) selector.
    ^ aClass compiledMethodAt: selector

    "Created: / 17-10-2014 / 09:53:45 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 02-11-2014 / 16:17:21 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

createMethodImmediate: aClass source: aSource
    "Much like createClassImmediate:superClassName:, but for method"

    ^ self createMethodImmediate: aClass protocol: 'protocol' source: aSource

    "Created: / 23-08-2014 / 20:17:22 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomNamespace methodsFor:'compiling'!

execute
    "Performs code changes ( add method, add class, rename class... )
    so they take in effect ( method is added, class is renamed, ... )
    with respect to current change manager implementatin - see CustomChangeManager subclasses."

    changeManager performChange: changes

    "Created: / 27-04-2014 / 16:30:05 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 21-09-2014 / 22:34:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified (comment): / 19-10-2014 / 14:30:45 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

undoChanges
    "redo all changes made by execute method"

    changeManager undoChanges

    "Created: / 19-10-2014 / 14:56:49 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomNamespace methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    super initialize.
    changeManager := SmallSense::CustomLocalChangeManager new.
    formatter := SmallSense::CustomRBLocalSourceCodeFormatter new.
    classModelClass := RBClass.
    methodModelClass := RBMethod.
    sourceCodeGeneratorClass := CustomSourceCodeGenerator.

    "Created: / 09-04-2014 / 23:44:04 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 05-02-2015 / 22:33:14 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 11-05-2015 / 09:08:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomNamespace methodsFor:'testing'!

isNamespace
    ^ true

    "Created: / 15-11-2014 / 17:29:25 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomNamespace class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

