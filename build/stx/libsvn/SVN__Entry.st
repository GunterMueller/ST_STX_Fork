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

Object subclass:#Entry
	instanceVariableNames:'path kind revision date author'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Core'
!

!Entry class methodsFor:'documentation'!

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

!Entry class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!Entry methodsFor:'accessing'!

author
    ^ author
!

className
    "Guess name of the class contained in this source. Guess is based only
     on file name"
    
    |name|

    name := path copyFrom:(path lastIndexOf:$/) + 1
                to:(path size - self programmingLanguage sourceFileSuffix size) - 1.
    name := name replaceAll:$_ with:$:.
    ^ name asSymbol

    "Created: / 27-08-2009 / 08:40:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

date
    ^ date
!

kind
    ^ kind
!

path
    ^ path
!

path:aString
    path := aString.
!

programmingLanguage
    "Guess language of source, nil if not language guessed. Current 
     implementation is bit stupid - guess language by file suffix"
    
    ProgrammingLanguage 
        allDo:[:lang | 
            ((path size > (lang sourceFileSuffix size + 1"dot"))
                and:[(path endsWith:lang sourceFileSuffix) 
                    and:[(path at: ((path size) - (lang sourceFileSuffix size))) == $.]]) 
                        ifTrue:[
                            ^ lang
                        ]
        ].
    ^ nil

    "Created: / 27-08-2009 / 08:42:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revision
    ^ revision
! !

!Entry methodsFor:'testing'!

isSourceEntry
    |dotIndex suffix|

    self kind isFile ifFalse:[
        ^ false
    ].
    dotIndex := path lastIndexOf:$..
    dotIndex = 0 ifTrue:[
        ^ false
    ].
    suffix := path copyFrom:dotIndex + 1.
    ProgrammingLanguage 
        allDo:[:lang | 
            (suffix = lang sourceFileSuffix) ifTrue:[
                ^ true
            ]
        ].
    ^ false

    "Created: / 02-11-2009 / 13:51:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-11-2009 / 09:22:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Entry class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__Entry.st 362 2011-08-08 13:07:42Z vranyj1 §'
! !
