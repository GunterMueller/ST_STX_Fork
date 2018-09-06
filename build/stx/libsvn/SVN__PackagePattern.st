"
 Copyright (c) 2007-2010 Jan Vrany
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
"{ Package: 'stx:libsvn' }"

"{ NameSpace: SVN }"

Object subclass:#PackagePattern
	instanceVariableNames:'pattern patternComponents'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Private'
!

!PackagePattern class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany
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

!PackagePattern class methodsFor:'instance creation'!

for: aString

    ^self new setPattern: aString

    "Created: / 12-03-2011 / 20:59:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PackagePattern class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!PackagePattern methodsFor:'initialization'!

setPattern:something
    pattern := something.
    self preProcess

    "Created: / 12-03-2011 / 20:58:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PackagePattern methodsFor:'matching'!

match: package into: replacements

    | packageComponents start replacementIndex replacementSize |

    "Ugly code warning. Q&D hack"

    packageComponents := (package copyReplaceAll: $: with: $/) tokensBasedOn: $/.
    start := 1.
    replacementIndex := 1.
    replacementSize := replacements size.
    1 to: patternComponents size do:
        [:i| 
        start := self matchAt: i into: replacements index: replacementIndex in: packageComponents from: start.
        replacementSize ~= replacements size ifTrue:
            [replacementIndex := replacementIndex + 1.
            replacementSize := replacements size].   
        start ifNil:[^false]].
    ^true.

    "Created: / 12-03-2011 / 21:21:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matches: package

    ^self match: package into: nil.

    "Created: / 12-03-2011 / 21:20:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PackagePattern methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    pattern printOn:aStream.

    "Modified: / 18-10-2012 / 16:02:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PackagePattern methodsFor:'private'!

matchAt: componentIdx into: replacements index: replacementIndex in: packageComponents from: start

    | component |
    component := patternComponents at: componentIdx.
    component ~= '*' ifTrue:[
        start > packageComponents size ifTrue:[^nil].
        (packageComponents at: start) = component
            ifTrue:[^start + 1]
            ifFalse:[^nil]
    ] ifFalse:[
        start > packageComponents size ifTrue:[
            componentIdx == patternComponents size ifTrue:[
                replacements ifNotNil:[
                replacements 
                    at: replacementIndex printString 
                    put: ''].
                ^start + 1
            ] ifFalse:[
                ^nil
            ]
        ].
        componentIdx == patternComponents size ifTrue:[
            replacements ifNotNil:[            
            replacements 
                at: replacementIndex printString 
                put: (packageComponents asStringWith:$/ from: start to: packageComponents size)].
            ^start + 1.   
        ] ifFalse:[
            | next i |
            next := packageComponents at: componentIdx + 1.
            i := packageComponents indexOf: next startingAt: start.
            i == 0 ifTrue:[^nil].
            replacements ifNotNil:[            
            replacements 
                at: replacementIndex printString 
                put: (packageComponents asStringWith:$/ from: start to: i - 1)].
            ^i.               
        ]        
    ]

    "Created: / 12-03-2011 / 21:49:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-03-2011 / 09:32:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

preProcess

    patternComponents := (pattern copyReplaceAll: $: with: $/) tokensBasedOn: $/.
    patternComponents first isEmpty ifTrue:[patternComponents removeFirst].
    patternComponents last  isEmpty ifTrue:[patternComponents removeLast].

    1 to: patternComponents size - 1 do:
        [:i| | c |
        c := patternComponents at: i.
        (c = '*' and:[(patternComponents at: i+1) = '*'])
            ifTrue:[self error:'Two consecutive stars may cause ambiguous match!!'].
        c isEmpty
            ifTrue:[self error:'Two consecutive slashes are not allowed!!'].                        
        (c ~= '*' and:[c includes: $*]) 
            ifTrue:[self error:'Mixed string/* matches not supported (yet)'].
        ]

    "Created: / 12-03-2011 / 21:04:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PackagePattern class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

