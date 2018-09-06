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

WCPathCommand subclass:#StatusCommand
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Private-Commands'
!

!StatusCommand class methodsFor:'documentation'!

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

!StatusCommand class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!StatusCommand methodsFor:'executing - private'!

svnCmd
    "raise an error: must be redefined in concrete subclass(es)"

    ^'status'

    "Created: / 15-03-2008 / 21:56:01 / janfrog"
!

svnCmdArgumentsOn:arg
    "raise an error: must be redefined in concrete subclass(es)"

    arg
	nextPut:'--xml';
	nextPut:'--verbose'

    "Created: / 15-03-2008 / 21:56:01 / janfrog"
!

svnParseXML: doc

    ^((doc root childNodes anyOne childNodes
	collect:
	    [:entryNode|
	    (WCEntry readFromXml: entryNode) wc: workingCopy; yourself]) asSortedCollection:[:a :b|a path < b path])
	    asOrderedCollection

    "Created: / 15-03-2008 / 22:05:01 / janfrog"
    "Modified: / 16-03-2008 / 08:44:49 / janfrog"
    "Modified: / 18-08-2009 / 14:28:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 27-08-2009 / 09:51:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

svnProcessCommandOutput:out err:err
    ^ self svnParseXML:((XML::XMLParser on:out)
		validate:false;
		scanDocument)

    "Created: / 03-10-2008 / 16:31:45 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!StatusCommand class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__StatusCommand.st 372 2011-09-29 10:47:58Z vranyj1 §'
! !
