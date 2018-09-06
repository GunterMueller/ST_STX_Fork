"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
	       All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Smalltalk }"

MethodChange subclass:#MethodCategoryChange
	instanceVariableNames:'origin'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!MethodCategoryChange class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
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
    instances represent method-category changes (as done in the browser). 
    They are typically held in a ChangeSet.

    Change origin.

    When a changeset diff is generated, two MethodChanges that 
    represent the same method (code is the same) might differ only in
    category/ Such changes are transformed to MethodCategoruChanges.
    In that case, origin keeps the reference to original MethodChange.

    [author:]
        Claus Gittinger
        Jan Vrany

    [instance variables:]
        origin      <MethodChange>  Change that cause this category
                                    change to be created. See comment.


"
! !

!MethodCategoryChange class methodsFor:'instance creation'!

class:cls selector:sel category:cat 
    ^ self basicNew class:cls selector:sel category:cat


!

className:clsName selector:sel category:cat 
    ^ self basicNew className:clsName selector:sel category:cat

    "Created: / 12-11-2006 / 15:54:25 / cg"
! !

!MethodCategoryChange methodsFor:'accessing'!

class:cls selector:sel category:cat
    self className:cls name selector:sel category:cat

    "Modified: / 12-11-2006 / 15:55:11 / cg"
!

className:clsName selector:sel category:cat
    className := clsName.
    selector := sel.
    methodCategory := cat

    "Created: / 16.2.1998 / 14:14:16 / cg"
!

deltaDetail
    "Returns a delta to the current state as a ChangeDelta object"

    | mth|

    mth := self changeMethod.
    (mth notNil and:[mth category = methodCategory]) ifTrue:[
        ^ ChangeDeltaInformation identical 
    ].
    ^ ChangeDeltaInformation different

    "Created: / 09-10-2015 / 17:45:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-10-2015 / 16:34:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

origin
    ^ origin
!

origin:aMethodChange
    origin := aMethodChange.
!

prettyPrintedSource
    ^ self sourceForMethod, Character cr 
          , '    category:' , methodCategory storeString

    "Modified: / 09-10-2006 / 13:59:15 / cg"
!

source
    ^ self sourceForMethod , ' category:' , methodCategory storeString

    "Modified: / 09-10-2006 / 13:59:10 / cg"
!

source: aString
    | expr |

    expr := Parser parseExpression: aString onError: [ self error: 'Invalid source'].
    expr isMessage ifFalse:[ self error: 'Invalid source' ].
    expr selector == #'category:' ifFalse:[ self error: 'Invalid source' ].
    methodCategory := expr arguments first value.

    "Created: / 20-03-2012 / 22:26:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MethodCategoryChange methodsFor:'applying'!

apply
    "apply the change"

    |mthd|

    mthd := self changeMethod.
    mthd category:methodCategory asSymbol.

    "Modified: / 23-11-2006 / 16:59:09 / cg"
! !

!MethodCategoryChange methodsFor:'testing'!

isMethodCategoryChange
    ^ true
!

isMethodCodeChange
    "true if this is a method's code change (not package, category etc.)"

    ^ false
! !

!MethodCategoryChange methodsFor:'visiting'!

acceptChangeVisitor:aVisitor
    ^ aVisitor visitMethodCategoryChange:self.

    "Created: / 25-11-2011 / 17:13:58 / cg"
! !

!MethodCategoryChange class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

