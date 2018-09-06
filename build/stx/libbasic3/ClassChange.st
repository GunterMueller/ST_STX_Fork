"
 COPYRIGHT (c) 1993 by Claus Gittinger
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

Change subclass:#ClassChange
	instanceVariableNames:'className classIsJava package nameSpaceOverride nameSpaceName
		owningClassName'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!ClassChange class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    Abstract superclass for class related changes
    They are typically held in a ChangeSet.

    [author:]
        Claus Gittinger
        Jan Vrany

    [:instvars] incomplete
        className <String> ............ the class name *without* namespace, 
                                        but including all owners (if the class
                                        is private)
        owningClassName <String|nil> .. class name of the owning class if any
        nameSpaceName <String|nil> .... namespace name of the change or nil, if
                                        class is in no namespace.
        nameSpaceOverride <NameSpace|nil>  enforced namespace in which the class will 
                                        should be installed.
"
! !

!ClassChange class methodsFor:'instance creation'!

class:aClass
    ^ self new class:aClass

    "Created: 3.12.1995 / 14:01:32 / cg"
!

class:aClass source:source
    ^ self new class:aClass source:source

    "Created: 3.12.1995 / 14:01:32 / cg"
!

className:aClassName
    ^ self new className:aClassName

    "Created: / 13-11-2006 / 10:37:39 / cg"
!

className:aClassName source:source
    ^ self new className:aClassName source:source

    "Created: / 12-11-2006 / 20:11:26 / cg"
! !

!ClassChange methodsFor:'accessing'!

changeClass
    "the class of the change (nil if not present).
     Take care for changes from foreign Smalltalks having 
     a different Namespace definition syntax"

    "do not autoload an owning class of a private class!!"

    |clsNm class owner altName nsName ns meta|

    clsNm := self className.
    clsNm isNil ifTrue:[^ nil].

    "/ ok, try some heuristics (for example Root.something -> Smalltalk::something)
    (clsNm includes:$.) ifTrue:[
        "/ VW - namespace prefix - convert to colon-notation
        clsNm := clsNm copyReplaceAll:$. withAll:'::'.
    ].       
    nsName := self nameSpaceName ? 'Smalltalk'.
    (nsName includes:$.) ifTrue:[
        "/ VW - namespace prefix - convert to colon-notation
        nsName := nsName copyReplaceAll:$. withAll:'::'.
    ].       
    nsName notNil ifTrue:[
        ns := Smalltalk at:nsName asSymbol.
        ns isNil ifTrue:[
            ns := NameSpace fullName:nsName
        ]
    ].
    (meta := (clsNm endsWith:' class')) ifTrue:[    
        clsNm := clsNm copyButLast:6.
    ].

    ns := (ns ? Smalltalk).
    class := ns isNameSpace 
                ifTrue:[ ns loadedClassNamed:clsNm ]
                ifFalse:[ Smalltalk loadedClassNamed:clsNm ].     
    class isNil ifTrue:[
        self isPrivateClassDefinitionChange ifTrue:[
            ns isNameSpace ifTrue:[
                owner := ns loadedClassNamed:(self owningClassName).
            ] ifFalse:[
                owner := Smalltalk loadedClassNamed:(self owningClassName).
            ].
            owner notNil ifTrue:[
                class := owner privateClassesAt:clsNm.
                ^ meta ifTrue:[class theMetaclass] ifFalse:[class].
            ].
        ] ifFalse:[
            class := ns isNameSpace 
                        ifTrue:[ ns classNamed:clsNm ]
                        ifFalse:[ Smalltalk loadedClassNamed:clsNm ].     

            "/ class := Parser evaluate:className ifFail:[nil].
            class isNil ifTrue:[
                (altName := self classNameForWellKnownVisualWorksNamespaceClass:clsNm) notNil
                ifTrue:[
                    class := ns isNameSpace 
                                ifTrue:[ ns classNamed:altName ]
                                ifFalse:[ Smalltalk loadedClassNamed:altName ].     
                    class isNil ifTrue:[
                        class := Parser evaluate:altName ifFail:[nil]
                    ]
                ].
            ].
        ].
        class isNil ifTrue:[
            ns ~= Smalltalk ifTrue:[
                self isPrivateClassDefinitionChange ifTrue:[
                    owner := Smalltalk loadedClassNamed:(self owningClassName).
                    owner notNil ifTrue:[
                        class := owner privateClassesAt:clsNm.
                        ^ meta ifTrue:[class theMetaclass] ifFalse:[class].
                    ].
                ] ifFalse:[
                    class := Smalltalk classNamed:clsNm.
                    "/ class := Parser evaluate:className ifFail:[nil].
                    class isNil ifTrue:[
                        ^ nil.
                    ].
                ].
            ].
            class isNil ifTrue:[^ nil].
        ].
    ].

    "/ care for aliases...
    "/ (class nameWithoutPrefix ~= className) ifTrue:[ ^ nil ].
    ^ meta ifTrue:[class theMetaclass] ifFalse:[class].

    "Modified: / 10-08-2012 / 12:07:26 / cg"
    "Modified: / 12-12-2013 / 13:35:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeClass:aClass
    "set the class of the change"

    className := aClass name.
!

class:aClass
    "set the class of the change"

    self className:aClass name.

    "Created: / 03-12-1995 / 14:01:45 / cg"
    "Modified: / 12-11-2006 / 20:10:28 / cg"
!

class:aClass source:newSource
    "set both class and source of the change"

    self className:(aClass name) source:newSource
!

classBaseName 
    "return the className of the change.
     This is without *any* prefix (namespace or private-owner)"

    ^ self cutNameSpaceOf:className

    "Modified: 15.7.1996 / 09:28:35 / cg"
!

className
    "Returns class name of the class as it was present in the original change.
     For changes from a file with namespace override, this will be the
     className *without* toplevel namespace, but with all owning classes 
     (if the change class is a private class).
     For changes generated internally (by the browser), this will be the full name,
     and the namespace override will be nil.
     
     cg: this is all very confusing and needs some cleanup.
     However it will be done, any change here needs checks in all users of this code."

    ^ className

    "Modified (comment): / 12-06-2013 / 11:33:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

className:aString 
    "set the className of the change"

    self assert:aString notNil.
    className := aString

    "Modified: / 15.7.1996 / 09:28:35 / cg"
    "Created: / 16.2.1998 / 13:05:36 / cg"
!

className:newClassName source:newSource
    "set both className and source of the change"

    self assert:(newSource isString).
    self assert:(newClassName isString).

    self className: newClassName.
    source := newSource.

    "Created: / 03-12-1995 / 14:01:45 / cg"
    "Modified: / 15-07-1996 / 09:28:26 / cg"
    "Modified: / 11-06-2013 / 17:44:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classNameForWellKnownVisualWorksNamespaceClass:className
    (className startsWith:'Root::') ifTrue:[
        ^ className copyFrom:7.
    ].
    (className startsWith:'Core.') ifTrue:[
        ^ className copyFrom:6.
    ].
    (className startsWith:'Smalltalk.') ifTrue:[
        ^ className copyFrom:11.
    ].
    ^ nil

    "Created: / 29-01-2011 / 11:29:59 / cg"
!

classNameWithoutNamespace
    "return the className of the change"

    ^ self cutMyNameSpaceOf: "cutNameSpaceOf:"className

    "Modified: / 06-10-2011 / 16:58:34 / cg"
!

fullClassName
    "Returns the fully qualified class name, i.e., including namespace in which the
     class should be installed 
     (i.e., the override namespace (if any) rather than original namespace (of any))"

    |ns|

    "/ used to be ^ className;
    "/
    "/ now include a translation from vw namespace to stx nameSpace

    "/ cg: why is override ignore here???
    ns := self nameSpaceName.
    "/ ns := self nameSpaceOverride.
    (ns isNil or:[ns = 'Smalltalk']) ifTrue:[^ self className].

    ^ ns , '::' , self className

    "Modified (comment): / 04-02-2014 / 19:29:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fullOwningClassName
    "Returns fully qualified owner's class name, i.e., including namespace in which the
     class should be found (i.e., the override namespace (if any) rather than
     original namespace (of any))"

    |nm ns|

    nm := self owningClassName.
    nm isNil ifTrue:[^ nil].

    "/ cg: why is override ignore here???
    ns := self nameSpaceName.
    "/ ns := self nameSpaceOverride.
    ns notNil ifTrue:[
        ^ ns,'::',nm
    ].
    nameSpaceName notNil ifTrue:[
        ^ nameSpaceName,'::',nm    
    ].
    ^ nm
"/    |nm ns|
"/
"/    "/ used to be ^ owningClassName;
"/    "/
"/    "/ now include a translation from vw namespace to stx nameSpace
"/    nm := self owningClassName.
"/    ns := self nameSpaceName.
"/    (ns isNil or:[ns = 'Smalltalk']) ifTrue:[^ nm].
"/
"/    ^ ns , '::' , nm
!

localClassName
    "for private classes, this returns the name relative to its owner;
     for non-private ones, this is the regular name.
     Notice that className always returns the full name (incl. any owner prefix)
     but *without* any namespace prefix"

    ^self className

    "Modified (comment): / 12-06-2013 / 11:34:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameSpace
    |nsName nameSpace|

    (nsName := self nameSpaceName) notNil ifTrue:[
        ^ NameSpace name:nsName.
    ].
    ^ Smalltalk
!

nameSpace: aNameSpace
    self nameSpaceName: aNameSpace name

    "Created: / 11-06-2013 / 15:57:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameSpaceName
    "Return the namespace in which the class should be installed.

     If the user enforces a namespace using nameSpaceOverride or
     using query signal, then the enforced namespace is returned.
     Otherwise, changes's original namespace is returned, if any."

    | ns |

    className isNil ifTrue:[^ nil].

    ns := self nameSpaceOverride.
    ns notNil ifTrue:[ ^ ns ].

"/  JV: Following code is rubbish because it cannot distiguish
"/      between namespace and owning class...

"/    (idx := className indexOf:$:) ~~ 0 ifTrue:[
"/        "/ in a namespace
"/        ^ className copyTo:(idx - 1).
"/    ].

"/  JV: I commented following It is not clear to how it is supposed to
"/      work. If anybody wants this back, he/she should first write
"/      a testcase to demonstrate how it should work.

"/    (idx := className indexOf:$.) ~~ 0 ifTrue:[
"/        "/ in a namespace
"/        ns := className copyTo:(idx - 1).
"/        cnm := className copyFrom:(idx + 1).
"/        "cheat: VW namespaces"
"/        ^ self nameSpaceForVWNamespace:ns class:cnm ifAbsent:ns
"/    ].

    ^ nameSpaceName

    "Modified: / 03-08-2006 / 02:04:03 / cg"
    "Modified: / 11-06-2013 / 15:03:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 04-02-2014 / 17:54:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameSpaceName: aString
    nameSpaceName := aString ~= 'Smalltalk' ifTrue:[aString] ifFalse:[nil].

    "Created: / 11-06-2013 / 15:53:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameSpaceOverride
    "Return namespace enforced by the caller.

    NOTE: This code used to use `Class nameSpaceQuerySignal` to
    allow enforcing namespace by query. This made the code more
    complicated and was used only by Tools::ChangeSetBrowser2 so
    it was removed. 

    To apply change in particular namespace, use nameSpaceOverride:.
    You may use applyWithNameSpaceOverride: for your convenience.
    "

    |ns|

    ns := nameSpaceOverride.
    ns isNil ifTrue:[^ nil].
    ns isString ifTrue:[ ^ ns ].
    ^ ns name

    "Created: / 07-09-2011 / 20:45:43 / cg"
    "Modified (comment): / 04-02-2014 / 18:33:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameSpaceOverride:aNamespaceOrString
    aNamespaceOrString isString ifTrue:[
        nameSpaceOverride := NameSpace name:aNamespaceOrString
    ] ifFalse:[
        nameSpaceOverride := aNamespaceOrString
    ]

    "Created: / 20-03-2012 / 17:12:08 / cg"
!

nonMetaClassName
    ^ self isForMeta
	ifTrue:[ self className copyTo:(self className size - 6) ]
	ifFalse:[ self className ]

    "Created: / 06-11-2008 / 17:26:03 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

owningClassName
    ^ owningClassName

    "Modified: / 11-06-2013 / 14:50:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

owningClassName:aStringOrSymbol
    owningClassName := aStringOrSymbol

    "Created: / 30-08-2010 / 13:55:37 / cg"
!

package
    "return the value of the instance variable 'package' (automatically generated)"

    ^ package
!

package:something
    "set the value of the instance variable 'package' (automatically generated)"

    package := something.
! !

!ClassChange methodsFor:'applying'!

apply
    "apply the change"

    |class|

    class := self changeClass.
    class isNil ifTrue:[
        self error:('Cannot apply change for missing class: ' , className) mayProceed:true.
        ^ self
    ].
    class autoload.         "Most changes cannot be applied to unloaded classes"
    Class nameSpaceQuerySignal answer:self nameSpace do:[
        Parser evaluate:(self source)
    ].
"/    |ns|
"/
"/    ns := Class nameSpaceQuerySignal isHandled 
"/            ifTrue:[ Class nameSpaceQuerySignal query ]
"/            ifFalse:[ self nameSpace ].
"/
"/    Class nameSpaceQuerySignal answer:ns do:[
"/        Parser evaluate:(self source)
"/    ].

    "Modified: / 29-01-2011 / 12:28:03 / cg"
!

applyWithNameSpaceOverride: nameSpaceOrNameSpaceName
    "Apply the change, overriding a namespace to given one"

    | savedNameSpaceOverride |

    savedNameSpaceOverride := nameSpaceOverride.
    nameSpaceOverride := nameSpaceOrNameSpaceName.
    self apply.
    nameSpaceOverride := savedNameSpaceOverride

    "Created: / 04-02-2014 / 18:24:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassChange methodsFor:'printing & storing'!

printOn:aStream
    "append a user printed representation of the receiver to aStream.
     The format is suitable for a human - not meant to be read back."

    source isNil ifTrue:[
        aStream nextPutAll:self class nameWithArticle,'-change (no source)'.
        ^ self
    ].
    aStream nextPutAll:(self class name , ' - ' , source string firstLine , '...').
! !

!ClassChange methodsFor:'queries'!

cutMyNameSpaceOf:aString
    |ns|

    aString isNil ifTrue:[ ^ nil ].
    (ns := self nameSpaceOverride) isNil ifTrue:[ ^ aString ].
    (aString startsWith:(ns , '.')) ifTrue:[ ^ self cutNameSpaceOf:aString ].
    (aString startsWith:(ns , '::')) ifTrue:[ ^ self cutNameSpaceOf:aString ].

    ^ aString

    "Modified: / 07-09-2011 / 20:49:33 / cg"
!

cutNameSpaceOf:aString
    |dotIndex colonIndex|

    aString isNil ifTrue:[ ^ nil].

    dotIndex := aString indexOf:$..
    dotIndex ~~ 0 ifTrue:[
        ^ aString copyFrom:dotIndex+1
    ].
    colonIndex := aString indexOf:$:.
    colonIndex ~~ 0 ifTrue:[
        ^ aString copyFrom:colonIndex+2
    ].
    ^ aString

    "Modified: / 29-01-2011 / 11:32:01 / cg"
!

isForMeta
    ^ (self className endsWith:' class')
!

nameSpaceForVWNamespace:ns class:className ifAbsent:default
    "map the namespace for a given class - hack; only works for some"

    ns = 'Core' ifTrue:[^ 'Smalltalk'].
    ns = 'Kernel' ifTrue:[^ 'Smalltalk'].
    ns = 'Graphics' ifTrue:[^ 'Smalltalk'].
    ns = 'OS' ifTrue:[^ 'Smalltalk'].
    ns = 'Smalltalk' ifTrue:[^ 'Smalltalk'].
    ns = 'UI' ifTrue:[^ 'Smalltalk'].
    ^ default value
! !

!ClassChange methodsFor:'testing'!

isClassChange
    ^ true
! !

!ClassChange class methodsFor:'documentation'!

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

