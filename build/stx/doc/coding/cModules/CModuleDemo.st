"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1997 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This is a demo example:

 THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
"
"{ Package: 'stx:doc/coding/cModules' }"

"{ NameSpace: CodingExamples }"

Object subclass:#CModuleDemo
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-C-Modules'
!

!CModuleDemo class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This is a demo example:

 THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
"
!

documentation
"
    this example demonstrates, how a C object file can be dynamically
    loaded, the function(s) found there be called and finally be
    unloaded.

    This may be useful to implement things like extension interfaces
    (a la netscape plugIns ;-?) which call third party C-code.

    To demonstrate, compile the C-source found in demo[1234].c
    into appropriate loadable object files
    (i.e.:
	make demo1.o demo2.o demo3.o demo4.o
	(on ELF-based systems, followed by:
	    make demo1.so demo2.so demo3.so demo4.so
	)

    then fileIn this class and.

    Notice: watch the xterm window for the output
	    (C-code cannot easily send messages to the Transcript)

    demo1
	contains simple C functions.
    demo2
	contains a C function; it provides an init function,
	which is automatically called when the module is loaded.
	The initFunctions returnValue indicates a 'sucessful' init.
    demo3
	like demo2, but indicates a failed initialization.
	Its automatically unloaded.

    Notice: the code here is not 'the best coding style';
    the path-stuff & loading should be done in a separate
    method.

    [start with:]
	CModuleDemo demo1
	CModuleDemo demo2
	CModuleDemo demo3

    [author:]
	Claus Gittinger

    [see also:]
	ObjectFileLoader ObjectFileHandle
"
! !

!CModuleDemo class methodsFor:'class initialization'!

initialize
    CParser isNil ifTrue:[
        Smalltalk loadPackage:'exept:ctypes'
    ].
! !

!CModuleDemo class methodsFor:'demos - old style'!

demo1
    "load a C object file, extract some functions, call them and finally
     unload the object."

    |f|

    f := self getFunction:'demo1_function1' dll:'demoCLib1'.

    "/
    "/ call it ...
    "/
    'calling the C function ...' printCR.
    f call.

    "/
    "/ unload the object file
    "/

    'unloading ...' printCR.
    ObjectFileLoader unloadDynamicObject:(f moduleHandle)

    "
     CModuleDemo demo1
    "
!

demo2
    "load a C object file which contains some auto-init function,
     extract a function, call it and finally unload the object."

    |path ext handle f|

    "/ load the module.
    "/ instead of hardcoding the file-extension,
    "/ ask the system about its preferred extension for object files;
    "/ Thus the following works on NT and ELF based systems as well.

    'loading ...' printCR.
    ext := ObjectFileLoader sharedLibraryExtension.
    path := self dllPath first.
    handle := ObjectFileLoader loadObjectFile:(path / ('demoCLib2' , ext)) invokeInitializeMethods:true.

    handle isNil ifTrue:[
	^ self error:'object file load failed'.
    ].

    "/
    "/ good; look for the C-function named 'demo2_function1' there
    "/

    'extracting function1''s handle ...' printCR.
    f := handle getFunction:'demo2_function1'.
    f isNil ifTrue:[
	ObjectFileLoader unloadDynamicObject:handle.
	^ self error:'demo2_function1 not found in demoCLib2'.
    ].

    "/
    "/ call it ...
    "/

    'calling C function ...' printCR.
    f call.

    "/
    "/ unload the object file
    "/

    'unloading ...' printCR.
    ObjectFileLoader unloadDynamicObject:handle

    "
     CModuleDemo demo2
    "
!

demo3
    "load a C object file which contains some auto-init function,
     (which fails), try to extract a function, call it and
     finally unload the object.
     Since the initialization fails, the call will not be done."

    |path ext handle f|

    "/ load the module.
    "/ instead of hardcoding the file-extension,
    "/ ask the system about its preferred extension for object files;
    "/ Thus the following works on NT and ELF based systems as well.

    'loading ...' printCR.
    ext := ObjectFileLoader sharedLibraryExtension.
    path := self dllPath first.
    handle := ObjectFileLoader loadObjectFile:(path / ('demoCLib3' , ext)) invokeInitializeMethods:false.

    handle isNil ifTrue:[
	^ self error:'object file load failed'.
    ].

    "/
    "/ good; look for the C-function named 'demo3_function1' there
    "/

    'extracting function1''s handle ...' printCR.
    f := handle getFunction:'demo3_function1'.
    f isNil ifTrue:[
	ObjectFileLoader unloadDynamicObject:handle.
	^ self error:'demo3_function1 not found in demoCLib3'.
    ].

    "/
    "/ call it ...
    "/

    'calling C function ...' printCR.
    f call.

    "/
    "/ unload the object file
    "/

    'unloading ...' printCR.
    ObjectFileLoader unloadDynamicObject:handle

    "
     CModuleDemo demo3
    "
!

getFunction:fnName dll:dllName
    "extract some function.
     Returns an externalFunction"

    |path ext handle f|

    "/ load the module.
    "/ instead of hardcoding the file-extension,
    "/ ask the system about its preferred extension for object files;
    "/ Thus the following works on NT and ELF based systems as well.

    ext := ObjectFileLoader sharedLibraryExtension.
    path := self dllPath first.
    handle := ObjectFileLoader loadObjectFile:(path / (dllName , ext)) invokeInitializeMethods:false.

    handle isNil ifTrue:[
        ^ self error:'object file load failed'.
    ].

    "/
    "/ good; look for the C-function named 'demo1_function1' there
    "/

    'extracting function''s handle ...' printCR.
    f := handle getFunction:fnName.
    f isNil ifTrue:[
        ObjectFileLoader unloadDynamicObject:handle.
        ^ self error:('%1 not found in demoCLib1' bindWith:fnName).
    ].
    ^ f
! !

!CModuleDemo class methodsFor:'demos - preferred style'!

callDemo_8
    |structType struct retVal|

    structType :=
        CParser parseType:'
            struct testStruct {
                int i1;
                int i2;
                int i3;
                int i4;
                int i5;
            };
         '.
    struct := structType gcMalloc.
    struct i1:1.
    struct i2:2.
    struct i3:3.
    struct i4:4.
    struct i5:5.
    retVal := self demo1_8:struct data _:99.
    "/ see code of demo_function8, which sums up s.i1, s.i5 and the second arg
    self assert:(retVal == (struct i1 + struct i5 + 99)).
!

callDemo_8b
    |structType struct retVal|

    structType :=
        CParser parseType:'
            struct testStruct {
                int i1;
                int i2;
                int i3;
                int i4;
                int i5;
            };
         '.
    struct := structType gcMalloc.
    struct i1:1.
    struct i2:2.
    struct i3:3.
    struct i4:4.
    struct i5:5.
    retVal := self inlineCallDemo1_8:struct data _:99.
    "/ see code of demo_function8, which sums up s.i1, s.i5 and the second arg
    self assert:(retVal == (struct i1 + struct i5 + 99)).
!

callDemo_9
    |structType structRetVal retVal|

    structType :=
        CParser parseType:'
            struct testStruct {
                int i1;
                int i2;
                int i3;
                int i4;
                int i5;
            };
         '.
    structRetVal := structType gcMalloc.
    retVal := self demo1_9:structRetVal data _:1 _:2 _:3 _:4 _:5.
    self assert:retVal = structRetVal data.
    "/ see code of demo_function9, which sums up s.i1..s.i5 multiplied by 2..6
    self assert:(retVal == ((1*2)+(2*3)+(3*4)+(4*5)+(5*6))).
!

demo1_1
    <cdecl: void "demo1_function1" (void) module: "demoCLib1" >

    "
     Transcript showCR:(self demo1_1)
    "
!

demo1_2:int
    <cdecl: void "demo1_function2" (int) module: "demoCLib1" >

    "
     Transcript showCR:(self demo1_2:123)
    "
!

demo1_3:aString
    <cdecl: char* "demo1_function3" (char*) module: "demoCLib1" >

    "
     Transcript showCR:(self demo1_3:'hello')
    "
!

demo1_4:aDouble
    <cdecl: double "demo1_function4" (double) module: "demoCLib1" >

    "
     Transcript showCR:(self demo1_4:123.456)
    "
!

demo1_5:aDouble
    <cdecl: char* "demo1_function5" (double) module: "demoCLib1" >

    "
     Transcript showCR:(self demo1_5:123.456) storeString
    "
!

demo1_6:double1 _:double2
    <cdecl: float "demo1_function6" (double, double) module: "demoCLib1" >

    "
     Transcript showCR:(self demo1_6:123.456 _:234.567)
    "
!

demo1_7:double1 _:double2
    <cdecl: double "demo1_function7" (double, double) module: "demoCLib1" >

    "
     Transcript showCR:(self demo1_7:123.456 _:234.567)
    "
!

demo1_8:struct1 _:int2
    <cdecl: int "demo1_function8" (struct, int) module: "demoCLib1" >
    "/ DLLEXPORT int
    "/ demo1_function8(struct testStruct s1, int i2)
!

demo1_9:structOut _:int1 _:int2 _:int3 _:int4 _:int5
    <cdecl: struct "demo1_function9" (struct, int, int, int, int, int) module: "demoCLib1" >
    "/ DLLEXPORT struct testStruct
    "/ demo1_function9(int i1, int i2, int i3, int i4, int i5)
!

demo2_1
    <cdecl: void "demo2_function1" (void) module: "demoCLib2" >

    "
     Transcript showCR:(self demo2_1)
    "
!

demo3_1
    <cdecl: void "demo3_function1" (void) module: "demoCLib3" >

    "
     Transcript showCR:(self demo3_1)
    "
!

dllPath
    |path|

    path := 'stx:doc/coding/cModules' asPackageId packageDirectory.
    path isNil ifTrue:[
	^ self error:'cannot find any c modules (cModules directory)'
    ].
    ^ { path }

    "
     Transcript showCR:(self demo1_1)
    "
!

inlineCallDemo1_8:s _:i
    |func addr|
    
    func := self getFunction:'demo1_function8' dll:'demoCLib1'.
    addr := func code.
%{
    struct str {
        int i1;
        int i2;
        int i3;
        int i4;
        int i5;
    } C_s;
    if (__isExternalBytes(s)) {
        if (__intVal(__externalBytesSize(s)) == sizeof(struct str)) {
            C_s = *(struct str *)(__externalBytesAddress(s));
            if (__isExternalAddressLike(addr)) {
                // typedef struct str (*structFUNC)();
                typedef int (*intFUNC)();
                int retVal;
                
                // structFUNC f = (structFUNC)__externalAddressVal(addr);
                intFUNC f = (intFUNC)__externalAddressVal(addr);
                retVal = (*f)(C_s, __intVal(i));
                RETURN(__MKSMALLINT(retVal));
            }    
        }
    }
%}.
    self primitiveFailed.

    "
     self callDemo_8b
    "
! !

!CModuleDemo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/cModules/CModuleDemo.st,v 1.10 2016-10-03 21:32:40 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/doc/coding/cModules/CModuleDemo.st,v 1.10 2016-10-03 21:32:40 cg Exp $'
! !


CModuleDemo initialize!
