"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:goodies/smallsense' }"

"{ NameSpace: SmallSense }"

CompactHierarchicalItem subclass:#PO
	instanceVariableNames:'label relevance context'
	classVariableNames:'IconWidth'
	poolDictionaries:''
	category:'SmallSense-Core-Interface-PO'
!

!PO class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!PO class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    IconWidth := 16.

    "Modified: / 18-09-2013 / 00:13:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PO class methodsFor:'Instance creation'!

forClass: aClass
    ^ ClassPO new initializeWithClass: aClass

    "Created: / 20-05-2014 / 09:56:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forClass: aClass selector: aSymbol
    ^ MethodPO new initializeWithClass: aClass selector: aSymbol

    "Created: / 20-05-2014 / 10:31:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forClasses: aCollection selector: aSymbol
    ^ MethodPO new initializeWithClasses: aCollection selector: aSymbol

    "Created: / 20-05-2014 / 10:33:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forClasses: aCollection selector: aSymbol prefix: aString
    ^ aString notEmptyOrNil 
        ifTrue: [ MethodKeywordRestPO new initializeWithClasses: aCollection selector: aSymbol prefix: aString ]
        ifFalse:[ MethodPO new initializeWithClasses: aCollection selector: aSymbol ]

    "Created: / 20-05-2014 / 10:43:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forFieldBinding: binding
    ^ VariableBindingPO new binding: binding

    "Created: / 14-08-2014 / 09:04:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forGlobalNamed: name
    ^ VariablePO globalVariable: name

    "Created: / 24-07-2014 / 16:50:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forInstanceVariableNamed: nm in: cls
    ^ VariablePO instanceVariable: nm in: cls.

    "Created: / 13-08-2014 / 21:27:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forLocalVariableBinding: binding
    ^ VariableBindingPO new binding: binding

    "Created: / 14-08-2014 / 09:04:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forLocalVariableNamed: nm
    ^ VariablePO variable: nm

    "Created: / 12-08-2014 / 10:40:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forPackage:aSymbol
    ^ PackagePO new initializeWithPackage: aSymbol

    "Created: / 02-10-2014 / 00:01:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

subject: anObject
    <resource: #obsolete>

    ^self new subject: anObject

    "Created: / 06-04-2011 / 21:01:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PO class methodsFor:'instance creation-java'!

forMethodBinding: binding
    ^ MethodBindingPO new binding: binding

    "Created: / 13-08-2014 / 22:24:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PO methodsFor:'accessing'!

context
    ^ context
!

context:something
    something notNil ifTrue:[
        context := something.
    ].

    "Modified: / 17-10-2013 / 01:16:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cursorColumnAfterCompleteForLanguage: language
    "Answers a cursor column after completion. The number returned
     is relative to the start of the text being replaced"

    ^ (self stringToCompleteForLanguage: language) size

    "Created: / 03-10-2013 / 16:49:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-10-2013 / 07:48:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hint
    "Return a hint text to be displayed in gray after a label
     (if there's space). If nil is returned, no hint is shown"

    ^ nil

    "Created: / 20-05-2014 / 11:52:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

icon

    ^nil

    "Created: / 04-04-2011 / 17:25:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Return a text to be displayed. The label may be cached
     `label` instvar."

    ^ self subclassResponsibility

    "Created: / 07-04-2011 / 09:55:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-05-2014 / 11:30:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    <resource: #obsolete>

    self obsoleteMethodWarning.
    ^ self label

    "Modified: / 20-05-2014 / 11:36:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name:aString
    <resource: #obsolete>

    self shouldNeverBeSent

    "Modified: / 20-05-2014 / 11:36:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

relevance
    "Return relevance value, i.e., how much likely is that this
     is what user wants to complete.

     Relevance is an integer between 1 (least relevant) and 
     100 (most relevant)"

    ^ relevance ? 1

    "Modified: / 18-01-2014 / 22:41:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

relevance: anInteger
    "Set the relevance value, i.e., how much likely is that this
     is what user wants to complete.

     Relevance is an integer between 1 (least relevant) and 
     100 (most relevant)"

    ^ relevance := anInteger.

    "Modified: / 18-01-2014 / 22:41:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stringAlreadyWritten
    "Answers a string already written in the textview"    

    ^ context wordBeforeCursor

    "Created: / 20-10-2013 / 00:14:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stringToComplete
    ^ self stringToCompleteForLanguage: context language.

    "Created: / 05-04-2011 / 16:48:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-03-2014 / 23:10:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stringToCompleteForLanguage: aProgrammingLanguage
    "Answers a string to complete"

    ^ self subclassResponsibility

    "Created: / 02-10-2013 / 02:32:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-05-2014 / 11:32:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

subject:anObject
    <resource: #obsolete>

    self error: 'Should no longer be sent'.

    "Modified: / 20-05-2014 / 10:16:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PO methodsFor:'accessing-private'!

subject
    "Return the real object for which the receiver
     is a presentor.

     For internal usage only."

    ^ self subclassResponsibility

    "Modified: / 20-06-2014 / 11:09:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PO methodsFor:'completion'!

insert
    "Insert given completion item at cursor position"

    | po stringToComplete stringAlreadyWritten stringToInsert textView |

    po := self.
    textView := context textView.
    stringToComplete := po stringToCompleteForLanguage: context language.
    stringAlreadyWritten := self stringAlreadyWritten.
    stringToInsert := stringToComplete copyFrom: (stringAlreadyWritten size + 1).
    textView isCodeView2 ifTrue:[textView := textView textView].
    (stringToComplete startsWith: stringAlreadyWritten) ifTrue:[
        context support 
                electricInsert:stringToInsert
                ignoreKeystrokes:stringToInsert.
        textView cursorCol: textView cursorCol - stringToComplete size + (po cursorColumnAfterCompleteForLanguage: context language).
    ] ifFalse:[
       | startCol endCol |
       textView undoableDo:[
            endCol := textView cursorCol - 1.
            startCol := textView cursorCol - stringAlreadyWritten size.
            textView insertStringAtCursor: stringToComplete.
            textView deleteFromLine:textView cursorLine col: startCol toLine:textView cursorLine col:endCol.
        ].
        textView cursorCol: startCol + (po cursorColumnAfterCompleteForLanguage: context language).

    ].

    "Created: / 17-10-2013 / 01:08:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-02-2015 / 23:53:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PO methodsFor:'displaying'!

displayLabel:lab h:lH on:gc x:x y:y0 h:h isHighlightedAsSelected: highlighted
    | cx hint hintW cy |

    cx := x.

"/    iconOrNil := self icon.
"/    iconOrNil notNil ifTrue:[
"/        iconOrNil displayOn: aGC x: cx y: y + (h / 2) - (iconOrNil height / 2).
"/    ].
"/    cx := cx + IconWidth.

    "/ Display label
    super displayLabel:lab h:lH on:gc x:cx y:y0 h:h isHighlightedAsSelected: highlighted.

    "/ Display hint
    hint := self hint.
    hint notNil ifTrue:[ 
        cx := cx + (lab widthOn: gc).
        hintW := hint widthOn: gc.
        "/ Check whether there's enougn space fit the hint
        (gc width) > (cx + hintW + 10"spacing") ifFalse:[ 
            hint isString ifFalse:[ 
                "/ There's nothing to do for non-strings
                ^ self 
            ].
            "/ Try to shorten the text.
            hint := hint contractAtEndTo: ((gc width - cx - 10) // ('m' widthOn: gc)).
            hint size < 6 ifTrue:[ 
                "/ To short to be meaningfull, give up.
                ^ self.
            ].
            hintW := hint widthOn: gc.
            "/ Check again if it can fit...
            (gc width) > (cx + hintW + 10"spacing") ifFalse:[ 
                "/ Give up.
                ^ self.
            ]
        ].

        cx := gc width - hintW - 3"right padding".
        cy := y0 - ((lH + 1 - h) // 2).    
        (hint isString and:[hint isText not]) ifTrue:[ 
            | savPaint |

            cy := cy + (hint ascentOn:gc).   
            savPaint := gc paint.
            highlighted ifTrue:[
                gc paint: (Color white).
            ] ifFalse:[ 
                gc paint: (Color gray: 40).
            ].
            hint displayOn:gc x: cx y:cy.  
            gc paint: savPaint
        ] ifFalse:[ 
            hint isText ifTrue:[ 
                cy := cy + (hint ascentOn:gc).   
            ].
            hint displayOn:gc x: cx y:cy.  
        ].
    ].

    "Created: / 03-02-2015 / 05:34:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

displayOn:aGC x:x y:y h:h isHighlightedAsSelected: highlighted
    | cx iconOrNil |

    cx := x.

    parent isNil ifTrue:[
        iconOrNil := self icon.
        iconOrNil notNil ifTrue:[
            iconOrNil displayOn: aGC x: cx y: y + (h / 2) - (iconOrNil height / 2).
        ].
        cx := cx + IconWidth.
    ].

    super displayOn:aGC x:cx y:y h:h isHighlightedAsSelected: highlighted

    "Created: / 05-02-2015 / 06:48:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

displayString
    ^ self label

    "Created: / 20-04-2012 / 18:19:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-05-2014 / 11:34:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PO methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPut:$(.
    aStream nextPutAll:self label.
    aStream nextPut:$).

    "Modified: / 13-08-2014 / 01:53:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PO methodsFor:'queries'!

startsWith: prefix

    ^self stringToComplete startsWith: prefix

    "Created: / 26-11-2011 / 19:25:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PO methodsFor:'testing'!

isSmallSenseClassPO
    ^ false
!

isSmallSenseConstantPO
    ^ false
!

isSmallSenseMethodBindingPO
    "return false here; to be redefined in subclass(es)"

    ^ false
!

isSmallSenseMethodPO
    ^ false
!

isSmallSensePluggablePO
    ^ false
!

isSmallSenseSnippetPO
    ^ false
!

isSmallSenseVariableBindingPO
    "return false here; to be redefined in subclass(es)"

    ^ false
!

isSmallSenseVariablePO
    ^ false
! !

!PO class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !


PO initialize!
