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

Object subclass:#HG2CVS
	instanceVariableNames:'srcRoot dstRoot script'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-CVS'
!

!HG2CVS class methodsFor:'documentation'!

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
    A simple and naive tool to update CVS to match the Mercurial repository.
    Yes, believe or not, there are still CVS repositories out there,

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!HG2CVS methodsFor:'accessing'!

dstRoot
    ^ dstRoot
!

dstRoot:something
    dstRoot := something.
!

srcRoot
    ^ srcRoot
!

srcRoot:something
    srcRoot := something.
! !

!HG2CVS methodsFor:'updating'!

add: file
    self cvs: 'add' files: { file } in: file directory.
    file isDirectory ifTrue:[
        |  files dirs |

        files := OrderedCollection new.
        dirs := OrderedCollection new.
        file directoryContentsAsFilenamesDo:[:e|
            (self shouldIgnore: e baseName) ifFalse:[
               e isDirectory ifTrue:[
                   dirs add: e
                ] ifFalse:[
                    files add: e.
                ]
            ]
        ].
        self cvs: 'add' files: files in: file.
        dirs do:[:e|self add: e].


    ].

    "Created: / 15-02-2013 / 11:04:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-02-2013 / 18:33:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cvs: cmd files: files in: wd
    | filesAsString cmdLine |


    files isEmpty ifTrue:[ ^ self ].

    filesAsString := String streamContents:[:s|
        files do:[:e|
            s nextPut: $'; nextPutAll: e baseName; nextPut: $'; space.
        ]
    ].
    cmdLine := ('cvs ', cmd ,' ', filesAsString).
    Transcript showCR: '  --> exec: ', cmdLine.


    script := 
        script , Character cr ,
        ('pushd %1
%2
popd') bindWith: wd asString with: cmdLine.

    "Created: / 15-02-2013 / 12:27:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-09-2013 / 00:52:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

remove: file

    file isDirectory ifTrue:[
        file directoryContentsAsFilenamesDo:[:e|
            (self shouldIgnore: e baseName) ifFalse:[
               self remove: e
            ].
        ]
    ].
    file isDirectory ifFalse:[
        file remove.
    ].
    self cvs: 'remove' files: { file } in: file directory.

    "Created: / 15-02-2013 / 11:04:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-02-2013 / 18:33:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shouldIgnore: basename
    ^ #('.cvsignore' 'CVS' '.svn' '.hg' 'thesis') includes: basename

    "Created: / 15-02-2013 / 11:30:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update

    script := ''.
    self update: srcRoot to: dstRoot.
    script := script , Character cr , 'cvs commit'.

    (dstRoot asFilename / 'commit.sh') writingFileDo:[:s|
        s nextPutAll: script.
        s cr.
    ].

    "Created: / 15-02-2013 / 11:05:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-09-2013 / 00:50:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update: src to: dst
    | srcFiles dstFiles additions removals common additionsF additionsD |

    srcFiles := src directoryContents reject:[:e|self shouldIgnore: e].
    dstFiles := dst directoryContents reject:[:e|self shouldIgnore: e].
    removals := dstFiles \ srcFiles.
    additions := srcFiles \ dstFiles.
    common := srcFiles intersect:dstFiles.


    Transcript showCR: ' ==== ' , dst pathName , ' ===='.
    removals do:[:e|
       Transcript showCR:' Removing ', e.
       self remove: dst / e.
    ].

    additionsF := OrderedCollection new.
    additionsD := OrderedCollection new.
    additions do:[:e|
        | srcF dstF |

        Transcript showCR:' Adding ', e.
        srcF := src / e.
        dstF := dst / e.
        srcF recursiveCopyTo:dstF.
        srcF isDirectory ifTrue:[
            additionsD add: dstF
        ] ifFalse:[
            additionsF add: dstF
        ].
    ].
    additionsD do:[:e|self add:e].
    self cvs: 'add' files: additionsF in: dst.



    common do:[:e|
        | srcF dstF |
        srcF := src / e.
        dstF := dst / e.

        Transcript showCR:' Updating ', e.

        srcF isDirectory ifTrue:[
            self assert: dstF isDirectory.
            self update: srcF to: dstF
        ] ifFalse:[
            srcF copyTo: dstF.
        ]
    ].
    Transcript showCR: ' ==== ===='.

    "Created: / 15-02-2013 / 11:03:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-02-2013 / 18:45:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HG2CVS class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

