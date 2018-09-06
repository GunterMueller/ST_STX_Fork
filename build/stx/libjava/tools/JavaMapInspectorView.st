"{ Package: 'stx:libjava/tools' }"

DictionaryInspectorView subclass:#JavaMapInspectorView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tools-Inspectors'
!


!JavaMapInspectorView methodsFor:'menu actions'!

doRemoveKey
    "remove selected item from keys"

    |l|

    listView withWaitCursorDo:[
        self selectedKeys do:[:key |
            inspectedObject 
                perform: #'remove(Ljava/lang/Object;)Ljava/lang/Object;'
                with: key
        ].

        keys := nil.
        selectionIndex := selectedLine := nil.
        inspectedObject changed.
    ].

    l := listView firstLineShown.
    self reinspect. "force list update"
    listView scrollToLine:l.

    "Created: / 04-12-2011 / 17:49:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMapInspectorView methodsFor:'private'!

allNumericKeys

    ^false "for now"

    "Created: / 04-12-2011 / 17:38:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

baseInspectedObjectClass

    | cls |
    cls := inspectedObject class.
    [ cls binaryName startsWith: 'java/util/' ] whileFalse:[
        cls := cls superclass.
    ].
    ^cls.

    "Created: / 04-12-2011 / 17:02:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-07-2014 / 09:39:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

indexList
    "return a list of indexes to show in the selectionList.
     Set hasMore to true, if a '...' entry should be added."

    | sortBlockForKeys allShown iterator |

    allShown := (inspectedObject perform: #'size()I') <= nShown.

    (allShown and:[self allNumericKeys]) ifTrue:[
        sortBlockForKeys := [:a :b | a < b].
    ] ifFalse:[
        sortBlockForKeys := [:a :b | a displayString < b displayString].
    ].

    keys := (SortedCollection new:nShown) sortBlock:sortBlockForKeys.
    iterator := (inspectedObject 
                    perform: #'keySet()Ljava/util/Set;') 
                    perform: #'iterator()Ljava/util/Iterator;'.
    [ ( iterator perform: #'hasNext()Z' ) == 1 ] whileTrue:[
        keys add: ( iterator perform: #'next()Ljava/lang/Object;' ).
        keys size >= nShown ifTrue:[ 
            hasMore := true.
            ^ keys
        ].
    ].
    ^ keys

    "Modified: / 10-05-2011 / 08:14:59 / cg"
    "Created: / 04-12-2011 / 17:38:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

valueForSpecialLine:line

    line string = '-size' ifTrue:[
        ^inspectedObject perform: #'size()I'
    ].
    ^super valueForSpecialLine: line

    "Created: / 04-12-2011 / 17:06:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMapInspectorView methodsFor:'user interaction'!

indexedValueAtIndex:idx
    |key|

    key := keys at:idx.
    ^self indexedValueAtKey: key

    "Modified: / 04-12-2011 / 17:55:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

indexedValueAtIndex:idx put:newValue
    |key|

    key := keys at:idx.
    ^inspectedObject 
        perform: #'put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;'
        with:key 
        with:newValue.

    "Modified: / 04-12-2011 / 17:46:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

indexedValueAtKey:key
    ^ inspectedObject 
        perform: #'get(Ljava/lang/Object;)Ljava/lang/Object;'
        with: key.

    "Created: / 04-12-2011 / 17:54:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMapInspectorView class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/tools/JavaMapInspectorView.st,v 1.5 2015-03-20 13:29:52 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

