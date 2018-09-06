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

HGRepositoryObject subclass:#HGChangesetLabel
	instanceVariableNames:'name color'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-Internal'
!

!HGChangesetLabel class methodsFor:'documentation'!

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
    documentation to be added.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!HGChangesetLabel class methodsFor:'testing'!

isAbstract
    ^ self == HGChangesetLabel
! !

!HGChangesetLabel methodsFor:'accessing'!

name
    "Returns a branche's name"
    ^ name

    "Modified (comment): / 22-10-2012 / 19:59:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetLabel methodsFor:'accessing-presentation'!

color
    "Return a color that should be maybe when displaying branch
     visual guide."     

    ^ self subclassResponsibility

    "Modified (comment): / 20-03-2014 / 01:43:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetLabel methodsFor:'displaying'!

displayOn: aGC x: x y: y
    | savedFG savedBG w h a |

    savedFG := aGC paint.
    savedBG := aGC background.

    w := aGC widthOfString: self name.
    h := aGC font height.
    a := aGC font ascent.
    aGC fillRectangleX: x y: y width: w + 3 + 3 height: h + 2 + 2 color: self color.
    aGC paint: (self color contrastingBlackOrWhite).
    aGC displayString: self name x: x + 3 y: y + a + 2. 
    aGC paint: savedFG.
    aGC background: savedBG

    "Created: / 16-03-2014 / 23:20:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-03-2014 / 23:33:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

heightOn: aGC
    | h |

    h := aGC font height.
    ^ h + 2 + 2.

    "Created: / 17-03-2014 / 09:05:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

widthOn: aGC 
    | w |

    w := aGC widthOfString: self name.
    ^ w + 3 + 3

    "Created: / 17-03-2014 / 09:05:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetLabel methodsFor:'initialization'!

setName: aString
    name := aString

    "Created: / 22-10-2012 / 20:00:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetLabel methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPutAll:'('.
    name printOn:aStream.
    aStream nextPutAll:')'.

    "Modified: / 10-12-2012 / 03:17:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGChangesetLabel methodsFor:'testing'!

isBookmark
    ^ false
!

isBranch
    ^ false
!

isTag
    ^ false
! !

!HGChangesetLabel class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

