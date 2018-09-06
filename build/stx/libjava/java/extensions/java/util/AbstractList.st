"{ Package: 'stx:libjava' }"

!

!(Java classForName:'java.util.AbstractList') methodsFor:'* instance *'!

at: index

    "/ Defined here (in addition to List iface) to overwrite
    "/ Object>>at:
    ^ self get: index - 1.
! !
!(Java classForName:'java.util.AbstractList') methodsFor:'* instance *'!

inspectorClass
    ^JavaListInspectorView
! !
