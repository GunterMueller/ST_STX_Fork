"{ Package: 'stx:goodies/monticello' }""{ NameSpace: Smalltalk }"MCBrowserList subclass:#MCRepositoryList	instanceVariableNames:''	classVariableNames:''	poolDictionaries:''	category:'SCM-Monticello-St/X UI'!


!MCRepositoryList methodsFor:'drag & drop'!

dropObjects:aCollectionOfDropObjects
    "drop manager wants to drop.
     This is ony sent, if #canDrop: returned true.
     Must be redefined in order for drop to work."

    ^ self shouldImplement
! !

!MCRepositoryList methodsFor:'generators'!

makeEntry: repository

    ^MCRepositoryEntry repository: repository

    "Created: / 16-09-2010 / 18:40:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

makeGenerator

    ^Iterator on:
        [:whatToDo| | selection |
        selection := self selectionHolder value.
        selection ifNotNil:[
            selection packages do: [:pkgentry|whatToDo value: pkgentry]
        ]
    ].

    "Modified: / 16-09-2010 / 18:58:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCRepositoryList methodsFor:'private'!

browserNameList
    "superclass Tools::BrowserList says that I am responsible to implement this method"

    ^ self shouldImplement
!

makeDependent
    "superclass Tools::BrowserList says that I am responsible to implement this method"

    "^ self shouldImplement"

    "Modified: / 16-09-2010 / 16:05:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

makeIndependent
    "superclass Tools::BrowserList says that I am responsible to implement this method"

    "^ self shouldImplement"

    "Modified: / 16-09-2010 / 16:05:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateList
    | repos list |

    self withWaitCursorDo:[
        repos := self inGeneratorHolder value.
        repos ifNil:[repos := MCRepositoryGroup default repositories].
        list := repos collect: [:repo|self makeEntry:repo].
        self listHolder value: list.
        self setListValid:true.
    ]

    "Modified: / 16-09-2010 / 18:58:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-12-2011 / 09:16:57 / cg"
! !

!MCRepositoryList class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCRepositoryList.st,v 1.5 2015-02-07 11:09:30 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCRepositoryList.st,v 1.5 2015-02-07 11:09:30 cg Exp $'
!

version_SVN
    ^ '$Id: MCRepositoryList.st,v 1.5 2015-02-07 11:09:30 cg Exp $'
! !

