"{ Package: 'stx:libjava/tools' }"

OrderedCollectionInspectorView subclass:#JavaListInspectorView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tools-Inspectors'
!


!JavaListInspectorView methodsFor:'private'!

baseInspectedObjectClass

    | cls |
    cls := inspectedObject class.
    [ cls binaryName startsWith: 'java/util/' ] whileFalse:[
        cls := cls superclass.
    ].
    ^cls.

    "Created: / 04-12-2011 / 17:02:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-10-2013 / 22:45:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

indexList 
    "return a list of indexes to show in the selectionList.
     Set hasMore to true, if a '...' entry should be added."

    |n|

    n := inspectedObject perform: #'size()I'.
    (n > nShown) ifTrue:[
        n := nShown.
        hasMore := true.
    ].

    ^ (1 to:n)

    "Created: / 04-12-2011 / 16:55:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaListInspectorView methodsFor:'user interaction'!

indexedValueAtIndex:idx

    ^inspectedObject perform: #'get(I)Ljava/lang/Object;' with: idx - 1

    "Created: / 04-12-2011 / 16:58:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

indexedValueAtIndex:idx put: value

    ^inspectedObject 
        perform: #'set(ILjava/lang/Object;)Ljava/lang/Object;'
        with: idx - 1
        with: value.

    "Created: / 04-12-2011 / 16:58:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

indexedValueAtKey: idx

    ^self indexedValueAtIndex: idx

    "Created: / 04-12-2011 / 17:25:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

removeIndex
    "remove selected item from the collection"

    |idx|

    idx := self keyIndexForLine:selectionIndex.
    idx notNil ifTrue:[
        inspectedObject perform: #'remove(I)Ljava/lang/Object;' with:idx.
        selectionIndex := selectedLine := nil.
        inspectedObject changed.
        self reinspect.
    ].

    "Created: / 04-12-2011 / 17:08:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaListInspectorView class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/tools/JavaListInspectorView.st,v 1.5 2015-03-20 13:29:52 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

