"
Copyright (c) 2017 Jan Vrany

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MeERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Object subclass:#TTYAttributes
	instanceVariableNames:'c_iflag c_oflag c_cflag c_lflag c_cc'
	classVariableNames:''
	poolDictionaries:''
	category:'OS-Unix'
!

!TTYAttributes class methodsFor:'documentation'!

copyright
"
Copyright (c) 2017 Jan Vrany

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MeERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

"
! !

!TTYAttributes methodsFor:'accessing'!

c_cc
    ^ c_cc
!

c_cc:something
    c_cc := something.
!

c_cflag
    ^ c_cflag
!

c_cflag:something
    c_cflag := something.
!

c_iflag
    ^ c_iflag
!

c_iflag:something
    c_iflag := something.
!

c_lflag
    ^ c_lflag
!

c_lflag:something
    c_lflag := something.
!

c_oflag
    ^ c_oflag
!

c_oflag:something
    c_oflag := something.
! !

!TTYAttributes methodsFor:'debugging'!

inspectorExtraAttributes
    | printer |

    printer := [ :flag :flags |
        | first |

        first := true.
        String streamContents:[ :s |
            flags do:[:each | 
                | eachVal |

                eachVal := TTYConstants classVarNamed: each.
                (eachVal notNil and:[(flag bitAnd: eachVal) ~~ 0]) ifTrue:[ 
                    first ifTrue:[ 
                        first := false
                    ] ifFalse:[ 
                        s nextPutAll: ' | '.
                    ].
                    s nextPutAll: each.
                ].
            ].
        ].
    ].
    ^ super inspectorExtraAttributes
        at: '-c_iflag'put: [ printer value: c_iflag value: #(BRKINT ICRNL IGNBRK IGNCR IGNPAR INLCR INPCK ISTRIP IXANY IXOFF IXON PARMRK)];
        at: '-c_oflag'put: [ printer value: c_oflag value: #(OPOST ONLCR OCRNL ONOCR ONLRET OFILL NLDLY CRDLY TABDLY BSDLY VTDLY FFDLY )];
        at: '-c_cflag'put: [ printer value: c_cflag value: #(CSIZE CSTOPB CREAD PARENB PARODD HUPCL CLOCAL)];
        at: '-c_lflag'put: [ printer value: c_lflag value: #(ECHO ECHOE ECHOK ECHONL ICANON IEXTEN ISIG NOFLSH TOSTOP ) ];
        yourself

    "
    OperatingSystem getTerminalAttributes: (Stdout fileDescriptor).
    "

    "Created: / 30-05-2017 / 15:51:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-05-2017 / 20:28:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TTYAttributes class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

