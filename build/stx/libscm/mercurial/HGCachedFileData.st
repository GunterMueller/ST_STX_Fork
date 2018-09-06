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

"{ NameSpace: Smalltalk }"

Object subclass:#HGCachedFileData
	instanceVariableNames:'file exists timestamp size data reader'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-Internal'
!

!HGCachedFileData class methodsFor:'documentation'!

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

!HGCachedFileData class methodsFor:'instance creation'!

on: file reader: reader
    ^self new setFile: file reader: reader

    "Created: / 14-01-2013 / 16:27:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCachedFileData methodsFor:'accessing'!

value
    | fexists finfo fmodtime |

    fexists := file exists.
    fexists == exists ifTrue:[
        fexists ifTrue:[
            finfo := file info.
            fmodtime := finfo statusChangeTime ? finfo modificationTime.
            (data notNil 
                and:[timestamp notNil
                and:[fmodtime <= timestamp
                and:[finfo size = size]]]) 
                ifTrue:[
                    ^ data 
                ].
        ] ifFalse:[ 
            ^ data
        ].
    ].
    exists := fexists.        
    fexists ifTrue:[
        finfo isNil ifTrue:[ 
            finfo := file info.
            fmodtime := finfo statusChangeTime ? finfo modificationTime.       
        ].
        timestamp := fmodtime.
        size := finfo size.
    ].
    data := reader valueWithOptionalArgument: data and: file.
    ^data

    "Created: / 14-01-2013 / 16:25:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-02-2018 / 15:10:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCachedFileData methodsFor:'initialization'!

flush
    timestamp := size := nil.

    "Created: / 14-01-2013 / 16:26:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-03-2014 / 21:49:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setData: anObject
    data := anObject

    "Created: / 25-01-2013 / 18:52:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setFile:fileArg reader:readerArg 
    file := fileArg.
    reader := readerArg.

    "Created: / 14-01-2013 / 16:20:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCachedFileData class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

