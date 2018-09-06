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

TestCase subclass:#CommitTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Tests'
!

!CommitTests class methodsFor:'documentation'!

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

!CommitTests methodsFor:'initialization & release'!

setUp

    super setUp.
    Class withoutUpdatingChangesDo:
	[self source_stx_goodies_libsvn_CommitTests_st readStream fileIn.
	self source_SVN__CommitTestsMockA_st readStream fileIn.
	self source_SVN__CommitTestsMockB_st readStream fileIn]

    "Created: / 19-08-2009 / 14:59:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CommitTests methodsFor:'sources'!

source_SVN__CommitTestsMockA_st

	"
	SVN::CommitTestsMockA fileOutAsMethodIn: SVN::CommitTests selector: #'source_SVN__CommitTestsMockA_st' category: 'sources'

	SVN::CommitTests new source_SVN__CommitTestsMockA_st
	"

^'''From Smalltalk/X, Version:5.4.4 on 08-04-2009 at 09:23:01 PM''                  !!

"{ Package: ''stx:goodies/libsvn_CommitTests'' }"

"{ NameSpace: SVN }"

Object subclass:#CommitTestsMockA
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''SVN-Tests-Mocks''
!!

'

    "Modified: / 19-08-2009 / 13:33:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

source_SVN__CommitTestsMockB_st

	"
	SVN::CommitTestsMockA fileOutAsMethodIn: SVN::CommitTests selector: #'source_SVN__CommitTestsMockA_st' category: 'sources'

	SVN::CommitTests new source_SVN__CommitTestsMockA_st
	"

^'"{ Package: ''stx:goodies/libsvn_CommitTests'' }"

"{ NameSpace: SVN }"

Object subclass:#CommitTestsMockB
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''SVN-Tests-Mocks''
!!

'

    "Created: / 09-04-2009 / 17:41:32 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 13:33:57 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

source_stx_goodies_libsvn_CommitTests_st

	"
	stx_goodies_libsvnCommitTests fileOutAsMethodIn: SVN::CommitTests selector: #'source_stx_goodies_libsvnCommitTests_st' category: 'sources'

	SVN::CommitTests new source_stx_goodies_libsvnCommitTests_st
	"

^'''From Smalltalk/X, Version:5.4.4 on 08-04-2009 at 09:23:54 PM''                  !!

"{ Package: ''stx:goodies/libsvn_CommitTests'' }"

LibraryDefinition subclass:#stx_goodies_libsvn_CommitTests
	instanceVariableNames:''''
	classVariableNames:''''
	poolDictionaries:''''
	category:''* Projects & Packages *''
!!

!!stx_goodies_libsvn_CommitTests class methodsFor:''description''!!

preRequisites
    ^ #(
	#''stx:libbasic''    "LibraryDefinition - superclass of stx_goodies_libsvnCommitTests "
    )
!! !!

!!stx_goodies_libsvn_CommitTests class methodsFor:''description - contents''!!

classNamesAndAttributes
    ^ #(
	"<className> or (<className> attributes...) in load order"
	#''SVN::CommitTestsMockA''
	#''SVN::CommitTestsMockB''
	#''stx_goodies_libsvn_CommitTests''
    )
!!

extensionMethodNames
    ^ #(
    )
!! !!

!!stx_goodies_libsvn_CommitTests class methodsFor:''description - project information''!!

applicationIconFileName
    "Return the name (without suffix) of an icon-file (the app''s icon); will be included in the rc-resource file"

    ^ nil
    "/ ^ self applicationName
!!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ ''eXept Software AG''
!!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ ''Smalltalk/X Class library''
!!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ ''Copyright Claus Gittinger 1988-2009\nCopyright eXept Software AG 1998-2009''
!!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ ''Smalltalk/X''
!! !!

'

    "Created: / 19-08-2009 / 13:34:32 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

sources

    ^super sources ,
    #(
	(dir  'trunk')
	(file 'trunk/SVN__CommitTestsMockA.st'          source_SVN__CommitTestsMockA_st)
	(file 'trunk/SVN__CommitTestsMockB.st'          source_SVN__CommitTestsMockB_st)
	(file 'trunk/stx_goodies_libsvn_CommitTests.st'  source_stx_goodies_libsvn_CommitTests_st)

	(dir  'branches')

	(dir  'tags')
    )

    "Created: / 08-04-2009 / 21:25:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 13:35:05 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CommitTests methodsFor:'tests'!

test_01_simple

    "
	Tests the simpliest commit
    "

    Class packageQuerySignal answer: self package do:
	[SVN::CommitTestsMockA compile: 'r1 ^''Revision 1''' classified: 'methods - r1'].

    wc commit:'CommitTests>>test_01 commit'.

    self assert:
	(wc branch cat: 'SVN__CommitTestsMockA.st')
	    = (String streamContents:[:s| SVN::CommitTestsMockA fileOutOn: s withTimeStamp: false]).

    "Created: / 12-06-2009 / 21:46:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 14:57:46 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_01_simple_ui

    | w repositoryCode imageCode |

    self assert:(Smalltalk at: #'SVN::CommitTestsMockA' ifAbsent:[nil]) notNil.

    Class packageQuerySignal answer: self package do:
	[SVN::CommitTestsMockA compile: 'r1 ^''Revision 1''' classified: 'methods - r1'].


    w := CommitWizard new.
    w task: wc commitTask.
    [ w open ] fork.
    Delay waitForSeconds: 4.
    self assert: w goPrevEnabledHolder value == false.
    self assert: w goNextEnabledHolder value == true.
    w goNext.
    self assert: w goPrevEnabledHolder value == true.
    self assert: w goNextEnabledHolder value == false.
    w pane message: 'CommitTests>>test_01 commit'.
    w doAccept.

    Delay waitForSeconds: 2.

    repositoryCode := (wc branch cat: 'SVN__CommitTestsMockA.st').
    imageCode := (String streamContents:[:s| SVN::CommitTestsMockA fileOutOn: s withTimeStamp: false]).

    self assert: (repositoryCode = imageCode).
    "
	DiffTextView openOn: repositoryCode and: imageCode
    "

    "Created: / 12-06-2009 / 21:46:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 15:10:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_02_selective_commit

    "
	Selective class commit test
    "

    self assert:(Smalltalk at: #'SVN::CommitTestsMockA' ifAbsent:[nil]) notNil.
    self assert:(Smalltalk at: #'SVN::CommitTestsMockB' ifAbsent:[nil]) notNil.

    Class packageQuerySignal answer: self package do:
	[SVN::CommitTestsMockA compile: 'r1 ^''Revision 1''' classified: 'methods - r1'].

    Class packageQuerySignal answer: self package do:
	[SVN::CommitTestsMockB compile: 'r1 ^''Revision 1''' classified: 'methods - r1'].

    wc commitTask
	classes: (Array with: SVN::CommitTestsMockA);
	message: 'CommitTests>>test_03 commit';
	do.

    self assert:
	(wc branch cat: 'SVN__CommitTestsMockA.st')
	    = (String streamContents:[:s| SVN::CommitTestsMockA fileOutOn: s withTimeStamp: false]).

    self assert:
	(wc branch cat: 'SVN__CommitTestsMockB.st')
	    = self source_SVN__CommitTestsMockB_st.

    "Created: / 12-06-2009 / 21:46:25 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 14:57:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_03_class_remove

    "
	Tests class remove
    "

    self assert:(Smalltalk at: #'SVN::CommitTestsMockA' ifAbsent:[nil]) notNil.
    self assert:(Smalltalk at: #'SVN::CommitTestsMockB' ifAbsent:[nil]) notNil.

    Smalltalk removeClass: SVN::CommitTestsMockB.

    wc commitTask
	message: 'CommitTests>>test_03 commit';
	do.
    self assert: (wc branch list size = (2 + 4)"Make.spec, Make.proto, abbrev.stc, libInit.cc")

    "Created: / 12-06-2009 / 21:52:09 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 19-08-2009 / 15:09:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CommitTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^'§Id: SVN__CommitTests.st 110 2009-08-19 13:21:10Z vranyj1 §'
! !

