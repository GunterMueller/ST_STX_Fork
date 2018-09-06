"
 COPYRIGHT (c) 2007 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libjavascript' }"

HTMLDocGenerator subclass:#HTMLDocGeneratorForJavaScript
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLDocGeneratorForJavaScript class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2007 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

examples
    "
     HTMLDocGeneratorForJavaScript htmlDocOf:Array
     HTMLDocumentView openFullOnText:(HTMLDocGeneratorForJavaScript htmlDocOf:Array)
    "
! !

!HTMLDocGeneratorForJavaScript class methodsFor:'document generation-helpers'!

htmlForMethod:aMethod
    "redefined to generate a javascript method spec"

    |who sel jsSel argStr firstArg|

    who := aMethod who.
    sel := who methodSelector.
    jsSel := ''.
    argStr := ''.

    sel numArgs > 0 ifTrue:[
        firstArg := true.
        (sel keywords) with:(aMethod methodArgNames) do:[:part :argName |
            |partWithoutColon xLatedArgName|

            (argName = 'aBlock') ifTrue:[
                xLatedArgName := 'aFunction'.
            ] ifFalse:[
                xLatedArgName := argName.
            ].

            (part endsWith:$:) ifTrue:[
                partWithoutColon := part copyButLast:1
            ] ifFalse:[
                partWithoutColon := part
            ].
            firstArg ifTrue:[
                "/ jsSel := partWithoutColon.
                argStr := '<I>' , xLatedArgName , '</I>'.
                firstArg := false.
            ] ifFalse:[
                "/ jsSel := jsSel , '_' , partWithoutColon.
                argStr := argStr , ', <I>' , xLatedArgName , '</I>'.
            ].
        ].
    ] ifFalse:[
        "/ jsSel := sel.
    ].
    jsSel := JavaScriptParser reverseTranslatedJavaScriptSelectorFor:sel.
    ^ '<B>' , jsSel , '</B>' , '( ' , argStr , ' )'.

    "Created: / 05-11-2007 / 16:14:46 / cg"
! !

!HTMLDocGeneratorForJavaScript class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjavascript/HTMLDocGeneratorForJavaScript.st,v 1.4 2014-09-23 20:27:55 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjavascript/HTMLDocGeneratorForJavaScript.st,v 1.4 2014-09-23 20:27:55 cg Exp $'
! !

