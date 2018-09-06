"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

CacheDictionary subclass:#CacheDictionaryWithFactory
	instanceVariableNames:'factoryBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Unordered'
!

!CacheDictionaryWithFactory class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
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
    like a Dictionary, but does not grow beyond a given max. size
    (i.e. only keeps size items),
    It can be used as a cache, for keeping recently used objects alive.
    Must be created with an initial (=maximal) size. 
    In addition to the normal CacheDictionary, 
    this also keeps a factoryBlock to automatically compute missing elements.

    [author:]
        Claus Gittinger (cg@alan)

    [see also:]
        CacheDictionary
        Dictionary
"
!

examples
"
  caches reverse strings (stupid usage)
                                                                [exBegin]
    |c|

    c := CacheDictionaryWithFactory
            new:100 factory:[:key | key reversed].

    c at:'hello'.
    c at:'hello'.
    1 to:1000 do:[:i | c at:i printString].
    c at:'hello'.
                                                                [exEnd]


  Test: should halt (compute 'hello') only twice.
                                                                [exBegin]
    |c numHalts|

    numHalts := 0.

    c := CacheDictionaryWithFactory
            new:100 factory:[:key | key = 'hello' ifTrue:[numHalts := numHalts + 1]. key reversed].

    c at:'hello'.
    c at:'hello'.
    1 to:1000 do:[:i | c at:i printString].
    c at:'hello'.
    self assert:( numHalts == 2 ).
                                                                [exEnd]
"
! !

!CacheDictionaryWithFactory class methodsFor:'instance creation'!

new:cacheSize factory:aBlock
    ^ (self new:cacheSize) factory:aBlock
! !

!CacheDictionaryWithFactory methodsFor:'accessing'!

at:key
    ^ super at:key ifAbsentPut:[factoryBlock value:key]
! !

!CacheDictionaryWithFactory methodsFor:'initialization'!

factory:aBlock
    factoryBlock := aBlock
! !

!CacheDictionaryWithFactory class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

