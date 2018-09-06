"{ Encoding: utf8 }"

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
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

Object subclass:#LintHighlighter
	instanceVariableNames:'rules rulesToIntervalsMap sequenceNumber formattingMethod
		emphasisError emphasisInformation emphasisWarning'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Lint'
!

!LintHighlighter class methodsFor:'documentation'!

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

!LintHighlighter class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!LintHighlighter methodsFor:'accessing'!

rules
    ^ rules
!

rules:aCollectionOfRules
    rules := aCollectionOfRules.
    rulesToIntervalsMap := nil.

    "Modified (format): / 07-03-2012 / 17:24:02 / cg"
    "Modified: / 15-12-2014 / 20:25:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rulesToIntervalsMap
    ^ rulesToIntervalsMap

    "Created: / 15-12-2014 / 15:20:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sequenceNumber
    ^ sequenceNumber
! !

!LintHighlighter methodsFor:'accessing-emphasis'!

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

emphasisForSeverity: severity

    severity == #error ifTrue:[^self emphasisForError].
    severity == #information ifTrue:[^self emphasisForInformation].

    ^self emphasisForWarning

    "Created: / 05-08-2011 / 09:31:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

emphasisForWarning
    |warnColor|

    emphasisWarning isNil ifTrue:[
        warnColor := Color yellow slightlyDarkened. "/ (Color redByte: 224 greenByte: 200 blueByte: 45).
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

!LintHighlighter methodsFor:'formatting'!

formatClassDefinition:source in:class

    formattingMethod := false.
    ^ self format: source in: class

    "Created: / 04-08-2011 / 23:44:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-12-2014 / 11:29:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatClassDefinition:source in:class elementsInto: elements

    formattingMethod := false.
    ^ self format: source asString asText in: class

    "Created: / 04-08-2011 / 23:44:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-12-2014 / 11:29:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatExpression:source in:class

    formattingMethod := false.
    ^ self format: source in: class

    "Created: / 04-08-2011 / 23:45:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-12-2014 / 11:29:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatExpression:source in:class elementsInto: elements

    formattingMethod := false.
    ^ self format: source in: class

    "Created: / 04-08-2011 / 23:43:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-12-2014 / 11:29:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatMethod:mth source:source in:class using: preferences

    formattingMethod := true.
    ^ self format: source in: class

    "Created: / 04-08-2011 / 23:45:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-12-2014 / 11:29:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatMethod:mth source:sourceString in:class using: preferences elementsInto: elements

    formattingMethod := true.
    ^ self format: sourceString in: class

    "Created: / 04-08-2011 / 23:42:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-12-2014 / 11:30:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintHighlighter methodsFor:'formatting-private'!

format: sourceString in: class
    | tree t |

    tree := RBParser 
                parseMethod: sourceString string 
                onError:[:error :pos| ^ sourceString ].
    t := sourceString asText.
    self format: t tree: tree in: class.
    ^t

    "Created: / 02-12-2014 / 11:27:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-12-2014 / 18:42:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

format: text tree: tree in: class
    rulesToIntervalsMap := Dictionary new.
    sequenceNumber := sequenceNumber + 1.
    rules ? #() do:[:rule|
        rule isEmpty ifFalse:[
            self format: text tree: tree in: class rule: rule
        ].
    ].
    ^text

    "Created: / 02-12-2014 / 11:28:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-12-2014 / 18:43:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

format: text tree: tree in: class rule: rule
    | string |

    string := text string.
    "rule result isParseTreeEnvironment"true ifTrue:[
        formattingMethod ifTrue:[
            rule 
                resultSelectionIntervalsForSource: string tree: tree in: class 
                do: [:interval|
                    interval notEmptyOrNil ifTrue:[
                        ((interval first == 1 and:[interval last == text size]) or:[interval last > text size]) ifTrue:[
                            self debuggingCodeFor:#jv is:[
                                 Transcript showCR:'>> no meaningful selection interval for ' , rule printString.
                            ].
                        ] ifFalse:[
                            self mark: text from: interval first to: interval last for: rule.
                        ]
                    ]
                ].
        ].
    ] ifFalse: [
        | searches |

        searches := rule result searchStrings asSet.

        searches do:[:search|
            | i |
            i := 1.
            [
                i := string findString: search startingAt: i.
                i ~~ 0
            ] whileTrue:[
                self mark: text from: i to: (i + search size - 1) for: rule.
                i := i + search size + 1.
            ]


        ]
    ]

    "Created: / 02-12-2014 / 11:28:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 15-12-2014 / 18:58:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 19-11-2016 / 13:35:25 / cg"
    "Modified: / 30-01-2017 / 14:51:18 / stefan"
! !

!LintHighlighter methodsFor:'initialization'!

initialize
    sequenceNumber := 0.
! !

!LintHighlighter methodsFor:'markup'!

mark: text from: start to: end for: rule
    "this underwaves the rule's complaint"

    | emphasis |

    emphasis := self emphasisForSeverity: rule severity.
    text emphasisFrom: start to: end add: emphasis.
    (rulesToIntervalsMap at: rule ifAbsentPut: [ Set new ])
        add: (start to: end)

    "Created: / 30-01-2012 / 15:30:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-12-2014 / 15:52:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintHighlighter class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

