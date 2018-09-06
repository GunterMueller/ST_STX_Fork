"
 COPYRIGHT (c) 2018 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg' }"

"{ NameSpace: Smalltalk }"

Object subclass:#CodeViewTheme
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Text-Theme'
!

!CodeViewTheme class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2018 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    This class represent a 'theme' used by CodeView and subclasses.
    To create a new theme, subclass `CodeViewTheme` and override
    instance methods as desired.

    Use `UserPreferences current codeViewTheme: someThemeInstance`
    to install a theme globally, for example:

        UserPreferences current codeViewTheme: Solarized new.
        UserPreferences current codeViewTheme: SolarizedDark new.

    To reset to defaults, set `#codeViewTheme:` preference to `nil`:

        UserPreferences current codeViewTheme: nil.

    WARNING: this is still experimental work and may need some tweaks 
    until it stabilizes. Expect glithes when using and report them
    to: https://swing.fit.cvut.cz/projects/stx-jv.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!CodeViewTheme methodsFor:'styles'!

argumentIdentifierColor
    "the color used for argument identifiers;
     If syntaxColoring is turned on."

    ^ self variableColor

    "Created: / 31-03-1998 / 15:08:20 / cg"
    "Modified: / 01-04-1998 / 13:19:58 / cg"
    "Modified: / 20-12-2017 / 22:09:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

argumentIdentifierEmphasis
    "the emphasis used for argument identifiers;
     If syntaxColoring is turned on."

    ^ self variableEmphasis

    "Created: / 31-03-1998 / 15:16:40 / cg"
    "Modified: / 01-04-1998 / 13:19:55 / cg"
    "Modified: / 20-12-2017 / 22:12:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

assignmentHighlightEmphasis
    ^ Array with:(#backgroundColor -> Color lightGray)

    "Created: / 15-12-2017 / 22:37:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

badIdentifierColor
    "the color used for illegal identifiers;
     If syntaxColoring is turned on."

    ^ self identifierColor

    "Modified: / 20-12-2017 / 22:50:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

badIdentifierEmphasis
    "the emphasis used for illegal identifiers;
     If syntaxColoring is turned on."

    ^ self identifierEmphasis

    "Modified: / 21-04-2011 / 12:34:50 / cg"
    "Modified: / 21-12-2017 / 10:55:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

booleanConstantColor
    "the color used for boolean constants;
     If syntaxColoring is turned on."

    ^ self constantColor

    "Created: / 31.3.1998 / 18:12:06 / cg"
    "Modified: / 1.4.1998 / 13:20:07 / cg"
!

booleanConstantEmphasis
    "the emphasis used for boolean constants;
     If syntaxColoring is turned on."

    ^ self constantEmphasis

    "Created: / 31.3.1998 / 18:12:46 / cg"
    "Modified: / 1.4.1998 / 13:26:01 / cg"
!

bracketColor
    "the color used for brackets;
     If syntaxColoring is turned on."

    ^ self defaultSyntaxColor

    "
     self current at:#bracketColor  put:Color red.
     self current at:#bracketEmphasis  put:#bold

     self current bracketColor
     self current bracketEmphasis
    "

    "Created: / 31.3.1998 / 19:11:38 / cg"
    "Modified: / 1.4.1998 / 13:22:33 / cg"
!

bracketEmphasis
    "the emphasis used for brackets;
     If syntaxColoring is turned on."

    ^ self defaultSyntaxEmphasis

    "
     self current at:#bracketEmphasis  put:#bold
     self current bracketEmphasis
    "

    "Created: / 31.3.1998 / 19:11:38 / cg"
    "Modified: / 1.4.1998 / 13:22:33 / cg"
!

classVariableIdentifierColor
    "the color used for classVar/classInstVar identifiers
     If syntaxColoring is turned on."

    ^ self globalIdentifierColor

    "Modified: / 1.4.1998 / 13:20:47 / cg"
    "Created: / 4.3.1999 / 12:50:31 / cg"
!

classVariableIdentifierEmphasis
    "the color used for classVar/classInstVar identifiers
     If syntaxColoring is turned on."

    ^ self globalIdentifierEmphasis

    "Modified: / 1.4.1998 / 13:20:47 / cg"
    "Created: / 4.3.1999 / 12:50:31 / cg"
!

collectionEnumerationSelectorColor
    "the color used for some selected collection enumeration
     selectors (such as collect:, select: etc.);
     If syntaxColoring is turned on.
     If left nil, the normal selector color is used."

    ^ self selectorColor

    "Created: / 14-02-2012 / 15:52:39 / cg"
!

collectionEnumerationSelectorEmphasis
    "the color used for some selected collection enumeration
     selectors (such as collect:, select: etc.);
     If syntaxColoring is turned on.
     If left nil, the normal selector emphasis is used."

    ^ self selectorEmphasis

    "Created: / 14-02-2012 / 15:58:58 / cg"
!

commentColor
    "the color used for comments;
     If syntaxColoring is turned on."

    ^ self defaultSyntaxColor

    "Created: / 31-03-1998 / 15:10:23 / cg"
    "Modified: / 21-04-2011 / 12:33:39 / cg"
!

commentEmphasis
    "the emphasis used for comments;
     If syntaxColoring is turned on."

    ^ self defaultSyntaxEmphasis

    "Created: / 31-03-1998 / 15:09:59 / cg"
    "Modified: / 21-04-2011 / 12:34:48 / cg"
!

commentEmphasisAndColor
    ^ self emphasis:(self commentEmphasis) andColor:(self commentColor).

    "Modified: / 17-02-2011 / 14:20:41 / cg"
!

constantColor
    "the color used for constants;
     If syntaxColoring is turned on."

    ^ self defaultSyntaxColor

    "Created: / 31-03-1998 / 18:13:15 / cg"
    "Modified: / 21-04-2011 / 12:33:36 / cg"
!

constantEmphasis
    "the emphasis used for constants;
     If syntaxColoring is turned on."

    ^ self defaultSyntaxEmphasis

    "Created: / 31-03-1998 / 18:13:23 / cg"
    "Modified: / 01-04-1998 / 13:25:43 / cg"
    "Modified: / 11-12-2017 / 15:10:32 / jv"
!

controlFlowSelectorColor
    "the color used for some selected controlFlow selectors (such as if, while etc.);
     If syntaxColoring is turned on."

    ^ self selectorColor

    "Created: / 08-09-2006 / 15:51:20 / cg"
!

controlFlowSelectorEmphasis
    "the emphasis used for some selected controlFlow selectors (such as if, while etc.);
     If syntaxColoring is turned on."

    ^ self selectorEmphasis

    "Created: / 08-09-2006 / 15:51:04 / cg"
    "Modified: / 11-12-2017 / 16:09:04 / jv"
!

cursorBackground
    ^ self defaultSyntaxColor

    "Created: / 11-12-2017 / 18:17:52 / jv"
!

cursorColor
    ^ self defaultSyntaxBackground

    "Created: / 11-12-2017 / 18:16:33 / jv"
!

debugSelectorColor
    "the color used for some selected debug
     selectors (such as halt etc.);
     If syntaxColoring is turned on.
     If left nil, the normal selector color is used."

    ^ self selectorColor
!

debugSelectorEmphasis
    "the color used for some selected debug
     selectors (such as halt etc.);
     If syntaxColoring is turned on.
     If left nil, the normal selector emphasis is used."

    ^ self selectorEmphasis
!

defaultSyntaxBackground
    "Return a background color for the code editor. If nil is returned,
     a TextView's default background is used instread."

    ^ nil "/ defaults to TextView's default background

    "Created: / 11-12-2017 / 14:34:35 / jv"
!

defaultSyntaxColor
    "the color used for anything else;
     If syntaxColoring is turned on."

    ^ Color black

    "Modified: / 21-04-2011 / 12:31:48 / cg"
!

defaultSyntaxEmphasis
    "the emphasis used for anything else;
     If syntaxColoring is turned on."

    ^ #normal

    "Modified: / 21-04-2011 / 12:34:46 / cg"
!

emphasis:e andColor:c
    ^ Text addEmphasis:e to:(#color->c).

    "Created: / 17-02-2011 / 14:20:25 / cg"
!

emphasizeParenthesisLevel
    ^ false

    "
     UserPreferences current emphasizeParenthesisLevel
     UserPreferences current emphasizeParenthesisLevel:true
     UserPreferences current emphasizeParenthesisLevel:false
    "
!

errorColor
    "the color used for illegal identifiers;
     If syntaxColoring is turned on."

    ^ self defaultSyntaxColor

    "Modified: / 21-04-2011 / 12:33:33 / cg"
!

errorEmphasis
    "raise an error: this method should be implemented (TODO)"

    ^ nil

    "Created: / 20-12-2017 / 22:00:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

errorRaisingSelectorColor
    "the color used for some selected error raising
     selectors (such as raise etc.);
     If syntaxColoring is turned on.
     If left nil, the normal selector color is used."

    ^ self selectorColor
!

errorRaisingSelectorEmphasis
    "the color used for some selected error raising
     selectors (such as raise etc.);
     If syntaxColoring is turned on.
     If left nil, the normal selector emphasis is used."

    ^ self selectorEmphasis
!

fullSelectorCheck
    "with fullSelector check, selectors are searched immediately for
     being implemented in the system. This may not be useful on slow machines"

    ^ true

    "Created: / 31.3.1998 / 15:09:41 / cg"
    "Modified: / 1.4.1998 / 13:25:06 / cg"
!

globalClassIdentifierColor
    "the color used for global identifiers which are known to be classes;
     If syntaxColoring is turned on."

    ^ self globalIdentifierColor

    "Modified: / 1.4.1998 / 13:20:47 / cg"
    "Created: / 4.3.1999 / 12:50:31 / cg"
!

globalClassIdentifierEmphasis
    "the emphasis used for global variable identifiers which are known to be classes;
     If syntaxColoring is turned on."

    ^ self globalIdentifierEmphasis

    "Modified: / 1.4.1998 / 13:25:31 / cg"
    "Created: / 4.3.1999 / 12:51:00 / cg"
!

globalIdentifierColor
    "the color used for global identifiers;
     If syntaxColoring is turned on."

    ^ self variableColor

    "Created: / 31-03-1998 / 15:18:49 / cg"
    "Modified: / 01-04-1998 / 13:20:47 / cg"
    "Modified: / 20-12-2017 / 22:10:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

globalIdentifierEmphasis
    "the emphasis used for global variable identifiers;
     If syntaxColoring is turned on."

    ^ self variableEmphasis

    "Created: / 31-03-1998 / 15:18:29 / cg"
    "Modified: / 01-04-1998 / 13:25:31 / cg"
    "Modified: / 20-12-2017 / 22:10:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hereColor
    "the color used for the here pseudoVariable;
     If syntaxColoring is turned on."

    ^ self selfColor

    "Created: / 31.3.1998 / 17:38:09 / cg"
    "Modified: / 1.4.1998 / 13:20:57 / cg"
!

hereEmphasis
    "the emphasis used for the hre special variable;
     If syntaxColoring is turned on."

    ^ self selfEmphasis

    "Created: / 31.3.1998 / 17:35:13 / cg"
    "Modified: / 1.4.1998 / 13:25:17 / cg"
!

identifierColor
    "the color used for other identifiers;
     If syntaxColoring is turned on."

    ^ self defaultSyntaxColor

    "
     UserPreferences current at:#identifierColor put:Color green darkened darkened.
     UserPreferences current at:#identifierColor put:Color black.
    "

    "Created: / 31.3.1998 / 17:35:55 / cg"
    "Modified: / 2.4.1998 / 10:39:42 / cg"
!

identifierEmphasis
    "the emphasis used for other identifiers;
     If syntaxColoring is turned on."

    ^ self defaultSyntaxEmphasis

    "Created: / 31.3.1998 / 15:09:41 / cg"
    "Modified: / 1.4.1998 / 13:25:06 / cg"
!

instVarIdentifierColor
    "the color used for instance variable identifiers;
     If syntaxColoring is turned on."

    ^ self variableColor

    "
     UserPreferences current at:#instVarIdentifierColor put:Color green darkened.
     UserPreferences current at:#instVarIdentifierColor put:Color black.
     UserPreferences current instVarIdentifierColor
    "

    "Created: / 16-04-1998 / 18:31:29 / cg"
    "Modified: / 20-12-2017 / 22:10:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

instVarIdentifierEmphasis
    "the emphais used for instance variable identifiers;
     If syntaxColoring is turned on."

    ^ self variableEmphasis

    "Modified: / 01-04-1998 / 13:24:42 / cg"
    "Created: / 16-04-1998 / 18:40:05 / cg"
    "Modified: / 20-12-2017 / 22:11:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

jsKeywordColor
    ^ self defaultSyntaxColor
!

jsKeywordEmphasis
    ^ self defaultSyntaxEmphasis
!

localIdentifierColor
    "the color used for local variable identifiers;
     If syntaxColoring is turned on."

    ^ self variableColor

    "
     UserPreferences current at:#localIdentifierColor put:Color green darkened.
     UserPreferences current at:#localIdentifierColor put:Color black.
    "

    "Created: / 31-03-1998 / 15:18:07 / cg"
    "Modified: / 02-04-1998 / 10:40:05 / cg"
    "Modified: / 20-12-2017 / 22:09:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

localIdentifierEmphasis
    "the emphais used for local variable identifiers;
     If syntaxColoring is turned on."

    ^ self variableEmphasis

    "Created: / 31-03-1998 / 15:16:56 / cg"
    "Modified: / 01-04-1998 / 13:24:42 / cg"
    "Modified: / 20-12-2017 / 22:11:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodSelectorColor
    "the color used for a methods selector pattern;
     If syntaxColoring is turned on."

    ^ self defaultSyntaxColor

    "Created: / 31.3.1998 / 15:11:24 / cg"
    "Modified: / 1.4.1998 / 13:24:26 / cg"
!

methodSelectorEmphasis
    "the emphasis used for a methods selector pattern;
     If syntaxColoring is turned on."

    ^ self defaultSyntaxEmphasis

    "Created: / 31-03-1998 / 15:11:16 / cg"
    "Modified: / 21-04-2011 / 12:34:42 / cg"
!

numberConstantColor
    "the color used for number constants;
     If syntaxColoring is turned on."

    ^  self constantColor
!

numberConstantEmphasis
    "the emphasis used for number constants;
     If syntaxColoring is turned on."

    ^  self constantEmphasis
!

poolVariableIdentifierColor
    "the color used for pool variable identifiers
     If syntaxColoring is turned on."

    ^ self globalIdentifierColor
!

poolVariableIdentifierEmphasis
    "the color used for pool variable identifiers
     If syntaxColoring is turned on."

    ^ self globalIdentifierEmphasis
!

returnColor
    "the color used for the return expression;
     If syntaxColoring is turned on."

    ^ self defaultSyntaxColor

    "Modified: / 5.1.1980 / 00:43:52 / cg"
!

returnEmphasis
    "the emphasis used for returns;
     If syntaxColoring is turned on."

    ^ self defaultSyntaxEmphasis

    "Created: / 5.1.1980 / 00:43:39 / cg"
!

selectorColor
    "the color used for message selectors;
     If syntaxColoring is turned on."

    ^ self defaultSyntaxColor

    "Created: / 31.3.1998 / 15:19:19 / cg"
    "Modified: / 1.4.1998 / 13:24:04 / cg"
!

selectorEmphasis
    "the emphasis used for message selectors;
     If syntaxColoring is turned on."

    ^ self defaultSyntaxEmphasis

    "Created: / 31-03-1998 / 15:19:09 / cg"
    "Modified: / 21-04-2011 / 12:34:39 / cg"
    "Modified: / 09-12-2017 / 23:59:45 / jv"
!

selfColor
    "the color used for the self pseudoVariable;
     If syntaxColoring is turned on."

    ^ self identifierColor

    "Created: / 31.3.1998 / 17:35:45 / cg"
    "Modified: / 1.4.1998 / 13:21:07 / cg"
!

selfEmphasis
    "the emphasis used for the self pseudoVariable;
     If syntaxColoring is turned on."

    ^ self identifierEmphasis

    "Created: / 31.3.1998 / 17:34:57 / cg"
    "Modified: / 1.4.1998 / 13:21:51 / cg"
!

sideEffectAssignmentBackgroundColor
    "the bg-color used for assignments with side effect (i.e. to instvars, globals, classvars or pool vars).
     If nil is returned, the variable's color is used"

    ^  nil

    "Created: / 13-02-2012 / 11:35:20 / cg"
!

sideEffectAssignmentColor
    "the color used for assignments with side effect (i.e. to instvars, globals, classvars or pool vars).
     If nil is returned, the variable's color is used"

    ^  nil

    "Created: / 13-02-2012 / 11:35:09 / cg"
!

sideEffectAssignmentEmphasis
    ^ self defaultSyntaxEmphasis

    "Created: / 11-12-2017 / 16:19:22 / jv"
!

stringColor
    "the color used for string constants;
     If syntaxColoring is turned on."

    ^ self constantColor

    "Created: / 31.3.1998 / 15:19:50 / cg"
    "Modified: / 1.4.1998 / 13:22:06 / cg"
!

stringEmphasis
    "the emphasis used for string constants;
     If syntaxColoring is turned on."

    ^ self constantEmphasis

    "Created: / 31.3.1998 / 15:19:09 / cg"
    "Modified: / 1.4.1998 / 13:22:00 / cg"
!

stringEmphasisAndColor
    ^ self emphasis:(self stringEmphasis) andColor:(self stringColor).

    "Created: / 17-02-2011 / 14:29:10 / cg"
!

superColor
    "the color used for the super pseudoVariable;
     If syntaxColoring is turned on."

    ^ self selfColor

    "Created: / 31.3.1998 / 17:37:56 / cg"
    "Modified: / 1.4.1998 / 13:21:15 / cg"
!

superEmphasis
    "the emphasis used for the super pseudoVariable;
     If syntaxColoring is turned on."

    ^ self selfEmphasis

    "Created: / 31.3.1998 / 17:35:08 / cg"
    "Modified: / 1.4.1998 / 13:21:41 / cg"
!

symbolColor
    "the color used for symbol constants;
     If syntaxColoring is turned on."

    ^ self constantColor

    "Created: / 1.4.1998 / 12:57:35 / cg"
    "Modified: / 1.4.1998 / 13:22:16 / cg"
!

symbolEmphasis
    "the emphasis used for symbol constants;
     If syntaxColoring is turned on."

    ^ self constantEmphasis

    "Created: / 1.4.1998 / 12:57:43 / cg"
    "Modified: / 1.4.1998 / 13:23:43 / cg"
!

thisContextColor
    "the color used for the thisContext pseudoVariable;
     If syntaxColoring is turned on."

    ^ self identifierColor

    "Created: / 31.3.1998 / 17:37:49 / cg"
    "Modified: / 1.4.1998 / 13:21:24 / cg"
!

thisContextEmphasis
    "the emphasis used for the thisContext pseudoVariable;
     If syntaxColoring is turned on."

    ^ self identifierEmphasis

    "Created: / 31.3.1998 / 17:35:27 / cg"
    "Modified: / 1.4.1998 / 13:21:30 / cg"
!

unimplementedSelectorColor
    "the color used for bad message selectors;
     If syntaxColoring is turned on."

    ^ self unknownIdentifierColor

    "Modified: / 21-04-2011 / 12:33:29 / cg"
!

unimplementedSelectorEmphasis
    "the emphasis used for bad message selectors;
     If syntaxColoring is turned on."

    ^ self unknownIdentifierEmphasis

    "Created: / 31-03-1998 / 15:19:09 / cg"
    "Modified: / 21-04-2011 / 12:34:36 / cg"
!

unknownIdentifierColor
    "the color used for unknown identifiers;
     If syntaxColoring is turned on."

    ^ self badIdentifierColor

    "
     self current at:#unknownIdentifierColor  put:Color red.
     self current at:#unknownIdentifierEmphasis  put:#bold

     self current unknownIdentifierColor
     self current unknownIdentifierEmphasis
    "

    "Created: / 31.3.1998 / 19:11:38 / cg"
    "Modified: / 1.4.1998 / 13:22:33 / cg"
!

unknownIdentifierEmphasis
    "the emphasis used for unknown identifiers;
     If syntaxColoring is turned on."

    ^ self badIdentifierEmphasis

    "Created: / 31.3.1998 / 19:11:55 / cg"
    "Modified: / 1.4.1998 / 13:22:45 / cg"
!

variableColor
    ^self identifierColor

    "Created: / 20-12-2017 / 22:09:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

variableEmphasis
    ^self identifierEmphasis

    "Created: / 20-12-2017 / 22:09:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

xmlAttributeColor
    "the emphasis used for xml-attributes;
     If syntaxColoring is turned on."

    ^  Color green darkened

    "
     self current at:#xmlAttributeColor put:Color black
     self current xmlAttributeColor
    "

    "Created: / 24-07-2011 / 21:30:59 / cg"
!

xmlAttributeEmphasis
    "the emphasis used for xml-attributes;
     If syntaxColoring is turned on."

    ^  #bold "#normal"

    "
     self current at:#xmlAttributeEmphasis put:#normal
     self current at:#xmlAttributeEmphasis put:#bold
     self current xmlAttributeEmphasis
    "

    "Created: / 24-07-2011 / 21:30:29 / cg"
!

xmlCDataColor
    "the emphasis used for xml-CData;
     If syntaxColoring is turned on."

    ^  Color blue

    "
     self current at:#xmlCDataColor put:Color black
     self current xmlCDataColor
    "

    "Created: / 24-07-2011 / 21:31:30 / cg"
!

xmlCDataEmphasis
    "the emphasis used for xml-CData;
     If syntaxColoring is turned on."

    ^  #normal

    "
     self current at:#xmlCDataEmphasis put:#normal
     self current xmlCDataEmphasis
    "

    "Created: / 24-07-2011 / 21:31:52 / cg"
!

xmlTagColor
    "the emphasis used for xml-tags;
     If syntaxColoring is turned on."

    ^  Color blue

    "
     self current at:#xmlTagColor put:Color black
     self current xmlTagColor
    "

    "Created: / 17-02-2011 / 14:18:28 / cg"
!

xmlTagEmphasis
    "the emphasis used for xml-tags;
     If syntaxColoring is turned on."

    ^  #bold

    "
     self current at:#xmlTagEmphasis put:#normal
     self current xmlTagEmphasis
    "

    "Created: / 17-02-2011 / 14:18:01 / cg"
! !

!CodeViewTheme class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

