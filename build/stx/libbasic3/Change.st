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

Object subclass:#Change
	instanceVariableNames:'source timeOfChangeIfKnown mcDefinition'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!Change class methodsFor:'documentation'!

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
    abstract superclass for all kind of changes - managed in changeSets.

    [instance variables:]
        mcDefinition    ....    prep for monticello

    [author:]
        Claus Gittinger
"
! !

!Change class methodsFor:'support'!

isSource:source1Arg sameSourceAs:source2Arg
    "return true, if the given sources are the same, ignoring tabs and whitespace differences."

    |source1 source2 tSource1 tSource2|

    source1 := source1Arg.
    source2 := source2Arg.

    source1 = source2 ifTrue:[^ true].
    source1 isNil ifTrue:[^ false].
    source2 isNil ifTrue:[^ false].

    source1 := source1 withoutTrailingSeparators asCollectionOfLines.
    source2 := source2 withoutTrailingSeparators asCollectionOfLines.
    [source1 notEmptyOrNil and:[ source1 last isEmptyOrNil]] whileTrue:[ source1 removeLast ].
    [source2 notEmptyOrNil and:[ source2 last isEmptyOrNil]] whileTrue:[ source2 removeLast ].

    source1 size ~~ source2 size ifTrue:[^ false].
    source1 = source2 ifTrue:[^ true].

    tSource1 := source1 collect:[:line | (line withTabsExpanded:8) withoutTrailingSeparators].
    tSource2 := source2 collect:[:line | (line withTabsExpanded:8) withoutTrailingSeparators].
    tSource1 = tSource2 ifTrue:[^ true].

"/ how about that one?
"/    tSource1 := source1 collect:[:line | line withoutLeadingSeparators withoutTrailingSeparators].
"/    tSource2 := source2 collect:[:line | line withoutLeadingSeparators withoutTrailingSeparators].
"/    tSource1 = tSource2 ifTrue:[^ true].

    ^ false.

    "Created: / 25-07-2006 / 11:22:21 / cg"
    "Modified: / 21-05-2015 / 13:30:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Change methodsFor:'accessing'!

changeClass
    "the class of the change (nil if not present)"

    ^ nil

!

changeLanguage
    "Answer the programming language of the receiver. 
     Since changesets are currently only supported for Smalltalk, 
     return SmalltalkLanguage unconditionally"

    ^ SmalltalkLanguage instance

    "Modified (comment): / 25-07-2012 / 17:40:47 / cg"
!

changeSelector
    "the selector, if it is a method change. Nil oherwise"

    ^ nil

    "Created: / 06-02-1998 / 13:29:35 / cg"
!

changeSource
    "Return the source of the change"

    ^ self source

    "Created: / 19-07-2011 / 19:03:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 25-07-2012 / 17:39:24 / cg"
!

className
    "the className of the change"

    ^ nil

    "Modified: / 15.7.1996 / 09:26:34 / cg"
    "Created: / 6.2.1998 / 13:06:56 / cg"
!

delta
    <resource: #obsolete>
    "Returns a delta to current state as symbol:
        #+ .....the subject is to be added to the image (new)
        #- .....the subject is to be removed from the image (old)
        #= .....the image is up to date
        #~ .....change version and image version differ
        #? .....delta is unknown or N/A for this kind of change
    "

    ^ self deltaDetail shortDeltaSymbol

    "Modified (comment): / 31-08-2011 / 10:29:47 / cg"
    "Modified: / 23-04-2015 / 10:38:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

deltaDetail
    "Returns a delta to the current state as a ChangeDelta object"
    
    ^ ChangeDeltaInformation unknown   "We don't know how to compute delta for generic change"

    "Created: / 31-08-2011 / 09:59:15 / cg"
!

file
    ^ nil "/ to be added as instvar
!

file:aFile position:anInteger
    ^ self "/ to be added 
!

imageSource
    "Return the source of the in-image version
     or nil if there is no source for this change"

    ^ nil

    "Created: / 19-07-2011 / 11:58:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 25-07-2012 / 17:37:23 / cg"
!

nameSpaceOverride:ns

    "Created: / 20-03-2012 / 17:18:17 / cg"
!

nonMetaClassName

    ^nil

    "Created: / 26-11-2009 / 16:14:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

objectType:aSymbol
    ^ self "/ to be added as instvar
!

package
    ^ nil
!

prettyPrintedSource
    "return the prettyPrinted or normal source of the change"

    ^ self source
!

selector
    ^ nil

    "Created: / 6.2.1998 / 13:29:35 / cg"
!

source
    "return the source of the change"

    |s|

    source isNil ifTrue:[
        s := String writeStream.
        self printOn:s.
        ^ s contents.
    ].
    ^ source

    "Modified: 15.7.1996 / 09:26:34 / cg"
!

source:someString
    "set the source of the change"

    "/ debugging only ...
    someString isString ifFalse:[
        (someString respondsTo:#string) ifFalse:[
            self halt:'argument should be string-like'
        ]
    ].
    source := someString

    "Modified: / 15.7.1996 / 09:26:34 / cg"
    "Created: / 16.2.1998 / 13:05:16 / cg"
!

timeOfChangeIfKnown
    ^ timeOfChangeIfKnown
!

timeStamp:aTimestamp
    timeOfChangeIfKnown := aTimestamp
! !

!Change methodsFor:'applying'!

apply
    "apply the change"

    self subclassResponsibility

    "Modified: / 13-10-2006 / 00:41:05 / cg"
!

applyWithNameSpaceOverride: nameSpaceOrNameSpaceName
    "Apply the change, overriding a namespace to given one"

    self apply

    "Created: / 04-02-2014 / 18:21:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Change methodsFor:'change notification'!

sendChangeNotificationThroughSmalltalk
    "intentionally left blank"
! !

!Change methodsFor:'comparing'!

isForSameAs:changeB
    "return true, if the given change represents a change for the same
     thingy as the receiver (i.e. same method, same definition etc.)."

    ^ false

!

sameAs:changeB
    "return true, if the given change represents the same change as the receiver."

    ^ false

!

sameSourceAs:changeB
    "return true, if the given change has the same source as the receiver."

    ^ self class isSource:(self source) sameSourceAs:(changeB source)

    "Modified: / 25-07-2006 / 11:22:46 / cg"
! !

!Change methodsFor:'converting'!

asAntiChange
    "Returns my anti-change, i.e. change that do the
     opposite. For class defintion change it returns
     class remove change, for method defintion change
     it returns method remove change. If there is no way
     how to revert the change, an error is trigerred.

     JV: personal note: we should switch to deltastreams
     (http://wiki.squeak.org/squeak/6001)

     CG: is the above really true - what about a classDefChange for
         an existing class????
    "

    "/self error: 'Could not create antichange'
    ^self copy

    "Created: / 02-11-2009 / 11:11:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-11-2009 / 16:10:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Change methodsFor:'enumerating'!

do: aBlock

    ^aBlock value: self

    "Created: / 29-10-2010 / 14:02:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Change methodsFor:'fileout'!

basicFileOutOn: aStream

    aStream 
        cr;
        nextPutAllAsChunk: self source; 
        cr;
        nextPutChunkSeparator; cr
!

fileOutOn: aStream

    self removed ifFalse:[self basicFileOutOn: aStream]
! !

!Change methodsFor:'printing & storing'!

printStringWithoutClassName
    |s|

    s := String writeStream.
    self printWithoutClassNameOn:s.
    ^ s contents
!

printWithoutClassNameOn:aStream
    self printOn:aStream


! !


!Change methodsFor:'queries'!

isForGeneratedSubject
    "
    Answers true iff subject of this method is somewhat
    auto-generated by some tool - just like version methods
    are.
    "

    ^ false

    "Created: / 08-04-2009 / 09:45:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 17-08-2009 / 18:55:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Change methodsFor:'testing'!

isClassCategoryChange
    "return true, if this is a class-category change"

    ^ false

    "Created: / 7.2.1998 / 19:26:50 / cg"
!

isClassChange
    "return true, if this is a class-related change"

    ^ false

    "Created: / 7.2.1998 / 19:26:50 / cg"
!

isClassCommentChange
    "return true, if this is a class-comment change"

    ^ false

    "Created: / 7.2.1998 / 19:26:50 / cg"
!

isClassDefinitionChange
    "return true, if this is a class-definition change"

    ^ false

    "Created: / 7.2.1998 / 19:26:50 / cg"
!

isClassInitializeChange
    ^ false
!

isClassInstVarDefinitionChange
    ^ false

!

isClassRemoveChange
    ^ false

    "Created: / 7.2.1998 / 19:26:50 / cg"
!

isClassRemoveChangeOrMethodRemoveChange
    ^self isClassRemoveChange or: [self isMethodRemoveChange]

    "Created: / 25-11-2009 / 08:16:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isClassRenameChange
    ^ false

    "Created: / 7.2.1998 / 19:26:50 / cg"
!

isCompositeChange
    ^ false

    "Created: / 7.2.1998 / 19:26:50 / cg"
!

isConflict
    "true if this change is different than what is already in the image
     (i.e. it overwrites some existing code)"

    ^ true
!

isDoIt
    ^ false

    "Created: / 7.2.1998 / 19:26:50 / cg"
!

isMethodCategoryChange
    ^ false
!

isMethodCategoryRenameChange
    ^ false

    "Created: / 7.2.1998 / 19:26:50 / cg"
!

isMethodChange
    "true if this is a method related change"

    ^ false

    "Created: / 7.2.1998 / 19:26:50 / cg"
!

isMethodChangeForCopyrightMethod
    "Return true if this is a change of #copyright method"

    ^ false

    "Created: / 01-08-2012 / 16:34:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isMethodChangeForExtensionsVersionMethod
    "true if this is a change for an extensionsVersion method"

    ^ false

    "Created: / 7.2.1998 / 19:26:50 / cg"
!

isMethodChangeForVersionMethod
    "true if this is a change for a version method"

    ^ false

    "Created: / 7.2.1998 / 19:26:50 / cg"
!

isMethodCodeChange
    "true if this is a method's code change (not package, category etc.)"

    ^ false

    "Created: / 7.2.1998 / 19:26:50 / cg"
!

isMethodDefinitionChange
    ^ false
!

isMethodPackageChange
    ^ false

    "Created: / 08-04-2009 / 09:00:21 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

isMethodRemoveChange
    ^ false
!

isNameSpaceCreationChange
    ^ false

    "Created: / 24-11-2011 / 12:10:06 / cg"
!

isOrContainsClassDefinitionChange
    ^ false

    "Created: / 7.2.1998 / 19:26:50 / cg"
!

isOtherChange
    ^ false
!

isPrimitiveChange
    ^ false

!

isPrimitiveDefinitionsChange
    ^ false

!

isPrimitiveFunctionsChange
    ^ false

!

isPrimitiveVariablesChange
    ^ false

!

isPrivateClassDefinitionChange
    ^ false

    "Created: / 12-10-2006 / 22:59:04 / cg"
! !

!Change methodsFor:'visiting'!

acceptChangeVisitor:aVisitor
    ^ aVisitor visitChange:self.

    "Created: / 25-11-2011 / 17:12:05 / cg"
! !

!Change class methodsFor:'documentation'!

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

