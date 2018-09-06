"
 COPYRIGHT (c) 2005-2011 by Jan Vrany & Martin Dvorak

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
"{ Package: 'stx:goodies/loggia' }"

"{ NameSpace: Loggia }"

ApplicationModel subclass:#AbstractUI
	instanceVariableNames:'modelHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Loggia-UI'
!

!AbstractUI class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005-2011 by Jan Vrany & Martin Dvorak

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

!AbstractUI class methodsFor:'instance creation'!

on:aModel
    ^self new model:aModel

    "Created: / 27-09-2004 / 21:15:56 / janfrog"
    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
! !

!AbstractUI class methodsFor:'defaults'!

defaultDomainModel
    "Answers default domain model for me"
    ^nil

    "Created: / 27-09-2004 / 21:12:40 / janfrog"
    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
! !

!AbstractUI class methodsFor:'interface opening'!

openOn:aModel
    ^(self on:aModel) open

    "Created: / 27-09-2004 / 21:16:17 / janfrog"
    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
! !

!AbstractUI class methodsFor:'plugIn spec'!

aspectSelectors

    ^ #(
	#model
      ).

    "Created: / 28-09-2004 / 19:07:08 / janfrog"
    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
! !

!AbstractUI methodsFor:'Compatibility-AAF'!

subject
    ^self model

    "Created: / 27-09-2004 / 21:15:17 / janfrog"
    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
!

subject:aModel
    ^self model:aModel

    "Created: / 27-09-2004 / 21:15:22 / janfrog"
    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
!

subjectChannel
    ^self modelHolder

    "Created: / 27-09-2004 / 21:15:12 / janfrog"
    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
! !

!AbstractUI methodsFor:'accessing'!

model
    ^self modelHolder value

    "Created: / 27-09-2004 / 21:14:07 / janfrog"
    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
!

model:aModel
    self modelHolder subjectChannel:aModel
    "aModel isValueModel
	ifTrue:[self modelHolder subjectChannel:aModel]
	ifFalse:[self modelHolder subject:aModel]."

    "Created: / 27-09-2004 / 21:14:15 / janfrog"
    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
!

modelHolder
    ^modelHolder ifNil:[
	modelHolder := (AspectAdaptor subjectChannel:self class defaultDomainModel sendsUpdates:true)
			    forAspect:#value
    ]

    "Created: / 27-09-2004 / 21:13:56 / janfrog"
    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
!

modelHolder: aValueModel

    modelHolder := aValueModel

    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
    "Created: / 08-04-2010 / 12:03:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractUI methodsFor:'utilities-bindings'!

aspectAdaptorFor:aSymbol
    ^self aspectAdaptorFor:aSymbol on:self modelHolder

    "Created: / 28-09-2004 / 13:19:42 / janfrog"
    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
!

aspectAdaptorFor:aSymbol on: aValueModel

    ^ (AspectAdaptor forAspect: aSymbol) subjectChannel: aValueModel

    "Created: / 29-05-2014 / 10:11:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

aspectAt: key ifAbsentPut: block
    builder isNil ifTrue:[
	builder := self createBuilder.
    ].
    ^ builder bindings at: key ifAbsentPut: block

    "Created: / 29-05-2014 / 10:06:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractUI class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__AbstractUI.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__AbstractUI.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_SVN
    ^ '$Id: Loggia__AbstractUI.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
! !
