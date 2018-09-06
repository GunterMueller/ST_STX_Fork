"
 COPYRIGHT (c) 2009 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

Object subclass:#DiffListUtility
	instanceVariableNames:''
	classVariableNames:'DiffCommandTemplate'
	poolDictionaries:''
	category:'Views-Text'
!

!DiffListUtility class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2009 by eXept Software AG
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
    a utility to encapsulate access to the diff command
    (may also be a facade to a smalltalk-diff algorithm, eventually)

    [author:]
        cg (cg@CG-PC)

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!DiffListUtility class methodsFor:'defaults'!

diffCommand
    "return the diff-command (with argument placeHolders).
     By default, diff is used with windows, diff -b with Unix.
     You can change this via the diffCommandTemplate"

    DiffCommandTemplate notNil ifTrue:[ ^ DiffCommandTemplate ].
    ^ UserPreferences current externalDiffCommandTemplate
!

diffCommandTemplate:aCommandTemplateString
    "set the diff-command template"

    DiffCommandTemplate := aCommandTemplateString
! !

!DiffListUtility class methodsFor:'private'!

saveForDiff:text as:filename
    |stream|

    [
        stream := filename writeStream.
        text do:[:line |
            |lOut i|

            line notEmptyOrNil ifTrue:[
                lOut := line.
                (line includes:Character return) ifTrue: [
                    (line endsWith:Character return) ifTrue:[
                        lOut := line copyButLast:1.
                    ].
                ] ifFalse:[
                    (line endsWith:(String crlf)) ifTrue: [
                        lOut := line copyButLast:2.
                    ]
"/                        i := line indexOf:Character return.
"/                        (line at:i+1) == Character nl ifTrue:[
"/                            "/ crnl endings
"/                            lOut := line copyReplaceString:(String crlf) withString:(String lf).
"/                        ] ifFalse:[
"/                            "/ cr endings
"/                            lOut := line copyReplaceAll:(Character return) with:Character nl.
"/                        ].
"/                    ]
                ].
                lOut isWideString ifTrue:[
                    (lOut first = (Character value:16rFEFF)) ifTrue:[
                        lOut := (lOut copyFrom:2) asSingleByteStringReplaceInvalidWith:(Character value:16rFF).
                    ].
                ].
                lOut printOn:stream.
            ].
            stream cr
        ].
    ] ensure:[
        stream close.
    ].

    "Modified: / 22-10-2008 / 17:52:52 / cg"
! !

!DiffListUtility class methodsFor:'utilities'!

diffListFor:text1 and:text2
    "execute DiffCommand to get a list of diffs."

    "
     The returned list is in raw-diff output format, such as:
        1 : '1c1'
        2 : '< hello world'
        3 : '---'
        4 : '> Hello World'
        5 : '2a3'
        6 : '> line2'
        7 : '4d4'
        8 : '< line4'
    "

    |tmpFile1 tmpFile2 stream line 
     diffList diffTemplate diffCmd|

    diffTemplate := self diffCommand.
    diffTemplate isEmptyOrNil ifTrue:[
        "/ self warn:'no diff command available'.
        ^ nil
    ].

    text1 = text2 ifTrue:[
        "no diff"
        ^ #()
    ].

    "
     save them texts in two temporary files ...
    "
    [
        self saveForDiff:text1 as:(tmpFile1 := Filename newTemporary).
        self saveForDiff:text2 as:(tmpFile2 := Filename newTemporary).

        "
         start diff on it ...
        "
        diffCmd := diffTemplate
                    bindWith:tmpFile1 asString
                    with:tmpFile2 asString.

        stream := PipeStream readingFrom:diffCmd.
        stream isNil ifTrue:[
            "this code is not reached in win32.
             PipeStream starts a cmd.exe, which is always successful
             at the first place and fails later"
            stream := PipeStream readingFrom:('support' asFilename / diffCmd).
            stream isNil ifTrue:[
                self error:'cannot execute diff' mayProceed:true.
                ^ nil.
            ]
        ].

        diffList := OrderedCollection new.
        (stream readWaitWithTimeout:10) ifTrue:[
            "/ timeout
            stream close.
            (stream exitStatus notNil and:[stream exitStatus isError]) ifTrue:[
                self error:'cannot execute diff (command error)' mayProceed:true.
            ] ifFalse:[
                self error:'cannot execute diff (timeout)' mayProceed:true.
            ].
            ^ nil.
        ].

        [stream atEnd] whileFalse:[
            line := stream nextLine.
            line notNil ifTrue:[diffList add:line]
        ].
        stream close.
    ] ensure:[
        tmpFile1 notNil ifTrue:[ tmpFile1 delete ].
        tmpFile2 notNil ifTrue:[ tmpFile2 delete ].
    ].
    ^ diffList

    "
     self 
        diffListFor:#(
                        'hello world'
                        'line1'
                        'line3'
                        'line4'
                    )
        and:        #(
                        'Hello World'
                        'line1'
                        'line2'
                        'line3'
                    )
    "
! !

!DiffListUtility class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/DiffListUtility.st,v 1.9 2014-05-08 17:49:06 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/DiffListUtility.st,v 1.9 2014-05-08 17:49:06 stefan Exp $'
! !

