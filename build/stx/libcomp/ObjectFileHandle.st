"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcomp' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ObjectFileHandle
	instanceVariableNames:'sysHandle1 sysHandle2 pathName moduleID handleType weakMethodRef
		weakClassRefs weakFunctionRefs snapshot'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler'
!

!ObjectFileHandle class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    not for public use - used by ObjectFileLoader to keep track of loaded modules,
    associating objectFile names and moduleIDs to classes/methods.
    This is required to be able to fixup classes, methods and function references
    when an image is restarted and the dynamic objects are reloaded.

    [see also:]
	ExternalFunction
	ObjectFileLoader

    [author:]
	Claus Gittinger
"
! !

!ObjectFileHandle class methodsFor:'change & update'!

preSnapshot
    "about to write a snapshot.
     Mark all the current instances as being snapshotted"

    self allInstancesDo:[:i| i snapshot:true].
! !

!ObjectFileHandle methodsFor:'accessing'!

classes
    "return the classes"

    weakClassRefs isNil ifTrue:[^ #()].
    ^ weakClassRefs asArray

    "Created: 14.9.1995 / 21:13:13 / claus"
!

classes:aCollectionOfClasses
    "set the classes collection"

    weakClassRefs notNil ifTrue:[
	weakClassRefs removeDependent:self.
	weakClassRefs := nil.
	handleType := nil.
    ].
    aCollectionOfClasses notNil ifTrue:[
	weakClassRefs := WeakArray withAll:aCollectionOfClasses.
	weakClassRefs addDependent:self.
	handleType := #classLibraryObject
    ].

    "Created: 14.9.1995 / 21:13:13 / claus"
!

functions
    "return the functions which were already extracted from the module."

    weakFunctionRefs isNil ifTrue:[^ #()].
    ^ weakFunctionRefs asArray
	select:[:f | f notNil and:[f class ~~ SmallInteger]]

    "Created: 12.7.1996 / 15:33:09 / cg"
    "Modified: 30.1.1997 / 20:54:54 / cg"
!

makeClassLibHandle
    "make this a classLibHandle - must be done manually when init failed for proper de-registration
     later."

    handleType notNil ifTrue:[
	self error:'should not happen'.
    ].
    handleType := #classLibraryObject
!

method
    "return the method (or nil, if I am not a method-file handle)"

    weakMethodRef isNil ifTrue:[^ nil].
    ^ weakMethodRef at:1

    "Created: 14.9.1995 / 21:13:13 / claus"
!

method:something
    "set the method"

    weakMethodRef notNil ifTrue:[
	weakMethodRef removeDependent:self.
	weakMethodRef := nil.
	handleType := nil.
    ].
    something notNil ifTrue:[
	weakMethodRef := WeakArray with:something.
	weakMethodRef addDependent:self.
	handleType := #methodObject.
    ].

    "Created: 14.9.1995 / 21:13:13 / claus"
!

methods
    "return the collection of methods (or an empty collection,
     if I am not a method-file handle)"

    |m|

    (m := self method) isNil ifTrue:[^ #()].
    "/ TODO: this will return a real collection, when method-only
    "/ binaries remember that relevant information ...
    ^ Array with:m
!

moduleID
    "return moduleID"

    ^ moduleID

    "Created: 14.9.1995 / 21:13:12 / claus"
!

moduleID:something
    "set moduleID"

    moduleID := something.

    "Created: 14.9.1995 / 21:13:12 / claus"
!

pathName
    "return pathName"

    ^ pathName

    "Created: 14.9.1995 / 21:13:12 / claus"
!

pathName:something
    "set pathName"

    pathName := something.

    "Created: 14.9.1995 / 21:13:12 / claus"
!

snapshot
    "return the value of the instance variable 'snapshot' (automatically generated)"

    ^ snapshot
!

snapshot:something
    "set the value of the instance variable 'snapshot' (automatically generated)"

    snapshot := something.
!

sysHandle1
    "return sysHandle1"

    ^ sysHandle1

    "Created: 14.9.1995 / 21:13:12 / claus"
!

sysHandle1:something
    "set sysHandle1"

    sysHandle1 := something.

    "Created: 14.9.1995 / 21:13:12 / claus"
!

sysHandle2
    "return sysHandle2"

    ^ sysHandle2

    "Created: 14.9.1995 / 21:13:12 / claus"
!

sysHandle2:something
    "set sysHandle2"

    sysHandle2 := something.

    "Created: 14.9.1995 / 21:13:12 / claus"
! !

!ObjectFileHandle methodsFor:'actions'!

removeConnectedObjects
    "remove the smalltalk objects from the system that are connected
     with this ObjectFileHandle"

    |method|

    self isClassLibHandle ifTrue:[
	"/ remove the classes (meta- and private classes are removed as a side effect)...
	Class withoutUpdatingChangesDo:[
	    self classes do:[:eachClass |
		(eachClass notNil
		 and:[eachClass isMeta not
		 and:[eachClass isPrivate not]]) ifTrue:[
		    eachClass removeFromSystem.
		]
	    ]
	].
	^ self.
    ].
    self isMethodHandle ifTrue:[
	"we keep the method, but break the association to its code"
	method := self method.
	method notNil ifTrue:[
	    method code:nil.
	    self method:nil.
	].
    ].
!

removeUnusedObjectFile
    "remove the object file,
     but only if we are sure, that it is not referenced by a snapshot."

    snapshot ~~ true ifTrue:[
	OperatingSystem removeFile:pathName.
    ]
!

unload
    "unload the object file represented by me"

    ObjectFileLoader unloadDynamicObject:self
! !

!ObjectFileHandle methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "my method/class object was collected - unload the underlying objectfile"

    changedObject == weakMethodRef ifTrue:[
	weakMethodRef nilAllCorpsesAndDo:[:idx |].
    ].

    changedObject == weakClassRefs ifTrue:[
	weakClassRefs nilAllCorpsesAndDo:[:idx |].
    ].

    self isObsolete ifTrue:[
	weakFunctionRefs notNil ifTrue:[
	    weakFunctionRefs removeDependent:self.
	    weakFunctionRefs := nil.
	].
	weakClassRefs notNil ifTrue:[
	    weakClassRefs removeDependent:self.
	    weakClassRefs := nil.
	].
	weakMethodRef notNil ifTrue:[
	    weakMethodRef removeDependent:self.
	    weakMethodRef := nil.
	].
	('ObjectFileHandle [info]: unloading ' , pathName , '  (method/classes were garbageCollected)') infoPrintCR.
	self unload.
	self removeUnusedObjectFile.
    ].

    "Created: 5.12.1995 / 18:05:08 / cg"
    "Modified: 30.1.1997 / 20:57:56 / cg"
! !

!ObjectFileHandle methodsFor:'copying'!

postCopy
    "flush module handles of the copy"

    sysHandle1 := sysHandle2 := moduleID := nil

    "Created: 5.12.1995 / 21:10:49 / cg"
    "Modified: 25.4.1996 / 09:43:53 / cg"
!

postDeepCopy
    sysHandle1 := sysHandle2 := moduleID := nil
! !

!ObjectFileHandle methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to aStream"

    aStream nextPutAll:self class name; nextPutAll:'(handle=<'.
    sysHandle1 printOn:aStream.
    aStream space.
    sysHandle2 printOn:aStream.
    aStream nextPutAll:'> path='''.
    pathName printOn:aStream.
    aStream nextPutAll:''' id='.
    moduleID printOn:aStream.
    aStream nextPutAll:' type='.
    handleType printOn:aStream.
    aStream nextPutAll:' method=<'.
    self method printOn:aStream.
    aStream nextPutAll:'> classes=<'.
    self classes printOn:aStream.
    aStream nextPut:$>.

    aStream nextPut:$).

    "Modified: / 25-04-1996 / 09:44:08 / cg"
    "Modified: / 17-02-2017 / 10:35:25 / stefan"
! !

!ObjectFileHandle methodsFor:'queries'!

getFunction:aString
    "return a function object for an entry in the module represented by the receiver."

    |f|

    f := ExternalFunction basicNew.
    (self getFunctionAddress:aString into:f) isNil ifTrue:[
	^ nil
    ].
    f setName:aString moduleHandle:self.
    ^ f.
!

getFunctionAddress:aString into:anExternalFunction
    "fill the code address of the external function named aString into anExternalFunction.
     Returns the address, or nil."

    |address slot sz nW|

    address := ObjectFileLoader getFunction:aString from:self.
    address isNil ifTrue:[
	anExternalFunction code:0.
	^ nil
    ].

    anExternalFunction code:address.
    weakFunctionRefs isNil ifTrue:[
	handleType := #functionObject.
	weakFunctionRefs := WeakArray with:anExternalFunction.
	^ address.
    ].

    (weakFunctionRefs includesIdentical:anExternalFunction) ifTrue:[
	^ address
    ].

    slot := weakFunctionRefs identityIndexOf:nil.
    slot ~~ 0 ifTrue:[
	weakFunctionRefs at:slot put:anExternalFunction.
	^ address.
    ].
    weakFunctionRefs := weakFunctionRefs copyWith:anExternalFunction.

"/    sz := weakFunctionRefs size.
"/    nW := WeakArray new:(sz + 1).
"/    nW replaceFrom:1 to:sz with:weakFunctionRefs startingAt:1.
"/    nW at:sz+1 put:anExternalFunction.
"/
"/    weakFunctionRefs := nW.
    ^ address
!

hasUndefinedSymbols
    "return true, if the module has any undefined symbols.
     The only system, which allows modules with undefined symbols to be
     loaded is (currently) the linux a.out version."

    ^ ObjectFileLoader hasUndefinedSymbolsIn:self

    "Created: 12.7.1996 / 14:59:09 / cg"
!

isClassLibHandle
    "return true, if I am a handle for a class library"

    ^ handleType == #classLibraryObject
!

isFunctionObjectHandle
    "return true, if I am a handle for a c-code (or other) function object file"

    ^ handleType == #functionObject

    "Created: 12.7.1996 / 15:35:33 / cg"
    "Modified: 12.7.1996 / 17:25:31 / cg"
!

isMethodHandle
    "return true, if I am a handle for a single compiled method"

    ^ handleType == #methodObject
!

isObsolete
    "return true, if my clases/method has already been removed from
     the image. I.e. if the object file can be unloaded without danger."

    |ref|

    moduleID notNil ifTrue:[
	handleType == #classLibraryObject ifTrue:[
	    ^ weakClassRefs isNil or:[(weakClassRefs findFirst:[:x | x notNil and:[x class ~~ SmallInteger]]) == 0]
	].
	handleType == #methodObject ifTrue:[
	    weakMethodRef isNil ifTrue:[^ true].
	    ref := weakMethodRef at:1.
	    ^ ref isNil or:[ref class == SmallInteger]
	].
	handleType == #functionObject ifTrue:[
	    ^ weakFunctionRefs isNil or:[(weakFunctionRefs findFirst:[:x | x notNil and:[x class ~~ SmallInteger]]) == 0]
	].
    ].
    ^ false

    "Modified: 12.7.1996 / 15:42:21 / cg"
!

isUnknownHandle
    "return true, if it is not (yet) known, what type of
     file is represented by the handle. (i.e. when loaded, but not yet
     registered/initialized)"

    ^ handleType isNil
!

package
    "retrieve the packageID of the class-library handle"

    |classes methods|

    "/ sigh - for now, the package must be extracted from the first classes/methods
    "/ package.

    self isClassLibHandle ifTrue:[
	(classes := self classes) notEmpty ifTrue:[
	    ^ classes first package
	].
	^ nil
    ].
    self isMethodHandle ifTrue:[
	(methods := self methods) notEmpty ifTrue:[
	    ^ methods first package
	].
	^ nil
    ].
    ^ nil

    "Modified: / 12-10-2006 / 20:00:15 / cg"
! !

!ObjectFileHandle class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

