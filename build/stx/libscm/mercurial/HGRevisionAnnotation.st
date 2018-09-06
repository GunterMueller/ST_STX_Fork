"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

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
"{ Package: 'stx:libscm/mercurial' }"

Annotation subclass:#HGRevisionAnnotation
	instanceVariableNames:'revision'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-StX'
!

!HGRevisionAnnotation class methodsFor:'documentation'!

copyright
"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

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
! !

!HGRevisionAnnotation class methodsFor:'instance creation'!

revision: aString
    ^self new revision: aString

    "Created: / 20-11-2012 / 23:36:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRevisionAnnotation methodsFor:'accessing'!

key
    "superclass Annotation says that I am responsible to implement this method"

    ^ #HGRevision:

    "Modified: / 20-11-2012 / 23:27:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

revision
    ^ revision
!

revision:aStringOrHGRevision
    revision := aStringOrHGRevision asHGRevision

    "Modified: / 20-11-2012 / 23:32:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRevisionAnnotation methodsFor:'accessing-pragma'!

arguments
    "Answer the arguments of the receiving pragma. For a pragma defined as <key1: val1 key2: val2> this will answer #(val1 val2)."

    ^ Array with: revision asString

    "Modified: / 20-11-2012 / 23:28:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRevisionAnnotation methodsFor:'initialization'!

setArguments:anArray
    "Ignored"

    "Modified: / 20-11-2012 / 23:28:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setKeyword:aSymbol
    "Ignored"

    "Modified: / 20-11-2012 / 23:28:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setMethod:aCompiledMethod
    "Ignored"

    "Modified: / 20-11-2012 / 23:28:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRevisionAnnotation methodsFor:'printing & storing'!

storeOn:aStream
    "superclass Annotation says that I am responsible to implement this method"

    aStream nextPutAll: '(HGRevisionAnnotation revision: '.
    revision asString storeOn: aStream.
    aStream nextPut:$).

    "Modified: / 20-11-2012 / 23:31:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRevisionAnnotation methodsFor:'processing'!

annotatesClass:aClass
    "Ignored"

    "Modified: / 20-11-2012 / 23:31:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

annotatesMethod:aMethod
    "Ignored"

    "Modified: / 20-11-2012 / 23:31:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRevisionAnnotation class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

