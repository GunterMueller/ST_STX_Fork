"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1999 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Registry subclass:#CachingRegistry
	instanceVariableNames:'keptReferences cacheSize'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support'
!

!CachingRegistry class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
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
    A CachingRegistry behaves generally like a registry;
    However, it keeps hard references to the last n registered objects,
    preventing them from being garbage collected (and finalized).
    This is useful for resources, which do not cost too much memory,
    but are expensive to allocate - a special candidate of this kind are
    XFonts. With a CachingRegistry, fonts are kept a bit longer alive
    and can therefore often be reused - even if temporarily unreferenced.

    This is kind of experimental.

    [author:]
        Claus Gittinger (cg@exept)

    [see also:]

    [instance variables:]
        keptObjects             Collection      hard referenced objects
        cacheSize               Integer         number of hard references
"
! !

!CachingRegistry class methodsFor:'instance creation'!

new:cacheSize
    ^ (super new:cacheSize) cacheSize:cacheSize
! !

!CachingRegistry methodsFor:'enumerating'!

detect:aBlock ifNone:exceptionValue
    "... additionaly move it to the front of the LRU chain"

    |cnt|

    "first a quick lookup 
     (most recent entry is at the end, because #removeIdentical makes room at the end)..."

    cnt := 1.
    keptReferences reverseDo:[:obj|
        (aBlock value:obj) ifTrue:[
            "if not at the end, put it to the end.
             but avoid to much remove/add actions"
            cnt > (cacheSize // 4) ifTrue:[
                keptReferences removeIdentical:obj ifAbsent:[].
                keptReferences addLast:obj.
            ].
            ^ obj
        ].
        cnt := cnt + 1.
    ].

    "check the whole registry..."
    keyArray validElementsDo:[:eachElement |
        eachElement ~~ DeletedEntry ifTrue:[
            |realObject|

            realObject := eachElement.
            eachElement == NilEntry ifTrue:[realObject := nil].
            (aBlock value:realObject) ifTrue:[
                keptReferences size >= cacheSize ifTrue:[
                    keptReferences removeFirst.
                ].
                keptReferences addLast:realObject.
                ^ realObject
            ].
        ].
    ].
    ^ exceptionValue value
! !

!CachingRegistry methodsFor:'private'!

cacheSize:aNumber
    keptReferences := OrderedCollection new:aNumber.
    cacheSize := aNumber.
! !

!CachingRegistry methodsFor:'registering objects'!

register:anObject as:aHandle
    keptReferences removeIdentical:anObject ifAbsent:nil.
    aHandle notNil ifTrue:[
        keptReferences size >= cacheSize ifTrue:[
            keptReferences removeFirst.
        ].
        keptReferences addLast:anObject.
    ].
    super register:anObject as:aHandle.
!

removeKey:anObject ifAbsent:absentBlock
    keptReferences removeIdentical:anObject ifAbsent:nil.
    super removeKey:anObject ifAbsent:absentBlock.
!

safeRemoveKey:anObject
    keptReferences removeIdentical:anObject ifAbsent:nil.
    super safeRemoveKey:anObject.
! !

!CachingRegistry class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id: CachingRegistry.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !



