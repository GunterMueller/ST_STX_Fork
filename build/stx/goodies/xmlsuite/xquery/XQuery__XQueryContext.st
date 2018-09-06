"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Perseus::InterpreterContext variableSubclass:#XQueryContext
	instanceVariableNames:'dataContext optContext variables nodeSet'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Core'
!


!XQueryContext class methodsFor:'instance creation'!

withSingleBoolean: aBoolean

    ^self new
                dataContextSingle:(
                    AtomicItem withBoolean: aBoolean).

    "Created: / 28-12-2006 / 12:03:30 / janfrog"
    "Modified: / 21-03-2007 / 13:03:41 / janfrog"
    "Modified: / 07-10-2009 / 12:12:50 / Jan Kurs <kursj1@fel.cvut.cz>"
!

withSingleNumber:aNumber 
    ^ XQueryContext new 
        dataContextSingle:(AtomicItem withNumber: aNumber).

    "Created: / 28-12-2006 / 12:04:05 / janfrog"
    "Modified: / 21-03-2007 / 13:03:49 / janfrog"
    "Modified: / 07-10-2009 / 12:13:14 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQueryContext methodsFor:'accessing'!

dataContext
    ^ dataContext

    "Created: / 01-09-2006 / 20:51:05 / ked"
!

dataContext:something 
    dataContext := something.

    "Created: / 01-09-2006 / 20:51:44 / ked"
!

dataContextEmpty
    dataContext := OrderedCollection new.

    "Created: / 01-09-2006 / 20:57:22 / ked"
!

dataContextSingle:something 
    dataContext := XQuerySequence new add:something; yourself.

    "Created: / 01-09-2006 / 20:57:38 / ked"
    "Modified: / 15-09-2006 / 10:35:57 / ked"
    "Modified: / 21-03-2007 / 13:04:03 / janfrog"
!

flatten

    | current flattened | 
    current := self.
    flattened := self class new.
    [ current notNil ] whileTrue:[
        current variables keysAndValuesDo:
            [:name :value|
            (flattened variables includesKey: name) ifFalse:
                [flattened variables at: name put: value]].
        current := current sender.
    ].
    ^flattened

    "Created: / 04-05-2010 / 18:48:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nodeSet

    nodeSet ifNil:[nodeSet := XQuerySequence new:0].
    ^nodeSet

    "Created: / 21-03-2007 / 12:54:08 / janfrog"
    "Modified: / 18-09-2008 / 16:12:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

nodeSet:something
    ^nodeSet := something.

    "Created: / 21-03-2007 / 12:54:08 / janfrog"
    "Modified: / 18-09-2008 / 16:41:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

optContext
    ^ optContext

    "Created: / 03-09-2006 / 11:46:33 / ked"
!

optContext:something 
    optContext := something.

    "Created: / 03-09-2006 / 11:46:49 / ked"
!

optContextEmpty
    optContext := Dictionary new.

    "Created: / 03-09-2006 / 11:47:05 / ked"
! !

!XQueryContext methodsFor:'accessing - variables'!

variableAt: name

    ^self variables at: name

    "Created: / 20-03-2007 / 23:02:29 / janfrog"
!

variableAt: name put: value
    self assert: (name class = String).
    ^self variables at: name put: value

    "Created: / 20-03-2007 / 23:02:42 / janfrog"
    "Modified: / 19-09-2009 / 15:02:41 / Jan Kurs <kursj1@fel.cvut.cz>"
!

variables

    ^variables ifNil:[variables := OrderedDictionary new]

    "Created: / 20-03-2007 / 23:03:04 / janfrog"
    "Modified: / 18-09-2008 / 18:23:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XQueryContext methodsFor:'copying'!

copyContext

    ^self copyToLevel: 2.

    "Created: / 07-10-2006 / 22:30:22 / ked"
! !

!XQueryContext class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
