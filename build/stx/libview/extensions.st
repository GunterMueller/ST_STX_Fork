"{ Package: 'stx:libview' }"!

!ConfigurableFeatures class methodsFor:'queries-features'!

hasFontConfig
%{
#if defined(HAVE_FONTCONFIG)
    RETURN ( true );
#endif	
%}.
    ^ false

    "Created: / 22-02-2016 / 08:08:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ConfigurableFeatures class methodsFor:'queries-features'!

hasXFT
%{
#if defined(HAVE_FONTCONFIG) && defined(XFT)
    RETURN ( true );
#endif	
%}.
    ^ false

    "Created: / 22-02-2016 / 08:08:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'testing'!

isColormap
    ^ false
! !

!Object methodsFor:'testing'!

isKeyboardMap
    ^ false
! !

!stx_libview class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !
