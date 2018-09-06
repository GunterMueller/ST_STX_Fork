"
 COPYRIGHT (c) 2002 by eXept Software AG 
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

Object subclass:#CachedTags
	instanceVariableNames:'tagTimestamp tagList'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools-File-Tags'
!

!CachedTags class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG 
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.


"
! !

!CachedTags methodsFor:'accessing'!

tagList
    "return the value of the instance variable 'tagList' (automatically generated)"

    ^ tagList
!

tagList:something
    "set the value of the instance variable 'tagList' (automatically generated)"

    tagList := something.
!

tagTimestamp
    "return the value of the instance variable 'tagTimestamp' (automatically generated)"

    ^ tagTimestamp
!

tagTimestamp:something
    "set the value of the instance variable 'tagTimestamp' (automatically generated)"

    tagTimestamp := something.
! !

!CachedTags class methodsFor:'documentation'!

version_CVS
    ^ '§Header: /cvs/stx/stx/libtool/Tools__CachedTags.st,v 1.1 2011/05/06 08:34:57 cg Exp §'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: Tools__CachedTags.st 7854 2012-01-30 17:49:41Z vranyj1 $'
! !

