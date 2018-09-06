"{ Package: 'stx:goodies/xmlsuite/xquery' }"

!

!Boolean methodsFor:'* As yet uncategorized *'!

xqueryValueType
    ^ XQuery::TypeFactory getType:'xs:boolean'.

    "Created: / 21-06-2009 / 19:43:25 / Jan Kurs <kursj1@fel.cvut.cz>"
! !
!Float methodsFor:'converting'!

asString
    "TODO: this is not the solution specified by the XQuery documentation
      - for more information, see casting xs:float to xs:string rules"
    (self asInteger = self) ifTrue:
    [ 
        ^ self asInteger printString 
    ]
    ifFalse:
    [
        ^ self printString.
    ]

    "Created: / 22-09-2009 / 21:12:48 / Jan Kurs <kursj1@fel.cvut.cz>"
! !
!Float methodsFor:'* As yet uncategorized *'!

xqueryValueType
    ^ XQuery::TypeFactory getType:'xs:float'.

    "Created: / 21-06-2009 / 19:42:19 / Jan Kurs <kursj1@fel.cvut.cz>"
! !
!Integer methodsFor:'* As yet uncategorized *'!

xqueryValueType
    ^ XQuery::TypeFactory getType:'xs:integer'.

    "Created: / 21-06-2009 / 19:47:23 / Jan Kurs <kursj1@fel.cvut.cz>"
! !
!String methodsFor:'* As yet uncategorized *'!

xqueryValueType
    ^ XQuery::TypeFactory getType:'xs:string'.

    "Created: / 21-06-2009 / 19:49:59 / Jan Kurs <kursj1@fel.cvut.cz>"
! !
