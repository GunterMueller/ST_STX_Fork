"{ Package: 'stx:libjava/tools' }"

SetInspectorView subclass:#JavaSetInspectorView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tools-Inspectors'
!


!JavaSetInspectorView methodsFor:'private'!

baseInspectedObjectClass

    | cls |
    cls := inspectedObject class.
    [ cls binaryName startsWith: 'java/util/' ] whileFalse:[
        cls := cls superclass.
    ].
    ^cls.

    "Created: / 04-12-2011 / 17:02:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-08-2014 / 11:24:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

indexList 
    "return a list of indexes to show in the selectionList.
     Set hasMore to true, if a '...' entry should be added."

    | coll iterator | 

    coll := OrderedCollection new.
    iterator := inspectedObject perform: #'iterator()Ljava/util/Iterator;'.
    [ ( iterator perform: #'hasNext()Z' ) == 1 ] whileTrue:[
        coll add: ( iterator perform: #'next()Ljava/lang/Object;' ).
        coll size >= nShown ifTrue:[ 
            hasMore := true.
            ^ coll asSortedCollection:[:a :b | a displayString < b displayString].
        ].
    ].
    ^coll asSortedCollection:[:a :b | a displayString < b displayString].

    "Created: / 04-12-2011 / 17:57:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaSetInspectorView class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/tools/JavaSetInspectorView.st,v 1.5 2015-03-20 13:29:52 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

