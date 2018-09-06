"
 COPYRIGHT (c) 2011 by Jan Vrany & Jan Kurs
		       SWING Research Group, Czech Technical University in Prague

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Object subclass:#PolymorphicInlineCache
	instanceVariableNames:'address numArgs'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Classes'
!

!PolymorphicInlineCache class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2011 by Jan Vrany & Jan Kurs
		       SWING Research Group, Czech Technical University in Prague

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.

"
!

documentation
"
    This class provides a basic access to inline cache structure as
    used by the virtual machine.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>
        Janb Kurs <kursjan@fit.cvut.cz>

    [instance variables:]
        address     <ExternalAddress> a pointer to the VM inline cache structure.
                                    if the address is NULL, then PolymorphicInlineCache
                                    is invalid.
        numArgs    <SmallInteger> a number of arguments
    [class variables:]

    [see also:]

"
! !

!PolymorphicInlineCache methodsFor:'binding / unbinding'!

bindTo: aMethod forClass: aClass
    | selector |

    selector := aMethod selector.
%{
    __ilcBind(self, aClass, aMethod,  selector);
    RETURN(self);
%}.
    self primitiveFailed.

    "Created: / 02-10-2011 / 18:05:26 / Jan Kurs <kursjan@fit.cvut.cz>"
! !

!PolymorphicInlineCache class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

