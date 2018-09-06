"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Perseus::Function subclass:#Function
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Functions'
!

!Function class methodsFor:'documentation'!

documentation

    "
        I'm instance of function and I'm holded in interprete's
        funcTable. I know my name as well as namespace uri in which
        I'm. 

        To execute myself on conrete data, you have to 'instantiate' myself
        using the #instantiate to obtain so called 'function instance'. Then
        you have to fill the instance with particular content (as parameters,
        interpreter and so on) and evaluate me (I'm actually a command pattern).

        I've two main subclasses - NativeFunction and UserDefinedFunction. Note,
        that NativeFunctions is his own 'function instance'.
    "
! !

!Function methodsFor:'function API'!

evaluateInContext: context withParameters:parameters forInterpreter:interpreter

    "Evaluates an function. Should return an XQuery sequence"

    ^self subclassResponsibility

    "Created: / 28-08-2007 / 22:50:13 / janfrog"
!

localName

    ^self subclassResponsibility

    "Created: / 28-12-2006 / 12:02:11 / janfrog"
!

namespaceURI

    ^self subclassResponsibility

    "Created: / 28-12-2006 / 12:02:23 / janfrog"
! !

!Function class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
