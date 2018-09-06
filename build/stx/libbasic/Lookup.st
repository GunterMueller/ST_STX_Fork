"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
 COPYRIGHT (c) 2010 Jan Vrany
	      All Rights Reserved

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

Object subclass:#Lookup
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Extensions'
!

!Lookup class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
 COPYRIGHT (c) 2010 Jan Vrany
	      All Rights Reserved

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
! !

!Lookup class methodsFor:'initialization'!

initialize
    "/ do we really need this?
    "/ i.e. my own messages can be resolved by the VM - can't they ?

    "/ self lookupObject: Lookup builtin

    "Created: / 26-04-2010 / 21:15:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Lookup class methodsFor:'accessing'!

builtin
    ^BuiltinLookup instance

    "Created: / 26-04-2010 / 19:26:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Lookup methodsFor:'lookup'!

lookupMethodForSelector: selector directedTo: initialSearchClass
    |cls md method|

    "Following C code is just a performance optimization.
     It is not necessary, however it speeds up UI code,
     since it heavily uses perform:"
%{
    RETURN (  __lookup(initialSearchClass, selector) );
%}.

    cls := initialSearchClass.
    [ cls notNil ] whileTrue:[
       md := cls methodDictionary.
       method := md at:selector ifAbsent:nil.
       method notNil ifTrue:[^ method ].
       cls := cls superclass.
    ].
    ^ nil

    "Created: / 27-04-2010 / 15:30:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lookupMethodForSelector:selector directedTo:initialSearchClass for:aReceiver withArguments:argArrayOrNil from:sendingContext
    <resource: #obsolete>

    "
     This method is no longer sent by the VM as it nows pass
     inline/poly cache object.
    "

    "invoked by the VM to ask me for a method to call.
     The arguments are: the selector, receiver and arguments,
     the class to start the search in (for here-, super and directed sends)
     the sending context.

     The returned method object will be put into the inline- and polyCache
     at the call site; it might therefore be called more than once for the
     same receiver-class/selector combination (once for each call site).
     If I return nil, a doesNotUnderstand will be invoked."

     |cls md method|

    "Following C code is just a performance optimization.
     It is not necessary, however it speeds up UI code,
     since it heavily uses perform:"
%{
    RETURN (  __lookup(initialSearchClass, selector) );
%}.
    ^ self lookupMethodForSelector: selector
                   directedTo: initialSearchClass
!

lookupMethodForSelector:selector directedTo:initialSearchClass for:aReceiver withArguments:argArrayOrNil from:sendingContext ilc: ilcCache
    "Invoked by the VM to ask me for a method to call.
     The arguments are: the selector, receiver and arguments,
     the class to start the search in (for here-, super and directed sends)
     the sending context and the inline/poly cache (instance of
         PolymorphicInlineCache).

     The returned method object will NOT be put into the inline- and
         polyCache bu default. To update the call site's cache, you have to
         call ilcCache bindTo: method forClass: initialSearch class. If you
         don't call it, inline/poly cache won't be updated and next call
         won't be cached (therefore it will be relatively slow.

     If I return nil, a doesNotUnderstand: will be send."

    | method |

    "Following C code is just a performance optimization.
     It is not necessary, however it speeds up UI code,
     since it heavily uses perform:"
%{
    method = __lookup(initialSearchClass, selector);
    if ( method ) {
        __ilcBind(ilcCache, initialSearchClass, method, selector);
    }
    RETURN (method);
%}.

    method := self lookupMethodForSelector:selector directedTo:initialSearchClass for:aReceiver withArguments:argArrayOrNil from:sendingContext.
    ilcCache notNil ifTrue:[
        ilcCache bindTo: method forClass: initialSearchClass.
    ].
    ^ method.

    "Created: / 01-10-2011 / 13:18:40 / Jan Kurs <kursjan@fit.cvut.cz>"
! !

!Lookup class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !


Lookup initialize!
