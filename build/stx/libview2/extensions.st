"{ Package: 'stx:libview2' }"!

!CharacterArray methodsFor:'converting'!

asMimeType
    ^ MIMETypes mimeTypeFromString:self string

    "
     'text/html' asMimeType isTextType
     'text/html' asMimeType isImage
     'image/gif' asMimeType isImage
    "
! !

!stx_libview2 class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !
