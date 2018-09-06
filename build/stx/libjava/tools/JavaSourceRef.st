"{ Package: 'stx:libjava/tools' }"

Object subclass:#JavaSourceRef
	instanceVariableNames:'line0 lineH offset length'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tools-Source'
!

!JavaSourceRef class methodsFor:'documentation'!

documentation
"
    JavaMethodSourceRef is a reference to method's source in
    its class's source file.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]
        line <Integer>      line number of first line of the method's source.
                            If the method have Javadoc, then line is first line
                            of the Javadoc, otherwise it's a first line of its
                            header, 
        offset <Integer>    offset of methods source portion in source file in bytes.
                            Zero-based.
        length <Integer>    length of the source in bytes.
                            Zero-based.
        

    [class variables:]

    [see also:]

"
! !

!JavaSourceRef class methodsFor:'utilities'!

undent: source
    | lines indent |

    lines := source asStringCollection withTabsExpanded.
    lines size == 1 ifTrue:[ ^ source ].

    indent := lines last indexOfNonSeparator - 1.
    (indent \\ 4) == 0 ifFalse:[ ^ source ].
    2 to: lines size do:[:lineNr |
        | line |

        line := lines at: lineNr.
        line size < indent ifTrue:[
            line do:[:c|c isSeparator ifFalse:[ ^ source ]].
        ] ifFalse:[
            1 to: indent do:[:colNr |
                (line at: colNr) ~~ (Character space) ifTrue:[ ^ source ].
            ].
        ].
        lines at: lineNr put: (line copyFrom: indent + 1).
    ].
    ^ lines asString

    "Created: / 09-09-2013 / 01:05:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaSourceRef methodsFor:'accessing'!

length
    ^ length
!

length:anInteger
    length := anInteger.
!

line0
    ^ line0
!

line0:anInteger
    line0 := anInteger.
!

lineH
    ^ lineH
!

lineH:anInteger
    lineH := anInteger.
!

offset
    ^ offset
!

offset:anInteger
    offset := anInteger.
! !

!JavaSourceRef methodsFor:'reading'!

readFrom: stringOrStream
    | s |
    s := stringOrStream readStream.
    s position: offset.
    ^ self class undent: (s next: length)

    "Created: / 07-09-2013 / 02:31:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-09-2013 / 01:05:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaSourceRef class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/tools/JavaSourceRef.st,v 1.2 2015-03-20 13:29:52 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

