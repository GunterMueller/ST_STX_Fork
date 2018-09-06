"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libtool' }"

RBProgramNodeVisitor subclass:#CodeGenerator
	instanceVariableNames:'class protocol source change replacements
		recordedReplacementsInSource'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers'
!

!CodeGenerator class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
! !

!CodeGenerator methodsFor:'accessing'!

category:aString

    self protocol: aString

    "Created: / 30-12-2008 / 17:41:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-07-2009 / 18:46:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

change

   change ifNil:[self createChange].
   ^change

    "Created: / 30-12-2008 / 17:14:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-07-2009 / 18:45:07 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

class:aClass

    class := aClass

    "Created: / 30-12-2008 / 15:38:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-07-2009 / 18:46:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

protocol
    ^ protocol
!

protocol:aString
    protocol := aString.
!

replace: placeholder with: code

    replacements 
        at: placeholder
        put: (code isSymbol 
                ifTrue:[code]
                ifFalse:[RBParser parseRewriteExpression: code])

    "Created: / 07-07-2009 / 18:48:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-07-2009 / 19:58:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

replacementFor: placeholder

    ^replacements 
        at: placeholder
        ifAbsent:[self error:'No replacement for ', placeholder]

    "Created: / 07-07-2009 / 19:13:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

source:aString
    source := aString.

    "Created: / 30-12-2008 / 17:04:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CodeGenerator methodsFor:'compiling'!

compile

    ^self change apply

    "Created: / 07-07-2009 / 18:47:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CodeGenerator methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    super initialize.
    replacements := Dictionary new.

    "Created: / 30-12-2008 / 15:29:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-07-2009 / 18:45:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CodeGenerator methodsFor:'private'!

createChange

    | parser method |
    parser := RBParser new.
    recordedReplacementsInSource := OrderedCollection new.
    parser errorBlock:[ :str :pos | self error: ('Error: %1: %2' bindWith: pos with: str). ^ self ].
    parser initializeParserWith: source type: #rewriteSavingCommentsOn:errorBlock:.
    method := parser parseMethod: source.    

    method source: nil.
    method acceptVisitor: self.
    self replaceInSourceCode.
    (change := InteractiveAddMethodChange new)
        class: class
        protocol: protocol
        source: (source notNil ifTrue:[source] ifFalse:[method formattedCode]).

    "Created: / 07-07-2009 / 18:44:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 26-08-2014 / 23:51:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

recordReplaceInSourceFrom:start to:stop by:code
    recordedReplacementsInSource add: { start. stop . code }.

    "Modified: / 26-08-2014 / 23:50:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

replaceInSourceCode
    "Perform recorded replacements in source"

    recordedReplacementsInSource sort: [ :a :b | a second < b first ].
    recordedReplacementsInSource reverseDo:[ :replacement |
        source := 
            (source copyTo: replacement first - 1) , replacement third , (source copyFrom: replacement second + 1)  
    ].

    "Created: / 26-08-2014 / 23:51:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

replacePlaceholdersInSelectorPartsOf:aMessageNode 
    aMessageNode selectorParts do:[:part | 
        part isPatternVariable ifTrue:[
            |replacement|

            replacement := self replacementFor:part value.
            (replacement isSymbol or:[ replacement isVariable ]) ifFalse:[
                self error:'Replacement for selector parts must be a single selector'
            ].
            source notNil ifTrue:[
                self 
                      recordReplaceInSourceFrom:part start
                      to:part stop
                      by:replacement formattedCode.
            ].
            part value:replacement formattedCode.                 
        ]
    ]

    "Modified: / 26-08-2014 / 23:37:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeGenerator methodsFor:'visitor-double dispatching'!

acceptMessageNode:aMessageNode 
    self replacePlaceholdersInSelectorPartsOf:aMessageNode.
    super acceptMessageNode:aMessageNode.

    "Created: / 07-07-2009 / 19:23:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

acceptMethodNode: aMethodNode

    self replacePlaceholdersInSelectorPartsOf: aMethodNode.
    super acceptMethodNode: aMethodNode.

    "Created: / 07-07-2009 / 19:09:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

acceptVariableNode: aVariableNode

    aVariableNode isPatternNode ifTrue:[            
        source notNil ifTrue:[ 
            self 
                  recordReplaceInSourceFrom:aVariableNode start
                  to:aVariableNode stop
                  by:(self replacementFor:aVariableNode name) formattedCode
        ].
        aVariableNode replaceWith: (self replacementFor:aVariableNode name).
    ]

    "Created: / 30-12-2008 / 17:13:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-07-2009 / 19:13:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 26-08-2014 / 23:37:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeGenerator class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/CodeGenerator.st,v 1.4 2014-08-26 22:58:13 vrany Exp $'
!

version_SVN
    ^ '$Id: CodeGenerator.st,v 1.4 2014-08-26 22:58:13 vrany Exp $'
! !

