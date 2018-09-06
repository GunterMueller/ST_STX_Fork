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

CompletionEngineTests subclass:#AbstractJavaCompletionEngineTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Tests'
!

!AbstractJavaCompletionEngineTests class methodsFor:'documentation'!

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

!AbstractJavaCompletionEngineTests class methodsFor:'accessing'!

resources
    ^ Array with: JavaCompletionEngineEnvironmentResource

    "Created: / 22-05-2014 / 17:18:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractJavaCompletionEngineTests class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == AbstractJavaCompletionEngineTests.
! !

!AbstractJavaCompletionEngineTests methodsFor:'tests - completion'!

test_complete_catch_01a
    "
    Test catch completion
    "

    | java_io_IOException |

    self complete:'try { 
        do(something);
    } catch ( IOE┃'.

    java_io_IOException := context environment == Smalltalk 
                            ifTrue:[ context environment classNamed: #'JAVA::java::io::IOException'  ]
                            ifFalse:[ context environment classNamed: #'java/io/IOException'].

    self assert: result notEmpty.
    self assert: (result allSatisfy:[:each | each isSmallSenseClassPO ]).
    self assert: (result contains:[:each | each klass == java_io_IOException ]).

    "Created: / 07-08-2014 / 15:11:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_complete_catch_01b
    "
    Test catch completion
    "

    | java_io_IOException |

    self complete:'try { 
        do(something);
    } catch ( ┃'.

    java_io_IOException := context environment == Smalltalk 
                            ifTrue:[ context environment classNamed: #'JAVA::java::io::IOException'  ]
                            ifFalse:[ context environment classNamed: #'java/io/IOException'].

    self assert: result notEmpty.
    self assert: (result allSatisfy:[:each | each isSmallSenseClassPO ]).
    self assert: (result contains:[:each | each klass == java_io_IOException ]).

    "Created: / 07-08-2014 / 16:02:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_complete_catch_01c
    "
    Test catch completion
    "

    | java_io_IOException |

    self complete:'try { 
        do(something);
    } catch ( java.io.IO┃'.

    java_io_IOException := context environment == Smalltalk 
                            ifTrue:[ context environment classNamed: #'JAVA::java::io::IOException'  ]
                            ifFalse:[ context environment classNamed: #'java/io/IOException'].

    self assert: result notEmpty.
    self assert: (result allSatisfy:[:each | each isSmallSenseClassPO ]).
    self assert: (result contains:[:each | each klass == java_io_IOException ]).

    "Created: / 07-08-2014 / 16:07:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_complete_catch_01d
    "
    Test catch completion
    "

    | java_io_IOException |

    self complete:'try { 
        do(something);
    } catch ( java.io.┃'.

    java_io_IOException := context environment == Smalltalk 
                            ifTrue:[ context environment classNamed: #'JAVA::java::io::IOException'  ]
                            ifFalse:[ context environment classNamed: #'java/io/IOException'].

    self assert: result notEmpty.
    self assert: (result allSatisfy:[:each | each isSmallSenseClassPO ]).
    self assert: (result contains:[:each | each klass == java_io_IOException ]).

    "Created: / 07-08-2014 / 16:08:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_complete_catch_01e
    "
    Test catch completion
    "

    | java_io_IOException |

    self complete:'try { 
        do(something);
    } catch ( jav┃'.

    java_io_IOException := context environment == Smalltalk 
                            ifTrue:[ context environment classNamed: #'JAVA::java::io::IOException'  ]
                            ifFalse:[ context environment classNamed: #'java/io/IOException'].

    self assert: result notEmpty.
    self assert: (result allSatisfy:[:each | each isSmallSenseClassPO ]).
    self assert: (result contains:[:each | each klass == java_io_IOException ]).

    "Created: / 07-08-2014 / 16:20:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

