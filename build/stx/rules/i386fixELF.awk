# $Header: /cvs/stx/stx/rules/i386fixELF.awk,v 1.11 2010-08-23 21:22:57 stefan Exp $
#
# awk assembler output processing.
# these are not really required for valid code, but
# slightly speedup / shorten the resulting code.
# Some of it is a bit magic ...
#
# mostly, this is eliminating useless jumps (which result from inline asm code),
# and recodes some calls to pass args in registers instead of pushing.
# This may not be required with NT (where you can specify argument passing in registers)
# and other compilers.
# Also, this may be rewritten into a peephole asm processor later ...

BEGIN   {
	    VERBOSE=1
	    VERBOSE2=0
	    VERBOSE3=0

	    INTEXT=1
	    INDATA=0
	    STATE="INITIAL"
	    NEXTSTATE="INITIAL"
	    KEEP=0
	    LASTKEEP=0
	    NBUFFER=0
	    SKIPTHIS=0
	    ESPMOVESELIMINATED=0
	    MOVESELIMINATED=0
	    MOVESRELAXED=0
	    MOVESREORDERED=0
	    JUMPSTOJUMPS=0
	    CONDBRANCHRELAX=0
	    JUMPSREMOVED=0
	    ALIGNREMOVED=0
	    ADDSELIMINATED=0
	    PUSHESELIMINATED=0
	    PUSHESCONVERTED=0
	    POPSELIMINATED=0
	    PUSHRETSELIMINATED=0
	    NOPSELIMINATED=0
	    GLOBLDECLSREMOVED=0
	    NEED_CALL_BX=0
	    NEED_CALL_SI_BX=0
	    NEED_CALL_DI_SI_BX=0
	    CODEARRAY=0
	    SEPINITCODE=0
	}

END     {
	    printf "# fixup done by i386fixELF.awk:\n"
	    printf "# esp moves eliminated: %d; pushes converted to eax-moves: %d, removed: %d; pops eliminated: %d\n",ESPMOVESELIMINATED,PUSHESCONVERTED,PUSHESELIMINATED,POPSELIMINATED
	    printf "# moves eliminated: %d; moves relaxed: %d; moves reordered: %d; addls combined: %d\n",MOVESELIMINATED,MOVESRELAXED,MOVESREORDERED,ADDSELIMINATED
	    printf "# jnos to jumps eliminated: %d; cond branches relaxed: %d\n",JUMPSTOJUMPS,CONDBRANCHRELAX
	    printf "# useless entry jumps eliminated: %d\n",JUMPSREMOVED
	    printf "# push/rets eliminated: %d; nops eliminated: %d\n",PUSHRETSELIMINATED,NOPSELIMINATED
	    printf "# .aligns eliminated:%d; .globls eliminated: %d\n",ALIGNREMOVED, GLOBLDECLSREMOVED
	}

/^[\t ]*$/ {
	    printf("# match empty\n")
	    SKIPTHIS=1
	    NEXTSTATE=STATE
	    KEEP=LASTKEEP
	}

/\.align 4,0x90/ {
	    if (!INDATA) {
		SKIPTHIS=1
		ALIGNREMOVED++
		NEXTSTATE=STATE
		KEEP=LASTKEEP
	    }
	}

/\.align 4/ {
	    if (!INDATA) {
		SKIPTHIS=1
		ALIGNREMOVED++
		NEXTSTATE=STATE
		KEEP=LASTKEEP
	    }
	}

/\.align 16/ {
	    if (!INDATA) {
		SKIPTHIS=1
		ALIGNREMOVED++
		NEXTSTATE=STATE
		KEEP=LASTKEEP
	    }
	}

/^\.data/ {
	    INTEXT=0
	    INDATA=1
	}

/\.section[\t ]*\.text/ {
	    INTEXT=1
	}

/\.section[\t ]*\.stxitext/ {
	    INTEXT=1
	}

/\.section[\t ]*\.stxidat.*/ {
	    INTEXT=0
	    INDATA=1
	}

/\.section[\t ]*\.rodata.*/ {
	    INTEXT=0
	    INDATA=1
	}

#-----------------------
# eliminate useless nop-move
#-----------------------

/movl %eax,%eax$/ {
	    if (VERBOSE3==1) printf "# MATCH: /movl %%eax,%%eax$/\n"
	    if (VERBOSE==1) printf "# eliminated %s %s here\n",$1,$2
	    MOVESELIMINATED=MOVESELIMINATED + 1
	    SKIPTHIS=1
	    NEXTSTATE=STATE
	    KEEP=LASTKEEP
	}

/^[ \t]*nop$/ {
	    if (VERBOSE3==1) printf "# MATCH: /^[ \t]*nop$/\n"
	    NOPSELIMINATED=NOPSELIMINATED+1
	    SKIPTHIS=1
	    NEXTSTATE=STATE
	    KEEP=LASTKEEP
	}

#-----------------------
# eliminate 2nd move in:
#  movl %eax, %edx
#  movl %edx, %eax
#-----------------------

/movl %eax,%edx/ {
	    if (VERBOSE3==1) printf "# MATCH: /movl %%eax,%%edx/\n"
	    if (STATE == "INITIAL") {
		NEXTSTATE="MOVE_EAX_EDX"
		KEEP=1
	    }
	}

/movl %edx,%eax/ {
	    if (VERBOSE3==1) printf "# MATCH: /movl %%edx,%%eax/\n"
	    if (STATE == "MOVE_EAX_EDX") {
		if (VERBOSE==1) printf "# eliminated %s %s here\n",$1,$2
		SKIPTHIS=1
	    }
	}

#-----------------------
# change:
#  leal n1(%esp), %eax
#  movl %eax, n2(%esp)
#  movl n1(%esp), %eax
# into:
#  leal n1(%esp), %eax
#  movl %eax, n2(%esp)
#  movl 0(%eax), %eax
#
# this eliminates an offset and also
# makes an sp-relative offset into a reg-relative
# one (which results in a one-byte-shorter instruction)
#-----------------------

/leal [0-9]*\(%esp\),%e[acd]x/ {
	    if (VERBOSE3==1) printf "# MATCH: /leal [0-9]*\\(%%esp\\),%%e[acd]x/\n"
	    if (STATE == "INITIAL") {
		split($2,RIGHT,",");
		REG=RIGHT[2]
		split(RIGHT[1],O,"(");
		OFFSET=O[1]

		OFFSET1=OFFSET
		REG1=REG
		NEXTSTATE="LEAL"
		KEEP=1
	    } else {
		KEEP=0
	    }
	}

/movl %e[acd]x,[0-9]*\(%esp\)/ {
	    if (VERBOSE3==1) printf "# MATCH: /movl %%e[acd]x,[0-9]*\\(%%esp\\)/\n"
	    if ((STATE == "LEAL") && (REG == REG1)) {
		split($2,RIGHT,",");
		REG=RIGHT[1]
		split(RIGHT[2],O,"(");
		OFFSET=O[1]

		REG2=REG
		OFFSET2=OFFSET
		NEXTSTATE="LEAL_MOVL"
		KEEP=1
	    } else {
		KEEP=0
	    }
	}

/movl [0-9]*\(%esp\),%e[acd]x/ {
	    if (VERBOSE3==1) printf "# MATCH: /movl [0-9]*\\(%%esp\\),%%e[acd]x/\n"

	    split($2,RIGHT,",");
	    REG=RIGHT[2]
	    split(RIGHT[1],O,"(");
	    OFFSET=O[1]

	    if (STATE == "LEAL_MOVL") {
		if (OFFSET == OFFSET1) {
		    printf "\tleal %d(%%esp),%s\n",OFFSET1, REG1
		    printf "\tmovl %s,%d(%%esp)\n",REG1,OFFSET2
		    if (VERBOSE==1) printf "# relaxed offset here\n"
		    printf "\tmovl 0(%s),%s\n",REG1,REG
		    MOVESRELAXED++
		} else {
		    printf "\tleal %d(%%esp),%s\n",OFFSET1, REG1
		    printf "\tmovl %s,%d(%%esp)\n",REG1,OFFSET2
		    if (OFFSET == OFFSET2) {
			if (REG1 == REG) {
			    if (VERBOSE==1) printf "# removed move here\n"
			    MOVESELIMINATED=MOVESELIMINATED + 1
			} else {
			    if (VERBOSE==1) printf "# relaxed move here\n"
			    MOVESRELAXED=MOVESRELAXED + 1
			    printf "\tmovl %s,%s\n",REG1,REG
			}
		    } else {
			printf "\tmovl %d(%%esp),%s\n",OFFSET,REG
		    }
		}
		SKIPTHIS=1
		KEEP=0
		NBUFFER=0
	    } else {
		if (STATE == "LEAL_MOVLABS") {
		    if ((REG1 == REG2) && (REG != REG1)) {
			if (VERBOSE==1) printf "# reordered loads here\n"
			printf "\tmovl %d(%%esp),%s\n",OFFSET, REG
			printf "\tleal %d(%%esp),%s\n",OFFSET1, REG1
			printf "\tmovl %s,%d\n",REG2,ADDR2
			MOVESREORDERED++
		    }
		    SKIPTHIS=1
		    KEEP=0
		    NBUFFER=0
		} else {
		    KEEP=0
		}
	    }
	}

#-----------------------
# also reorder:
#  leal n1(%esp), %R1
#  movl %R1, nnnn 
#  movl n2(%esp), %R2
#  pushl %R2
# to:
#  leal n1(%esp), %R1
#  movl n2(%esp), %R2
#  movl %R1, nnnn 
#  pushl %R2
# if R1 is not equal to R2
#----------------------- 

#
#/movl %e[acd]x,[0-9]*$/ {
#            split($2,RIGHT,",");
#           REG=RIGHT[1]
#            ADDR=RIGHT[2]
#           if ((STATE == "LEAL") && (REG == REG1)) {
#               REG2=REG
#               ADDR2=ADDR
#               NEXTSTATE="LEAL_MOVLABS"
#                KEEP=1
#           } else {
#               KEEP=0
#           }
#       }
#

#-----------------------
# eliminate addl in:
# convert:
#  addl $n1, %esp
#  popl %ebx
#  addl $n2, %esp
# into:
#  movl n1(%esp), %ebx
#  addl $n1+n2+4, %esp
#-----------------------

/addl \$[0-9]*,%esp/ {
	    if (VERBOSE3==1) printf "# MATCH: /addl \\$[0-9]*,%%esp/\n"

	    split($2,RIGHT,",");
	    split(RIGHT[1],O,"$");
	    OFFSET=O[2]

	    if (STATE == "INITIAL") {
		NEXTSTATE="GOT_ADD_SP"
		KEEP=1
		OFFSET1=OFFSET
	    } else {
		if (STATE == "GOT_ADD_SP__POP_EBX") {
		    OFFSET2=OFFSET
		    if (VERBOSE==1) printf "# eliminated addl here\n"
		    printf "\tmovl %d(%%esp),%%ebx\n", OFFSET1
		    printf "\taddl $%d,%%esp\n", OFFSET1+OFFSET2+4
		    KEEP=0
		    NBUFFER=0
		    SKIPTHIS=1
		    ADDSELIMINATED=ADDSELIMINATED+1
		} else {
		    if (STATE == "GOT_ADD_SP__POP_EBX__POP_ESI") {
			OFFSET2=OFFSET
			if (VERBOSE==1) printf "# eliminated addl here\n"
			printf "\tmovl %d(%%esp),%%ebx\n", OFFSET1
			printf "\tmovl %d(%%esp),%%esi\n", OFFSET1+4
			printf "\taddl $%d,%%esp\n", OFFSET1+OFFSET2+8
			KEEP=0
			NBUFFER=0
			SKIPTHIS=1
			ADDSELIMINATED=ADDSELIMINATED+1
		    } else {
			KEEP=0
		    }
		}
	    }
	}

/popl %ebx/ {
	    if (VERBOSE3==1) printf "# MATCH: /popl %%ebx/\n"

	    if (STATE == "GOT_ADD_SP") {
		NEXTSTATE="GOT_ADD_SP__POP_EBX"
		KEEP=1
	    } else {
		KEEP=0
	    }
	}

/popl %esi/ {
	    #
	    # mhmh - seems to blow up the code a bit ...
	    #
	    if (VERBOSE3==1) printf "# MATCH: /popl %%esi/\n"

	    if (STATE == "XXX_GOT_ADD_SP__POP_EBX") {
		NEXTSTATE="GOT_ADD_SP__POP_EBX__POP_ESI"
		KEEP=1
	    } else {
		KEEP=0
	    }
	}

# ---------------------
# the code:
#       jno 0f
#       call MKLARGEINT
#   0:
#   #NO_APP
#       jmp label
#
# is replaced by:
#       jno label
#       call MKLARGEINT
#       jmp label
# ---------------------

/jno *0f/ {
	    if (STATE == "INITIAL") {
		NEXTSTATE="JNO"
		KEEP=1
	    } else {
		KEEP=0
	    }
	}

/call *__MKLARGEINTov_[as]\@PLT/ {
	    if (STATE == "JNO") {
		FUNC=$2
		NEXTSTATE="JNO_CALL"
		KEEP=1
	    } else {
		KEEP=0
	    }
	}

/call *__MKLARGEINTov_s1\@PLT/ {
	    if (STATE == "JNO") {
		FUNC=$2
		NEXTSTATE="JNO_CALLS1"
		KEEP=1
	    } else {
		KEEP=0
	    }
	}

/ *0: *$/ {
	if (VERBOSE==1) printf "# got 0: STATE: %s\n", STATE
	    if (STATE == "JNO_CALL") {
		NEXTSTATE="JNO_CALL_2"
		KEEP=1
	    } else {
		if (STATE == "JNO_CALLS1") {
		    NEXTSTATE="JNO_CALLS1_2"
		    KEEP=1
		} else {
		    KEEP=0
		}
	    }
	}

/jmp \.L*/ {
	    if (STATE == "JNO_CALL_2") {
		if (VERBOSE==1) printf "# jump to jump relaxed here\n"
		printf "\tjno %s\n",$2
		printf "\tcall %s\n",FUNC
		printf "\tjmp %s\n",$2
		JUMPSTOJUMPS++
		NBUFFER=0
		KEEP=0
		SKIPTHIS=1
	    } else {
		if (STATE == "JNO_CALLS1_3") {
		    if (VERBOSE==1) printf "# jump to jump relaxed here\n"
		    printf "\tjo 0f\n"
		    printf "\tincl %%eax\n"
		    printf "\tjmp %s\n",$2
		    printf "0:\n"
		    printf "\tcall __MKLARGEINTov_s@PLT\n"
		    printf "\tjmp %s\n",$2
		    JUMPSTOJUMPS++
		    NBUFFER=0
		    KEEP=0
		    SKIPTHIS=1
		} else {
		    KEEP=0
		}
	    }
	}

/incl[\t ]*%eax/ {
	    if (STATE == "JNO_CALLS1_2") {
		NEXTSTATE="JNO_CALLS1_3"
		KEEP=1
	    } else {
		KEEP=0
	    }
	}

# ----------------------
# the method entry code:
#       jmp __x_label
#       [optional #NO_APP / .text / .align / .data / .stabs]
#   __x_label:
#
# is removed from the assembler code.
# This is mostly done for more compact code - a bit for speed.
# (the saving is roughly 6% in libbasic2)
# ----------------------

/jmp __x.*/ {
	    if (STATE == "INITIAL") {
		NEXTSTATE="MTHD_PROLOG"
		LABEL=$2
		KEEP=1
	    } else {
		KEEP=0
	    }
	}

/#NO_APP/ {
	    SKIPTHIS=1
	    if (STATE == "MTHD_PROLOG") {
		NEXTSTATE="MTHD_PROLOG1"
		KEEP=1
	    } else {
		if (STATE != "INITIAL") {
		    NEXTSTATE=STATE
		    KEEP=LASTKEEP
		} else {
		    KEEP=0
		}
	    }
	}

/\.globl __x/ {
	    if (STATE == "MTHD_PROLOG1") {
		SKIPTHIS=1
		NEXTSTATE="MTHD_PROLOG2"
		KEEP=1
	    } else {
		if (STATE == "MTHD_PROLOG2") {
		    SKIPTHIS=1
		    NEXTSTATE="MTHD_PROLOG3"
		    KEEP=1
		} else {
		    KEEP=0
		}
	    }
	}

/\.type/ {
	    if (STATE == "MTHD_PROLOG2") {
		SKIPTHIS=1
		NEXTSTATE="MTHD_PROLOG3"
		KEEP=1
	    } else {
		if (STATE == "MTHD_PROLOG3") {
		    SKIPTHIS=1
		    NEXTSTATE="MTHD_PROLOG4"
		    KEEP=1
		} else {
		    KEEP=0
		}
	    }
	}

/^\.text/ {
	    INTEXT=1
	    if (STATE == "MTHD_PROLOG1") {
		SKIPTHIS=1
		NEXTSTATE="MTHD_PROLOG2"
		KEEP=1
	    } else {
		KEEP=0
	    }
	}

/^__x.*:/ {
	    if ((STATE == "MTHD_PROLOG3") || (STATE == "MTHD_PROLOG4")) {
		if ($1 == LABEL":") {
		    NBUFFER=0
		    #
		    # print the label
		    #
		    if (VERBOSE==1) printf "# entry sequence changed here\n"
		    printf "%s:\n", LABEL
		    JUMPSREMOVED++
		    KEEP=0
		    SKIPTHIS=1
		} else {
		    KEEP=0
		}
	    } else {
		KEEP=0
	    }
	}


# ----------------------
# common & default rule
# ----------------------

	{

	    LASTKEEP=KEEP

	    if (VERBOSE3==1) {
		printf("# defaultRule: ")
		print
		printf "# KEEP:%d SKIPTHIS:%d NBUFFER:%d STATE:%s NEXT:%s\n", KEEP, SKIPTHIS, NBUFFER, STATE, NEXTSTATE
	    }

	    if (STATE != NEXTSTATE) {
		if (VERBOSE2==1) printf "# next state %s for:%s\n", NEXTSTATE, $0
	    }

	    if (KEEP == 1) {
		if (SKIPTHIS == 0) {
		    NBUFFER++
		    BUFFER[NBUFFER]=$0
		}
	    } else {
		IDX=1
		while (IDX <= NBUFFER) {
		    print BUFFER[IDX]
		    IDX++
		}
		NBUFFER=0
		if (SKIPTHIS == 0) print
	    }

	    KEEP=0
	    STATE=NEXTSTATE
	    NEXTSTATE="INITIAL"
	    SKIPTHIS=0
	}
