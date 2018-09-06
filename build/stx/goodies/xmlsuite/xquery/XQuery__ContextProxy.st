"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Perseus::ContextProxy subclass:#ContextProxy
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Debugging-Model'
!


!ContextProxy methodsFor:'accessing'!

functionName

    ^nativeContext compiledCode name asString

    "Created: / 03-09-2010 / 17:44:03 / Jan Kurs <kurs.jan@post.cz>"
!

variables
    "Superclass Perseus::ContextProxy says that I am responsible to implement this method"

    ^nativeContext variables keys collect:
        [:name|
        VariableProxy new
            name: name;
            nativeContext: nativeContext].

    "Created: / 18-09-2008 / 18:12:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!ContextProxy class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
