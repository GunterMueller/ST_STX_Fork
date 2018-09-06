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

Object subclass:#HGChangesetFile
	instanceVariableNames:'changeset name parent children'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-Core'
!

!HGChangesetFile class methodsFor:'documentation'!

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
!

documentation
"
    A representation on a file in working copy. It behaves just like 
    ordinary filename but also provides methods for quering it's
    state (added/removed/modified...), access to previous versions
    and so on.

    The protocol of HGChangesetFile is Filename-like, however,
    no modification is allowed.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!HGChangesetFile methodsFor:'accessing'!

/ aString
    ^self construct: aString

    "Created: / 16-11-2012 / 23:47:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

baseName
    ^name

    "Created: / 17-11-2012 / 00:00:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeset
    ^ changeset
!

changesetId
    ^ changeset id

    "Created: / 22-01-2013 / 13:36:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

children
    ^ children
!

construct: aString
    "Returns a child name aString. If no such child
     exist, raise an error."

    | components file |

    ( aString includes: $/ ) ifTrue:[
        components := aString tokensBasedOn: $/.
    ] ifFalse:[
        ( aString includes: Filename separator ) ifTrue:[
            components := aString tokensBasedOn: Filename separator.
        ] ifFalse:[
            ^self childNamed: aString
        ]
    ].

    file := self.
    components do:[:each|file := file childNamed: each].
    ^file

    "Created: / 16-11-2012 / 23:47:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-12-2012 / 01:33:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

directory
    ^parent

    "Created: / 16-11-2012 / 23:50:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newer
    "Return newer revisions of given file based immediately on the recevier"

    ^self newer: false

    "Created: / 06-12-2012 / 00:09:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newer: recursively
    "Return newer revisions of given file based on the recevier. If
     recursively is true, than all newer revisions are returned.
     otherwise only those based immediately on the receiver
    "

    | queue newer path |

    path := self pathName.
    queue := Stack withAll: (changeset children collect:[:e|Array with: e with: path]).
    newer := OrderedCollection new.

    [ queue notEmpty ] whileTrue:[
        | pair cs cont p |

        cs := queue top first.
        p := queue top second.
        queue pop.
        cont := true.
        cs changes do:[:chg|
            "/Catch renames...
            (chg isCopied and:[chg source = p]) ifTrue:[
                p := chg path.
            ].
            chg path = p ifTrue:[
                cont := false.
                chg isRemoved ifFalse:[
                    newer add: cs / p.
                ].
            ].
        ].
        (cont or:[recursively]) ifTrue:[
            queue addAll: (cs children collect:[:e|Array with: e with: p]).
        ].
    ].
    ^newer reversed

    "Created: / 06-12-2012 / 00:12:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 08-07-2013 / 02:22:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parent
    ^ parent
!

pathName
    ^String streamContents:[:s|self printPathOn: s].

    "Created: / 16-11-2012 / 23:55:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readStream
    | file |

    "Sigh, pipes on Windows does not work correctly, create
     a temporary file then..."
    ^ OperatingSystem isMSWINDOWSlike ifTrue:[
        file := Filename newTemporary.
        HGCommand cat
            workingDirectory: self repository pathName;
            path: self pathName;
            revision: changeset id revno;
            destination: file pathName;
            execute.
        file readStream
    ] ifFalse:[
        HGCommand cat
            workingDirectory: self repository pathName;
            path: self pathName;
            revision: changeset id revno;
            execute.
    ].

    "Created: / 17-11-2012 / 00:00:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-03-2013 / 11:16:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

repository
    ^self changeset repository

    "Created: / 17-11-2012 / 00:05:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sha1
    "Returns a SHA1 sum of file's contents"
    | sha1 |

    self readingFileDo:[:s | sha1 := SHA1Stream hashValueOf:s].
    ^ sha1

    "Created: / 24-04-2018 / 15:37:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetFile methodsFor:'accessing-private'!

childNamed: aString
    "Returns a child name aString. If no such child
     exist, raise an error."

    aString = '.' ifTrue:[ ^ self ].
    aString = '..' ifTrue:[ ^ parent ].


    children notNil ifTrue:[
        children at: aString ifPresent:[:child|^child].
    ].
    HGError newException
        parameter: (Array with: self with: aString );
        messageText: 'No such file or directory';
        raiseSignal.

    "Created: / 01-12-2012 / 01:29:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetFile methodsFor:'enumerating'!

recursiveDirectoryContentsDo:aBlock 
    "Evaluates `aBlock` for itself and all children recursivelly,
     passing the child to the block."

    children notEmptyOrNil ifTrue:[ 
        children do:[:each | 
            aBlock value: each.    
            each recursiveDirectoryContentsDo:aBlock.
        ]
    ].

    "Created: / 13-04-2018 / 22:46:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-04-2018 / 22:38:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetFile methodsFor:'initialization'!

setChangeset: anHGChangeset name: aString
    ^self setChangeset: anHGChangeset name: aString parent: nil.

    "Created: / 16-11-2012 / 23:33:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setChangeset: anHGChangeset name: aString parent: anHGChangesetFile
    changeset := anHGChangeset.
    name := aString.
    parent := anHGChangesetFile

    "Created: / 16-11-2012 / 23:50:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetFile methodsFor:'instance creation-private'!

create0: aString
    | file |

    aString isEmpty ifTrue:[ ^ self ].    
    children isNil ifTrue:[
        children := Dictionary new
    ] ifFalse:[
        children at: aString ifPresent:[:child|^child].
    ].
    file := self class new setChangeset: changeset name: aString parent: self.
    children at: aString put: file.
    ^file

    "Created: / 16-11-2012 / 23:41:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

create: aString
    | file |
    (aString includes: $/) ifTrue:[
        file := self.
        (aString tokensBasedOn: $/) do:[:each|
            file := file create0: each.            
        ]
    ] ifFalse:[
        file := self create0: aString
    ].
    ^file.

    "Created: / 16-11-2012 / 23:41:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetFile methodsFor:'operations'!

copyTo: aStringOrFilename
    "Writes contents of the receiver to given file"

    HGCommand cat
        workingDirectory: self repository pathName;
        path: self pathName;
        revision: changeset id revno;
        destination: aStringOrFilename;
        execute.

    "Created: / 04-12-2012 / 01:58:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetFile methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    aStream nextPutAll:'anHGChangesetFile['.
    changeset id printOn: aStream.
    aStream space.
    self printPathOn: aStream.
    aStream nextPut:$].

    "Modified: / 06-12-2012 / 00:28:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printPathOn: aStream
    parent notNil ifTrue:[
        parent printPathOn: aStream.
        parent parent notNil ifTrue:[
            aStream nextPut:$/.
        ].
    ].
    aStream nextPutAll: name.

    "Created: / 16-11-2012 / 23:53:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetFile methodsFor:'private'!

ensureNotLazy
    "Noop, I'm not lazy"

    "Created: / 22-01-2013 / 13:44:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetFile methodsFor:'reading-files'!

contents
    "return the contents of the file as a collection of lines;
     Raises an error, if the file is unreadable/non-existing.
     See also #contentsOfEntireFile, which returns a string for textFiles.
     CAVEAT: bad naming - but req'd for VW compatibility."

    ^ self readingFileDo:[:s | s contents].

    "
     'Makefile' asFilename contents
     'foobar' asFilename contents            
    "

    "Modified: / 2.7.1996 / 12:49:45 / stefan"
    "Created: / 11.7.1996 / 14:09:11 / cg"
    "Modified: / 15.10.1998 / 11:41:45 / cg"
!

contentsAsString
    "to compensate for the bad naming, use this to make things explicit.
     See also #contents, which returns the lines as stringCollection for textFiles."

    ^ self contentsOfEntireFile

    "
     'Makefile' asFilename contentsAsString
     'foobar' asFilename contentsAsString
    "

    "Modified: / 02-07-1996 / 12:49:45 / stefan"
    "Created: / 08-11-2007 / 13:29:59 / cg"
!

contentsOfEntireFile
    "return the contents of the file as a string;
     Raises an error, if the file is unreadable/non-existing.
     See also #contents, which returns the lines as stringCollection for textFiles.
     CAVEAT: bad naming - but req'd for VW compatibility."

    ^ self readingFileDo:[:s | s contentsOfEntireFile].

    "
     'Makefile' asFilename contentsOfEntireFile
     'foobar' asFilename contentsOfEntireFile
    "

    "Modified: / 2.7.1996 / 12:49:45 / stefan"
    "Modified: / 15.10.1998 / 11:42:05 / cg"
!

readingFileDo:aBlock
    "create a read-stream on the receiver file, evaluate aBlock, passing that stream as arg,
     and return the blocks value. 
     If the file cannot be opened, an exception is raised or
     (old behavior, will vanish:)the block is evaluated with a nil argument.
     Ensures that the stream is closed."

    |stream result|

    stream := self readStream.
    [
        result := aBlock value:stream
    ] ensure:[
        stream notNil ifTrue:[stream close]
    ].
    ^ result

    "
     read the first line from some file:

     |rslt|

     rslt := 
        '/etc/passwd' asFilename 
            readingFileDo:[:s |
                s nextLine
            ]. 
     Transcript showCR:rslt.
    "

    "
     find all used shells in /etc/passwd and count their usage:

     |rslt|

     rslt :=
        '/etc/passwd' asFilename 
            readingFileDo:
                [:s |
                    |shells|

                    shells := Bag new.
                    s linesDo:
                        [:line |
                            |parts|

                            parts := line asCollectionOfSubstringsSeparatedBy:$:.
                            shells add:(parts seventh).
                        ].
                    shells contents
                ].           
     Transcript showCR:rslt.
    "
!

readingLinesDo:aBlock
    "create a read-stream on the receiver file,
     evaluate aBlock for each line read from the stream.
     If the file cannot be opened, an error is raised.
     Ensures that the stream is closed."

    self readingFileDo:[:stream |
        stream linesDo:aBlock
    ].

    "
    '/etc/passwd' asFilename 
        readingLinesDo:[:eachLine |
            Transcript showCR:eachLine.
        ]. 
    "

    "
    '/etc/xxxxx' asFilename 
        readingLinesDo:[:eachLine |
            Transcript showCR:eachLine.
        ]. 
    "
! !

!HGChangesetFile methodsFor:'testing'!

isDirectory
    ^ children notNil

    "Created: / 07-03-2014 / 12:46:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isRootDirectory
    ^parent isNil

    "Created: / 16-11-2012 / 23:58:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetFile class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

