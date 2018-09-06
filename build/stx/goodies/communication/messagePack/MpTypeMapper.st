"{ Package: 'stx:goodies/communication/messagePack' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MpTypeMapper
	instanceVariableNames:'actionMap'
	classVariableNames:''
	poolDictionaries:''
	category:'MessagePack-Core'
!

MpTypeMapper class instanceVariableNames:'actionMap'

"
 No other class instance variables are inherited by this class.
"
!


!MpTypeMapper class methodsFor:'accessing'!

actionMap
	^ actionMap ifNil: [actionMap := self createActionMap]
! !

!MpTypeMapper class methodsFor:'actions for compounds'!

defineCompoundsActionsTo: map
	"override"
! !

!MpTypeMapper class methodsFor:'actions for exts'!

defineExtsActionsTo: map
	"override"
! !

!MpTypeMapper class methodsFor:'actions for primitives'!

definePrimitivesActionsTo: map
	"override"
! !

!MpTypeMapper class methodsFor:'class initialization'!

initialize
	"self initialize"
	actionMap  := nil.
	self actionMap
	
!

initializeAll
	"self initializeAll"
	self allSubclasses do: [:each | each initialize]
! !

!MpTypeMapper class methodsFor:'factory'!

createActionMap
	| map |
	map := IdentityDictionary new.
	self definePrimitivesActionsTo: map.
	self defineCompoundsActionsTo: map.
	self defineExtsActionsTo: map.
	^map
! !

!MpTypeMapper methodsFor:'accessing'!

actionMap

	^ actionMap ifNil: [actionMap := IdentityDictionary new]
!

defaultActionMap

	^ self class actionMap
! !

!MpTypeMapper methodsFor:'initialization'!

initActionMaps
	"override for custom mapping"
	actionMap := nil
! !

!MpTypeMapper class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpTypeMapper.st,v 1.2 2018-05-08 11:02:05 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpTypeMapper.st,v 1.2 2018-05-08 11:02:05 cg Exp $'
! !


MpTypeMapper initialize!
