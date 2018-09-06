"{ NameSpace: TDV }"

Object subclass:#ReadMe
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'_README'
!

!ReadMe class methodsFor:'documentation'!

documentation
"
    The TDV namespace contains a framework for 3D visualization,
    using the OpenGLDevice openGL interface.
    These require the libopengl-classLibrary to be loaded
    (see $TOP/libopengl).

    Concrete demo applications are:

        ApplicationColumn3D
            renders incoming column-wise sensor data

        ApplicationMatrix3D
            renders matrix-like data grids
"


! !

!ReadMe class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DataViewer/ReadMe.st,v 1.1 1998-10-26 18:10:56 cg Exp $'
! !
