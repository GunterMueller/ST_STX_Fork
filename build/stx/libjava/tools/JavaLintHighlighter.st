"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libjava/tools' }"

Object subclass:#JavaLintHighlighter
	instanceVariableNames:'class problems annotations formattingMethod emphasisError
		emphasisInformation emphasisWarning'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tools-Editor-Lint'
!

!JavaLintHighlighter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!JavaLintHighlighter methodsFor:'accessing'!

annotations
    ^ annotations
!

problems
    ^ problems
!

problems:aCollection
    self reset.
    problems := aCollection.

    "Modified: / 07-08-2014 / 00:49:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLintHighlighter methodsFor:'accessing-emphasis'!

emphasisForError
    |warnColor|

    emphasisError isNil ifTrue:[
        warnColor := Color red.
        emphasisError := Array 
            "/with: #backgroundColor -> warnColor lightened lightened 
            with: #underwave 
            with: #underlineColor -> warnColor                    
    ].
    ^emphasisError

    "Created: / 05-08-2011 / 09:31:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-03-2012 / 03:00:51 / cg"
    "Modified: / 20-04-2012 / 18:29:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

emphasisForInformation
    |warnColor|

    emphasisInformation isNil ifTrue:[
        warnColor := Color blue lighter.
        emphasisInformation := Array 
            "/with: #backgroundColor -> warnColor lightened lightened
            with: #underwave 
            with: #underlineColor -> warnColor                    
    ].
    ^emphasisInformation

    "Created: / 05-08-2011 / 09:31:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-03-2012 / 03:01:22 / cg"
    "Modified: / 20-04-2012 / 18:29:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

emphasisForProblem: problem

    ^problem isError
        ifTrue:[self emphasisForError]
        ifFalse:[self emphasisForWarning].

    "Created: / 15-04-2013 / 23:33:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

emphasisForWarning
    |warnColor|

    emphasisWarning isNil ifTrue:[
        warnColor := (Color redByte: 224 greenByte: 200 blueByte: 45).
        emphasisWarning := Array 
            "/with: #backgroundColor -> warnColor lightened lightened
            with: #underwave 
            with: #underlineColor -> warnColor                  
    ].
    ^emphasisWarning

    "Created: / 05-08-2011 / 09:31:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-03-2012 / 03:00:19 / cg"
    "Modified: / 20-04-2012 / 18:29:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLintHighlighter methodsFor:'formatting'!

formatClassDefinition:source in:jclass

    class := jclass.
    ^ self format: source

    "Created: / 04-08-2011 / 23:44:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-04-2013 / 23:27:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatClassDefinition:source in:jclass elementsInto: elements

    class := jclass.
    (problems isNil and:[elements notNil]) ifTrue: [
        | tree |

        tree := elements perform: #tree ifNotUnderstood: [ nil ].
        tree notNil ifTrue: [
            self reset.
            problems := tree compilationResult problems.
        ].
    ].
    ^ self format: source

    "Created: / 04-08-2011 / 23:44:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-08-2014 / 00:38:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatClassDefinition: code line: line number: lineNr in: cls
    ^ code

    "Created: / 12-08-2014 / 13:34:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatExpression:source in:jclass

    ^ self format: source

    "Created: / 04-08-2011 / 23:45:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-04-2013 / 23:27:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatExpression:source in:jclass elementsInto: elements

    (problems isNil and:[elements notNil]) ifTrue: [
        | tree |

        tree := elements perform: #tree ifNotUnderstood: [ nil ].
        tree notNil ifTrue: [
            self reset.
            problems := tree compilationResult problems.
        ].
    ].   
    ^ self format: source

    "Created: / 04-08-2011 / 23:43:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-08-2014 / 00:39:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatMethod:mth source:source in:jclass using: preferences

    class := jclass.
    ^ self format: source

    "Created: / 04-08-2011 / 23:45:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-04-2013 / 23:28:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatMethod:mth source:source in:jclass using: preferences elementsInto: elements

    class := jclass.
    (problems isNil and:[elements notNil]) ifTrue: [
        | tree |

        tree := elements perform: #tree ifNotUnderstood: [ nil ].
        tree notNil ifTrue: [
            self reset.
            problems := tree compilationResult problems.
        ].
    ].   
    ^ self format: source

    "Created: / 04-08-2011 / 23:42:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-08-2014 / 00:39:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatMethod:mthd source:newCode line: line number: lnr in:cls using:syntaxPreferences
    ^ newCode

    "Created: / 12-08-2014 / 13:31:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLintHighlighter methodsFor:'formatting-private'!

format: text 
    "/ Fetch problems from Java parse tree
    ^ problems notEmptyOrNil 
        ifTrue: [ self format: text problems: problems ]
        ifFalse: [ text ]

    "Created: / 04-08-2011 / 23:51:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-08-2014 / 00:36:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

format: source problem: problem
    | start stop |

    start := problem getSourceStart.
    stop := problem getSourceEnd.

    ((start between: 0 and: source size - 1) and:[(stop between: 0 and: source size - 1)]) ifTrue:[
        self mark: source from: start + 1 to: stop + 1 for: problem.

    ]

    "Created: / 15-04-2013 / 22:22:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-04-2013 / 23:36:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

format: givenSource problems: problems
    "Highlight a list of problems in givenSource.
     Return a copy of the text if there is at least one problem"

    | source |

    problems isEmptyOrNil ifTrue:[ ^ givenSource ].
    source := givenSource deepCopy.
    problems do:[:problem|
        "/ `problem` may be nil, the reporter allocates
        "/ larger array ot avoid reallocation each time a
        "/ problem is added. We do not trim the array to avoid
        "/ extra array creation
        problem notNil ifTrue:[
            self format: source problem: problem.
        ].
    ].
    ^source

    "Created: / 15-04-2013 / 22:11:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-10-2013 / 10:45:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLintHighlighter methodsFor:'initialization'!

reset
    problems := nil.
    annotations := OrderedCollection new.

    "Created: / 18-02-2012 / 22:54:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-08-2014 / 00:39:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLintHighlighter methodsFor:'markup'!

mark: text from: start to: end for: problem
    | emphasis |

    emphasis := self emphasisForProblem: problem.
    text emphasisFrom: start to: end add: emphasis.     
    annotations add:
        (JavaLintAnnotation from: start to: end problem: problem)

    "Created: / 30-01-2012 / 15:30:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-09-2013 / 10:30:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unmark: text from: start to: end
    "Remove all problem emphasis from text"

    text emphasisFrom: start to: end remove: #underwave.
    text emphasisFrom: start to: end remove: #underlineColor.

    "Created: / 07-08-2014 / 01:24:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLintHighlighter class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/tools/JavaLintHighlighter.st,v 1.2 2015-03-20 13:29:52 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

