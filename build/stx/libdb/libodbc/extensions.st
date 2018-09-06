"{ Package: 'stx:libdb/libodbc' }"!

!Boolean class methodsFor:'odbc queries'!

odbcTypeSymbol
    ^ #'SQL_BIT'
! !

!ByteArray class methodsFor:'odbc queries'!

odbcTypeSymbol
    ^ #'SQL_BINARY'
! !

!CharacterArray class methodsFor:'odbc queries'!

odbcTypeSymbol
    ^ #'SQL_CHAR'
! !

!Date class methodsFor:'odbc queries'!

odbcTypeSymbol
    ^ #'SQL_DATE'
! !

!FixedPoint class methodsFor:'odbc queries'!

odbcTypeSymbol
    ^ #'SQL_DECIMAL'
! !

!Float class methodsFor:'odbc queries'!

odbcTypeSymbol
    ^ #'SQL_DOUBLE'
! !

!Integer class methodsFor:'odbc queries'!

odbcTypeSymbol
    ^ #'SQL_INTEGER'
! !

!Number class methodsFor:'odbc queries'!

odbcTypeSymbol
    ^ #'SQL_NUMERIC'
! !

!Object class methodsFor:'odbc queries'!

odbcTypeSymbol
    "If the column value is not further specified or nil, 
     assume the most generic buffer- String"

    ^ #'SQL_CHAR'
! !

!ShortFloat class methodsFor:'odbc queries'!

odbcTypeSymbol
    ^ #'SQL_FLOAT'
! !

!Time class methodsFor:'odbc queries'!

odbcTypeSymbol
    ^ #'SQL_TIME'
! !

!Timestamp class methodsFor:'odbc queries'!

odbcTypeSymbol
    ^ #'SQL_TIMESTAMP'
! !

!UUID class methodsFor:'odbc queries'!

odbcTypeSymbol
    ^ #'SQL_GUID'
! !

!Unicode16String class methodsFor:'odbc queries'!

odbcTypeSymbol
    ^ #'SQL_WCHAR'
! !

!stx_libdb_libodbc class methodsFor:'documentation'!

extensionsVersion_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/extensions.st,v 1.4 2015-10-29 12:29:52 stefan Exp $'
! !

