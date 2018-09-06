"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015 Jan Vrany

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
"{ Package: 'stx:goodies/smallsense/refactoring_custom' }"

"{ NameSpace: SmallSense }"

CodeGenerator subclass:#CustomSourceCodeGenerator
	instanceVariableNames:'formatter commentPlaceholderMarker commentReplacements'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom'
!

!CustomSourceCodeGenerator class methodsFor:'documentation'!

copyright
"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015 Jan Vrany

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
!

documentation
"
    Extension for CodeGenerator to support work just with source code and with formatter.
    Replacements definition are not stricly limited to just expressions, but also method call.

    [author:]
        Jakub Nesveda <nesvejak@fit.cvut.cz>

"
! !

!CustomSourceCodeGenerator methodsFor:'accessing'!

commentPlaceholderMarker: aString
    "
    Sets prefix string which will mark comment replace 
    in code replacements given by:
    replace: '`comment' with: 'comment'
    "

    commentPlaceholderMarker := aString

    "Created: / 19-09-2014 / 21:17:08 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

formatter

    ^ formatter

    "Created: / 19-09-2014 / 22:24:21 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

formatter: aSourceCodeFormatter

    formatter := aSourceCodeFormatter

    "Created: / 19-09-2014 / 22:25:13 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

newSource
    "
    Returns formatted method source
    code as string (with replacements and so on)
    "

    | parser method |  

    source := self replaceCommentsInSource: source.
    parser := RBParser new.
    recordedReplacementsInSource := OrderedCollection new.
    parser errorBlock:[ :str :pos | self error: ('Error: %1: %2' bindWith: pos with: str). ^ self ].

    parser initializeParserWith: source type: #rewriteSavingCommentsOn:errorBlock:.
    method := parser parseMethod: source.    

    method source: nil.
    method acceptVisitor: self.
    self replaceInSourceCode.
    method source: source.

    ^ formatter formatParseTree: method.

    "Created: / 19-09-2014 / 22:07:14 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

replace: placeholder with: code

    (placeholder startsWith: commentPlaceholderMarker) ifTrue: [
        commentReplacements
            at: placeholder 
            put: code
    ]
    ifFalse: [
        replacements 
            at: placeholder
            put: (self replacementFromCode: code)
    ]

    "Created: / 19-09-2014 / 21:18:30 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 19-09-2014 / 23:58:39 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSourceCodeGenerator methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    super initialize.
    commentPlaceholderMarker := '`"'.
    commentReplacements := Dictionary new.

    "Created: / 19-09-2014 / 21:42:26 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSourceCodeGenerator methodsFor:'private'!

formatReplacement: replacement 
    "Returns formatted source code replacement, but keep Symbol not formatted"

    replacement isSymbol ifTrue: [ 
        ^ replacement formattedCode
    ].

    ^ formatter formatParseTree: replacement

    "Created: / 20-09-2014 / 10:01:18 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

replaceCommentsInSource: aSourceCodeString
    "
    Returns source string with replaced occurences of comment
    replaces given by:
    replace: '`{double_quote_char}comment' with: '{double_quote_char}a comment{double_quote_char}'
    where {double_quote_char} is "" (but not escaped like in this comment)
    "

    | sourceCode |

    sourceCode := aSourceCodeString.

    commentReplacements keysAndValuesDo: [ :placeholder :code | 
        sourceCode := sourceCode copyReplaceString: placeholder withString: code       
    ].

    ^ sourceCode

    "Created: / 19-09-2014 / 22:08:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

replacePlaceholdersInSelectorPartsOf:aMessageNode 
    aMessageNode selectorParts do:[:part | 
        part isPatternVariable ifTrue:[
            |replacement|

            replacement := self replacementFor:part value.
            "(replacement isSymbol or:[ replacement isVariable ]) ifFalse:[
                self error:'Replacement for selector parts must be a single selector'
            ]."
            replacement isNil ifTrue: [ 
                self error: 'None replacement for: ', part value asString.
            ].
            source notNil ifTrue:[
                self 
                      recordReplaceInSourceFrom:part start
                      to:part stop
                      by: (self formatReplacement: replacement).
            ].
            part value: (self formatReplacement: replacement).
        ]
    ]

    "Created: / 19-09-2014 / 23:55:53 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 20-09-2014 / 10:14:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

replacementFromCode: aCode

    ^ aCode isSymbol 
        ifTrue:[aCode]
        ifFalse:[
            RBParser parseRewriteExpression: aCode onError: [ :str :pos |
                RBParser parseRewriteMethod: aCode onError: [ :str :pos | 
                    self error: 'Cannot parse: ', str, ' at pos: ', pos asString 
                ]
            ]
        ]

    "Created: / 19-09-2014 / 23:56:27 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSourceCodeGenerator class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

