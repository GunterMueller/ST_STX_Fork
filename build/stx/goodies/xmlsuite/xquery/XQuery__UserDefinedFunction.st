"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Function subclass:#UserDefinedFunction
	instanceVariableNames:'params body'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Functions'
!


!UserDefinedFunction methodsFor:'accessing'!

body:anAstEnclosedExpr
    bodyNode := anAstEnclosedExpr expr

    "Created: / 28-12-2006 / 14:06:17 / janfrog"
    "Modified: / 29-12-2006 / 15:55:54 / janfrog"
    "Modified: / 18-09-2008 / 17:08:23 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

params
    ^ params

    "Created: / 28-12-2006 / 16:27:19 / janfrog"
!

params:something
    params := something.

    "Created: / 28-12-2006 / 16:27:19 / janfrog"
! !

!UserDefinedFunction methodsFor:'function API'!

evaluateInContext:context withParameters:parameters forInterpreter:interpreter 
    |retval|

    interpreter context:
        (XQueryContext new 
            dataContextEmpty;
            parent: context;
            compiledCode: self;
            yourself).
    self params with:parameters
        do:[:formalParam :realParam | 
            interpreter 
                bindVar:formalParam name
                to:realParam
                inContext:interpreter context
        ].
    retval := interpreter visit:self body.
    interpreter context:context.
     "
     self params do:[:formalParam |
     interpreter unbindVar:formalParam name inContext:context
     ].
    "
    ^ retval

    "Created: / 28-08-2007 / 22:54:26 / janfrog"
    "Modified: / 18-09-2008 / 15:43:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 03-09-2010 / 17:46:59 / Jan Kurs <kurs.jan@post.cz>"
!

localName

    ^name localName

    "Created: / 28-12-2006 / 16:27:56 / janfrog"
!

namespaceURI

    ^name ns

    "Created: / 28-12-2006 / 16:27:56 / janfrog"
! !

!UserDefinedFunction class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
