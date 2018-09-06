"
 COPYRIGHT (c) 1996 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libhtml' }"

"{ NameSpace: Smalltalk }"

HTMLMarkup variableSubclass:#HTMLScript
	instanceVariableNames:'scriptText scriptObject'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLScript class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
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
    Attention: Please read the warning in HTMLElement.

    I represent a script in an html document.
"
! !

!HTMLScript methodsFor:'accessing'!

language
    "return language"

    ^ self parameterFor:#'LANGUAGE'
!

scriptObject
    "return scriptObject"

    ^ scriptObject
!

scriptObject:something
    "set scriptObject"

    scriptObject := something.
!

scriptText
    "return scriptText"

    ^ scriptText

    "Created: 18.9.1996 / 14:56:54 / cg"
!

scriptText:something
    "set scriptText"

    |lines n any i|

    scriptText := something.

    "/ ignore any initial HTML comment.
    "/ this is used to block non-script-capable browsers
    "/ from interpreting the script code as HTML ...
    "/
    "/ always write scripts as:
    "/   <SCRIPT LANGUAGE="smalltalkScript">
    "/   <!!--
    "/      actual script
    "/   -->
    "/   </SCRIPT>

    lines := scriptText asCollectionOfLines.
    n := lines size.
    n >= 2 ifTrue:[
        any := false.
        i := 1.
        [(i <= n) and:[(lines at:i) isEmpty]] whileTrue:[
            i := i + 1.
        ].
        (i <= n) ifTrue:[
            ((lines at:i) withoutSeparators startsWith: '<!!-') ifTrue:[
                lines at:i put:''.
                any := true.
            ].
        ].
        i := n.
        [(i >= 1) and:[(lines at:i) isEmpty]] whileTrue:[
            i := i - 1.
        ].
        (i > 0) ifTrue:[
            ((lines at:i) withoutSeparators startsWith: '-->') ifTrue:[
                lines at:i put:''.
                any := true.
            ].
        ].
        any ifTrue:[
            scriptText := lines asStringWithCRs.
        ]
    ].

    "Modified: / 25.5.1998 / 20:57:08 / cg"
!

src
    "return source"

    ^ self parameterFor:#'SRC'

    "Created: / 07-05-2011 / 17:04:19 / cg"
! !

!HTMLScript class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLScript.st,v 1.10 2016-04-28 20:45:38 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLScript.st,v 1.10 2016-04-28 20:45:38 cg Exp $'
! !

