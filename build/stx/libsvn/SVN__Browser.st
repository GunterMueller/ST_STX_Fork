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

ApplicationModel subclass:#Browser
	instanceVariableNames:'modelHolder selectionHolder singleSelectionHolder listHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-UI-Browsers'
!

!Browser class methodsFor:'documentation'!

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

!Browser class methodsFor:'instance creation'!

on: aWorkingCopy

    ^self new 
        model: aWorkingCopy;
        yourself

    "Created: / 14-04-2008 / 11:09:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Browser class methodsFor:'interface opening'!

openOn: aWorkingCopy

    ^(self on: aWorkingCopy) open

    "Created: / 14-04-2008 / 11:09:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Browser class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!Browser class methodsFor:'plugIn spec'!

aspectSelectors

    ^ #(
        #model
      ).

    "Created: / 12-04-2008 / 21:04:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Browser methodsFor:'accessing'!

model
    ^self modelHolder value

    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
    "Created: / 12-04-2008 / 21:01:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

model:aModel
    self modelHolder subjectChannel:aModel
    "aModel isValueModel 
        ifTrue:[self modelHolder subjectChannel:aModel]
        ifFalse:[self modelHolder subject:aModel]."

    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
    "Created: / 12-04-2008 / 21:01:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

selection

    ^self selectionHolder value

    "Created: / 22-10-2008 / 11:30:03 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

selection: selection

    ^self selectionHolder value: selection

    "Created: / 22-10-2008 / 11:30:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Browser methodsFor:'accessing - selection'!

theSingleSelectedObject

    | sel selSize obj |
    sel := self selection.

    (sel isCollection and:[self isString not])
        ifFalse:[^sel].

    selSize := 0.
    obj := nil.        
    sel do:
        [:each|
        selSize := selSize + 1.
        selSize > 1 ifTrue:[^nil].
        obj := each].
    ^obj

    "Created: / 10-11-2009 / 11:12:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-11-2009 / 19:54:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Browser methodsFor:'aspects'!

hasSelectionHolder

    |holder|

    (holder := builder bindingAt:#hasSelectionHolder) isNil ifTrue:[
        holder := (AspectAdaptor forAspect: #notEmptyOrNil)
            subjectChannel: self selectionHolder.
        builder aspectAt:#hasSelectionHolder put: holder
    ].
    ^ holder.

    "Created: / 22-10-2008 / 11:34:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 22-10-2008 / 12:38:47 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

listHolder
    "return/create the 'listHolder' value holder (automatically generated)"

    listHolder isNil ifTrue:[
        listHolder := ValueHolder new.
    ].
    ^ listHolder

    "Modified: / 01-11-2009 / 16:57:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

modelHolder
    ^modelHolder ifNil:[
        modelHolder := (AspectAdaptor subjectChannel:nil)
                            forAspect:#value
    ]

    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
    "Created: / 12-04-2008 / 21:01:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

selectionHolder
    "return/create the 'selectionHolder' value holder (automatically generated)"

    selectionHolder isNil ifTrue:[
        selectionHolder := ValueHolder new.
        selectionHolder addDependent:self.
    ].
    ^ selectionHolder
!

singleSelectionHolder
    "return/create the 'singleSelectionHolder' value holder (automatically generated)"

    singleSelectionHolder isNil ifTrue:[
        singleSelectionHolder := ValueHolder new.
    ].
    ^ singleSelectionHolder

    "Modified: / 10-11-2009 / 11:09:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Browser methodsFor:'change & update'!

selectionChanged

    self singleSelectionHolder value: 
        self theSingleSelectedObject

    "Created: / 22-10-2008 / 11:29:24 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 10-11-2009 / 11:13:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update: aspect with: param from: sender

    sender == selectionHolder ifTrue:[^self selectionChanged].
    ^super update: aspect with: param from: sender

    "Created: / 10-11-2009 / 11:10:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Browser methodsFor:'initialization'!

initialize

    super initialize.
    self createBuilder

    "Created: / 22-10-2008 / 12:37:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Browser methodsFor:'queries'!

hasSelection

    ^self selection notEmptyOrNil

    "Created: / 22-10-2008 / 12:23:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Browser class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__Browser.st 363 2011-08-08 13:49:48Z vranyj1 §'
! !
