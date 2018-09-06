"{ Package: 'stx:clients/Clock' }"

ApplicationDefinition subclass:#stx_clients_Clock
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_clients_Clock class methodsFor:'description'!

preRequisites
    ^ #(
'stx:libbasic'
'stx:libwidg3'
)
!

startupClassName
    ^ 'Clock'
!

subProjects
    ^ #(
)
! !

!stx_clients_Clock class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'stx_clients_Clock'
        Clock
        Clock2
        RoundClock
        RoundClock2
    )
! !

!stx_clients_Clock class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'eXept Software AG'
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Application'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988-2013\nCopyright eXept Software AG 1998-2013'
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_clients_Clock class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Clock/stx_clients_Clock.st,v 1.5 2013-07-09 20:40:20 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/clients/Clock/stx_clients_Clock.st,v 1.5 2013-07-09 20:40:20 cg Exp $'
! !

