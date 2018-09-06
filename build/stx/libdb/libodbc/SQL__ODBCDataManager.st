"{ Package: 'stx:libdb/libodbc' }"

"{ NameSpace: SQL }"

ApplicationModel subclass:#ODBCDataManager
	instanceVariableNames:'selectedTabIndex selectedTreeItemIndex selectedTabCanvas odbcTree
		tabCanvasHolder sqlView resultView sqlNotebookVisibleHolder
		dataSourceInfoVisibleHolder driverInfoVisibleHolder
		tableInfoVisibleHolder columnInfoVisibleHolder currentDataSource
		currentSession sqlTextHolder resultList sqlTextAcceptor
		resultColumnSpecHolder dataSourceInfoTable dataSourceInfoColumns
		driverInfoTable driverInfoColumns tableInfoTable tableInfoColumns
		columnInfoTable columnInfoColumns driverDebug'
	classVariableNames:'UserName Password'
	poolDictionaries:''
	category:'DataBase-ODBC-UI'
!

HierarchicalItem subclass:#TreeItem
	instanceVariableNames:'label icon menu databaseSession'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ODBCDataManager
!

ODBCDataManager::TreeItem subclass:#DataSourceItem
	instanceVariableNames:'description'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ODBCDataManager
!

ODBCDataManager::TreeItem subclass:#DriverItem
	instanceVariableNames:'description'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ODBCDataManager
!

ODBCDataManager::TreeItem subclass:#TableItem
	instanceVariableNames:'description'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ODBCDataManager
!

ODBCDataManager::TreeItem subclass:#ColumnItem
	instanceVariableNames:'columnDescription'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ODBCDataManager
!

!ODBCDataManager class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        Claus Gittinger (cg@alan)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
  Starting the application:
                                                                [exBegin]
    SQL::ODBCDataManager open

                                                                [exEnd]

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for 
    ... executable example here ...
                                                                [exEnd]
"
! !

!ODBCDataManager class methodsFor:'helpers'!

connectDialogFor:databaseName
    |bindings user password db loginParameters|

    bindings := IdentityDictionary new.
    bindings at:#inputFieldDBNameModel put:(databaseName ? 'mysql') asValue.
    bindings at:#inputFieldDBUserModel put:(UserName ? 'root') asValue.
    bindings at:#inputFieldDBPasswordModel put:(Password ? '') asValue.

    (SimpleDialog new
        openDialogSpec:(self connectDialogSpec) withBindings:bindings) ifFalse:[
        ^ nil
    ].

    UserName := user := (bindings at:#inputFieldDBUserModel) value.
    Password := password := (bindings at:#inputFieldDBPasswordModel) value.
    db := (bindings at:#inputFieldDBNameModel) value.

    loginParameters := Structure 
                with:#userName -> user
                with:#password -> password
                with:#databaseName -> db.
    ^ loginParameters

     "
      self connectDialogFor:'test'
     "
! !

!ODBCDataManager class methodsFor:'image specs'!

computer
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self computer inspect
     ImageEditor openOnClass:self andSelector:#computer
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SQL::ODBCDataManager class computer'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 20; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@PDA@PDA@@@@@@@@@@@@@@DA@PDA@PDA@PDA@PDA@@@@@@@@@@@@@@@@@@@@@@DA@PDA@PDA@@@@@@@@@@@@@@@@@@@@@@DA@PDA@PDA@@@@@@@@@@@@@@@@
@@@@@@DA@PDA@PDA@@@@@@@@@@@@@@@@@@@@@@DA@PDA@PDA@@@@@@@@@@@@@@@@@@@@@@@@@PDA@PD@@@@@@@@@@@@C@@@@@@@@@@@@@PDA@P@C@0LC@0LC
@0L@@@@@@@@@@@@@@PDA@P@CA XFA XFA L@@@@@@@@@@@@@@@@@@P@CA HDA@PDA@L@@@@@@@@@@@DA@PDA@P@CA HDA@PDA@L@@@@@@@@@@@DA@PDA@P@C
A@PDA@PDA@L@@@@@@@@@@@@A@PDA@P@C@0LC@0LC@0L@@@@@@@@@@@@@@PDA@P@@@@@@@@@@@@@@@@@@@@DA@P@@@PDA@@DA@PDA@PDA@PDA@@@@@@@A@PDA
@PDA@@LC@0LC@0LC@0LC@@DA@PDA@PDA@PDA@@@@@@@@@@@@@@@@@@DA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA
@PDA@PDA@PDA@PDA@PDA@@@@@@@@@@DA@PDA@PDA') ; colorMapFromArray:#[0 0 0 240 248 240 0 248 240 184 188 184 0 0 240 80 88 96 0 0 128]; mask:((Depth1Image new) width: 24; height: 20; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@A?8@C?8@C?8@C?8@C?8@C?8@C?8@C?8@G?<@G?<@G?<@@@@@@@@@@@@@') ; yourself); yourself]
!

dataSourcesIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self dataSourcesIcon inspect
     ImageEditor openOnClass:self andSelector:#dataSourcesIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SQL::ODBCDataManager class dataSourcesIcon'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 20; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@PDA@PDA@@@@@@@@@@@@@@DA@PDA@PDA@PDA@PDA@@@@@@@@@@@@@@@@@@@@@@DA@PDA@PDA@@@@@@@@@@@@@@@@@@@@@@DA@PDA@PDA@@@@@@@@@@DA@PD@
@@@@@@DA@PDA@PDA@@@@@@@@@PDA@PDA@@@@@@DA@PDA@PDA@@@@@@@@@@DA@PD@@@@@@@@@@PDA@PD@@@@@@@@@@P@@@@@A@@@@@@@@@PDA@P@C@0LC@0L@
@PDA@PDA@@@@@@@@@PDA@P@CA0\GA0\@@PDA@PDA@@@@@@@@@@@@@P@CA0HDA@P@@PDA@PDA@@@@@@DA@PDA@P@CA0HDA@P@@PDA@PDA@@@@@@DA@PDA@P@C
A@PDA@P@@PDA@PDA@@@@@@@A@PDA@P@C@0LC@0L@@PDA@PDA@@@@@@@@@PDA@P@@@@@@@@@@@@DA@PD@@@DA@P@@@PDA@@DA@PDA@PDA@P@@@@@@@@@A@PDA
@PDA@@LC@0LC@0LC@0LC@@DA@PDA@PDA@PDA@@@@@@@@@@@@@@@@@@DA@PDA@@DA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA
@PDA@PDA@PDA@PDA@PDA@@@@@@@@@@DA@PDA@PDA') ; colorMapFromArray:#[0 0 0 240 248 240 0 248 240 184 188 184 0 0 240 80 88 96 255 0 0 0 0 128]; mask:((Depth1Image new) width: 24; height: 20; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@^@@@?@@A? @A? A?? C?? C?? C?? C?? C?? C?? C??@G?>@G?<@G?<@@@@@@@@@@@@@') ; yourself); yourself]
!

driversIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self driversIcon inspect
     ImageEditor openOnClass:self andSelector:#driversIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SQL::ODBCDataManager class driversIcon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@A@PDA@@@@@@@@@@@@@PDA@PB@ HDA@P@@@@@@@@D@@@@A@HBA@HBA@@@@@PDA@PB@ HD@ PB@@P@@@@D@@@@A@HB@ H@@ DD@@@@A@HB@ HB@ HB
@ @B@@P@A@PDA@PD@ HB@@H@@PDD@@PB@ HB@ HBA@P@@ @BA@@D@ HB@ HB@ PD@@H@@@P@A@PDA@PD@ HB@@H@@PDD@@@D@ HB@ H@@ @B@@@@A@@@A@HB
@ PB@ @B@@HAA@@@@@PDA@PB@ HD@ P@@@P@@@@@@@PB@ HD@ @D@@@D@@@@@@@DA@PD@ H@A@PD@@@@@@@@@@@@A@PDA@@@@@@@@@@a') ; colorMapFromArray:#[240 248 240 152 160 152 184 188 184 80 88 96 0 0 0]; mask:((Depth1Image new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@<@_>A?<_?1??G?>??;??/?>??9??''?<_?0_?A?8@<@b') ; yourself); yourself]
!

executeSqlIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self executeSqlIcon inspect
     ImageEditor openOnClass:self andSelector:#executeSqlIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SQL::ODBCDataManager class executeSqlIcon'
        ifAbsentPut:[(Depth2Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(2)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'UUUUUUUUUUUUUTEUUUTAUUUUQUUUP@UUUQPAQUUTAAUTTAUUT@@UUUTAAUUUUPUUUUTEUUUUPUUUUUUUUUUUUP@a') ; colorMapFromArray:#[0 0 0 192 192 192]; mask:((Depth1Image new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@A @N@@P@_@B^PA6AN@O8@N0@C@@L@@X@@@@@@b') ; yourself); yourself]
!

odbcIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self odbcIcon inspect
     ImageEditor openOnClass:self andSelector:#odbcIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SQL::ODBCDataManager class odbcIcon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 16; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@A@PDA@PD@@@@@@@@@@@DAJ24.@R<0@PD@@@@@@@D&F2 *K@D1L#L5@P@@@@D!!FRP''GB$AMCX7NS,A@@@AE1 "H2TZ@S :OC4?@P@AD1TVG2@A@PDA
O$AAP$PA@Q@REA8A@@@@@@ECQTYH@PDLC!!D]@P@@@@@AQ4%JS@DABPPMC0D@@@@@@T-MS%@A@P\CB ,A@@@@@@EOTUIT@PDF@  AX0DA@PDAT5UVU0D@@PTA
YVQ"XVA^WPEXV D@@@DAY&U#X&E W%5\@U,A@@@@@VY%X6I!!XE9]WE$A@@@@@@@A@VM"XVA_WPDA@@@@@@@@@@@A@PDA@PD@@@@@@@@a') ; colorMapFromArray:#[0 0 0 0 0 0 0 68 0 0 85 0 0 101 0 0 56 0 0 60 0 0 76 0 0 76 0 0 93 0 0 93 0 0 101 0 0 109 0 0 109 0 0 117 0 0 117 0 0 121 0 0 125 0 0 133 0 0 141 0 0 141 0 0 149 0 0 157 0 0 165 0 0 174 0 0 186 0 0 206 0 0 206 0 0 210 0 0 133 0 0 149 0 0 165 0 0 174 0 0 178 0 0 182 0 0 190 0 0 194 0 0 198 0 0 202 0 0 202 0 0 214 0 0 218 0 0 222 0 0 226 0 0 226 0 0 230 0 0 234 0 16 48 48 16 52 52 20 60 60 20 64 64 24 72 72 24 72 72 24 80 80 24 80 80 28 89 89 28 89 89 28 93 93 28 93 97 32 101 101 32 101 105 36 109 109 36 109 109 36 113 117 36 117 117 40 125 125 40 129 129 40 133 133 44 137 137 44 137 141 48 145 145 48 145 149 48 149 153 48 153 153 52 161 161 52 161 161 52 165 165 52 165 170 56 174 174 56 174 178 56 178 182 56 182 182 60 186 186 60 186 190 60 190 194 60 194 194 64 198 198 64 202 206 64 206 206 68 0 0 68 210 210 72 218 222 89 0 0 113 0 0 137 0 0 141 0 0 165 0 0 186 0 0 210 0 0 226 0 0 230 0 0 242 0 0 255 0 0]; mask:((ImageMask new) width: 16; height: 16; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'A>@_>C?<_?9??/???C?<O?0??C???7?>_?8??A?8A>@b') ; yourself); yourself]
!

singleDataSourceIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self singleDataSourceIcon inspect
     ImageEditor openOnClass:self andSelector:#singleDataSourceIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SQL::ODBCDataManager class singleDataSourceIcon'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 20; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@PDA@PDA@@@@@@@@@@@@@@DA@PDA@PDA@PDA@PDA@@@@@@@@@@@@@@@@@@@@@@DA@PDA@PDA@@@@@@@@@@@@@@@@@@@@@@DA@PDA@PDA@@@@@@@@@@DA@PD@
@@@@@@DA@PDA@PDA@@@@@@@@@PDA@PDA@@@@@@DA@PDA@PDA@@@@@@@@@@DA@PD@@@@@@@@@@PDA@PD@@@@@@@@@@P@@@@@A@@@@@@@@@PDA@P@C@0LC@0L@
@PDA@PDA@@@@@@@@@PDA@P@CA0\GA0\@@PDA@PDA@@@@@@@@@@@@@P@CA0HDA@P@@PDA@PDA@@@@@@DA@PDA@P@CA0HDA@P@@PDA@PDA@@@@@@DA@PDA@P@C
A@PDA@P@@PDA@PDA@@@@@@@A@PDA@P@C@0LC@0L@@PDA@PDA@@@@@@@@@PDA@P@@@@@@@@@@@@DA@PD@@@DA@P@@@PDA@@DA@PDA@PDA@P@@@@@@@@@A@PDA
@PDA@@LC@0LC@0LC@0LC@@DA@PDA@PDA@PDA@@@@@@@@@@@@@@@@@@DA@PDA@@DA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA
@PDA@PDA@PDA@PDA@PDA@@@@@@@@@@DA@PDA@PDA') ; colorMapFromArray:#[0 0 0 240 248 240 0 248 240 184 188 184 0 0 240 80 88 96 255 0 0 0 0 128]; mask:((Depth1Image new) width: 24; height: 20; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@^@@@?@@A? @A? A?? C?? C?? C?? C?? C?? C?? C??@G?>@G?<@G?<@@@@@@@@@@@@@') ; yourself); yourself]
!

singleDriverIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self singleDriverIcon inspect
     ImageEditor openOnClass:self andSelector:#singleDriverIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SQL::ODBCDataManager class singleDriverIcon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 15; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@ HB@ HA@PDA@PDB@ HB@ HB@PDA@0@E@0@C@PDA@ HB@PTC@@T@@0L@@0@C@0DB@ DEAPTC@0TE@0LE@0LA@ HA@PDCAPTC@0TE@0DA@PHAAPTEAPTC@PDC
@0TE@0LA@PPD@PTEAPDAAPTC@PTE@PDD@PPEAPTEAPTCAPTAAPDA@PLDAPTEAPTEAPTEA@DA@ DCA@DE@PTE@PPAAPPA@ HA@0DCA@DEAPDDA@DD@PHB@PDA
@0PAA@PAA@PA@PDB@ HB@PLD@PTE@PPD@PHB@ HB@ DA@PDEAPDA@PDB@ HB@ HB@ HA@PDA@ HB@ HB') ; colorMapFromArray:#[88 88 88 0 0 0 248 252 248 184 252 248 0 128 128 0 192 192]; mask:((Depth1Image new) width: 16; height: 15; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'A>@??G?>_?9??/??????????_?9??''?>G? _>@O@') ; yourself); yourself]
!

singleFieldIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self singleFieldIcon inspect
     ImageEditor openOnClass:self andSelector:#singleFieldIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SQL::ODBCDataManager class singleFieldIcon'
        ifAbsentPut:[(Depth4Image new) width: 18; height: 18; photometric:(#palette); bitsPerSample:(#(4)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
DQDQDQDQDQDQDQDQDQD@DQDQDQDQDQDD@ADQDQDP@ADAQ@@QDQDFXADAPTPADQA&@@@DMDPAD@Y&Y&U ECPADFY&@@@@QAPADFY&UPDAP4PADFY&Y DAPTPA
D@UUTADDMDPADQ@@@ADAECPADQDQDQDCQAPADQDQDQD@P4PADQDQDQDQ@DPADQDQDQDQDP@ADQDQDQDQDQDADQDQDQDQDQDQ') ; colorMapFromArray:#[0 0 0 248 252 248 0 0 128 128 128 128 192 192 192 248 168 88 248 220 168]; mask:((Depth1Image new) width: 18; height: 18; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@C@@@C0@A3<@C3>@G?>@_?>@_?>@_;>@_;>@_3>@G3>@@C>@@C>@@@>@@@N@@@B@@@@@') ; yourself); yourself]
!

singleTableIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self singleTableIcon inspect
     ImageEditor openOnClass:self andSelector:#singleTableIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SQL::ODBCDataManager class singleTableIcon'
        ifAbsentPut:[(Depth4Image new) width: 15; height: 12; photometric:(#palette); bitsPerSample:(#(4)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'DQDQD@@QDQ@QDQDADP@QDADQDAD1DP@PDQDAD1DQDP@QDAHQD1DS@ADBH!!DQDS@PDBHRHQHS@Q@BH"HRDS@QD@ABH"HS@QDPDPABH#@QDQ@QDPAC@QDQDADQ
DP@QDQDP') ; colorMapFromArray:#[0 0 0 248 252 248 248 252 192 192 192 0 128 128 0]; mask:((Depth1Image new) width: 15; height: 12; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@\DC<P_=C?<_?3?=_?''?<_?!!O<DO PLA') ; yourself); yourself]
!

systemDataSourcesIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self systemDataSourcesIcon inspect
     ImageEditor openOnClass:self andSelector:#systemDataSourcesIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SQL::ODBCDataManager class systemDataSourcesIcon'
        ifAbsentPut:[(Depth8Image new) width: 24; height: 20; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@@DA@P@C@0DA@PDA@PDA@PDA@PDA@PD@@@@C@0L@@0DA@PDA@PDA@PDA@PDA@P@A@PD@@0LC
@0DA@PDA@PDA@PDA@PDA@P@C@0LC@0LC@0DA@PDA@PDA@PDA@PDA@@@@@@@@@0LC@PDA@@@@@PDA@PD@@@@@@@LC@0LC@0L@@@DA@@@@@PDA@P@C@0LC@@LC
@0LC@0L@@@DA@@@@@PDA@P@CA XF@@@@@@@@@0LC@PDA@@@@@@@@@P@CA HDA@@C@0LC@0DC@PDA@@DA@PDA@P@CA HDA@@C@0L@@0LA@0DA@@DA@PDA@P@C
A@PDA@@@@@@C@0L@@0DA@@@A@PDA@P@C@0LC@0LC@@LC@0@C@PDA@@@@@PDA@P@@@@@@@@@@@@@@@@LC@PDA@P@@@PDA@@DA@PDA@PDA@PD@@@@@@@DA@PDA
@PDA@@LC@0LC@0LC@0L@@@DA@PDA@PDA@PDA@@@@@@@@@@@@@@@@@@DA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA@PDA
@PDA@PDA@PDA@PDA@PDA@@@@@@@@@@DA@PDA@PDA') ; colorMapFromArray:#[0 0 0 240 248 240 0 248 240 184 188 184 0 0 240 80 88 96 0 0 128]; mask:((Depth1Image new) width: 24; height: 20; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@? @A? @C? @C? @G? A?? C?? C?? C?? C?? C?? C?? C?? G?? G?<@G?<@@@@@@@@@@@@@') ; yourself); yourself]
!

tablesIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self tablesIcon inspect
     ImageEditor openOnClass:self andSelector:#tablesIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SQL::ODBCDataManager class tablesIcon'
        ifAbsentPut:[(Depth8Image new) width: 16; height: 15; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@PDA@PDA@PDA@@DA@PDA@PDA@PDA@P@A@@H@@@DA@PDA@PDA@P@A@@DA@PH@@@DA@PDA@P@A@@DA@PHA@PD@@PDA@P@A@@DA@ @@@PD@@PDA@P@A@@HA@P@A
@P@@@PDA@P@B@@HB@P@A@PDB@P@@@P@B@@HB@ @A@0DA@PDA@P@@@0LD@0@A@0DA@0DA@P@A@P@@@0@A@0DA@0HA@P@A@PDA@P@B@0DB@0DA@P@A@PDA@P@B
@ HB@0HA@ @A@PDA@PDA@@@B@ HB@ @A@PDA@PDA@PDA@@@B@ @A@PDA@PDA@PDA@PDA@@@A@PDA@PDA') ; colorMapFromArray:#[0 0 0 248 252 248 248 252 192 192 192 0 64 64 0]; mask:((Depth1Image new) width: 16; height: 15; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@D@B<@_<C?8_?C?8_?;????>_?0_>C?0G>@G0@F@') ; yourself); yourself]
!

userDataSourcesIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self userDataSourcesIcon inspect
     ImageEditor openOnClass:self andSelector:#userDataSourcesIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:#'SQL::ODBCDataManager class userDataSourcesIcon'
        ifAbsentPut:[(Depth8Image new) width: 18; height: 20; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
B@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@@@@@@@B@ HB@ HB@ HB@ H@@LC@0LC@@ HB@ HB@ HB@ @@0LC@@@@@@ HB@ HB@ HB@@C@0L@B@ H@@ H
B@ HB@ HB@@C@0L@B@X@@@ HB@ HB@@@@@@C@0@HB@ HB@@HB@ H@@HB@ HC@0@HB@ B@@ H@@ H@@HIBP$C@0@HB@ H@@ H@@ H@@HI@PTC@0@HA @@B@ H
B@ H@@HI@PTEA@L@B@@@B@ HB@ H@@HEAPTEAPLC@@ @@@ HB@ H@@HB@ HB@ HBB (H@@ HB@ H@@@@@@@@@@@@@@(JB @HB@ @@ HB@ HB@ HB@ @@B@ H
B@ @@ HB@ HB@ HB@ @@B@ HB@ @@@@@@@@@@@@@@@@@B@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ HB@ @B@ HB@ HB@ HB@ HB@ HB@ @B@ HB@ H
') ; colorMapFromArray:#[0 0 0 0 248 240 184 188 184 240 248 0 128 128 0 0 0 240 128 128 128 80 88 96 240 248 240 0 0 128 240 0 240]; mask:((Depth1Image new) width: 18; height: 20; photometric:(#blackIs0); bitsPerSample:(#(1)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@?@C8?@G<?@O<?@_<?@_<?C?>?G?<?G?<?G?8?G?8?G?<?G?<?G?>?O?8?O?8?O?8?@@@?@@@?@@@?') ; yourself); yourself]
! !

!ODBCDataManager class methodsFor:'interface specs'!

connectDialogSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SQL::ODBCDataManager andSelector:#connectDialogSpec
     SQL::ODBCDataManager new openInterface:#connectDialogSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: connectDialogSpec
        window: 
       (WindowSpec
          label: 'Database connect dialog'
          name: 'Database connect dialog'
          min: (Point 300 149)
          max: (Point 300 149)
          bounds: (Rectangle 16 46 316 195)
        )
        component: 
       (SpecCollection
          collection: (
           (LabelSpec
              label: 'Connect to Database:'
              name: 'Label4'
              layout: (LayoutFrame 0 0.0 0 0 0 1.0 22 0)
              style: (FontDescription #'MS SANS SERIF' bold roman 10)
              translateLabel: true
              adjust: left
            )
           (InputFieldSpec
              name: 'EntryField3'
              layout: (LayoutFrame 100 0 29 0 0 1.0 51 0)
              model: inputFieldDBNameModel
              isReadOnly: true
              formatString: ''
              acceptOnLeave: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: true
            )
           (LabelSpec
              label: 'User:'
              name: 'Label2'
              layout: (LayoutFrame 0 0 59 0 100 0 81 0)
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'EntryField1'
              layout: (LayoutFrame 100 0 59 0 300 0 81 0)
              model: inputFieldDBUserModel
              acceptOnLeave: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: true
            )
           (LabelSpec
              label: 'Password:'
              name: 'Label3'
              layout: (LayoutFrame 0 0 89 0 100 0 111 0)
              translateLabel: true
              adjust: right
            )
           (InputFieldSpec
              name: 'EntryField2'
              layout: (LayoutFrame 100 0 89 0 300 0 111 0)
              model: inputFieldDBPasswordModel
              type: password
              formatString: ''
              acceptOnLeave: true
              acceptOnLostFocus: true
              acceptOnPointerLeave: true
            )
           (HorizontalPanelViewSpec
              name: 'HorizontalPanel1'
              layout: (LayoutFrame 0 0 -30 1 0 1 0 1)
              horizontalLayout: spreadSpace
              verticalLayout: center
              horizontalSpace: 3
              verticalSpace: 3
              reverseOrderIfOKAtLeft: true
              component: 
             (SpecCollection
                collection: (
                 (ActionButtonSpec
                    label: 'Cancel'
                    name: 'Button1'
                    translateLabel: true
                    model: cancel
                    extent: (Point 125 22)
                  )
                 (ActionButtonSpec
                    label: 'OK'
                    name: 'Button2'
                    translateLabel: true
                    model: accept
                    isDefault: true
                    extent: (Point 125 22)
                  )
                 )
               
              )
            )
           (LabelSpec
              label: 'Databasename:'
              name: 'Label1'
              layout: (LayoutFrame 0 0 29 0 100 0 51 0)
              translateLabel: true
              adjust: right
            )
           )
         
        )
      )
!

resultViewSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SQL::ODBCDataManager andSelector:#resultViewSpec
     SQL::ODBCDataManager new openInterface:#resultViewSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: resultViewSpec
        window: 
       (WindowSpec
          label: 'ODBCDataManager'
          name: 'ODBCDataManager'
          min: (Point 10 10)
          bounds: (Rectangle 16 46 316 346)
        )
        component: 
       (SpecCollection
          collection: (
           (DataSetSpec
              name: 'Table1'
              layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              dataList: resultList
              has3Dsepartors: false
              columnHolder: resultColumnSpecHolder
            )
           )
         
        )
      )
!

sqlViewSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SQL::ODBCDataManager andSelector:#sqlViewSpec
     SQL::ODBCDataManager new openInterface:#sqlViewSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: sqlViewSpec
        window: 
       (WindowSpec
          label: 'ODBCDataManager'
          name: 'ODBCDataManager'
          min: (Point 10 10)
          bounds: (Rectangle 16 46 316 346)
        )
        component: 
       (SpecCollection
          collection: (
           (TextEditorSpec
              name: 'TextEditor1'
              layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              model: sqlTextHolder
              hasHorizontalScrollBar: true
              hasVerticalScrollBar: true
              acceptChannel: sqlTextAcceptor
              acceptCallBack: sqlTextAccepted
            )
           )
         
        )
      )
!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:SQL::ODBCDataManager andSelector:#windowSpec
     SQL::ODBCDataManager new openInterface:#windowSpec
     SQL::ODBCDataManager open
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: windowSpec
        window: 
       (WindowSpec
          label: 'SQL::ODBCDataManager'
          name: 'SQL::ODBCDataManager'
          min: (Point 10 10)
          max: (Point 1024 768)
          bounds: (Rectangle 16 46 512 405)
          menu: mainMenu
          icon: odbcIcon
        )
        component: 
       (SpecCollection
          collection: (
           (VariableHorizontalPanelSpec
              name: 'VariableHorizontalPanel1'
              layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
              snapMode: both
              component: 
             (SpecCollection
                collection: (
                 (HierarchicalListViewSpec
                    name: 'HierarchicalListView1'
                    model: selectedTreeItemIndex
                    hasHorizontalScrollBar: true
                    hasVerticalScrollBar: true
                    backgroundColor: (Color 100.0 100.0 100.0)
                    listModel: odbcTree
                    highlightMode: line
                    valueChangeSelector: treeSelectionChanged
                  )
                 (ViewSpec
                    name: 'Box1'
                    component: 
                   (SpecCollection
                      collection: (
                       (ViewSpec
                          name: 'SqlBox'
                          layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                          visibilityChannel: sqlNotebookVisibleHolder
                          component: 
                         (SpecCollection
                            collection: (
                             (MenuPanelSpec
                                name: 'ToolBar1'
                                layout: (LayoutFrame 0 0 0 0 0 1 30 0)
                                menu: sqlMenuBar
                                textDefault: true
                              )
                             (NoteBookViewSpec
                                name: 'NoteBook1'
                                layout: (LayoutFrame 0 0 30 0 0 1 0 1)
                                model: selectedTabIndex
                                menu: tabList
                                useIndex: true
                                canvas: tabCanvasHolder
                                keepCanvasAlive: true
                              )
                             )
                           
                          )
                        )
                       (ViewSpec
                          name: 'DriverInfoBox'
                          layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                          visibilityChannel: driverInfoVisibleHolder
                          component: 
                         (SpecCollection
                            collection: (
                             (DataSetSpec
                                name: 'DriverInfoTable'
                                layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                                hasHorizontalScrollBar: true
                                hasVerticalScrollBar: true
                                dataList: driverInfoTable
                                has3Dsepartors: false
                                columnHolder: driverInfoColumns
                              )
                             )
                           
                          )
                        )
                       (ViewSpec
                          name: 'DataSourceInfoBox'
                          layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                          visibilityChannel: dataSourceInfoVisibleHolder
                          component: 
                         (SpecCollection
                            collection: (
                             (DataSetSpec
                                name: 'DataSourceInfoTable'
                                layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                                hasHorizontalScrollBar: true
                                hasVerticalScrollBar: true
                                dataList: dataSourceInfoTable
                                has3Dsepartors: false
                                columnHolder: dataSourceInfoColumns
                              )
                             )
                           
                          )
                        )
                       (ViewSpec
                          name: 'TableInfoBox'
                          layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                          visibilityChannel: tableInfoVisibleHolder
                          component: 
                         (SpecCollection
                            collection: (
                             (DataSetSpec
                                name: 'TableInfoTable'
                                layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                                hasHorizontalScrollBar: true
                                hasVerticalScrollBar: true
                                dataList: tableInfoTable
                                has3Dsepartors: false
                                columnHolder: tableInfoColumns
                              )
                             )
                           
                          )
                        )
                       (ViewSpec
                          name: 'ColumnInfoBox'
                          layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                          visibilityChannel: columnInfoVisibleHolder
                          component: 
                         (SpecCollection
                            collection: (
                             (DataSetSpec
                                name: 'ColumnInfoTable'
                                layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
                                hasHorizontalScrollBar: true
                                hasVerticalScrollBar: true
                                dataList: columnInfoTable
                                has3Dsepartors: false
                                columnHolder: columnInfoColumns
                              )
                             )
                           
                          )
                        )
                       )
                     
                    )
                  )
                 )
               
              )
              handles: (Any 0.344758 1.0)
            )
           )
         
        )
      )
! !

!ODBCDataManager class methodsFor:'list specs'!

tabList
    "This resource specification was automatically generated
     by the TabListEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the TabListEditor may not be able to read the specification."

    "
     TabListEditor new openOnClass:SQL::ODBCDataManager andSelector:#tabList
    "

    <resource: #tabList>

    ^     #(
       (TabItem
          label: 'SQL'
        )
       (TabItem
          label: 'Result'
        )
       )
     
      collect:[:aTab| TabItem new fromLiteralArrayEncoding:aTab ]
! !

!ODBCDataManager class methodsFor:'menu specs'!

mainMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:SQL::ODBCDataManager andSelector:#mainMenu
     (Menu new fromLiteralArrayEncoding:(SQL::ODBCDataManager mainMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'File'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Exit'
                  itemValue: closeRequest
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Debug'
            translateLabel: true
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Driver Debug'
                  itemValue: driverDebug:
                  translateLabel: true
                  indication: driverDebug
                )
               )
              nil
              nil
            )
          )
         (MenuItem
            label: 'Help'
            translateLabel: true
            startGroup: right
            submenu: 
           (Menu
              (
               (MenuItem
                  label: 'Documentation'
                  itemValue: openDocumentation
                  translateLabel: true
                )
               (MenuItem
                  label: '-'
                )
               (MenuItem
                  label: 'About this Application'
                  itemValue: openAboutThisApplication
                  translateLabel: true
                )
               )
              nil
              nil
            )
          )
         )
        nil
        nil
      )
!

singleTableItemMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:SQL::ODBCDataManager andSelector:#singleTableItemMenu
     (Menu new fromLiteralArrayEncoding:(SQL::ODBCDataManager singleTableItemMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Update'
            itemValue: updateSingleTable
            translateLabel: true
          )
         )
        nil
        nil
      )
!

sqlMenuBar
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:SQL::ODBCDataManager andSelector:#sqlMenuBar
     (Menu new fromLiteralArrayEncoding:(SQL::ODBCDataManager sqlMenuBar)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Execute SQL'
            itemValue: acceptAndExecuteSqlStatement
            translateLabel: true
            isButton: true
            labelImage: (ResourceRetriever nil executeSqlIcon)
          )
         )
        nil
        nil
      )
!

tablesItemMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:SQL::ODBCDataManager andSelector:#tablesItemMenu
     (Menu new fromLiteralArrayEncoding:(SQL::ODBCDataManager tablesItemMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'New...'
            itemValue: newTable
            translateLabel: true
            isVisible: false
          )
         (MenuItem
            label: '-'
            isVisible: false
          )
         (MenuItem
            label: 'Remove...'
            itemValue: removeTable
            translateLabel: true
            isVisible: false
          )
         (MenuItem
            label: '-'
            isVisible: false
          )
         (MenuItem
            label: 'Update'
            itemValue: updateTables
            translateLabel: true
          )
         )
        nil
        nil
      )
! !

!ODBCDataManager class methodsFor:'tableColumns specs'!

columnInfoColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:SQL::ODBCDataManager andSelector:#columnInfoColumns
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         label: 'Key'
         labelButtonType: Button
         model: at:
       )
      (DataSetColumnSpec
         label: 'Value'
         labelButtonType: Button
         model: at:
       )
      )
!

dataSourceInfoColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:SQL::ODBCDataManager andSelector:#dataSourceInfoColumns
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         label: 'Key'
         labelButtonType: Button
         model: at:
       )
      (DataSetColumnSpec
         label: 'Value'
         labelButtonType: Button
         model: at:
       )
      )
!

driverInfoColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:SQL::ODBCDataManager andSelector:#driverInfoColumns
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         label: 'Key'
         labelButtonType: Button
         model: at:
       )
      (DataSetColumnSpec
         label: 'Value'
         labelButtonType: Button
         model: at:
       )
      )
!

tableInfoColumns
    "This resource specification was automatically generated
     by the DataSetBuilder of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the DataSetBuilder may not be able to read the specification."

    "
     DataSetBuilder new openOnClass:SQL::ODBCDataManager andSelector:#tableInfoColumns
    "

    <resource: #tableColumns>

    ^#(
      (DataSetColumnSpec
         label: 'Key'
         labelButtonType: Button
         model: at:
       )
      (DataSetColumnSpec
         label: 'Value'
         labelButtonType: Button
         model: at:
       )
      )
! !

!ODBCDataManager methodsFor:'actions'!

acceptAndExecuteSqlStatement
    self sqlTextAcceptor value:true.
!

executeSqlStatement
    |statementText stmt cursor row colSpec|

    self resultList removeAll.
    statementText := self sqlTextHolder value.

    currentSession isNil ifTrue:[
        self halt.
    ].

    stmt := currentSession newStatementFor:statementText.
    SQL::SQLError handle:[:ex |
        Dialog warn:('SQL Error:' , Character cr, Character cr, ex description).
    ] do:[
        cursor := stmt execute. 
    ].

    cursor isNil ifTrue:[^ self].

    "/ generate result-tableColSpec
    colSpec := OrderedCollection new.
    cursor columnDescriptions do:[:colDescr |
        |lbl col|

        col := DataSetColumnSpec new.
        lbl := colDescr name.
        "/ lbl := lbl , '[' , colDescr sqlType , ']'.
        col label:lbl.
        col model:#'at:'.
        col minWidth:50.
        colSpec add:col.
    ].
    self resultColumnSpecHolder value:colSpec asArray.

    cursor next.
    [(row := cursor rowAsArray) notNil] whileTrue:[
        row replaceAll:nil with:'<NULL>'.
        self resultList add:row.

        Transcript showCR:row.
        cursor next.
    ].
    stmt release.

    self selectedTabIndex value:2.  "/ switch to result view
!

selectedTabIndexChanged
    |idx view|

    idx := self selectedTabIndex value.
    idx == 1 ifTrue:[
        view := self sqlView.
    ].
    idx == 2 ifTrue:[
        view := self resultView.
    ].

    self tabCanvasHolder value:view.
!

showColumnItem:selItem
    |cols|

    self makeColumnInfoVisible.
    cols := OrderedCollection new.

    #(
        ('Name'  name)
        ('Type'  type)
        ('Size'  columnSize)
    ) do:[:pair |
        |name selector value|

        name := pair at:1.
        selector := pair at:2.
        value := (selItem columnDescription perform:selector).
        cols add:(Array with:name with:value).
    ].

    self columnInfoTable value:cols.
!

showDataSourceItem:selItem
    |info keys sources|

    self makeAllRightViewsInvisible.

    info := selItem description.

    sources := OrderedCollection new.

    keys := info keys asOrderedCollection sort.

"/    "/ want some keys to come first...
"/    #('Driver' 'Description') do:[:toComeFirst |
"/        (keys includes:toComeFirst) ifTrue:[
"/            keys remove:toComeFirst.
"/            keys addFirst:toComeFirst.
"/        ].
"/    ].
"/
    keys do:[:eachKey |
        |eachValue|

        eachValue := info at:eachKey.
        sources add:(Array with:eachKey with:eachValue).
    ].

    self dataSourceInfoTable value:sources.
    self expandDataSourceItem:selItem.

    self makeSqlViewVisible.
!

showDriverItem:selItem
    |info keys list|

    info := selItem description.

    self makeDriverInfoVisible.

    list := OrderedCollection new.
    keys := info keys asOrderedCollection sort.

    "/ want some keys to come first...
    #('Driver' 'Description') do:[:toComeFirst |
        (keys includes:toComeFirst) ifTrue:[
            keys remove:toComeFirst.
            keys addFirst:toComeFirst.
        ].
    ].

    keys do:[:eachKey |
        |eachValue|

        eachValue := info at:eachKey.
        list add:(Array with:eachKey with:eachValue).
    ].

    self driverInfoTable value:list
!

showOtherItem:selItem
!

showTableItem:selItem
    self expandTableItem:selItem.
!

treeSelectionChanged
    |selItem|

    self makeAllRightViewsInvisible.

    selItem := self selectedTreeItem.
    selItem isNil ifTrue:[
        ^ self.
    ].

    selItem showIn:self.
! !

!ODBCDataManager methodsFor:'aspects'!

columnInfoColumns
    columnInfoColumns isNil ifTrue:[
        columnInfoColumns := self class columnInfoColumns asValue.
    ].
    ^ columnInfoColumns.
!

columnInfoTable
    columnInfoTable isNil ifTrue:[
        columnInfoTable := #() asValue.
    ].
    ^ columnInfoTable.
!

columnInfoVisibleHolder
    columnInfoVisibleHolder isNil ifTrue:[
        columnInfoVisibleHolder := false asValue.
    ].
    ^ columnInfoVisibleHolder.
!

dataSourceInfoColumns
    dataSourceInfoColumns isNil ifTrue:[
        dataSourceInfoColumns := self class dataSourceInfoColumns asValue.
    ].
    ^ dataSourceInfoColumns.
!

dataSourceInfoTable
    dataSourceInfoTable isNil ifTrue:[
        dataSourceInfoTable := #() asValue.
    ].
    ^ dataSourceInfoTable.
!

dataSourceInfoVisibleHolder
    dataSourceInfoVisibleHolder isNil ifTrue:[
        dataSourceInfoVisibleHolder := false asValue.
    ].
    ^ dataSourceInfoVisibleHolder.
!

driverDebug
    driverDebug isNil ifTrue:[
        driverDebug := false asValue.
    ].
    ^ driverDebug.
!

driverInfoColumns
    driverInfoColumns isNil ifTrue:[
        driverInfoColumns := self class driverInfoColumns asValue.
    ].
    ^ driverInfoColumns.
!

driverInfoTable
    driverInfoTable isNil ifTrue:[
        driverInfoTable := #() asValue.
    ].
    ^ driverInfoTable.
!

driverInfoVisibleHolder
    driverInfoVisibleHolder isNil ifTrue:[
        driverInfoVisibleHolder := false asValue.
    ].
    ^ driverInfoVisibleHolder.
!

odbcTree
    odbcTree isNil ifTrue:[
        odbcTree := HierarchicalList new.
        odbcTree application:self.
        odbcTree root:(self setupODBCTree).
    ].
    ^ odbcTree.
!

resultColumnSpecHolder
    resultColumnSpecHolder isNil ifTrue:[
        resultColumnSpecHolder := #() asValue.
    ].
    ^ resultColumnSpecHolder.
!

resultList
    resultList isNil ifTrue:[
        resultList := List new.
    ].
    ^ resultList.
!

selectedTabIndex
    selectedTabIndex isNil ifTrue:[
        selectedTabIndex := 1 asValue.
        selectedTabIndex onChangeSend:#selectedTabIndexChanged to:self.
    ].
    ^ selectedTabIndex.
!

selectedTreeItemIndex
    selectedTreeItemIndex isNil ifTrue:[
        selectedTreeItemIndex := ValueHolder new.
    ].
    ^ selectedTreeItemIndex.
!

sqlNotebookVisibleHolder
    sqlNotebookVisibleHolder isNil ifTrue:[
        sqlNotebookVisibleHolder := false asValue.
    ].
    ^ sqlNotebookVisibleHolder.
!

sqlTextAcceptor
    sqlTextAcceptor isNil ifTrue:[
        sqlTextAcceptor := TriggerValue new.
    ].
    ^ sqlTextAcceptor.
!

sqlTextHolder
    sqlTextHolder isNil ifTrue:[
        sqlTextHolder := '' asValue.
    ].
    ^ sqlTextHolder.
!

tabCanvasHolder
    tabCanvasHolder isNil ifTrue:[
        tabCanvasHolder := ValueHolder new.
    ].
    ^ tabCanvasHolder.
!

tabList
    |list|

    (list := builder bindingAt:#tabList) isNil ifTrue:[
        builder aspectAt:#tabList put:(list := self class tabList).
    ].
    ^ list
!

tableInfoColumns
    tableInfoColumns isNil ifTrue:[
        tableInfoColumns := self class tableInfoColumns asValue.
    ].
    ^ tableInfoColumns.
!

tableInfoTable
    tableInfoTable isNil ifTrue:[
        tableInfoTable := #() asValue.
    ].
    ^ tableInfoTable.
!

tableInfoVisibleHolder
    tableInfoVisibleHolder isNil ifTrue:[
        tableInfoVisibleHolder := false asValue.
    ].
    ^ tableInfoVisibleHolder.
! !

!ODBCDataManager methodsFor:'initialization & release'!

initialize
    "/ Smalltalk loadPackage:'stx:libdb'.
    "/ Smalltalk loadPackage:'stx:libdb/libodbc'.

    super initialize.
!

postBuildWith:aBuilder
    self selectedTabIndexChanged.

    ^ super postBuildWith:aBuilder
! !

!ODBCDataManager methodsFor:'menu actions'!

driverDebug:aBoolean
    SQL::ODBCEnvironment debug:aBoolean.
!

menuNew
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'new' is selected."

    "/ change below and add any actions as required here ...
    self warn:'no action for ''new'' available.'.
!

menuOpen
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'open' is selected."

    "/ change below and add any actions as required here ...
    self warn:'no action for ''open'' available.'.
!

menuSave
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'save' is selected."

    "/ change below and add any actions as required here ...
    self warn:'no action for ''save'' available.'.
!

menuSaveAs
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'saveAs' is selected."

    "/ change below and add any actions as required here ...
    self warn:'no action for ''saveAs'' available.'.
!

newTable
    self makeSqlViewVisible.
    self sqlTextHolder value:'create table <TABLENAME>
( 
  <FIELDNAME_1> <TYPENAME_1>
  ...
  <FIELDNAME_n> <TYPENAME_n> 
)'.
!

openAboutThisApplication
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'help-about' is selected."

    "/ could open a customized aboutBox here ...
    super openAboutThisApplication
!

openDocumentation
    "This method was generated by the Browser.
     It will be invoked when the menu-item 'help-documentation' is selected."

    "/ change below as required ...

    "/ to open an HTML viewer on some document (under 'doc/online/<language>/' ):
    HTMLDocumentView openFullOnDocumentationFile:'TOP.html'.

    "/ add application-specific help files under the 'doc/online/<language>/help/appName'
    "/ directory, and open a viewer with:
    "/ HTMLDocumentView openFullOnDocumentationFile:'help/<MyApplication>/TOP.html'.
!

removeTable
    self halt
!

sqlTextAccepted
    self executeSqlStatement
!

updateSingleTable
    |tableItem|

    tableItem := self selectedTreeItem.
    tableItem removeAll.
    self addODBCColumnItemsTo:tableItem
!

updateTables
    |tablesItem|

    tablesItem := self selectedTreeItem.
    tablesItem removeAll.
    self addODBCTablesItemsTo:tablesItem.
! !

!ODBCDataManager methodsFor:'private'!

buildResultView
    |v|

    v := View new.
    v viewBackground:Color green.
    v client:self spec:#resultViewSpec builder:builder.
    ^ v
!

buildSqlView
    |v|

    v := View new.
    v viewBackground:Color red.
    v client:self spec:#sqlViewSpec builder:builder.
    ^ v
!

createSessionForItem:aDataSourceItem
    |dbName info userName password session|

    dbName := aDataSourceItem label.
    dbName = currentDataSource ifTrue:[^ self].

    info := self class connectDialogFor:dbName.
    info isNil ifTrue:[
        AbortSignal raise
    ].
    userName := info userName.
    password := info password.

    session := SQL::ODBCSession new.
    session connectWithUsername:userName password:password dbname:dbName.

    currentDataSource := dbName.
    currentSession := session.
!

expandDataSourceItem:aDataSourceItem
    self createSessionForItem:aDataSourceItem.
    aDataSourceItem hasChildren ifFalse:[
        self addODBCTableItemsTo:aDataSourceItem.
        "/ aDataSourceItem recursiveExpand.
    ].
!

expandTableItem:aTableItem
    aTableItem hasChildren ifFalse:[
        self addODBCColumnItemsTo:aTableItem.
        "/ aTableItem recursiveExpand.
    ].
!

makeAllRightViewsInvisible
    self sqlNotebookVisibleHolder value:false.
    self dataSourceInfoVisibleHolder value:false.
    self driverInfoVisibleHolder value:false.
    self tableInfoVisibleHolder value:false.
    self columnInfoVisibleHolder value:false.
!

makeColumnInfoVisible
    self makeAllRightViewsInvisible.
    self columnInfoVisibleHolder value:true.
!

makeDataSourceInfoVisible
    self makeAllRightViewsInvisible.
    self dataSourceInfoVisibleHolder value:true.
!

makeDriverInfoVisible
    self makeAllRightViewsInvisible.
    self driverInfoVisibleHolder value:true.
!

makeSqlViewVisible
    self makeAllRightViewsInvisible.
    self sqlNotebookVisibleHolder value:true.
!

makeTableInfoVisible
    self makeAllRightViewsInvisible.
    self tableInfoVisibleHolder value:true.
!

resultView
    resultView isNil ifTrue:[
        resultView := self buildResultView
    ].
    ^ resultView
!

selectedTreeItem
    |idx selItem|

    idx := (self selectedTreeItemIndex value).
    idx ~~ 0 ifTrue:[
        selItem := self odbcTree at:idx.
    ].

    ^ selItem 
!

sqlView
    sqlView isNil ifTrue:[
        sqlView := self buildSqlView
    ].
    ^ sqlView
! !

!ODBCDataManager methodsFor:'private-odbc tree'!

addODBCColumnItemsTo:aTableItem
    |keys|

    keys := currentSession primaryKeysInTable:(aTableItem label).
    keys notEmpty ifTrue:[self halt].

    (currentSession columnsInTable:(aTableItem label)) do:[:eachColDescr |
        |item|

        item := ColumnItem new.
        item label:(eachColDescr name , ' [' , eachColDescr type , ']') icon:(self class singleFieldIcon).
        item columnDescription:eachColDescr.
        aTableItem add:item.
    ].
!

addODBCDataSourceItemsTo:dataSourceItem
    SQL::ODBCEnvironment default dataSources do:[:eachPair |
        |item name description|

        name := eachPair key.
        description := eachPair value.

        item := DataSourceItem new.
        item label:name icon:(self class singleDataSourceIcon).
        item description:description.

        dataSourceItem add:item.
    ].
!

addODBCDriverItemsTo:driversItem
    SQL::ODBCEnvironment default drivers do:[:eachPair |
        |item driverName description|

        driverName := eachPair key.
        description := eachPair value.

        item := DriverItem new.
        item label:driverName icon:(self class singleDriverIcon).
        item description:description.
        driversItem add:item.
    ].
!

addODBCTableItemsTo:aDataSourceItem
    |tablesItem|

    tablesItem := TreeItem new.
    tablesItem label:'Tables' icon:(self class tablesIcon).
    aDataSourceItem add:tablesItem.
    tablesItem menu:(self class tablesItemMenu).

    self addODBCTablesItemsTo:tablesItem.
!

addODBCTablesItemsTo:aTablesItem
    currentSession tables do:[:each |
        |item|

        item := TableItem new.
        item label:each name icon:(self class singleTableIcon).
        item description:each comment.
        item menu:(self class singleTableItemMenu).
        aTablesItem add:item.
    ].
!

setupODBCTree
    |root drivers dataSources|

    root := TreeItem new.
    root label:('ODBC ' , '[' , SQL::ODBCHandle odbcName , ']') icon:(self class odbcIcon).

    drivers := TreeItem new.
    drivers label:'Drivers' icon:(self class driversIcon).
    root add:drivers.
    self addODBCDriverItemsTo:drivers.

    dataSources := TreeItem new.
    dataSources label:'Data Sources' icon:(self class dataSourcesIcon).
    root add:dataSources.
    self addODBCDataSourceItemsTo:dataSources.

    ^ root
! !

!ODBCDataManager::TreeItem methodsFor:'accessing'!

databaseSession
    ^ databaseSession
!

databaseSession:something
    databaseSession := something.
!

icon
    ^ icon
!

icon:something
    icon := something.
!

label
    ^ label
!

label:something
    label := something.
!

label:labelArg icon:iconArg 
    "set instance variables (automatically generated)"

    label := labelArg.
    icon := iconArg.
!

menu:something
    menu := something.
!

middleButtonMenu
    ^ menu
! !

!ODBCDataManager::TreeItem methodsFor:'queries'!

isColumnItem
    ^ false
!

isDataSourceItem
    ^ false
!

isDriverItem
    ^ false
!

isTableItem
    ^ false
! !

!ODBCDataManager::TreeItem methodsFor:'visiting'!

showIn:anApplication 
    anApplication showOtherItem:self
! !

!ODBCDataManager::DataSourceItem methodsFor:'accessing'!

description
    ^ description
!

description:something
    description := something.
! !

!ODBCDataManager::DataSourceItem methodsFor:'queries'!

isDataSourceItem
    ^ true
! !

!ODBCDataManager::DataSourceItem methodsFor:'visiting'!

showIn:anApplication 
    anApplication showDataSourceItem:self.
! !

!ODBCDataManager::DriverItem methodsFor:'accessing'!

description
    ^ description
!

description:something
    description := something.
! !

!ODBCDataManager::DriverItem methodsFor:'queries'!

isDriverItem
    ^ true
! !

!ODBCDataManager::DriverItem methodsFor:'visiting'!

showIn:anApplication 
    anApplication showDriverItem:self.
! !

!ODBCDataManager::TableItem methodsFor:'accessing'!

description
    ^ description
!

description:something
    description := something.
! !

!ODBCDataManager::TableItem methodsFor:'queries'!

isTableItem
    ^ true
! !

!ODBCDataManager::TableItem methodsFor:'visiting'!

showIn:anApplication 
    anApplication showTableItem:self.
! !

!ODBCDataManager::ColumnItem methodsFor:'accessing'!

columnDescription
    ^ columnDescription
!

columnDescription:something
    columnDescription := something.
! !

!ODBCDataManager::ColumnItem methodsFor:'queries'!

isColumnItem
    ^ true
! !

!ODBCDataManager::ColumnItem methodsFor:'visiting'!

showIn:anApplication 
    anApplication showColumnItem:self.
! !

!ODBCDataManager class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libodbc/SQL__ODBCDataManager.st,v 1.21 2004-01-14 14:43:58 cg Exp $'
! !
