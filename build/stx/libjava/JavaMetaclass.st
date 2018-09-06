"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava' }"

"{ NameSpace: Smalltalk }"

Metaclass subclass:#JavaMetaclass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Classes'
!

!JavaMetaclass class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
! !

!JavaMetaclass class methodsFor:'accessing - template'!

classTemplateFor:aSuperClass in:categoryString asNamespace:asNameSpace private:isPrivate
    ^JavaLanguage instance classTemplateFor: aSuperClass in: categoryString asNamespace: false private: isPrivate

    "Created: / 04-04-2012 / 02:07:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMetaclass methodsFor:'accessing'!

topOwningClass
    "return my outermost owningClass; that is the first non-private
     class along the owner-chain."

    | topOwningClass |

    topOwningClass := self owningClass.
    [ topOwningClass notNil and:[ topOwningClass owningClass notNil ] ] whileTrue:[ 
        topOwningClass := topOwningClass owningClass.
    ].
    ^ topOwningClass

    "Created: / 03-01-1997 / 19:19:58 / cg"
    "Modified: / 18-09-2014 / 16:56:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMetaclass methodsFor:'autoboxing support'!

javaWrap: javaClass
    ^ JavaVM reflection javaClassObjectForClass: javaClass

    "Created: / 09-04-2014 / 15:21:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMetaclass methodsFor:'compiler interface'!

programmingLanguage

    self == JavaMetaclass ifTrue:[^super programmingLanguage].
    ^JavaLanguage instance

    "Created: / 15-08-2009 / 09:07:09 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 16-08-2009 / 10:37:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 04-04-2012 / 01:58:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

realSubclassDefinerClass
    ^JavaCompiler

    "Created: / 04-04-2012 / 10:16:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-04-2013 / 20:22:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMetaclass methodsFor:'fileOut'!

fileOutMethod:aMethod on:aStream
    "file out aMethod onto aStream. Used for example to write individual changeChunks"

    |cat source privacy|

    self assert: aMethod programmingLanguage isSmalltalk.

    aStream nextPutChunkSeparator.
"/    aStream nextPutAll: 'JAVA'.
"/    (self name tokensBasedOn: $/) do:[:each|
"/        aStream space; nextPutAll: each.        
"/    ].
    aStream nextPutAll:'(Java classForName:'''.
    aStream nextPutAll:(myClass name copyReplaceAll:$/ with: $.).
    aStream nextPutAll:''') class '.

    (privacy := aMethod privacy) ~~ #public ifTrue:[
        aStream space; nextPutAll:privacy; nextPutAll:'MethodsFor:'.
    ] ifFalse:[
        aStream nextPutAll:' methodsFor:'.
    ].

    cat := aMethod category ? ''.
    aStream nextPutAll:cat asString storeString.
    aStream nextPutChunkSeparator; cr; cr.

    source := aMethod source.
    source isNil ifTrue:[
        FileOutErrorSignal
            raiseRequestWith:self
            errorString:(' - no source for method: ' ,
                         self name , '>>' ,
                         (self selectorAtMethod:aMethod))
    ] ifFalse:[
        aStream nextChunkPut:source.
    ].
    aStream space.
    aStream nextPutChunkSeparator.
    aStream cr

    "Created: / 05-09-2012 / 00:01:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-11-2012 / 23:43:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMetaclass methodsFor:'presentation'!

nameInBrowser
    ^ myClass nameInBrowser

    "Created: / 09-10-2013 / 00:21:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMetaclass methodsFor:'queries'!

isObsolete
   ^ myClass isObsolete

    "Created: / 19-09-2016 / 16:47:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

owningClass
    ^ myClass owningClass

    "Created: / 05-08-2014 / 22:35:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

supportsMethodCategories
    ^myClass supportsMethodCategories

    "Created: / 04-07-2012 / 19:54:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMetaclass class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaMetaclass.st,v 1.5 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id::                                                                                                                        '
! !

