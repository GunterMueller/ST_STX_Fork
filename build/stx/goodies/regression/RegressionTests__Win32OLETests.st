"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#Win32OLETests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-RuntimeSystem'
!


!Win32OLETests class methodsFor:'queries'!

coveredPackageNames
    ^ #('exept:ole')
! !

!Win32OLETests methodsFor:'tests'!

test00_loadOLE
    |iid_IEnum|

    self skipIf:[OperatingSystem isMSWINDOWSlike not] description:'test skipped (OS is not WINDOWS)'.

    Smalltalk at:#ExternalLibraryFunction:Verbose put:true.
    Smalltalk at:#ObjectFileLoader:Verbose put:true.
    "/
    "/ this will already perform a number of calls into OLE,
    "/ to get the CLSIDs of various wellknown interfaces
    "/ (see OLEInterfaceConstants initialize)
    Smalltalk loadPackage:'exept:ole'.

    "/ so when we arrive here without error, some is already known to work..
    self assert:(OLEInterfaceConstants notNil).

    iid_IEnum := OLEInterfaceConstants classVarAt:#'IID_IEnum'.
    self assert:(iid_IEnum notNil).
    self assert:(iid_IEnum class == GUID).
    self assert:(iid_IEnum printString = '{2AE64960-CDDD-101C-9029-040224007802}').

    "
     self new test00_loadOLE
    "
!

test01_SysAllocString
    |ole rslt bstr|

    ole := OLEAutomationDLL current.
    rslt := ole SysAllocString: 'hello World'.

    self assert:(rslt notNil).
    self assert:(rslt sizeInBytes == (4 + ('hello World' size * 2) "+ 2")).
    self assert:(rslt sizeInCharacters == 'hello World' size).
    self assert:(rslt characterAt:1) == $h.
    self assert:(rslt characterAt:2) == $e.

    "
     self new test01_SysAllocString
    "
!

test02_GuidFromProgID
    |guid|

    self
	should:[
	    guid := (GUID clsidFromProgID:'Foo.Bar').
	] raise:OLEError.

    OLEError handle:[:ex |
	ex hresult = (OLEStatusCodeConstants at:#CO_E_CLASSSTRING) ifTrue:[
	    "/ kind of expected - you machine has no AcroPDF installed...
	    Transcript showCR:'OLE: class not found: AcroPDF.PDF'
	] ifFalse:[
	    self assert:false description:'unexpected error code'.
	]
    ] do:[
	guid := (GUID clsidFromProgID:'AcroPDF.PDF').
	self assert:(guid notNil).
	"/ self assert:(guid printString = '').
    ].

     guid := (GUID clsidFromProgID:'InternetExplorer.Application').
     self assert:(guid notNil).
     self assert:(guid printString = '{0002DF01-0000-0000-C000-000000000046}').

     guid := (GUID clsidFromProgID: 'Msxml2.DOMDocument.4.0').
     self assert:(guid notNil).
     self assert:(guid printString = '{88D969C0-F192-11D4-A65F-0040963251E5}').

     guid := (GUID clsidFromProgID: 'Microsoft.JScript.Vsa.VsaEngine').
     self assert:(guid notNil).
     self assert:(guid printString = '{B71E484D-93ED-4B56-BFB9-CEED5134822B}').

    "
     self new test02_GuidFromProgID
    "

    "Modified: / 30-03-2016 / 02:28:15 / cg"
!

test03_verbsEnumerator
    |clsID enumerator nextVerb|

    clsID := GUID clsidFromProgID:'InternetExplorer.Application'.
    self assert:clsID notNil.
    self assert:(clsID printString = '{0002DF01-0000-0000-C000-000000000046}').

    enumerator := OLERegistryInterface verbsEnumerator:clsID.
    self assert:(enumerator notNil).

    nextVerb := enumerator next.
    self assert:nextVerb notNil.
    enumerator release.

    "
     self new test03_verbsEnumerator
    "

    "Created: / 30-03-2016 / 11:29:03 / cg"
!

test20_CreateInstance
    |guid iDispatch iWebBrowser iWebBrowserApp iWebBrowser2
     ids visibleID params result specTable|

    guid := (GUID clsidFromProgID:'InternetExplorer.Application').
    self assert:(guid notNil).
    self assert:(guid printString = '{0002DF01-0000-0000-C000-000000000046}').

    iDispatch := IClassFactory
		createInstance:guid
		iid: (OLEInterface oleConstantAt:'IID_IDispatch')
		controllingUnknown:nil
		context:(OLEInterface oleConstantAt:'CLSCTX_ALL').
    self assert:(iDispatch notNil).

    self assert:(iDispatch hasTypeInfo).
    iWebBrowser := iDispatch queryInterface: IWebBrowser iid.
    self assert:(iWebBrowser notNil).
    specTable := OLEDispatchSpecificationTable constructSpecificationTable: iDispatch getTypeInfo.
    iDispatch release.

    iWebBrowserApp := iWebBrowser queryInterface: IWebBrowserApp iid.
    self assert:(iWebBrowserApp notNil).
    iWebBrowser release.

    iWebBrowser2 := iWebBrowserApp queryInterface: IWebBrowser2 iid.
    self assert:(iWebBrowser2 notNil).
    iWebBrowserApp release.

    "/ iWebBrowser2 setProperty:'Visible' value:true.
    ids := iWebBrowser2 getIDsOfNames:(Array with:'Visible').
    visibleID := ids first.

    params := OLE_DISPPARAMS new.
    params cArgs: 0.
    result := iWebBrowser2 invokePropertyGet: visibleID with:params.
    self assert:(result == false).

"/    params := OLEDispatchValueAdaptor new
"/                parametersForPropertySet: aIDispatchSpecification arguments: valueArray
"/                parameters parametersForPropertySet: aDispatchSpecification arguments: valueArray

    params := OLE_DISPPARAMS new.
    params cArgs: 1.
    params arguments:(Array with:true).
self halt.
    result := iWebBrowser2 invokePropertyPut: visibleID with:params.
self halt.
    self assert:(result == false).

    iWebBrowser2 release.


    "
     self new test20_CreateInstance
    "

    "Created: / 30-03-2016 / 11:26:36 / cg"
    "Modified: / 30-03-2016 / 20:08:04 / cg"
! !

!Win32OLETests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

