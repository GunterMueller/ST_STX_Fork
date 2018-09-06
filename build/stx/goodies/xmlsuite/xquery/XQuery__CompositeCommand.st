"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

UpdateCommand subclass:#CompositeCommand
	instanceVariableNames:'commands'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Update Facility'
!

!CompositeCommand class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        Lukas Wroblewski (wrobll1@merunka)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

history
    "Created: / 02-01-2008 / 13:04:08 / wrobll1"
! !

!CompositeCommand class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.
!

with: cmd1 with: cmd2

        ^self new
                add:cmd1;
                add:cmd2;
                yourself
! !

!CompositeCommand class methodsFor:'priorities'!

priority
    "Superclass says that I am responsible to implement this method"

    self shouldImplement
! !

!CompositeCommand methodsFor:'adding & removing'!

add: cmd
        commands add: cmd

    "Modified: / 02-12-2009 / 14:54:45 / heverma1 <heverma1@fel.cvut.cz>"
    "Modified: / 18-04-2010 / 22:04:58 / Martin Hevera <>"
! !

!CompositeCommand methodsFor:'checks'!

checkSourceSequence:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldNotImplement
!

checkTargetSequence:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldNotImplement
! !

!CompositeCommand methodsFor:'enumerating'!

do: aBlock
        commands do:aBlock

    "Modified: / 02-12-2009 / 14:55:12 / heverma1 <heverma1@fel.cvut.cz>"
    "Modified: / 18-04-2010 / 22:05:19 / Martin Hevera <>"
! !

!CompositeCommand methodsFor:'executing'!

execute
    "Superclass says that I am responsible to implement this method"

    self flatten.
    commands := commands asSortedCollection.
    commands do:[:cmd|cmd execute]

    "Modified: / 02-12-2009 / 14:55:54 / heverma1 <heverma1@fel.cvut.cz>"
    "Modified: / 18-04-2010 / 22:06:13 / Martin Hevera <>"
! !

!CompositeCommand methodsFor:'flattening'!

flatten

        | flattenedCommandStream |
        flattenedCommandStream := OrderedCollection new writeStream.
        self flattenOn: flattenedCommandStream.
        commands := flattenedCommandStream contents.

    "Modified: / 02-12-2009 / 14:56:14 / heverma1 <heverma1@fel.cvut.cz>"
    "Modified: / 18-04-2010 / 22:06:28 / Martin Hevera <>"
!

flattenOn: aStream
        commands do:[:cmd|cmd flattenOn: aStream].

    "Modified: / 02-12-2009 / 14:56:28 / heverma1 <heverma1@fel.cvut.cz>"
    "Modified: / 18-04-2010 / 22:06:38 / Martin Hevera <>"
! !

!CompositeCommand methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
     commands := SortedCollection new.

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 02-12-2009 / 14:56:45 / heverma1 <heverma1@fel.cvut.cz>"
    "Modified: / 18-04-2010 / 22:07:00 / Martin Hevera <>"
! !

!CompositeCommand methodsFor:'merging'!

mergeWith: anotherCmd

        self add: anotherCmd.
        ^self
! !

!CompositeCommand class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
