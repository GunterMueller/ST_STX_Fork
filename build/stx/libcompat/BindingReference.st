"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

Object subclass:#BindingReference
	instanceVariableNames:'pathString'
	classVariableNames:'KnownBindings'
	poolDictionaries:''
	category:'Compatibility-VisualWorks'
!

!BindingReference class methodsFor:'documentation'!

documentation
"
    ST-80 compatibility class.
    This may be required when existing code has to be ported to ST/X;
    however, it may not be complete and more protocol may be added in the future.
    The code here was created when public domain code (Manchester) had to
    be ported to ST/X and missing classes/methods were encountered, and code added
    by reasoning 'what the original class could probably do there'.

    [author:]
        Claus Gittinger
"
! !

!BindingReference class methodsFor:'instance creation'!

pathString:pathString
    |ref|

    KnownBindings isNil ifTrue:[
        KnownBindings := WeakIdentityDictionary new.
    ].
    ref := KnownBindings at:pathString ifAbsent:nil.
    ref isNil ifTrue:[
        ref := self new pathString:pathString.
        KnownBindings at:pathString put:ref.
    ].
    ^ ref
! !

!BindingReference methodsFor:'accessing'!

asString
    ^ self pathString
!

pathString
    "return the value of the instance variable 'pathString' (automatically generated)"

    ^ pathString
!

pathString:something
    "set the value of the instance variable 'pathString' (automatically generated)"

    pathString := something.
!

replacementClassNameFor:name
    name = 'LargePositiveInteger' ifTrue:[
        ^ 'LargeInteger'
    ].
    name = 'CompiledBlock' ifTrue:[
        ^ 'Block'
    ].
    name = 'AnnotatedMethod' ifTrue:[
        ^ 'Method'
    ].

    ^ name

!

replacementKey
    "return a replacement key to fetch a value from the smalltalk dictionary.
     For compatibility, try to be somewhat heuristic w.r.t. nameSpace
     translations"

    |name key|

    ((name := pathString) includes:$.) ifTrue:[
        name := name copyFrom:(name lastIndexOf:$.) + 1.
    ].

    key := name asSymbolIfInterned.
    (key isNil or:[(Smalltalk includesKey:key) not]) ifTrue:[
        name := self replacementClassNameFor:name.
        key := name asSymbolIfInterned.
    ].

    ^ key
!

value
    "return the bindings value, or the result from evaluating aBlock.
     For compatibility, try to be somewhat heuristic w.r.t. nameSpace
     translations"

    |key|

    key := self replacementKey.
    key isNil ifTrue:[
        "/ self halt.
        ^ nil
    ].

    ^ Smalltalk at:key ifAbsent:nil
!

valueOrDo:aBlock
    "return the bindings value, or the result from evaluating aBlock.
     For compatibility, try to be somewhat heuristic w.r.t. nameSpace
     translations"

    |key|

    key := self replacementKey.
    key isNil ifTrue:[
        "/ self halt.
        ^ aBlock value
    ].

    ^ Smalltalk at:key ifAbsent:aBlock
! !

!BindingReference methodsFor:'misc'!

makeUnambiguous
    ^ self
! !

!BindingReference class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/BindingReference.st,v 1.12 2015-03-27 13:24:26 cg Exp $'
!

version_SVN
    ^ '$Id: BindingReference.st,v 1.12 2015-03-27 13:24:26 cg Exp $'
! !

