"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

MCBrowserList subclass:#MCPackageList
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-St/X UI'
!


!MCPackageList methodsFor:'generators'!

makeGenerator
    "superclass Tools::BrowserList says that I am responsible to implement this method"

    ^Iterator on:
        [:whatToDo| | selection |
        selection := self selectionHolder value.
        selection ifNotNil:[
        selection versions do: [:verentry|whatToDo value: verentry]]].

    "Modified: / 16-09-2010 / 19:01:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCPackageList methodsFor:'private'!

makeDependent
    "superclass Tools::BrowserList says that I am responsible to implement this method"

    "^ self shouldImplement"

    "Modified: / 16-09-2010 / 16:38:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

makeIndependent
    "superclass Tools::BrowserList says that I am responsible to implement this method"

    "^ self shouldImplement"

    "Modified: / 16-09-2010 / 16:38:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateList
    | generator list |

    self withWaitCursorDo:[
        generator := self inGeneratorHolder value ? #().
        list := SortedCollection sortBlock:[:a :b|a name < b name].
        generator do:[:pkgentry|list add: pkgentry].
        "/ list.
        self listHolder value: list.
        self setListValid:true.
    ].

    "Modified: / 16-09-2010 / 18:55:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-08-2011 / 16:22:41 / cg"
! !

!MCPackageList class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCPackageList.st,v 1.5 2015-02-01 14:14:48 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCPackageList.st,v 1.5 2015-02-01 14:14:48 cg Exp $'
!

version_SVN
    ^ '$Id: MCPackageList.st,v 1.5 2015-02-01 14:14:48 cg Exp $'
! !

