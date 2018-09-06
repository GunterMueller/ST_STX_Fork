"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Perseus::Compiler subclass:#XQueryCompiler
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Core'
!


!XQueryCompiler methodsFor:'compiler interface'!

compile: aNode

    "This is a dummy method (for now). Required by Perseus framework"

    ^XQueryQuery new 
        bodyNode: aNode;
        yourself

    "Created: / 18-09-2008 / 17:00:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 22-11-2008 / 08:13:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XQueryCompiler class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
