"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

ValueHolder subclass:#ConvertedValue
	instanceVariableNames:'conversion'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Models'
!

!ConvertedValue class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    a ConvertedValue translates changes on input via a conversion block
    to the output. For example, if you want to have a toggle to change the
    color inputs of some other labels, use a convertedValue which translates
    true/false into colors:

	|toggle label converter|

	converter := ConvertedValue new
			conversion:[:input | input == true
						ifTrue:[Color red]
						ifFalse:[Color blue]];
			value:false.


	toggle := Toggle label:'change color'.
	toggle controller pressChannel:converter.

	label := Label label:'see me changing'.
	label foregroundChannel:converter.

	toggle open.
	label open.
"
!

examples
"
    examples to be added.
"
! !

!ConvertedValue methodsFor:'accessing'!

conversion:aBlock
    conversion := aBlock
!

initialValue:someValue
    self value:someValue
!

value:input
    ^ super value:(conversion value:input)
! !

!ConvertedValue class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/ConvertedValue.st,v 1.5 2006-09-15 18:02:35 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

