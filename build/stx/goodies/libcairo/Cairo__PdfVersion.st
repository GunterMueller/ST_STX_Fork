"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

SharedPool subclass:#PdfVersion
	instanceVariableNames:''
	classVariableNames:'CAIRO_PDF_VERSION_1_4 CAIRO_PDF_VERSION_1_5'
	poolDictionaries:''
	category:'Cairo-Constants'
!

!PdfVersion class methodsFor:'initialization'!

initialize

    CAIRO_PDF_VERSION_1_4 := 0.
    CAIRO_PDF_VERSION_1_5 := 1.
! !

!PdfVersion class methodsFor:'constants'!

CAIRO_PDF_VERSION_1_4

    ^CAIRO_PDF_VERSION_1_4
!

CAIRO_PDF_VERSION_1_5

    ^CAIRO_PDF_VERSION_1_5
! !


PdfVersion initialize!
