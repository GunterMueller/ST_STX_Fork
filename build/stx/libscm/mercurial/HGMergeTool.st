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

Object subclass:#HGMergeTool
	instanceVariableNames:'file'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-StX'
!

HGMergeTool subclass:#Mercurial
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGMergeTool
!

HGMergeTool subclass:#Smalltalk
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:HGMergeTool
!

!HGMergeTool class methodsFor:'documentation'!

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
    A base abstract class for merge tools.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!HGMergeTool class methodsFor:'instance creation'!

for: anHGWorkingCopyFile
    "
    Return a merge tool suitable for given working copy file
    "
    ^anHGWorkingCopyFile suffix = 'st' ifTrue:[
        Smalltalk new setFile: anHGWorkingCopyFile 
    ] ifFalse:[
        Mercurial new setFile: anHGWorkingCopyFile
    ]

    "Created: / 14-01-2013 / 21:11:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGMergeTool methodsFor:'accessing'!

fileBase
    "Return path to a file representing base revision"

    ^(file pathName , '.base') asFilename

    "Created: / 14-01-2013 / 21:12:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-01-2013 / 10:08:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileLocal
    "Return path to a file representing current revision (the
     one of current wc revision"

    ^(file pathName , '.local') asFilename

    "Created: / 14-01-2013 / 21:13:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-01-2013 / 10:08:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOther
    "Return path to a file representing the revision to merge in"

    ^(file pathName , '.other') asFilename

    "Created: / 14-01-2013 / 21:13:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-01-2013 / 10:08:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutput
    "Return file where to save the merged version"

    ^file

    "Created: / 14-01-2013 / 21:13:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGMergeTool methodsFor:'initialization'!

setFile: anHGWorkingCopyFile
    self assert: (anHGWorkingCopyFile isKindOf: HGWorkingCopyFile).
    file := anHGWorkingCopyFile

    "Created: / 14-01-2013 / 18:04:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGMergeTool methodsFor:'merging'!

merge
    "Runs a merge on file. Return true, if file conflicts had been
     resolved, false otherwise"

    self subclassResponsibility

    "Created: / 14-01-2013 / 18:16:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-01-2013 / 20:00:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

premerge                
    "Tries to merge files automatically. Returns true, if succeeded, false otherwise.
     In that case, it is necessary to call #merge which may require user interaction. 

     Note that calling #merge is always safe.
     "

    ^false

    "Created: / 14-01-2013 / 20:04:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 14-01-2013 / 21:09:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGMergeTool::Mercurial class methodsFor:'documentation'!

documentation
"
    A merge tool using mercurials built-in merge tool resulution.
    Basically, it calls

        hg resolve <file>

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        hg help resolve 

"
! !

!HGMergeTool::Mercurial methodsFor:'merging'!

merge
    "Runs a merge on file. Return true, if file conflicts had been
     resolved, false otherwise"

    ^file workingCopy repository execute: 
        (HGCommand resolve
            workingDirectory: file directory pathName;
            files: (Array with: file baseName);
            yourself)

    "Modified: / 03-03-2013 / 23:06:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGMergeTool::Smalltalk class methodsFor:'documentation'!

documentation
"
    A merge tool for Smalltalk class .st files. It compares and merges
    changesets.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        ChangeSetDiff
        Tools::ChangeSetDiffTool

"
! !

!HGMergeTool::Smalltalk methodsFor:'merging'!

merge
    "Runs a merge on file. Return true, if file conflicts had been
     resolved, false otherwise"

    | tool |

    tool := Tools::ChangeSetDiffTool new.
    tool
        fileMenuOpenOnDiffInfo: self changesetDiffInfo;
        openModal.
    ^tool mergeSavedHolder value

    .

    "Modified: / 17-01-2013 / 21:11:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

premerge                
    "Tries to merge files automatically. Returns true, if succeeded, false otherwise.
     In that case, it is necessary to call #merge which may require user interaction. 

     Note that calling #merge is always safe.
     "

    | dinfo merged |

    file workingCopy repository execute:
        (HGCommand resolve
            workingDirectory: file directory pathName;
            tool: 'internal:dump';
            files: (Array with: file baseName);
            yourself).

    dinfo := self changesetDiffInfo.
    dinfo read.

    ^dinfo diffset isMerged ifTrue:[
        merged := dinfo diffset changesetMerged , dinfo same. 
        merged := merged reject:[:chg|chg isDoIt].
        merged saveToFile: self fileOutput format: #classSource.
        true.
    ] ifFalse:[
        false
    ]

    "Created: / 14-01-2013 / 21:15:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-03-2013 / 23:07:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGMergeTool::Smalltalk methodsFor:'private'!

changesetDiffInfo
    ^Tools::ChangeSetDiffInfo
        specA: (Tools::ChangeSetSpec file: self fileLocal pathName)
        specB: (Tools::ChangeSetSpec file: self fileOther pathName)
        specBase: (Tools::ChangeSetSpec file: self fileBase pathName)
        specMerge: (Tools::ChangeSetSpec file: self fileOutput pathName).

    "Created: / 14-01-2013 / 21:15:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGMergeTool class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

