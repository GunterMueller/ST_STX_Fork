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

"{ NameSpace: Tools }"

NamespaceList subclass:#NamespaceFilter
	instanceVariableNames:'selectedNamespacesHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

!NamespaceFilter class methodsFor:'documentation'!

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

!NamespaceFilter methodsFor:'aspects'!

selectedNamespaces
    "return/create the 'selectedNamespacesHolder' value holder (automatically generated)"

    selectedNamespacesHolder isNil ifTrue:[
        selectedNamespacesHolder := ValueHolder new.
        selectedNamespacesHolder addDependent:self.
    ].
    ^ selectedNamespacesHolder

    "Created: / 04-05-2011 / 20:17:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NamespaceFilter methodsFor:'change & update'!

update:something with:aParameter from:changedObject

    changedObject == selectedNamespacesHolder ifTrue:
        [
        self selectionHolder value:
            ((selectedNamespacesHolder value ? #()) collect:[:e|e string]).
        ^self
        ].
    ^super update:something with:aParameter from:changedObject

    "Created: / 04-05-2011 / 20:14:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NamespaceFilter methodsFor:'private'!

listEntryFor: namespaceName

    ^LabelAndIcon label: namespaceName icon: self class uncheckedIcon

    "Created: / 04-05-2011 / 20:01:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NamespaceFilter class methodsFor:'documentation'!

version_CVS
    ^ '§Header: /cvs/stx/stx/libtool/Tools__NamespaceFilter.st,v 1.2 2011/07/03 13:37:47 cg Exp §'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: Tools__NamespaceFilter.st 7911 2012-02-22 09:55:48Z vranyj1 $'
! !

