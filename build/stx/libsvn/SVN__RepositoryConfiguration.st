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

Object subclass:#RepositoryConfiguration
	instanceVariableNames:'package url'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Core'
!

!RepositoryConfiguration class methodsFor:'documentation'!

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

!RepositoryConfiguration class methodsFor:'instance creation'!

package: package url: url

    ^self new
        package: package;
        url: url

    "Created: / 19-08-2009 / 12:17:39 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!RepositoryConfiguration methodsFor:'accessing'!

package
    ^ package
!

package:aString
    package := aString.
!

packagePattern: aString

    <resource: #obsolete>

    self package: aString

    "Created: / 16-08-2009 / 16:59:27 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

url
    ^ url
!

url: aStringOrUrl 
    | givenUrl |

    givenUrl := aStringOrUrl asURL.
    givenUrl isValidSvnRepositoryUrl ifTrue:[
        url := givenUrl.
    ] ifFalse: [         
        self error: 'Invalid repository URL' mayProceed:true.
        url := nil.
    ].

    "Modified: / 16-08-2009 / 16:42:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

urlForPackage: pkg

    | packageAsPath |
    packageAsPath := pkg asString copy replaceAll:$: with:$/.
    ^url asString expandPlaceholdersWith:
        (Dictionary new
            at: 'p' put: packageAsPath;
            yourself)

    "Created: / 16-08-2009 / 16:56:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

urlPattern: aString

    <resource: #obsolete>

    self url: aString

    "Created: / 16-08-2009 / 16:59:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

urlString
    url isNil ifTrue: [^''].
    ^ url urlPrintString

    "Created: / 16-08-2009 / 17:28:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!RepositoryConfiguration methodsFor:'comparing'!

= anotherConf

    ^self class == anotherConf class
        and:[package = anotherConf package
            and:[url = anotherConf url]].

    "Created: / 25-05-2009 / 18:54:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 16-08-2009 / 17:24:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

hash

    ^package hash bitXor:
        url hash

    "Created: / 25-05-2009 / 18:53:53 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!RepositoryConfiguration methodsFor:'converting'!

literalArrayEncoding

    ^Array
        with: self class name
        with: #package:
        with: package literalArrayEncoding
        with: #url:
        with: url asString.

    "
        (SVN::RepositoryConfiguration package:'stx:libsvn' url: 'http://smalltalk.felk.cvut.cz/svn/stx/goodies/libsvn')
            literalArrayEncoding
            decodeAsLiteralArray

    "

    "Created: / 19-08-2009 / 21:56:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!RepositoryConfiguration methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    self class storeOn:aStream.
    aStream space.
    aStream nextPutAll:'package: '.
    package storeOn:aStream.
    aStream space.
    aStream nextPutAll:'url: '.
    url asString storeOn:aStream.

    "Modified: / 19-08-2009 / 12:18:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!RepositoryConfiguration methodsFor:'queries'!

matchesPackage: pkg

    ^pkg 
        ifNil:[false]
        ifNotNil:[pkg matches: package]

    "Created: / 26-05-2008 / 09:36:27 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 16-08-2009 / 16:29:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!RepositoryConfiguration class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'

!

version_SVN

    ^ '$Id$'

! !

