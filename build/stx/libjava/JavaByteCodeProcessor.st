"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava' }"

"{ NameSpace: Smalltalk }"

Object subclass:#JavaByteCodeProcessor
	instanceVariableNames:'byteCode pc method constantPool context receiver sp retVal
		instrPointer op wide numArgs numVars leaveProcessor'
	classVariableNames:'OpSwitchTable Verbose'
	poolDictionaries:''
	category:'Languages-Java-Bytecode'
!

!JavaByteCodeProcessor class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
!

documentation
"
    Basic class to process Java bytecode. Subclasses must implement
    all callback methods that handle individual instructions.

    Subclass `JavaByteCodeProcessorAdaptor` if you want to so somethinf
    special for some instructions and don't need to bother with rest
    of them.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        JavaByteCodeProcessorAdaptor

    [see also:]
        JavaByteCodeProcessorAdaptor


"
! !

!JavaByteCodeProcessor class methodsFor:'initialization'!

initialize
    OpSwitchTable := Array new: 256.
    OpSwitchTable at: 1 + 0 put: #nop.
    OpSwitchTable at: 1 + 1 put: #'aconst_null'.
    OpSwitchTable at: 1 + 2 put: #'iconst_m1'.
    OpSwitchTable at: 1 + 3 put: #'iconst_0'.
    OpSwitchTable at: 1 + 4 put: #'iconst_1'.
    OpSwitchTable at: 1 + 5 put: #'iconst_2'.
    OpSwitchTable at: 1 + 6 put: #'iconst_3'.
    OpSwitchTable at: 1 + 7 put: #'iconst_4'.
    OpSwitchTable at: 1 + 8 put: #'iconst_5'.
    OpSwitchTable at: 1 + 9 put: #'lconst_0'.
    OpSwitchTable at: 1 + 10 put: #'lconst_1'.
    OpSwitchTable at: 1 + 11 put: #'fconst_0'.
    OpSwitchTable at: 1 + 12 put: #'fconst_1'.
    OpSwitchTable at: 1 + 13 put: #'fconst_2'.
    OpSwitchTable at: 1 + 14 put: #'dconst_0'.
    OpSwitchTable at: 1 + 15 put: #'dconst_1'.
    OpSwitchTable at: 1 + 16 put: #bipush.
    OpSwitchTable at: 1 + 17 put: #sipush.
    OpSwitchTable at: 1 + 18 put: #ldc1.
    OpSwitchTable at: 1 + 19 put: #ldc2.
    OpSwitchTable at: 1 + 20 put: #ldc2w.
    OpSwitchTable at: 1 + 21 put: #iload.
    OpSwitchTable at: 1 + 22 put: #lload.
    OpSwitchTable at: 1 + 23 put: #fload.
    OpSwitchTable at: 1 + 24 put: #dload.
    OpSwitchTable at: 1 + 25 put: #aload.
    OpSwitchTable at: 1 + 26 put: #'iload_0'.
    OpSwitchTable at: 1 + 27 put: #'iload_1'.
    OpSwitchTable at: 1 + 28 put: #'iload_2'.
    OpSwitchTable at: 1 + 29 put: #'iload_3'.
    OpSwitchTable at: 1 + 30 put: #'lload_0'.
    OpSwitchTable at: 1 + 31 put: #'lload_1'.
    OpSwitchTable at: 1 + 32 put: #'lload_2'.
    OpSwitchTable at: 1 + 33 put: #'lload_3'.
    OpSwitchTable at: 1 + 34 put: #'fload_0'.
    OpSwitchTable at: 1 + 35 put: #'fload_1'.
    OpSwitchTable at: 1 + 36 put: #'fload_2'.
    OpSwitchTable at: 1 + 37 put: #'fload_3'.
    OpSwitchTable at: 1 + 38 put: #'dload_0'.
    OpSwitchTable at: 1 + 39 put: #'dload_1'.
    OpSwitchTable at: 1 + 40 put: #'dload_2'.
    OpSwitchTable at: 1 + 41 put: #'dload_3'.
    OpSwitchTable at: 1 + 42 put: #'aload_0'.
    OpSwitchTable at: 1 + 43 put: #'aload_1'.
    OpSwitchTable at: 1 + 44 put: #'aload_2'.
    OpSwitchTable at: 1 + 45 put: #'aload_3'.
    OpSwitchTable at: 1 + 46 put: #iaload.
    OpSwitchTable at: 1 + 47 put: #laload.
    OpSwitchTable at: 1 + 48 put: #faload.
    OpSwitchTable at: 1 + 49 put: #daload.
    OpSwitchTable at: 1 + 50 put: #aaload.
    OpSwitchTable at: 1 + 51 put: #baload.
    OpSwitchTable at: 1 + 52 put: #caload.
    OpSwitchTable at: 1 + 53 put: #saload.
    OpSwitchTable at: 1 + 54 put: #istore.
    OpSwitchTable at: 1 + 55 put: #lstore.
    OpSwitchTable at: 1 + 56 put: #fstore.
    OpSwitchTable at: 1 + 57 put: #dstore.
    OpSwitchTable at: 1 + 58 put: #astore.
    OpSwitchTable at: 1 + 59 put: #'istore_0'.
    OpSwitchTable at: 1 + 60 put: #'istore_1'.
    OpSwitchTable at: 1 + 61 put: #'istore_2'.
    OpSwitchTable at: 1 + 62 put: #'istore_3'.
    OpSwitchTable at: 1 + 63 put: #'lstore_0'.
    OpSwitchTable at: 1 + 64 put: #'lstore_1'.
    OpSwitchTable at: 1 + 65 put: #'lstore_2'.
    OpSwitchTable at: 1 + 66 put: #'lstore_3'.
    OpSwitchTable at: 1 + 67 put: #'fstore_0'.
    OpSwitchTable at: 1 + 68 put: #'fstore_1'.
    OpSwitchTable at: 1 + 69 put: #'fstore_2'.
    OpSwitchTable at: 1 + 70 put: #'fstore_3'.
    OpSwitchTable at: 1 + 71 put: #'dstore_0'.
    OpSwitchTable at: 1 + 72 put: #'dstore_1'.
    OpSwitchTable at: 1 + 73 put: #'dstore_2'.
    OpSwitchTable at: 1 + 74 put: #'dstore_3'.
    OpSwitchTable at: 1 + 75 put: #'astore_0'.
    OpSwitchTable at: 1 + 76 put: #'astore_1'.
    OpSwitchTable at: 1 + 77 put: #'astore_2'.
    OpSwitchTable at: 1 + 78 put: #'astore_3'.
    OpSwitchTable at: 1 + 79 put: #iastore.
    OpSwitchTable at: 1 + 80 put: #lastore.
    OpSwitchTable at: 1 + 81 put: #fastore.
    OpSwitchTable at: 1 + 82 put: #dastore.
    OpSwitchTable at: 1 + 83 put: #aastore.
    OpSwitchTable at: 1 + 84 put: #bastore.
    OpSwitchTable at: 1 + 85 put: #castore.
    OpSwitchTable at: 1 + 86 put: #sastore.
    OpSwitchTable at: 1 + 87 put: #pop1.
    OpSwitchTable at: 1 + 88 put: #pop2.
    OpSwitchTable at: 1 + 89 put: #dup.
    OpSwitchTable at: 1 + 90 put: #'dup_x1'.
    OpSwitchTable at: 1 + 91 put: #'dup_x2'.
    OpSwitchTable at: 1 + 92 put: #dup2.
    OpSwitchTable at: 1 + 93 put: #'dup2_x1'.
    OpSwitchTable at: 1 + 94 put: #'dup2_x2'.
    OpSwitchTable at: 1 + 95 put: #swap.
    OpSwitchTable at: 1 + 96 put: #iadd.
    OpSwitchTable at: 1 + 97 put: #ladd.
    OpSwitchTable at: 1 + 98 put: #fadd.
    OpSwitchTable at: 1 + 99 put: #dadd.
    OpSwitchTable at: 1 + 100 put: #isub.
    OpSwitchTable at: 1 + 101 put: #lsub.
    OpSwitchTable at: 1 + 102 put: #fsub.
    OpSwitchTable at: 1 + 103 put: #dsub.
    OpSwitchTable at: 1 + 104 put: #imul.
    OpSwitchTable at: 1 + 105 put: #lmul.
    OpSwitchTable at: 1 + 106 put: #fmul.
    OpSwitchTable at: 1 + 107 put: #dmul.
    OpSwitchTable at: 1 + 108 put: #idiv.
    OpSwitchTable at: 1 + 109 put: #ldiv.
    OpSwitchTable at: 1 + 110 put: #fdiv.
    OpSwitchTable at: 1 + 111 put: #ddiv.
    OpSwitchTable at: 1 + 112 put: #irem.
    OpSwitchTable at: 1 + 113 put: #lrem.
    OpSwitchTable at: 1 + 114 put: #frem.
    OpSwitchTable at: 1 + 115 put: #drem.
    OpSwitchTable at: 1 + 116 put: #ineg.
    OpSwitchTable at: 1 + 117 put: #lneg.
    OpSwitchTable at: 1 + 118 put: #fneg.
    OpSwitchTable at: 1 + 119 put: #dneg.
    OpSwitchTable at: 1 + 120 put: #ishl.
    OpSwitchTable at: 1 + 121 put: #lshl.
    OpSwitchTable at: 1 + 122 put: #ishr.
    OpSwitchTable at: 1 + 123 put: #lshr.
    OpSwitchTable at: 1 + 124 put: #iushr.
    OpSwitchTable at: 1 + 125 put: #lushr.
    OpSwitchTable at: 1 + 126 put: #iand.
    OpSwitchTable at: 1 + 127 put: #land.
    OpSwitchTable at: 1 + 128 put: #ior.
    OpSwitchTable at: 1 + 129 put: #lor.
    OpSwitchTable at: 1 + 130 put: #ixor.
    OpSwitchTable at: 1 + 131 put: #lxor.
    OpSwitchTable at: 1 + 132 put: #iinc.
    OpSwitchTable at: 1 + 133 put: #i2l.
    OpSwitchTable at: 1 + 134 put: #i2f.
    OpSwitchTable at: 1 + 135 put: #i2d.
    OpSwitchTable at: 1 + 136 put: #l2i.
    OpSwitchTable at: 1 + 137 put: #l2f.
    OpSwitchTable at: 1 + 138 put: #l2d.
    OpSwitchTable at: 1 + 139 put: #f2i.
    OpSwitchTable at: 1 + 140 put: #f2l.
    OpSwitchTable at: 1 + 141 put: #f2d.
    OpSwitchTable at: 1 + 142 put: #d2i.
    OpSwitchTable at: 1 + 143 put: #d2l.
    OpSwitchTable at: 1 + 144 put: #d2f.
    OpSwitchTable at: 1 + 145 put: #int2byte.
    OpSwitchTable at: 1 + 146 put: #int2char.
    OpSwitchTable at: 1 + 147 put: #int2short.
    OpSwitchTable at: 1 + 148 put: #lcmp.
    OpSwitchTable at: 1 + 149 put: #fcmpl.
    OpSwitchTable at: 1 + 150 put: #fcmpg.
    OpSwitchTable at: 1 + 151 put: #dcmpl.
    OpSwitchTable at: 1 + 152 put: #dcmpg.
    OpSwitchTable at: 1 + 153 put: #ifeq.
    OpSwitchTable at: 1 + 154 put: #ifne.
    OpSwitchTable at: 1 + 155 put: #iflt.
    OpSwitchTable at: 1 + 156 put: #ifge.
    OpSwitchTable at: 1 + 157 put: #ifgt.
    OpSwitchTable at: 1 + 158 put: #ifle.
    OpSwitchTable at: 1 + 159 put: #ificmpeq.
    OpSwitchTable at: 1 + 160 put: #ificmpne.
    OpSwitchTable at: 1 + 161 put: #ificmplt.
    OpSwitchTable at: 1 + 162 put: #ificmpge.
    OpSwitchTable at: 1 + 163 put: #ificmpgt.
    OpSwitchTable at: 1 + 164 put: #ificmple.
    OpSwitchTable at: 1 + 165 put: #ifacmpeq.
    OpSwitchTable at: 1 + 166 put: #ifacmpne.
    OpSwitchTable at: 1 + 167 put: #goto.
    OpSwitchTable at: 1 + 168 put: #jsr.
    OpSwitchTable at: 1 + 169 put: #ret.
    OpSwitchTable at: 1 + 170 put: #tableswtch.
    OpSwitchTable at: 1 + 171 put: #lookupswtch.
    OpSwitchTable at: 1 + 172 put: #ireturn.
    OpSwitchTable at: 1 + 173 put: #lreturn.
    OpSwitchTable at: 1 + 174 put: #freturn.
    OpSwitchTable at: 1 + 175 put: #dreturn.
    OpSwitchTable at: 1 + 176 put: #areturn.
    OpSwitchTable at: 1 + 177 put: #return.
    OpSwitchTable at: 1 + 178 put: #getstatic.
    OpSwitchTable at: 1 + 179 put: #putstatic.
    OpSwitchTable at: 1 + 180 put: #getfield.
    OpSwitchTable at: 1 + 181 put: #putfield.
    OpSwitchTable at: 1 + 182 put: #invvirt.
    OpSwitchTable at: 1 + 183 put: #invnonvirt.
    OpSwitchTable at: 1 + 184 put: #invstatic.
    OpSwitchTable at: 1 + 185 put: #invinterface.
    OpSwitchTable at: 1 + 186 put: #invdynamic.    
    OpSwitchTable at: 1 + 187 put: #new.
    OpSwitchTable at: 1 + 188 put: #newarray.
    OpSwitchTable at: 1 + 189 put: #anewarray.
    OpSwitchTable at: 1 + 190 put: #arraylength.
    OpSwitchTable at: 1 + 191 put: #athrow.
    OpSwitchTable at: 1 + 192 put: #checkcast.
    OpSwitchTable at: 1 + 193 put: #instanceof.
    OpSwitchTable at: 1 + 194 put: #monenter.
    OpSwitchTable at: 1 + 195 put: #monexit.
    OpSwitchTable at: 1 + 196 put: #wide.
    OpSwitchTable at: 1 + 197 put: #multianewarray.
    OpSwitchTable at: 1 + 198 put: #ifnull.
    OpSwitchTable at: 1 + 199 put: #ifnonnull.
    OpSwitchTable at: 1 + 200 put: #'goto_w'.
    OpSwitchTable at: 1 + 201 put: #'jsr_w'.
    OpSwitchTable at: 1 + 202 put: #breakpoint.
    OpSwitchTable at: 1 + 203 put: #'ret_w'.

    Verbose := false.
    "
     self initialize"

    "Created: / 17-03-2011 / 14:56:13 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 17-03-2011 / 16:43:17 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 25-02-2015 / 19:35:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaByteCodeProcessor class methodsFor:'accessing'!

verbose: bool
Verbose := bool.

    "Created: / 21-03-2011 / 18:32:37 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaByteCodeProcessor class methodsFor:'private-logging'!

log: aString 
    Verbose ifTrue: [
        Logger log: aString severity: Logger severityDEBUG facility: #JVM
    ]

    "Created: / 17-03-2011 / 14:59:24 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaByteCodeProcessor methodsFor:'initialization'!

reset
    pc := method startPC.
    byteCode := method byteCode.
    constantPool := method javaClass constantPool.

    "Modified: / 17-03-2011 / 14:53:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaByteCodeProcessor methodsFor:'instructions'!

aaload
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

aastore
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

aconst_null
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

aload
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 15:07:27 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

aload: arg 
    "
     Load reference from local variable 0
     nothing -> objectRef"
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility
 "
     Description
     The <n> must be an index into the local variable array of the
     current frame (3.6). The local variable at <n> must contain a
     reference. The objectref in the local variable at index is pushed
     onto the operand stack.

     Notes
     An aload_<n> instruction cannot be used to load a value of type
     returnAddress from a local variable onto the operand stack. This
     asymmetry with the corresponding astore_<n> instruction is intentional.
     Each of the aload_<n> instructions is the same as aload with an index
     of <n>, except that the operand <n> is implicit."

    "Modified: / 17-03-2011 / 15:26:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

aload_0
    "
     Load reference from local variable 0
     nothing -> objectRef"
    
    self aload: 0.

    "
     Description
     The <n> must be an index into the local variable array of the
     current frame (3.6). The local variable at <n> must contain a
     reference. The objectref in the local variable at index is pushed
     onto the operand stack.

     Notes
     An aload_<n> instruction cannot be used to load a value of type
     returnAddress from a local variable onto the operand stack. This
     asymmetry with the corresponding astore_<n> instruction is intentional.
     Each of the aload_<n> instructions is the same as aload with an index
     of <n>, except that the operand <n> is implicit."

    "Created: / 10-03-2011 / 21:42:22 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-03-2011 / 16:56:04 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

aload_1
    self aload: 1.

    "Created: / 10-03-2011 / 21:42:27 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-03-2011 / 16:56:20 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

aload_2
    self aload: 2.

    "Created: / 10-03-2011 / 21:42:31 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-03-2011 / 16:56:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

aload_3
    self aload: 3.

    "Created: / 10-03-2011 / 21:43:07 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-03-2011 / 16:56:24 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

anewarray
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:57:13 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

areturn
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

arraylength
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

astore
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:37:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

astore:arg
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

astore_0
    
    
    ^self astore: 0.

    "Created: / 17-03-2011 / 16:39:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

astore_1
    ^ self astore: 1.

    "Created: / 17-03-2011 / 16:39:10 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

astore_2
    ^ self astore: 2.

    "Created: / 17-03-2011 / 16:39:13 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

astore_3
    ^ self astore: 3.

    "Created: / 17-03-2011 / 16:39:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

athrow
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:57:25 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

baload
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

bastore
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

bipush
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

breakpoint
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:59:04 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

caload
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

castore
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

checkcast
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:57:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

d2f
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:50:50 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

d2i
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:50:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

d2l
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:50:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dadd
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

daload
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

dastore
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

dcmpg
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:52:17 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dcmpl
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:52:11 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dconst: arg 
    "Push the double constant <d> (0.0 or 1.0) onto the operand stack.
     stack: nothing -> const
     args: nothing"
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Modified: / 17-03-2011 / 15:27:29 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dconst_0
"
Push the double constant <d> (0.0 or 1.0) onto the operand stack.
stack: nothing -> const
args: nothing
"
    self dconst: 0.

    "Created: / 14-03-2011 / 18:02:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dconst_1
    "
     Push the double constant <d> (0.0 or 1.0) onto the operand stack.
     stack: nothing -> const
     args: nothing"
    
    self dconst: 1.

    "Created: / 14-03-2011 / 18:03:26 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ddiv
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:46:25 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dload
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 15:07:14 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dload: arg 
    "
     Load double from local variable
     stack: nothing -> value
     args: nothing"
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility
   "
     Description
     Both <n> and <n> + 1 must be indices into the local variable array of the current frame (3.6).
     The local variable at <n> must contain a double. The value of the local variable at <n> is pushed
     onto the operand stack.

     Notes
     Each of the dload_<n> instructions is the same as dload with an index of <n>, except that the
     operand <n> is implicit."

    "Modified: / 17-03-2011 / 15:26:26 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dload_0
    "
     Load double from local variable
     stack: nothing -> value
     args: nothing"
    
    self dload: 0.

    "
     Description
     Both <n> and <n> + 1 must be indices into the local variable array of the current frame (3.6).
     The local variable at <n> must contain a double. The value of the local variable at <n> is pushed
     onto the operand stack.

     Notes
     Each of the dload_<n> instructions is the same as dload with an index of <n>, except that the
     operand <n> is implicit."

    "Created: / 13-03-2011 / 17:55:29 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dload_1
    self dload: 1.

    "Created: / 13-03-2011 / 17:55:33 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dload_2
    self dload: 2.

    "Created: / 13-03-2011 / 17:55:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dload_3
    self dload: 3.

    "Created: / 13-03-2011 / 17:55:45 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dmul
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:46:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dneg
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:47:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

drem
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:47:05 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dreturn
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

dstore
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

dstore: arg 
    "
     Store double into local variable
     stack: value -> nothing
     args: nothing"
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility
"
     Description
     Both <n> and <n> + 1 must be indices into the local variable array of the
     current frame (3.6). The value on the top of the operand stack must be of
     type double. It is popped from the operand stack and undergoes value set
     conversion (3.8.3), resulting in value'. The local variables at <n> and
     <n> + 1 are set to value'.

     Notes
     Each of the dstore_<n> instructions is the same as dstore with an index
     of <n>, except that the operand <n> is implicit."

    "Modified: / 17-03-2011 / 15:28:07 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dstore_0
    "
     Store double into local variable
     stack: value -> nothing
     args: nothing"
    
    self dstore: 0.

    "
     Description
     Both <n> and <n> + 1 must be indices into the local variable array of the
     current frame (3.6). The value on the top of the operand stack must be of
     type double. It is popped from the operand stack and undergoes value set
     conversion (3.8.3), resulting in value'. The local variables at <n> and
     <n> + 1 are set to value'.

     Notes
     Each of the dstore_<n> instructions is the same as dstore with an index
     of <n>, except that the operand <n> is implicit."

    "Created: / 14-03-2011 / 19:04:44 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dstore_1
"
Store double into local variable
stack: value -> nothing
args: nothing
" 

self dstore: 1.
"
Description
Both <n> and <n> + 1 must be indices into the local variable array of the 
current frame (3.6). The value on the top of the operand stack must be of 
type double. It is popped from the operand stack and undergoes value set 
conversion (3.8.3), resulting in value'. The local variables at <n> and 
<n> + 1 are set to value'.

Notes
Each of the dstore_<n> instructions is the same as dstore with an index 
of <n>, except that the operand <n> is implicit.
"

    "Created: / 14-03-2011 / 19:04:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dstore_2
    "
     Store double into local variable
     stack: value -> nothing
     args: nothing"
    
    self dstore: 2.

    "
     Description
     Both <n> and <n> + 1 must be indices into the local variable array of the
     current frame (3.6). The value on the top of the operand stack must be of
     type double. It is popped from the operand stack and undergoes value set
     conversion (3.8.3), resulting in value'. The local variables at <n> and
     <n> + 1 are set to value'.

     Notes
     Each of the dstore_<n> instructions is the same as dstore with an index
     of <n>, except that the operand <n> is implicit."

    "Created: / 14-03-2011 / 19:04:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dstore_3
    "
     Store double into local variable
     stack: value -> nothing
     args: nothing"
    
    self dstore: 3.

    "
     Description
     Both <n> and <n> + 1 must be indices into the local variable array of the
     current frame (3.6). The value on the top of the operand stack must be of
     type double. It is popped from the operand stack and undergoes value set
     conversion (3.8.3), resulting in value'. The local variables at <n> and
     <n> + 1 are set to value'.

     Notes
     Each of the dstore_<n> instructions is the same as dstore with an index
     of <n>, except that the operand <n> is implicit."

    "Created: / 14-03-2011 / 19:04:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dsub
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:45:33 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dup
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:44:08 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

dup2
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

dup2_x1
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

dup2_x2
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

dup_x1
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

dup_x2
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

f2d
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:50:35 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

f2i
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:50:26 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

f2l
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:50:31 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fadd
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:44:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

faload
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

fastore
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

fcmpg
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:52:00 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fcmpl
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:51:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fconst: arg 
    "
     Push float constant
     stack: nothing -> const
     arg: nothing"
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility.
    "
     Description
         Push the float constant <f> (0.0, 1.0, or 2.0) onto the operand stack."

    "Modified: / 17-03-2011 / 15:28:47 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fconst_0
    "
     Push float constant
     stack: nothing -> const
     arg: nothing"
    
    self fconst: 0.

    "
     Description
     Push the float constant <f> (0.0, 1.0, or 2.0) onto the operand stack."

    "Created: / 14-03-2011 / 17:56:55 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fconst_1
    "
     Push float constant
     stack: nothing -> const
     arg: nothing"
    
    self fconst: 1.

    "
     Description
     Push the float constant <f> (0.0, 1.0, or 2.0) onto the operand stack."

    "Created: / 14-03-2011 / 17:57:50 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fconst_2
    "
     Push float constant
     stack: nothing -> const
     arg: nothing"
    
    self fconst: 2.

    "
     Description
     Push the float constant <f> (0.0, 1.0, or 2.0) onto the operand stack."

    "Created: / 14-03-2011 / 17:57:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fdiv
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:46:20 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fload 
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 15:07:02 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fload:arg
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

fload_0
    ^ self fload: 0.

    "Created: / 17-03-2011 / 16:34:59 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fload_1
    ^ self fload: 1.

    "Created: / 17-03-2011 / 16:35:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fload_2
    ^ self fload: 2.

    "Created: / 17-03-2011 / 16:35:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fload_3
    ^ self fload: 3.

    "Created: / 17-03-2011 / 16:35:11 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fmul
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:45:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fneg
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:47:40 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

frem
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:46:47 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

freturn
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:55:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fstore
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

fstore: arg 
    "
     Store float into local variable
     stack: value -> nothing
         args: index"
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility
    "
     Description
     The index is an unsigned byte that must be an index into the local
     variable array of the current frame (3.6). The value on the top of
     the operand stack must be of type float. It is popped from the operand
     stack and undergoes value set conversion (3.8.3), resulting in value'.
     The value of the local variable at index is set to value'.

     Notes
     The fstore opcode can be used in conjunction with the wide instruction
         to access a local variable using a two-byte unsigned index."

    "Modified: / 17-03-2011 / 15:29:22 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fstore_0 
    "
     Store float into local variable
     stack: value -> nothing
     args: index"
    
    self fstore: 0.

    "
     Description
     The index is an unsigned byte that must be an index into the local
     variable array of the current frame (3.6). The value on the top of
     the operand stack must be of type float. It is popped from the operand
     stack and undergoes value set conversion (3.8.3), resulting in value'.
     The value of the local variable at index is set to value'.

     Notes
     The fstore opcode can be used in conjunction with the wide instruction
     to access a local variable using a two-byte unsigned index."

    "Created: / 14-03-2011 / 17:59:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fstore_1
    "
     Store float into local variable
     stack: value -> nothing
     args: index"
    
    self fstore: 1.

    "
     Description
     The index is an unsigned byte that must be an index into the local
     variable array of the current frame (3.6). The value on the top of
     the operand stack must be of type float. It is popped from the operand
     stack and undergoes value set conversion (3.8.3), resulting in value'.
     The value of the local variable at index is set to value'.

     Notes
     The fstore opcode can be used in conjunction with the wide instruction
     to access a local variable using a two-byte unsigned index."

    "Created: / 14-03-2011 / 17:59:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fstore_2
    "
     Store float into local variable
     stack: value -> nothing
     args: index"
    
    self fstore: 2.

    "
     Description
     The index is an unsigned byte that must be an index into the local
     variable array of the current frame (3.6). The value on the top of
     the operand stack must be of type float. It is popped from the operand
     stack and undergoes value set conversion (3.8.3), resulting in value'.
     The value of the local variable at index is set to value'.

     Notes
     The fstore opcode can be used in conjunction with the wide instruction
     to access a local variable using a two-byte unsigned index."

    "Created: / 14-03-2011 / 18:00:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fstore_3
    "
     Store float into local variable
     stack: value -> nothing
     args: index"
    
    self fstore: 3.

    "
     Description
     The index is an unsigned byte that must be an index into the local
     variable array of the current frame (3.6). The value on the top of
     the operand stack must be of type float. It is popped from the operand
     stack and undergoes value set conversion (3.8.3), resulting in value'.
     The value of the local variable at index is set to value'.

     Notes
     The fstore opcode can be used in conjunction with the wide instruction
     to access a local variable using a two-byte unsigned index."

    "Created: / 14-03-2011 / 18:00:08 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fsub
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:45:29 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

getfield
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

getstatic
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:55:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

goto
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

goto_w
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:58:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

i2d
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:50:02 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

i2f
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:49:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

i2l
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:49:52 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

i_dup
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

iadd
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

iaload
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

iand
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

iastore
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

iconst: arg 
    "
     Push int constant
     stack: nothing -> const
     arg: nothing"
    
    self subclassResponsibility.

    "
     Description
     Push the int constant <i> (-1, 0, 1, 2, 3, 4 or 5) onto the operand stack.

     Notes
     Each of this family of instructions is equivalent to bipush <i> for the
     respective value of <i>, except that the operand <i> is implicit."

    "Created: / 17-03-2011 / 15:29:48 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-03-2011 / 20:41:04 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iconst_0
    "
     Push int constant
     stack: nothing -> const
     arg: nothing"
    
    self iconst: 0.

    "
     Description
     Push the int constant <i> (-1, 0, 1, 2, 3, 4 or 5) onto the operand stack.

     Notes
     Each of this family of instructions is equivalent to bipush <i> for the
     respective value of <i>, except that the operand <i> is implicit."

    "Modified: / 17-03-2011 / 15:30:00 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iconst_1
    self iconst:1.

    "Modified: / 17-03-2011 / 15:30:07 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iconst_2
    self iconst: 2.

    "Modified: / 17-03-2011 / 15:30:11 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iconst_3
    self iconst: 3.

    "Modified: / 17-03-2011 / 15:30:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iconst_4
    self iconst: 4.

    "Modified: / 17-03-2011 / 15:30:19 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iconst_5
   self iconst: 5.

    "Modified: / 17-03-2011 / 15:30:22 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iconst_m1
   self iconst: -1.

    "Modified: / 17-03-2011 / 15:30:27 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

idiv
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

ifacmpeq
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:53:47 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ifacmpne
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:53:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ifeq
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

ifge
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

ifgt
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

ificmpeq
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

ificmpge
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

ificmpgt
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

ificmple
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

ificmplt
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

ificmpne
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

ifle
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

iflt
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

ifne
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

ifnonnull
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:58:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ifnull
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:58:32 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iinc
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

iload     
    self iload: self fetchIndex

    "Created: / 17-03-2011 / 15:06:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2016 / 00:22:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

iload: arg 
    "
     loads an int value from local variable 0
     stack: nothing -> value
         args: nothing"
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility
    "
     Description
     The <n> must be an index into the local variable array of the current frame (Â§3.6).
     The local variable at <n> must contain an int. The value of the local variable
     at <n> is pushed onto the operand stack.

     Notes
     Each of the iload_<n> instructions is the same as iload with an index of <n>,
         except that the operand <n> is implicit."

    "Modified: / 17-03-2011 / 15:30:58 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iload_0
    "
     loads an int value from local variable 0
     stack: nothing -> value
     args: nothing"
    
    self iload: 0.

    "
     Description
     The <n> must be an index into the local variable array of the current frame (Â§3.6).
     The local variable at <n> must contain an int. The value of the local variable
     at <n> is pushed onto the operand stack.

     Notes
     Each of the iload_<n> instructions is the same as iload with an index of <n>,
     except that the operand <n> is implicit."

    "Created: / 06-03-2011 / 21:22:17 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-03-2011 / 20:58:31 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iload_1
    "check iload_0"
    self iload: 1.

    "Created: / 06-03-2011 / 21:22:30 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-03-2011 / 16:36:59 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iload_2
    "check iload_0"
    self iload:2.

    "Created: / 06-03-2011 / 21:24:02 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

iload_3
    "check iload_0"
    
    self iload: 3.

    "Created: / 14-03-2011 / 19:05:26 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

imul
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

ineg
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:47:24 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

instanceof
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:57:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

int2byte
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:51:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

int2char
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:51:08 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

int2short
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:51:13 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

invdynamic
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility

    "Created: / 25-02-2015 / 19:35:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invinterface
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:56:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

invnonvirt
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:56:26 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

invstatic
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

invvirt
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:56:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ior
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

irem
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

ireturn
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

ishl
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

ishr
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

istore     
    self istore: self fetchIndex

    "Created: / 17-03-2011 / 16:36:55 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2016 / 00:21:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

istore: arg 
    "store int value into variable 0
     stack: value -> nothing
         args: nothing"
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility
    "
     Description
     The <n> must be an index into the local variable array of the current frame (Â§3.6).
     The value on the top of the operand stack must be of type int. It is popped from
     the operand stack, and the value of the local variable at <n> is set to value.

     Notes
     Each of the istore_<n> instructions is the same as istore with an index of <n>,
         except that the operand <n> is implicit."

    "Modified: / 17-03-2011 / 15:31:20 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

istore_0
    "store int value into variable 0
     stack: value -> nothing
     args: nothing"
    
    self istore: 0.

    "
     Description
     The <n> must be an index into the local variable array of the current frame (Â§3.6).
     The value on the top of the operand stack must be of type int. It is popped from
     the operand stack, and the value of the local variable at <n> is set to value.

     Notes
     Each of the istore_<n> instructions is the same as istore with an index of <n>,
     except that the operand <n> is implicit."

    "Created: / 06-03-2011 / 21:01:27 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 17-03-2011 / 15:31:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

istore_1
    "check istore_0"
    self istore: 1.

    "Created: / 06-03-2011 / 21:18:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

istore_2
    "check istore_0"
    self istore: 2.

    "Created: / 06-03-2011 / 21:23:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

istore_3
    "check istore_0"
    
    self istore: 3.

    "Created: / 14-03-2011 / 19:05:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

isub
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

iushr
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

ixor
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

jsr
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:54:10 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

jsr_w
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:58:58 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

l2d
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:50:17 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

l2f
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:50:14 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

l2i
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:50:09 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ladd
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:44:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

laload
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

land
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:48:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lastore
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

lcmp
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:51:30 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lconst: arg 
    "
     Push long constant
     stack: nothing -> const
     arg: nothing"
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility
    "
     Push the long constant <l> (0 or 1) onto the operand stack."

    "Modified: / 17-03-2011 / 16:30:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lconst_0
    "
     Push long constant
     stack: nothing -> const
     arg: nothing"
    
    self lconst: 0.

    "
     Push the long constant <l> (0 or 1) onto the operand stack."

    "Created: / 14-03-2011 / 17:53:32 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 17-03-2011 / 16:28:58 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lconst_1
    "
     Push long constant
     stack: nothing -> const
     arg: nothing"
    
    self lconst: 1.

    "
     Push the long constant <l> (0 or 1) onto the operand stack."

    "Created: / 14-03-2011 / 17:53:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 17-03-2011 / 16:29:04 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ldc1
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility

    "
    Operation

       Push item from run-time constant pool

    Format

       ldc
       index

    Forms

       ldc = 18 (0x12)

    Operand Stack

       ... →

       ..., value

    Description

       The index is an unsigned byte that must be a valid index into
       the run-time constant pool of the current class ([384]§2.6).
       The run-time constant pool entry at index either must be a
       run-time constant of type int or float, or a reference to a
       string literal, or a symbolic reference to a class, method
       type, or method handle ([385]§5.1).

       If the run-time constant pool entry is a run-time constant of
       type int or float, the numeric value of that run-time constant
       is pushed onto the operand stack as an int or float,
       respectively.

       Otherwise, if the run-time constant pool entry is a reference
       to an instance of class String representing a string literal
       ([386]§5.1), then a reference to that instance, value, is
       pushed onto the operand stack.

       Otherwise, if the run-time constant pool entry is a symbolic
       reference to a class ([387]§5.1), then the named class is
       resolved ([388]§5.4.3.1) and a reference to the Class object
       representing that class, value, is pushed onto the operand
       stack.

       Otherwise, the run-time constant pool entry must be a symbolic
       reference to a method type or a method handle ([389]§5.1). The
       method type or method handle is resolved ([390]§5.4.3.5) and a
       reference to the resulting instance of
       java.lang.invoke.MethodType or java.lang.invoke.MethodHandle,
       value, is pushed onto the operand stack.

    Linking Exceptions

       During resolution of a symbolic reference to a class, any of
       the exceptions pertaining to class resolution ([391]§5.4.3.1)
       can be thrown.

       During resolution of a symbolic reference to a method type or
       method handle, any of the exception pertaining to method type
       or method handle resolution ([392]§5.4.3.5) can be thrown.

    Notes

       The ldc instruction can only be used to push a value of type
       float taken from the float value set ([393]§2.3.2) because a
       constant of type float in the constant pool ([394]§4.4.4) must
       be taken from the float value set.
    "

    "Modified (comment): / 29-07-2016 / 09:11:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ldc2
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility

    "
    ldc_w

    Operation

       Push item from run-time constant pool (wide index)

    Format

       ldc_w
       indexbyte1
       indexbyte2

    Forms

       ldc_w = 19 (0x13)

    Operand Stack

       ... →

       ..., value

    Description

       The unsigned indexbyte1 and indexbyte2 are assembled into an
       unsigned 16-bit index into the run-time constant pool of the
       current class ([395]§2.6), where the value of the index is
       calculated as (indexbyte1 << 8) | indexbyte2. The index must be
       a valid index into the run-time constant pool of the current
       class. The run-time constant pool entry at the index either
       must be a run-time constant of type int or float, or a
       reference to a string literal, or a symbolic reference to a
       class, method type, or method handle ([396]§5.1).

       If the run-time constant pool entry is a run-time constant of
       type int or float, the numeric value of that run-time constant
       is pushed onto the operand stack as an int or float,
       respectively.

       Otherwise, if the run-time constant pool entry is a reference
       to an instance of class String representing a string literal
       ([397]§5.1), then a reference to that instance, value, is
       pushed onto the operand stack.

       Otherwise, if the run-time constant pool entry is a symbolic
       reference to a class ([398]§4.4.1). The named class is resolved
       ([399]§5.4.3.1) and a reference to the Class object
       representing that class, value, is pushed onto the operand
       stack.

       Otherwise, the run-time constant pool entry must be a symbolic
       reference to a method type or a method handle ([400]§5.1). The
       method type or method handle is resolved ([401]§5.4.3.5) and a
       reference to the resulting instance of
       java.lang.invoke.MethodType or java.lang.invoke.MethodHandle,
       value, is pushed onto the operand stack.

    Linking Exceptions

       During resolution of the symbolic reference to a class, any of
       the exceptions pertaining to class resolution ([402]§5.4.3.1)
       can be thrown.

       During resolution of a symbolic reference to a method type or
       method handle, any of the exception pertaining to method type
       or method handle resolution ([403]§5.4.3.5) can be thrown.

    Notes

       The ldc_w instruction is identical to the ldc instruction
       ([404]§ldc) except for its wider run-time constant pool index.

       The ldc_w instruction can only be used to push a value of type
       float taken from the float value set ([405]§2.3.2) because a
       constant of type float in the constant pool ([406]§4.4.4) must
       be taken from the float value set.
    "

    "Modified (comment): / 29-07-2016 / 09:12:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ldc2w
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility

    "
    ldc2_w

    Operation

       Push long or double from run-time constant pool (wide index)

    Format

       ldc2_w
       indexbyte1
       indexbyte2

    Forms

       ldc2_w = 20 (0x14)

    Operand Stack

       ... →

       ..., value

    Description

       The unsigned indexbyte1 and indexbyte2 are assembled into an
       unsigned 16-bit index into the run-time constant pool of the
       current class ([407]§2.6), where the value of the index is
       calculated as (indexbyte1 << 8) | indexbyte2. The index must be
       a valid index into the run-time constant pool of the current
       class. The run-time constant pool entry at the index must be a
       run-time constant of type long or double ([408]§5.1). The
       numeric value of that run-time constant is pushed onto the
       operand stack as a long or double, respectively.

    Notes

       Only a wide-index version of the ldc2_w instruction exists;
       there is no ldc2 instruction that pushes a long or double with
       a single-byte index.

       The ldc2_w instruction can only be used to push a value of type
       double taken from the double value set ([409]§2.3.2) because a
       constant of type double in the constant pool ([410]§4.4.5) must
       be taken from the double value set.
    "

    "Modified (comment): / 29-07-2016 / 09:13:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ldiv
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:46:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lload
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 15:06:08 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lload: arg 
    "
     Load long from local variable
     stack: nothing -> value
         args: nothing"
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility.

    "
     Description
     Both <n> and <n> + 1 must be indices into the local variable array of the
     current frame (3.6). The local variable at <n> must contain a long. The
     value of the local variable at <n> is pushed onto the operand stack.

     Notes
     Each of the lload_<n> instructions is the same as lload with an index
     of <n>, except that the operand <n> is implicit."

    "Modified: / 17-03-2011 / 16:33:33 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lload_0
"
Load long from local variable
stack: nothing -> value
args: nothing
"
    self lload: 0.

"
Description
Both <n> and <n> + 1 must be indices into the local variable array of the 
current frame (3.6). The local variable at <n> must contain a long. The 
value of the local variable at <n> is pushed onto the operand stack.

Notes
Each of the lload_<n> instructions is the same as lload with an index 
of <n>, except that the operand <n> is implicit.
"

    "Created: / 14-03-2011 / 13:38:11 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lload_1
self lload: 1.

    "Created: / 14-03-2011 / 13:37:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lload_2
    self lload: 2.

    "Created: / 14-03-2011 / 13:38:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lload_3
    self lload: 3.

    "Created: / 14-03-2011 / 13:38:43 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lmul
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:45:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lneg
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:47:29 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lookupswtch
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:55:04 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lor
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:49:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lrem
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:46:58 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lreturn
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

lshl
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:48:09 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lshr
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:48:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lstore
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:37:14 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lstore:arg
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

lstore_0
    "store long into local variable 0
     stack: value -> nothing
     args: nothing"
    
    self lstore: 0.

    "
     Description
     Both <n> and <n> + 1 must be indices into the local variable array of the
     current frame (3.6). The value on the top of the operand stack must be
     of type long. It is popped from the operand stack, and the local variables
     at <n> and <n> + 1 are set to value.

     Notes
     Each of the lstore_<n> instructions is the same as lstore with an index
     of <n>, except that the operand <n> is implicit."

    "Created: / 14-03-2011 / 17:54:43 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lstore_1
    "store long into local variable
     stack: value -> nothing
     args: nothing"
    
    self lstore: 1.

    "
     Description
     Both <n> and <n> + 1 must be indices into the local variable array of the
     current frame (3.6). The value on the top of the operand stack must be
     of type long. It is popped from the operand stack, and the local variables
     at <n> and <n> + 1 are set to value.

     Notes
     Each of the lstore_<n> instructions is the same as lstore with an index
     of <n>, except that the operand <n> is implicit."

    "Created: / 14-03-2011 / 17:55:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lstore_2
    "store long into local variable
     stack: value -> nothing
     args: nothing"
    
    self lstore: 2.

    "
     Description
     Both <n> and <n> + 1 must be indices into the local variable array of the
     current frame (3.6). The value on the top of the operand stack must be
     of type long. It is popped from the operand stack, and the local variables
     at <n> and <n> + 1 are set to value.

     Notes
     Each of the lstore_<n> instructions is the same as lstore with an index
     of <n>, except that the operand <n> is implicit."

    "Created: / 14-03-2011 / 17:55:20 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lstore_3
    "store long into local variable
     stack: value -> nothing
     args: nothing"
    
    self lstore: 3.

    "
     Description
     Both <n> and <n> + 1 must be indices into the local variable array of the
     current frame (3.6). The value on the top of the operand stack must be
     of type long. It is popped from the operand stack, and the local variables
     at <n> and <n> + 1 are set to value.

     Notes
     Each of the lstore_<n> instructions is the same as lstore with an index
     of <n>, except that the operand <n> is implicit."

    "Created: / 14-03-2011 / 17:56:04 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lsub
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:45:25 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lushr
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:48:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lxor
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:49:09 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

monenter
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:58:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

monexit
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:58:10 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

multianewarray
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:58:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

new
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

newarray
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

nop
"Do nothing"
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Modified: / 17-03-2011 / 16:27:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

pop1
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:43:07 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

pop2
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

putfield
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

putstatic
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

ret
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:54:31 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ret_w
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:59:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

return
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

saload
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

sastore
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

sipush
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

swap
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

tableswtch
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:54:55 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

wide
    "raise an error: must be redefined in concrete subclass(es)"
    
    ^ self subclassResponsibility

    "Created: / 17-03-2011 / 16:58:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaByteCodeProcessor methodsFor:'private-helpers'!

fetchByte
    "fetch sign extended byte value stored in bytecode"
    pc := pc + 1.
    ^ (byteCode at: (pc - 1)) signExtendedByteValue.

    "Created: / 06-03-2011 / 22:26:09 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 17-03-2011 / 17:00:30 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fetchBytes2
    "fetch sign extended 2 byte value stored in bytecode"
    pc := pc + 2.
    ^ (((byteCode at: (pc - 2)) bitShift: 8) + (byteCode at: (pc - 1))) 
        signExtendedShortValue.

    "Created: / 06-03-2011 / 21:12:07 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 17-03-2011 / 17:00:43 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fetchBytes4
    "fetch sign extended 4 byte value stored in bytecode"
    
    pc := pc + 4.
    ^ (((((byteCode at: (pc - 4)) bitShift: 24) 
        bitOr: ((byteCode at: (pc - 3)) bitShift: 16)) 
            bitOr: ((byteCode at: (pc - 2)) bitShift: 8)) 
            bitOr: (byteCode at: (pc - 1))) signExtendedLongValue.

    "Created: / 21-03-2011 / 12:59:26 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 15:10:22 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 12-03-2016 / 00:00:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fetchIndex
    "fetch index value from bytecode"
    pc := pc + 1.
    ^ (byteCode at: (pc - 1)).

    "Created: / 24-02-2011 / 22:37:18 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 17-03-2011 / 17:01:14 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

fetchIndex2
    "fetch index 2 byte value from bytecode"
    pc := pc + 2.
    ^ ((byteCode at: (pc - 2)) bitShift: 8) bitOr: (byteCode at: (pc - 1)).

    "Modified: / 24-02-2011 / 21:33:53 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 17-03-2011 / 17:01:24 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

pop
    "return and remove top of the stack"
    
    sp := sp - 1.
    ^ context at: sp + 1.

    "Modified: / 17-03-2011 / 17:39:09 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

popDouble
    "so far I didn't find a reason to handle doubles and long on stack differently"
    ^ self pop.

    "Modified: / 17-03-2011 / 17:02:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

popLong
"so far I didn't find a reason to handle doubles and long on stack differently"
    ^ self pop.

    "Modified: / 17-03-2011 / 17:02:38 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

pushConstant: something 
    "push constant value on the stack - is there really not any better push method?"
    sp := sp + 1.
    context at: sp put: something

    "Modified: / 17-03-2011 / 17:05:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

pushDouble: something 
    "push double value on the stack"
    
    ^ self pushInt: something.

    "Modified: / 17-03-2011 / 17:06:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

pushFloat: something 
    "push float value on the stack"
    self pushInt: something.

    "Created: / 13-03-2011 / 16:39:52 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 17-03-2011 / 17:06:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

pushInt: something 
    "push integer value on the stack"
    sp := sp + 1.
    context at: sp put: something

    "Created: / 13-03-2011 / 17:28:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 17-03-2011 / 17:06:52 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

pushLong: something 
    "push long value on the stack"
    
    ^ self pushInt: something.

    "sp := sp + 2.
     context at: sp - 1 put: #'dummy long complement'.
     context at: sp put: something asLargeInteger."

    "Modified: / 17-03-2011 / 17:07:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

pushNewArrayOf: type sized: size 
    "push new array of type with <size> slots"
    
    self pushRef: ((JavaArray javaArrayClassFor: type) new: size).

    "Created: / 14-03-2011 / 18:36:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 27-03-2011 / 21:06:30 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

pushNewPrimitiveArrayOf: typeName sized: size 
    "push new array of <typeName> (e.g. 'long', only primitive types) with <size> slots"
    
    self 
        pushRef: ((JavaArray 
                javaArrayClassFor: (JavaDescriptor baseTypesByTypeName at: typeName)) 
                    new: size).

    "Created: / 27-03-2011 / 21:06:07 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

pushRef: something 
    "push java ref on the stack"
    sp := sp + 1.
    context at: sp put: something

    "Created: / 13-03-2011 / 16:35:55 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 21-03-2011 / 16:49:30 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

relativeJump: pos 
    "move pc relatively by the position <pos>."
   
    pc := instrPointer + pos.

    "Created: / 21-03-2011 / 18:19:44 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

skipPadding
    "in tableswitch and lookupswitch instructions, there's a padding after instruction to ensure 
     32bit values following begin at address that is multiple of 4 bytes from the start of the current
     method bytecode"
    
    | jmpSize |

    jmpSize := ((4 - (pc \\ 4)) + 1) \\ 4.
    pc := pc + jmpSize.
    ^ jmpSize.

    "Created: / 21-03-2011 / 13:13:55 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 22-03-2011 / 15:54:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

tos
    ^ context at:sp.
! !

!JavaByteCodeProcessor methodsFor:'private-logging'!

log: aMessage
self class log: aMessage.

    "Created: / 17-03-2011 / 14:59:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaByteCodeProcessor methodsFor:'processing loop'!

enterProcessingLoop
    Context cannotReturnSignal handle: 
            [:ex | 
            "/ this is required for blocks of this method, which do a homeReturn.
            "/ since my context is not really on the stack (and therefore not returnable),
            "/ catch the error and return manually.
            ^ ex parameter ]
        do: 
            [ [ leaveProcessor ] whileFalse: 
                    [ instrPointer := pc.
                    op := byteCode at: pc.
                    pc := pc + 1.
                    self switch: op. ]. ].

    "Created: / 31-03-2011 / 16:38:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

handleAbstractMethod
    self subclassResponsibility.

    "Created: / 22-03-2011 / 14:49:43 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

handleNativeMethod

    "Created: / 09-02-2012 / 22:47:03 / mh <hlopik@gmail.com>"
!

initializeContextArgsFrom: argArray 
    1 to: numArgs do: [:idx | context at: idx put: (argArray at: idx). ]

    "Created: / 21-03-2011 / 15:17:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

initializeContextVars
    1 to: numVars do: [:idx | context at: (numArgs + idx) put: nil. ]
!

leaveProcessorWith: aReturnObject 
    retVal := aReturnObject.
    leaveProcessor := true

    "Modified: / 17-03-2011 / 17:39:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

process:aMethod receiver:aReceiver arguments:args 
    | argArray |

    aMethod isAbstract ifTrue:[
        ^ self handleAbstractMethod.
    ].
    aMethod isNative ifTrue:[
        ^ self handleNativeMethod
    ].
    args size ~~ aMethod javaNumArgs ifTrue:[
        self error:'bad number of arguments'
    ].
    aMethod isStatic ifTrue:[
        argArray := args
    ] ifFalse:[
        argArray := OrderedCollection with:aReceiver.
        args notNil ifTrue:[
            argArray addAll:args.
        ].
    ].
    numArgs := argArray size.
    numVars := aMethod numVars.
    method := aMethod.
    context := JavaContext new:(numArgs + numVars + aMethod stackSize).
    context setNumArgs:numArgs numVars:numVars.
    receiver := aReceiver.
    byteCode := aMethod byteCode.
    constantPool := aMethod constantPool.
    pc := 1.
    wide := false.
    self initializeContextArgsFrom:argArray.
    self initializeContextVars.
    sp := numArgs + numVars.
    leaveProcessor := false.
    self enterProcessingLoop.
    ^ retVal

    "Modified: / 24-02-2011 / 11:09:07 / Marcel Hlopko <hlopik@gmail.com>"
    "Created: / 17-03-2011 / 17:25:31 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 31-03-2011 / 16:38:05 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 09-02-2012 / 22:51:38 / mh <hlopik@gmail.com>"
    "Modified: / 04-08-2014 / 15:51:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

switch: op 

    self log: 'invoking ' , (OpSwitchTable at: op + 1) printString , '(' , op printString , ')'.                 
    self perform: (OpSwitchTable at: op + 1)

    "Modified: / 17-03-2011 / 15:01:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 22-03-2011 / 20:55:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaByteCodeProcessor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/JavaByteCodeProcessor.st,v 1.9 2015-03-20 12:07:59 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaByteCodeProcessor.st,v 1.9 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


JavaByteCodeProcessor initialize!
