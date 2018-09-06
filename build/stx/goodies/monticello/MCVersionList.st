"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

MCBrowserList subclass:#MCVersionList
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-St/X UI'
!


!MCVersionList methodsFor:'generators'!

makeGenerator
    "superclass Tools::BrowserList says that I am responsible to implement this method"

     ^Iterator on:
        [:whatToDo| | selection |
        selection := self selectionHolder value.
        selection ifNotNil:[whatToDo value: selection]].

    "Modified: / 17-09-2010 / 09:53:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCVersionList methodsFor:'private'!

makeDependent
    "superclass Tools::BrowserList says that I am responsible to implement this method"

    "^ self shouldImplement"

    "Modified: / 16-09-2010 / 19:03:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

makeIndependent
    "superclass Tools::BrowserList says that I am responsible to implement this method"

    "^ self shouldImplement"

    "Modified: / 16-09-2010 / 19:03:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateList
    | generator list |

    self withWaitCursorDo:[
        generator := self inGeneratorHolder value ? #().
        list := SortedCollection sortBlock:
            [:v1 :v2| | vn1 vn2 |
            vn1 := v1 versionNumber.
            vn2 := v2 versionNumber.
            (vn1 notNil and:[vn2 notNil]) 
                ifTrue:[vn1 > vn2]
                ifFalse:[v1 name > v2 name]].
        generator do:[:verentry|list add: verentry].
        self listHolder value: list.
        self setListValid:true.
    ].

    "Modified: / 13-10-2010 / 15:32:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-08-2011 / 16:24:11 / cg"
! !

!MCVersionList class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCVersionList.st,v 1.5 2015-02-01 14:14:41 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCVersionList.st,v 1.5 2015-02-01 14:14:41 cg Exp $'
!

version_SVN
    ^ '$Id: MCVersionList.st,v 1.5 2015-02-01 14:14:41 cg Exp $'
! !

