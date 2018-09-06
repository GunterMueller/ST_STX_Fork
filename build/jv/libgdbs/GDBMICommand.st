"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'jv:libgdbs' }"

"{ NameSpace: Smalltalk }"

GDBCommand subclass:#GDBMICommand
	instanceVariableNames:'arguments'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core-Commands'
!

!GDBMICommand class methodsFor:'documentation'!

copyright
"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!GDBMICommand class methodsFor:'instance creation'!

arguments: anArray
    ^ self new arguments: anArray

    "Created: / 12-06-2014 / 01:10:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMICommand class methodsFor:'utilities'!

commands
    "A list if MI command recognized by GDB.
     Extracted from gdb sourcefile gdb/mi/mi-cmds.c

     See https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;a=blob;f=gdb/mi/mi-cmds.c

     "

    ^ #(
        'ada-task-info'
        'add-inferior'
        'break-after'
        'break-condition'
        'break-commands'
        'break-delete'
        'break-disable'
        'break-enable'
        'break-info'
        'break-insert'
        'dprintf-insert'
        'break-list'
        'break-passcount'
        'break-watch'
        'catch-assert'
        'catch-exception'
        'catch-load'
        'catch-unload'
        'data-disassemble'
        'data-evaluate-expression'
        'data-list-changed-registers'
        'data-list-register-names'
        'data-list-register-values'
        'data-read-memory'
        'data-read-memory-bytes'
        'data-write-memory'
        'data-write-memory-bytes'
        'data-write-register-values'
        'enable-timings'
        'enable-pretty-printing'
        'enable-frame-filters'
        'environment-cd'
        'environment-directory'
        'environment-path'
        'environment-pwd'
        'exec-arguments'
        'exec-continue'
        'exec-finish'
        'exec-jump'
        'exec-interrupt'
        'exec-next'
        'exec-next-instruction'
        'exec-return'
        'exec-run'
        'exec-step'
        'exec-step-instruction'
        'exec-until'
        'file-exec-and-symbols'
        'file-exec-file'
        'file-list-exec-source-file'
        'file-list-exec-source-files'
        'file-symbol-file'
        'gdb-exit'
        'gdb-set'
        'gdb-show'
        'gdb-version'
        'inferior-tty-set'
        'inferior-tty-show'
        'info-ada-exceptions'
        'info-gdb-mi-command'
        'info-os'
        'interpreter-exec'
        'list-features'
        'list-target-features'
        'list-thread-groups'
        'remove-inferior'
        'stack-info-depth'
        'stack-info-frame'
        'stack-list-arguments'
        'stack-list-frames'
        'stack-list-locals'
        'stack-list-variables'
        'stack-select-frame'
        'symbol-list-lines'
        'target-attach'
        'target-detach'
        'target-disconnect'
        'target-download'
        'target-file-delete'
        'target-file-get'
        'target-file-put'
        'target-select'
        'thread-info'
        'thread-list-ids'
        'thread-select'
        'trace-define-variable'
        'trace-find'
        'trace-frame-collected'
        'trace-list-variables'
        'trace-save'
        'trace-start'
        'trace-status'
        'trace-stop'
        'var-assign'
        'var-create'
        'var-delete'
        'var-evaluate-expression'
        'var-info-path-expression'
        'var-info-expression'
        'var-info-num-children'
        'var-info-type'
        'var-list-children'
        'var-set-format'
        'var-set-frozen'
        'var-set-update-range'
        'var-set-visualizer'
        'var-show-attributes'
        'var-show-format'
        'var-update'
    )

    "
    GDBMICommand commands do:[:command | 
        | commandClassName commandClass |

        commandClassName := ('GDBMI_' , (command copyReplaceAll: $- with: $_)) asSymbol.
        (Smalltalk at: commandClassName) isNil ifTrue:[ 
            GDBMICommand subclass: commandClassName
                instanceVariableNames:''
                classVariableNames:''
                poolDictionaries:''
                category:'GDB-Core-Commands-MI'  
        ].
        commandClass := (Smalltalk at: commandClassName).
        commandClass compile: (String streamContents:[ :s | s nextPutAll: 'operation'; cr; tab; nextPutAll: '^ '; nextPutAll: commnd storeString ].

    ].
    "

    "Created: / 12-06-2014 / 00:28:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generate
    self commands do:[:command | self generate: command ]

    "Created: / 12-06-2014 / 01:02:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generate: command
    | commandClassName commandClass commandDoc gdbDoc commandDocStartI commandDocEndI |

    gdbDoc := '/tmp/gdb-doc.txt' asFilename contents.    

    commandDocStartI := gdbDoc indexOf: 'The `-', command , ''' Command'.
    commandDocStartI ~~ 0 ifTrue:[ 
        | l |


        commandDocEndI := commandDocStartI + 1.
        l := gdbDoc at: commandDocEndI.
        [ commandDocEndI > gdbDoc size or:[ #('The `-' '27.' '28.') anySatisfy:[:e | l startsWith: e] ] ] whileFalse:[            
            commandDocEndI := commandDocEndI + 1.
            l := gdbDoc at: commandDocEndI.
        ].
        commandDoc := (gdbDoc copyFrom: commandDocStartI to: commandDocEndI - 1) asString.
        commandDoc replaceAll: $" with: $'.
    ].

    commandClassName := ('GDBMI_' , (command copyReplaceAll: $- with: $_)) asSymbol.
    (Smalltalk at: commandClassName) isNil ifTrue:[ 
        GDBMICommand subclass: commandClassName
            instanceVariableNames:''
            classVariableNames:''
            poolDictionaries:''
            category:'GDB-Core-Commands-MI'  
    ].
    commandClass := (Smalltalk at: commandClassName).
    commandClass compile: (String streamContents:[ :s | s nextPutAll: 'operation'; cr; tab; nextPutAll: '^ '; nextPutAll: command storeString ]) classified: 'accessing'.

    commandDoc notNil ifTrue:[ 
        commandClass class compile:(String streamContents:[ :s| s nextPutAll: 'documentation'; cr; nextPut: $"; cr; nextPutAll: commandDoc; cr; nextPut: $" ]) classified: 'documentation'.
    ].


"
    GDBMICommand generate: 'file-exec-and-symbols'
    GDBMICommand generate
"

    "Created: / 12-06-2014 / 00:56:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMICommand methodsFor:'accessing'!

arguments
    ^ arguments
!

arguments:aCollection
    self assert: (aCollection isSequenceable and:[ aCollection isString not ]).
    arguments := aCollection.

    "Modified: / 15-01-2018 / 22:58:37 / jv"
!

operation   
    ^ self subclassResponsibility

    "Created: / 09-06-2014 / 18:40:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-06-2014 / 00:43:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMICommand methodsFor:'testing'!

isMICommand
    ^ true
! !

