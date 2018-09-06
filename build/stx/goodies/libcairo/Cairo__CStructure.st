"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

ByteArray variableByteSubclass:#CStructure
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Objects'
!

CStructure class instanceVariableNames:'fields'

"
 No other class instance variables are inherited by this class.
"
!

!CStructure class methodsFor:'instance creation'!

new
    ^self basicNew: self sizeof

    "Created: / 16-02-2016 / 14:22:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new: size
    self shouldNotImplement

    "Created: / 16-02-2016 / 14:22:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CStructure class methodsFor:'accessing'!

sizeof
    ^ self subclassResponsibility

    "Created: / 16-02-2016 / 14:21:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CStructure class methodsFor:'private'!

fields
    ^ fields

    "Created: / 18-02-2016 / 09:05:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CStructure methodsFor:'inserting'!

inspectorExtraAttributes
    | attrs |

    attrs := super inspectorExtraAttributes.
    self class fields notNil ifTrue:[ 
        self class fields do:[:field | 
            attrs at: '-', field put: [ self perform: field ]
        ].
    ].
    ^ attrs

    "Created: / 18-02-2016 / 09:11:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

