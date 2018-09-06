"{ Encoding: utf8 }"

"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

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

AbstractJavaCompletionEngineTests subclass:#GroovyCompletionEngineSimpleTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Tests'
!

!GroovyCompletionEngineSimpleTests class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

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

!GroovyCompletionEngineSimpleTests methodsFor:'accessing-classes'!

completionEngineClass
    ^ GroovyCompletionEngineSimple

    "Created: / 22-05-2014 / 16:39:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

completionLanguage
    ^ GroovyLanguage instance

    "Created: / 07-03-2015 / 10:35:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyCompletionEngineSimpleTests methodsFor:'tests - analysis'!

test_analyze_01a

    self complete:'import java.util.Array;┃'.

    self assert: (engine instVarNamed: #imports) size == 1.
    self assert: (engine instVarNamed: #imports) first = 'java.util.Array'

    "Created: / 22-05-2014 / 17:08:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_analyze_01b

    self complete:'import java.util.*;┃'.

    self assert: (engine instVarNamed: #imports) size == 1.
    self assert: (engine instVarNamed: #imports) first = 'java.util.*'

    "Created: / 22-05-2014 / 17:08:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_analyze_01c

    self complete:'import java.util.*;
                   import java.lang.reflect.Field;┃'.

    self assert: (engine instVarNamed: #imports) size == 2.
    self assert: (engine instVarNamed: #imports) first = 'java.util.*'.
    self assert: (engine instVarNamed: #imports) second = 'java.lang.reflect.Field'.

    "Created: / 22-05-2014 / 17:09:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_analyze_02_boolean

    self complete:'boolean  var; ┃'.

    self assert: (engine instVarNamed: #locals) size == 1.
    self assert: ((engine instVarNamed: #locals) includesKey: 'var') .
    self assert: ((engine instVarNamed: #locals) at: 'var') = 'boolean' .

    "Created: / 23-05-2014 / 09:24:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_analyze_02_byte

    self complete:'byte var; ┃'.

    self assert: (engine instVarNamed: #locals) size == 1.
    self assert: ((engine instVarNamed: #locals) includesKey: 'var') .
    self assert: ((engine instVarNamed: #locals) at: 'var') = 'byte' .

    "Created: / 23-05-2014 / 09:23:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_analyze_02_char

    self complete:'char  var; ┃'.

    self assert: (engine instVarNamed: #locals) size == 1.
    self assert: ((engine instVarNamed: #locals) includesKey: 'var') .
    self assert: ((engine instVarNamed: #locals) at: 'var') = 'char' .

    "Created: / 23-05-2014 / 09:24:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_analyze_02_def

    self complete:'def var; ┃'.

    self assert: (engine instVarNamed: #locals) size == 1.
    self assert: ((engine instVarNamed: #locals) includesKey: 'var') .
    self assert: ((engine instVarNamed: #locals) at: 'var') isNil .

    "Created: / 23-05-2014 / 09:26:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_analyze_02_double

    self complete:'double  var; ┃'.

    self assert: (engine instVarNamed: #locals) size == 1.
    self assert: ((engine instVarNamed: #locals) includesKey: 'var') .
    self assert: ((engine instVarNamed: #locals) at: 'var') = 'double' .

    "Created: / 23-05-2014 / 09:24:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_analyze_02_float

    self complete:'float  var; ┃'.

    self assert: (engine instVarNamed: #locals) size == 1.
    self assert: ((engine instVarNamed: #locals) includesKey: 'var') .
    self assert: ((engine instVarNamed: #locals) at: 'var') = 'float' .

    "Created: / 23-05-2014 / 09:24:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_analyze_02_int_1

    self complete:'int var; ┃'.

    self assert: (engine instVarNamed: #locals) size == 1.
    self assert: ((engine instVarNamed: #locals) includesKey: 'var') .
    self assert: ((engine instVarNamed: #locals) at: 'var') = 'int' .

    "Created: / 23-05-2014 / 09:19:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_analyze_02_int_2

    self complete:'int var = 10; ┃'.

    self assert: (engine instVarNamed: #locals) size == 1.
    self assert: ((engine instVarNamed: #locals) includesKey: 'var') .
    self assert: ((engine instVarNamed: #locals) at: 'var') = 'int' .

    "Created: / 23-05-2014 / 09:22:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_analyze_02_long

    self complete:'long var; ┃'.

    self assert: (engine instVarNamed: #locals) size == 1.
    self assert: ((engine instVarNamed: #locals) includesKey: 'var') .
    self assert: ((engine instVarNamed: #locals) at: 'var') = 'long' .

    "Created: / 23-05-2014 / 09:23:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_analyze_02_ref_full

    self complete:'java.util.ArrayList var; ┃'.

    self assert: (engine instVarNamed: #locals) size == 1.
    self assert: ((engine instVarNamed: #locals) includesKey: 'var') .
    self assert: ((engine instVarNamed: #locals) at: 'var') = 'java.util.ArrayList' .

    "Created: / 23-05-2014 / 09:27:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_analyze_02_ref_short

    self complete:'ArrayList var; ┃'.

    self assert: (engine instVarNamed: #locals) size == 1.
    self assert: ((engine instVarNamed: #locals) includesKey: 'var') .
    self assert: ((engine instVarNamed: #locals) at: 'var') = 'ArrayList' .

    "Created: / 23-05-2014 / 09:26:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_analyze_02_short

    self complete:'short var; ┃'.

    self assert: (engine instVarNamed: #locals) size == 1.
    self assert: ((engine instVarNamed: #locals) includesKey: 'var') .
    self assert: ((engine instVarNamed: #locals) at: 'var') = 'short' .

    "Created: / 23-05-2014 / 09:23:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_analyze_03a

    self complete:' int var1; 
                    def var2 = var1 + ┃'.

    self assert: (engine instVarNamed: #locals) size == 2.
    self assert: ((engine instVarNamed: #locals) includesKey: 'var1') .
    self assert: ((engine instVarNamed: #locals) at: 'var1') = 'int' .

    self assert: ((engine instVarNamed: #locals) includesKey: 'var2') .
    self assert: ((engine instVarNamed: #locals) at: 'var2') = nil .

    "Created: / 23-05-2014 / 10:32:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyCompletionEngineSimpleTests methodsFor:'tests - completion'!

test_complete_01a

    self complete:'import java.uti┃'.

    self assert: result notEmpty.
    self assert: (result allSatisfy:[:each | each class == JavaImportPO ]).
    self assert: (result contains:[:each | each import = 'java.util.*' ]).
    self assert: (result contains:[:each | each import = 'java.util.zip.*' ]).
    self assert: (result contains:[:each | each import = 'java.util.ArrayList' ]).

    "Created: / 22-05-2014 / 17:28:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_complete_02a

    self complete:'im┃'.

    self assert: result notEmpty.
    self assert: (result contains:[:each | each isSmallSenseSnippetPO and:[each value = 'import '] ]).

    "Created: / 22-05-2014 / 17:33:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_complete_03a
    "
    Test variable completion"

    self complete:'int  ival = 10;
                   List ilist = new ArrayList();
                   il┃'.

    self assert: result size >= 2.
    self assert: (result contains:[:each | each isSmallSenseVariablePO and:[each name = 'ilist']]).
    self assert: (result contains:[:each | each isSmallSenseVariablePO and:[each name = 'ival']]) .

    "Created: / 23-05-2014 / 10:30:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_complete_03b
    "
    Test variable completion"

    self complete:'int  ival = 10;
                   List ilist = new ArrayList();
                   i┃'.

    self assert: result size >= 2.
    self assert: (result contains:[:each | each isSmallSenseVariablePO and:[each name = 'ilist'] ]).
    self assert: (result contains:[:each | each isSmallSenseVariablePO and:[each name = 'ival'] ]).

    "Created: / 23-05-2014 / 10:36:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_complete_03c
    "
    Test variable completion"

    self complete:'int  ival = 10;
                   List ilist = new ArrayList();
                   ilist.add( i┃ )'.

    self assert: result size >= 2.
    self assert: (result contains:[:each | each isSmallSenseVariablePO and:[each name = 'ilist'] ]).
    self assert: (result contains:[:each | each isSmallSenseVariablePO and:[each name = 'ival'] ]).

    "Created: / 23-05-2014 / 10:38:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_complete_03d
    "
    Test pseudo-variable completion"

    self complete:'th┃'.

    self assert: result size >= 1.
    self assert: (result contains:[:each | each isSmallSenseSnippetPO and:[each value = 'this '] ]).

    "Created: / 23-05-2014 / 10:39:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_complete_04a
    "
    Test class completion
    "

    | java_lang_ArrayList ctors pos |

    self complete:'def list = new Arr┃'.

    java_lang_ArrayList := context environment == Smalltalk 
                            ifTrue:[ context environment classNamed: #'JAVA::java::util::ArrayList'  ]
                            ifFalse:[ context environment classNamed: #'java/util/ArrayList'].
    ctors := java_lang_ArrayList methodDictionary values select:[:e | e selector startsWith: '<init>' ].
    pos := result select:[:each | each class == JavaConstructorPO and:[ each classes anElement == java_lang_ArrayList ] ].

    self assert: result size >= ctors size.
    ctors do:[:ctor |  
        self assert: (pos contains:[:po | po selector == ctor selector ]).
    ].

    "Created: / 23-05-2014 / 11:12:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_complete_04b
    "
    Test class completion
    "

    | java_lang_ArrayList ctors pos |

    self complete:'def list = new java.util.Arr┃'.

    java_lang_ArrayList := context environment == Smalltalk 
                            ifTrue:[ context environment classNamed: #'JAVA::java::util::ArrayList'  ]
                            ifFalse:[ context environment classNamed: #'java/util/ArrayList'].
    ctors := java_lang_ArrayList methodDictionary values select:[:e | e selector startsWith: '<init>' ].
    pos := result select:[:each | each class == JavaConstructorPO and:[ each classes anElement == java_lang_ArrayList ] ].

    self assert: result size >= ctors size.
    ctors do:[:ctor |  
        self assert: (pos contains:[:po | po selector == ctor selector ]).
    ].

    "Created: / 23-05-2014 / 11:32:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_complete_04c
    "
    Test class completion
    "

    | java_lang_ArrayList ctors pos |

    self complete:'def list = new java.util.┃'.

    java_lang_ArrayList := context environment == Smalltalk 
                            ifTrue:[ context environment classNamed: #'JAVA::java::util::ArrayList'  ]
                            ifFalse:[ context environment classNamed: #'java/util/ArrayList'].
    ctors := java_lang_ArrayList methodDictionary values select:[:e | e selector startsWith: '<init>' ].
    pos := result select:[:each | each class == JavaConstructorPO and:[ each classes anElement == java_lang_ArrayList ] ].

    self assert: result size >= ctors size.
    ctors do:[:ctor |  
        self assert: (pos contains:[:po | po selector == ctor selector ]).
    ].

    "Created: / 23-05-2014 / 11:33:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_complete_04d
    "
    Test class completion
    "

    | java_lang_ArrayList ctors pos |

    self complete:'def list = new java.ut┃'.

    java_lang_ArrayList := context environment == Smalltalk 
                            ifTrue:[ context environment classNamed: #'JAVA::java::util::ArrayList'  ]
                            ifFalse:[ context environment classNamed: #'java/util/ArrayList'].
    ctors := java_lang_ArrayList methodDictionary values select:[:e | e selector startsWith: '<init>' ].
    pos := result select:[:each | each class == JavaConstructorPO and:[ each classes anElement == java_lang_ArrayList ] ].

    self assert: result size >= ctors size.
    ctors do:[:ctor |  
        self assert: (pos contains:[:po | po selector == ctor selector ]).
    ].

    "Created: / 23-05-2014 / 11:41:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_complete_05a
    "
    Test method completion
    "

    | java_lang_ArrayList methods pos |

    self complete:'def list = new java.util.ArrayList();
                   list.addA┃'.

    java_lang_ArrayList := context environment == Smalltalk 
                            ifTrue:[ context environment classNamed: #'JAVA::java::util::ArrayList'  ]
                            ifFalse:[ context environment classNamed: #'java/util/ArrayList'].

    methods := java_lang_ArrayList methodDictionary values select:[:e | e selector startsWith: 'addA' ].
    pos := result select:[:each | each isSmallSenseMethodPO and:[ each selector startsWith: 'addA' ] ].

    self assert: result size >= methods size.
    methods do:[:method |  
        self assert: (pos contains:[:po | po selector == method selector ]).
    ].

    "Created: / 23-05-2014 / 11:43:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyCompletionEngineSimpleTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

