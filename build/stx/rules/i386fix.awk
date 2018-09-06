# $Header: /cvs/stx/stx/rules/i386fix.awk,v 1.17 1998-05-29 17:19:39 cg Exp $
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

	    STATE=0
	    KEEP=0
	    NBUFFER=0
	    SKIP=0
	    ESPMOVESELIMINATED=0
	    MOVESELIMINATED=0
	    MOVESRELAXED=0
	    JUMPSTOJUMPS=0
	    CONDBRANCHRRELAX=0
	    JUMPSREMOVED=0
	    ALIGNREMOVED=0
	    ADDSELIMINATED=0
	    PUSHESELIMINATED=0
	    PUSHESCONVERTED=0
	    POPSELIMINATED=0
	    PUSHRETSELIMINATED=0
	    GLOBLDECLSREMOVED=0
	    RELOADSREMOVED=0
	    NEED_CALL_BX=0
	    NEED_CALL_SI_BX=0
	    NEED_CALL_DI_SI_BX=0
	    CODEARRAY=0
	    SEPINITCODE=0
	}

END	{
	    printf "# %d esp moves eliminated; %d pushes converted to eax-moves, %d removed; %d pops eliminated\n",ESPMOVESELIMINATED,PUSHESCONVERTED,PUSHESELIMINATED,POPSELIMINATED
	    printf "# %d useless moves eliminated; %d moves relaxed; %d addls combined\n",MOVESELIMINATED,MOVESRELAXED,ADDSELIMINATED
	    printf "# %d reloads eliminated;\n",RELOADSREMOVED
	    printf "# %d jnos to jumps eliminated; %d cond branches relaxed\n",JUMPSTOJUMPS,CONDBRANCHRELAX
	    printf "# %d useless entry jumps eliminated\n",JUMPSREMOVED
	    printf "# %d push/rets eliminated\n",PUSHRETSELIMINATED
	    printf "# %d .aligns eliminated; %d .globls eliminated\n",ALIGNREMOVED, GLOBLDECLSREMOVED
	}

/.align 4,0x90/ {
	    SKIP=1
	    ALIGNREMOVED++
	}

/.align 16/ {
	    SKIP=1
	    ALIGNREMOVED++
	}

# ---------------------
# this awk script rewrites the stack-check sequence
# which results from the asm-inline stack-check
# by a slightly faster code sequence.
# the code:
# 	#APP
#  	movl %esp,%eax
#       #NO_APP
#	cmpl %eax,___stackBottom__
#
# is replaced by:
#	cmpl %esp,___stackBottom__
# ---------------------

/#APP/ {
	    if (STATE == 0) {
	        STATE=1
	        if (VERBOSE==1) printf "# got a #APP\n"
	        KEEP=1
		SKIP=1
	    } else {
	        KEEP=0
	    }
	}

/^\/APP/ {
	    if (STATE == 0) {
	        STATE=1
	        if (VERBOSE==1) printf "# got /APP\n"
	        KEEP=1
		SKIP=1
	    } else {
	        KEEP=0
	    }
	}

/movl %esp,%eax/ {
	    if (STATE == 1) {
		STATE=2
		if (VERBOSE==1) printf "# got move\n"
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/#NO_APP/ {
	    if (STATE == 2) {
	        STATE=3
	        if (VERBOSE==1) printf "# got a #NO_APP (2)\n"
	        KEEP=1
		SKIP=1
	    } else {
		if (STATE == 21) {
		    STATE=22
		    if (VERBOSE==1) printf "# got NO_APP (21)\n"
		    KEEP=1
		    SKIP=1
		} else {
		    if ((STATE >= 10) && (STATE <= 19)) {
		        if (VERBOSE==1) printf "# got NO_APP (%d)\n",STATE
		        KEEP=1
		        SKIP=1
		    } else {
			if (STATE == 222) {
			    if (VERBOSE==1) printf "# got NO_APP (%d)\n",STATE
			    KEEP=1
			    SKIP=1
			} else {
		            if (VERBOSE==1) printf "# got NO_APP in wrong (%d)\n",STATE
	                    KEEP=0
			}
		    }
		}
	    }
	}

/^\/NO_APP/ {
	    if (STATE == 2) {
	        STATE=3
	        if (VERBOSE==1) printf "# got /NO_APP (2)\n"
	        KEEP=1
		SKIP=1
	    } else {
		if (STATE == 21) {
		    STATE=22
		    if (VERBOSE==1) printf "# got /NO_APP (21)\n"
		    KEEP=1
		    SKIP=1
		} else {
		    if ((STATE >= 10) && (STATE <= 19)) {
		        if (VERBOSE==1) printf "# got /NO_APP (%d)\n",STATE
		        KEEP=1
		        SKIP=1
		    } else {
			if (STATE == 222) {
			    if (VERBOSE==1) printf "# got /NO_APP (%d)\n",STATE
			    KEEP=1
			    SKIP=1
			} else {
		            if (VERBOSE==1) printf "# got /NO_APP in wrong (%d)\n",STATE
	                    KEEP=0
			}
		    }
		}
	    }
	}

/cmpl %eax,___stackBottom__/ {
	    if (STATE == 3) {
		if (VERBOSE==1) printf "# cmpl\n"
		printf " cmpl %%esp,___stackBottom__\n"
		ESPMOVESELIMINATED++
		NBUFFER=0
		KEEP=0
		STATE=0
		SKIP=1
	    } else {
		if (VERBOSE==1) printf "# got cmpl in wrong state\n"
		KEEP=0
		STATE=0
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
#
# ---------------------
# and:
#       jno 0f
#       call MKLARGEINT
#       jmp 1f
#   0:
#       incl %eax
#   1:
#       jmp label
#
# is replaced by:
#       jo  0f
#       incl %eax
#       jmp label
#   0:  call MKLARGEINT
#       jmp label
#
# ----------------------

/ jno *0f/ {
            if (STATE == 0) {
                STATE=11
                if (VERBOSE==1) printf "# got a jno\n"
                KEEP=1
            } else {
                KEEP=0
            }
        }

/call *MKLARGEINT/ {
            if (STATE == 11) {
                STATE=12
                if (VERBOSE==1) printf "# got call MKLARGEINT\n"
                KEEP=1
            } else {
                KEEP=0
                STATE=0
            }
        }

/ jmp *1f/ {
            if (STATE == 12) {
                STATE=110
                if (VERBOSE==1) printf "# got a jmp\n"
                KEEP=1
            } else {
                KEEP=0
            }
        }

/^[ \t]*$/ {
	    if (STATE != 0) {
                if (VERBOSE==1) printf "# empty in %d\n",STATE
                KEEP=1
                SKIP=1
	    } else {
                if (VERBOSE==1) printf "# empty in 0\n"
	    }
        }

/ *0: *$/ {
            if (STATE == 12) {
                STATE=13
                if (VERBOSE==1) printf "# got 0: (12)\n"
                KEEP=1
            } else {
                if (STATE == 110) {
                    if (VERBOSE==1) printf "# got 0: (110)\n"
                    STATE=111
                    KEEP=1
                } else {
                    if (VERBOSE==1) printf "# got 0: in wrong state (%d)\n",STATE
                    KEEP=0
                    STATE=0
                }
            }
        }

/incl *%eax/ {
            if (STATE==111) {
                STATE=112
                KEEP=1
            } else {
                KEEP=0
                STATE=0
            }
        }

/ *1: */ {
            if (STATE==112) {
                STATE=113
                KEEP=1
            } else {
                KEEP=0
                STATE=0
            }
        }

/jmp L.*/ {
            if (STATE == 13) {
                if (VERBOSE==1) printf "# label %s\n",$2
                printf " jno %s\n",$2
                printf " call MKLARGEINT\n"
                printf " jmp %s\n",$2
                JUMPSTOJUMPS++
                NBUFFER=0
                KEEP=0
                STATE=0
                SKIP=1
            } else {
                if (STATE==113) {
                    printf " jo 0f\n"
                    printf " incl %%eax\n"
                    printf " jmp %s\n",$2
                    printf "0:\n"
                    printf " call MKLARGEINT\n"
                    printf " jmp %s\n",$2
                    CONDBRANCHRELAX++
                    NBUFFER=0
                    KEEP=0
                    STATE=0
                    SKIP=1
                } else {
                    if (VERBOSE==1) printf "# got JMP to label %s in wrong state %s\n",$2,STATE
                    KEEP=0
                    STATE=0
                }
            }
        }

# ----------------------
# the code:
#	je __x_label
#       jne 3b
#       [optional #NO_APP / .text / .align / .data]
#   __x_label:
#
# is replaced by:
#	jne 3b
#  __x_label:
# This is mostly done for more compact code - less for speed.
# (although it saves a useless branch in case of non-stack-using methods)

/je[ \t]*__x.*/ {
	    if (STATE == 0) {
		STATE=221
		LABEL=$2
		if (VERBOSE==1) printf "# got a je label=%s\n",LABEL
		KEEP=1
	    } else {
		if (VERBOSE==1) printf "# ignored je in state %d\n",STATE
		KEEP=0
	    }
	}

/jne[ \t]*3b/ {
	if (STATE == 221) {
	    if (VERBOSE==1) printf "# got a jne 3b\n"
	    JUMPTARGET="3b"
	    STATE=222
	    KEEP=1
	} else {
	    if (VERBOSE==1) printf "# got jne in wrong state %s\n", STATE
		KEEP=0
		STATE=0
	    }
	}

/jne[ \t]*2b/ {
	if (STATE == 221) {
	    if (VERBOSE==1) printf "# got a jne 2b\n"
	    JUMPTARGET="2b"
	    STATE=222
	    KEEP=1
	} else {
	    if (VERBOSE==1) printf "# got jne in wrong state %s\n", STATE
	        KEEP=0
	        STATE=0
	    }
	}

/jmp[ \t]*3b/ {
	if (STATE == 221) {
	    if (VERBOSE==1) printf "# got a jmp 3b\n"
	    JUMPTARGET="3b"
	    STATE=222
	    KEEP=1
	} else {
	    if (VERBOSE==1) printf "# got jmp in wrong state %s\n", STATE
	        KEEP=0
	        STATE=0
	    }
	}

/jmp[ \t]*2b/ {
        if (STATE == 221) {
            if (VERBOSE==1) printf "# got a jmp 2b\n"
                JUMPTARGET="2b"
                STATE=222
                KEEP=1
            } else {
                if (VERBOSE==1) printf "# got jmp in wrong state %s\n", STATE
                KEEP=0
                STATE=0
            }
        }

# ----------------------
# the code:
# 	jmp __x_label
#  	[optional #NO_APP / .text / .align / .data]
#   __x_label:
#
# is removed from the assembler code.
# This is mostly done for more compact code - a bit for speed.
# (the saving is roughly 6% in libbasic2)
# ----------------------

/jmp __x.*/ {
            if (STATE == 0) {
                STATE=21
                LABEL=$2
                if (VERBOSE==1) printf "# got a jump label=%s\n",LABEL
                KEEP=1
            } else {
                if (VERBOSE==1) printf "# ignored jmp in state %d\n",STATE
                KEEP=0
            }
        }

/.data/ {
            if (STATE == 21) {
                if (VERBOSE==1) printf "# got .data\n"
                KEEP=1
            } else {
                KEEP=0
                STATE=0
            }
        }

/^.text$/ {
            if ((STATE == 22) || (STATE == 21)) {
                STATE=23
                if (VERBOSE==1) printf "# got .text\n"
                KEEP=1
            } else {
		if (STATE==223) {
		    STATE=224
		    if (VERBOSE==1) printf "# got .text\n"
		    KEEP=1
		} else {
		    if (STATE==222) {
		        STATE=223
		        if (VERBOSE==1) printf "# got .text\n"
		        KEEP=1
		    } else {
                        KEEP=0
                        STATE=0
		    }
		}
            }
        }

/.align 4/ {
            if ((STATE == 22) || (STATE == 21) || (STATE == 23)) {
                STATE=24
                if (VERBOSE==1) printf "# got .align\n"
                KEEP=1
            } else {
		if (STATE==222) {
		    STATE=223
		    if (VERBOSE==1) printf "# got .align\n"
		    KEEP=1
		} else {
                    KEEP=0
                    STATE=0
		}
            }
        }

/.align 16/ {
	    if ((STATE == 22) || (STATE == 21) || (STATE == 23)) {
	        STATE=24
	        if (VERBOSE==1) printf "# got .align\n"
	        KEEP=1
	    } else {
	        if (STATE==222) {
	            STATE=223
	            if (VERBOSE==1) printf "# got .align\n"
	            KEEP=1
		} else {
		    KEEP=0
		    STATE=0
		}
	    }
	}

/^.globl __x.*/ {
	    if (((STATE == 24) || (STATE==223)) && ($2 == LABEL)) {
                if (VERBOSE==1) printf "# got .globl\n"
		KEEP=1
		SKIP=1
	    } else {
		if (STATE == 0) {
		    KEEP=1
		    SKIP=1
		    STATE=51
		} else {
		    KEEP=0
		    STATE=0
		}
	    }
	}

# ----------------------
# remove .globls
# but only when compiling for codeArray
# or non sepInitCode
# this only speeds up later linking
# ----------------------

/^[\t ]*___usesCodeArray___:/ {
	    ODEARRAY=1
	}

/^[\t ]*___codeArray___:/ {
	    CODEARRAY=1
	}

/^[\t ]*___sepInitCode___:/ {
	    SEPINITCODE=1
	}

/.globl _*_M_/ {
	    if (CODEARRAY || !SEPINITCODE) {
		if (VERBOSE==1) printf "# removed .globl %s\n", $1
	        SKIP=1
	    }
	    GLOBLDECLSREMOVED++
	}

/.globl .*__B_/ {
	    if (CODEARRAY || !SEPINITCODE) {
		if (VERBOSE==1) printf "# removed .globl %s\n", $1
	        SKIP=1
	    }
	    GLOBLDECLSREMOVED++
	}

/.type[\t ]*__x.*/ {
	    if ((STATE == 24) || (STATE==223)) {
	        if (VERBOSE==1) printf "# got .type\n"
	        KEEP=1
	        SKIP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/^__x.*:/ {
            if ((STATE == 24) || (STATE == 23) || (STATE == 22) || (STATE == 21)) {
                if (VERBOSE==1) printf "# label %s\n",$1
                if ($1 == LABEL":") {
                    if (VERBOSE==1) printf "# got jump target %s\n",LABEL
		    printf "%s:\n", LABEL
                    JUMPSREMOVED++
                    NBUFFER=0
                    KEEP=0
                    STATE=0
                    SKIP=1
                } else {
                    KEEP=0
                    STATE=0
                }
            } else {
		if ((STATE==224) || (STATE==223)) {
		    if (VERBOSE==1) printf "# label %s\n",$1
		    if ($1 == LABEL":") {
			if (VERBOSE==1) printf "# got jump target %s\n",LABEL
			printf " jne %s\n", JUMPTARGET
			printf "%s:\n", LABEL
			JUMPSREMOVED++
			NBUFFER=0
			KEEP=0
			STATE=0
			SKIP=1
		    } else {
			KEEP=0
			STATE=0
		    }
		} else {
		    if (STATE == 51) {
		        printf " .text\n"
		        printf "%s\n", $1
		        NBUFFER=0
		        KEEP=0
		        STATE=0
		        SKIP=1
		    } else {
                        KEEP=0
                        STATE=0
		    }
		}
            }
        }

# ----------------------
# the code:
# 	addl $n,%esp
#	addl $m,%esp
#
# is replaced by:
#       addl $n+m,%esp
#
# gcc sometimes generates this stupidity
#-----------------------

/addl \$[0-9]*,%esp/ {
	    split($2,RIGHT,",");
	    split(RIGHT[1],O,"$");
	    OFFSET=O[2]

	    if (VERBOSE==1) printf "# got addl of %d to esp in state %d (OFFSET1 is %d)\n",OFFSET,STATE,OFFSET1

	    if (STATE == 0) {
	        STATE=51
	        KEEP=1
		OFFSET1=OFFSET
	    } else {
	        if (STATE == 51) {
#
#		    after addl to esp
#
		    printf " addl $%d,%%esp\n", OFFSET+OFFSET1
                    NBUFFER=0
		    SKIP=1
		    KEEP=0
		    STATE=0
		    ADDSELIMINATED++
	        } else {
                    if ((STATE == 62) || (STATE == 63)) {
#
#			after interruptL, gstore,MKREALCONTEXT4 or MKREALCONTEXT5
#
			if (VALUE == "") {
                            PUSHESELIMINATED++
			} else {
                            printf " movl %s,%%eax\n",VALUE
			    if (VERBOSE==1) printf "# replaced push by eax-mov\n"
                            PUSHESCONVERTED++
			}
			if (VERBOSE==1) printf "# modified to call reg-arg function\n"
                        printf " call %s\n",EAX_FUNCTION
			if (STATE == 63) {
			    printf " movl %%eax, %s\n", MOVETO
			}
			if (OFFSET == 4) {
			    if (VERBOSE==1) printf "# eliminated pop\n"
                            POPSELIMINATED++
			} else {
			    if (VERBOSE==1) printf "# changed pop-count\n"
			    printf " addl $%s,%%esp\n", OFFSET-4
			}
                        NBUFFER=0
                        SKIP=1
                        KEEP=0
                        STATE=0
                    } else {
			if (STATE == 72) {
#
#			    after MKREALCONTEXT4
#
	                    KEEP=1
			    STATE=73
			    OFFSET1=OFFSET
			    OFFSET2=0
			} else {
			    if (STATE == 73) {
#	
#			        after MKREAL-add-esp
#
			        KEEP=1
			        STATE=74
			        OFFSET2=OFFSET
			    } else {
                                KEEP=0
                                STATE=0
			    }
			}
		    }
		}
	    }
	}

# ----------------------
# the sequence:
#	pushl $const
#	call  ___interruptL
#	addl  $4,%esp
#
# is replaced by:
#
#	movl $const,%eax
#	call  ___interruptL_eax
#
# for a (tiny) space saving
#
# ----------------------

/pushl \$[0-9]*/ {
	    if (STATE == 0) {
	        STATE=61
	        VALUE=$2
	        KEEP=1
		if (VERBOSE==1) printf "# got push imm %s\n", VALUE
	    } else {
	        KEEP=0
                STATE=0
	    }
	}

/call ___interruptL$/ {
            if (STATE == 61) {
		EAX_FUNCTION="___interruptL_eax"
                STATE=62
                KEEP=1
            } else {
                KEEP=0
                STATE=0
	    }
        }

# ----------------------
# the sequences:
#	pushl %ebx
#	call  .Lx
# .Lx:
#	popl  %ebx
#
# is replaced by:
#	call  .L_getPC
#
# similary:
#	pushl %esi
#	pushl %ebx
#	call  .Lx
# .Lx:
#	popl  %ebx
#
# by:
#	call  .L_getPC_si
#
# and:
#	pushl %edi
#	pushl %esi
#	pushl %ebx
#	call  .Lx
# .Lx:
#	popl  %ebx
#
# by:
#	call  .L_getPC_di_si
#
# these do not affect speed, but
# reduce code size a bit
# ----------------------

#/pushl %edi/ {
#	    if (STATE == 0) {
#		if (VERBOSE==1) printf "# got push of edi\n"
#	        STATE="GOT_PUSH_EDI"
#	        KEEP=1
#	    } else {
#	        KEEP=0
#                STATE=0
#	    }
#
#/pushl %esi/ {
#	    if (STATE == 0) {
#		if (VERBOSE==1) printf "# got push of esi\n"
#	        STATE="GOT_PUSH_ESI"
#	        KEEP=1
#	    } else {
#	        KEEP=0
#                STATE=0
#	    }
#	}
#
#/pushl %ebx/ {
#	    if (STATE == 0) {
#		if (VERBOSE==1) printf "# got push of ebx\n"
#	        STATE="GOT_PUSH_EBX"
#	        KEEP=1
#	    } else {
#	        KEEP=0
#                STATE=0
#	    }
#	}

# ----------------------
# the sequence:
#	pushl %eax / %edx
#	call  ___gstore
#	addl  $4,%esp
#
# is replaced by:
#
#	call  ___gstore_eax / ___gstore_edx
#
# for a (tiny) space saving
#
# also done with:
#	call ___SSEND0
#	call ___SSEND1
#	call ___SSEND2
#	call ___SSEND3
#       call ___MKREALCONTEXT4
#       call ___MKREALCONTEXT5
#
# ----------------------

/movl \(%eax\),%eax/ {
	    if (STATE == 0) {
		if (VERBOSE==1) printf "# got mov (eax),eax\n"
		STATE=79
		KEEP=1
		INDIR=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/movl %eax,%edx/ {
	    if (STATE == 62) {
		if (VERBOSE==1) printf "# got movl of eax\n"
		MOVETO="%edx"
		STATE=63
		KEEP=1
	    } else {
                KEEP=0
                STATE=0
            }
        }

/pushl %eax/ {
	    if (STATE == 61) {
		# after pushl imm
		if (VERBOSE==1) printf "# flush\n"
                IDX=1
                while (IDX <= NBUFFER) {
                    print BUFFER[IDX]
                    IDX++
                }
                NBUFFER=0
		STATE=0
	    }
	    if ((STATE == 0) || (STATE == 79)) {
		if (VERBOSE==1) printf "# got push of eax\n"
		if (STATE != 79) {
		    INDIR=0
		}
	        STATE=71
	        KEEP=1
		PUSHEDREG="eax"
	    } else {
	        KEEP=0
                STATE=0
	    }
	}

/pushl %ebx/ {
	    if (STATE == 61) {
		# after pushl imm
		if (VERBOSE==1) printf "# flush\n"
                IDX=1
                while (IDX <= NBUFFER) {
                    print BUFFER[IDX]
                    IDX++
                }
                NBUFFER=0
		STATE=0
	    }
            if (STATE == 0) {
                if (VERBOSE==1) printf "# got push of ebx\n"
                STATE=71
                KEEP=1
                PUSHEDREG="ebx"
            } else {
                KEEP=0
                STATE=0
            }
        }

/pushl %edx/ {
	    if (STATE == 61) {
		# after pushl imm
		if (VERBOSE==1) printf "# flush\n"
                IDX=1
                while (IDX <= NBUFFER) {
                    print BUFFER[IDX]
                    IDX++
                }
                NBUFFER=0
		STATE=0
	    }
	    if (STATE == 0) {
		if (VERBOSE==1) printf "# got push of edx\n"
		STATE=71
		KEEP=1
		PUSHEDREG="edx"
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/call ___SSEND0$/ {
	    if (STATE == 71) {
		if (VERBOSE==1) printf "# got call __SSEND0\n"
		VALUE=""
		STATE=62
	    	KEEP=1
		if (PUSHEDREG == "edx") {
		    EAX_FUNCTION="___SSEND0_edx"
		} else if (PUSHEDREG == "ebx") {
		    EAX_FUNCTION="___SSEND0_ebx"
		} else if (PUSHEDREG == "eax") {
		    if (INDIR) {
			EAX_FUNCTION="___SSEND0_Ieax"
		    } else {
		        EAX_FUNCTION="___SSEND0_eax"
		    }
		} else {
		    if (VERBOSE==1) printf "# wrong reg pushed: %s\n", PUSHEDREG
		    KEEP=0
		    STATE=0
		}
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/call ___SSEND1$/ {
            if (STATE == 71) {
                if (VERBOSE==1) printf "# got call __SSEND1\n"
                VALUE=""
                STATE=62
                KEEP=1
                if (PUSHEDREG == "edx") {
                    EAX_FUNCTION="___SSEND1_edx"
                } else if (PUSHEDREG == "ebx") {
                    EAX_FUNCTION="___SSEND1_ebx"
                } else if (PUSHEDREG == "eax") {
		    if (INDIR) {
			EAX_FUNCTION="___SSEND1_Ieax"
		    } else {
                        EAX_FUNCTION="___SSEND1_eax"
		    }
                } else {
		    if (VERBOSE==1) printf "# wrong reg pushed: %s\n", PUSHEDREG
                    KEEP=0
                    STATE=0
                }
            } else {
                KEEP=0
                STATE=0
            }
        }

/call ___SSEND2$/ {
            if (STATE == 71) {
                if (VERBOSE==1) printf "# got call __SSEND2\n"
                VALUE=""
                STATE=62
                KEEP=1
                if (PUSHEDREG == "edx") {
                    EAX_FUNCTION="___SSEND2_edx"
                } else if (PUSHEDREG == "ebx") {
                    EAX_FUNCTION="___SSEND2_ebx"
                } else if (PUSHEDREG == "eax") {
                    if (INDIR) {
                        EAX_FUNCTION="___SSEND2_Ieax"
                    } else {
                        EAX_FUNCTION="___SSEND2_eax"
                    }
                } else {
                    if (VERBOSE==1) printf "# wrong reg pushed: %s\n", PUSHEDREG
                    KEEP=0
                    STATE=0
                }
            } else {
                KEEP=0
                STATE=0
            }
        }

/call ___SSEND3$/ {
            if (STATE == 71) {
                if (VERBOSE==1) printf "# got call __SSEND3\n"
                VALUE=""
                STATE=62
                KEEP=1
                if (PUSHEDREG == "edx") {
                    EAX_FUNCTION="___SSEND3_edx"
                } else if (PUSHEDREG == "ebx") {
                    EAX_FUNCTION="___SSEND3_ebx"
                } else if (PUSHEDREG == "eax") {
                    if (INDIR) {
                        EAX_FUNCTION="___SSEND3_Ieax"
                    } else {
                        EAX_FUNCTION="___SSEND3_eax"
                    }
                } else {
                    if (VERBOSE==1) printf "# wrong reg pushed: %s\n", PUSHEDREG
                    KEEP=0
                    STATE=0
                }
            } else {
                KEEP=0
                STATE=0
            }
        }

/call ___MKREALCONTEXT4$/ {

            if (STATE == 71) {
		if (VERBOSE==1) printf "# got call __MKREALCONTEXT4\n"

# soon:
#
#		STATE=72
#		KEEP=1

                VALUE=""
                STATE=62
                KEEP=1
		if (PUSHEDREG == "edx") {
		    EAX_FUNCTION="___MKREALCONTEXT4_edx"
		} else if (PUSHEDREG == "ebx") {
                    EAX_FUNCTION="___MKREALCONTEXT4_ebx"
		} else if (PUSHEDREG == "eax") {
		    if (INDIR) {
			printf " movl (%%eax), %%eax\n"
		    }
                    EAX_FUNCTION="___MKREALCONTEXT4_eax"
		} else {
                    KEEP=0
                    STATE=0
		}
            } else {
                KEEP=0
                STATE=0
            }
        }

/call ___MKREALCONTEXT5$/ {
	    if (STATE == 71) {
		if (VERBOSE==1) printf "# got call __MKREALCONTEXT5\n"
		VALUE=""
		STATE=62
		KEEP=1
		if (PUSHEDREG == "edx") {
		    EAX_FUNCTION="___MKREALCONTEXT5_edx"
		} else if (PUSHEDREG == "ebx") {
		    EAX_FUNCTION="___MKREALCONTEXT5_ebx"
		} else if (PUSHEDREG == "eax") {
		    if (INDIR) {
			printf " movl (%%eax), %%eax\n"
		    }
		    EAX_FUNCTION="___MKREALCONTEXT5_eax"
		} else {
		    KEEP=0
		    STATE=0
		}
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/call ___gstore$/ {
            if (STATE == 71) {
	        VALUE=""
                STATE=62
                KEEP=1
		if (PUSHEDREG == "edx") {
		    EAX_FUNCTION="___gstore_edx"
		} else if (PUSHEDREG == "ebx") {
		    EAX_FUNCTION="___gstore_ebx"
		} else if (PUSHEDREG == "eax") {
		    if (INDIR) {
			printf " movl (%%eax), %%eax\n"
		    }
		    EAX_FUNCTION="___gstore_eax"
		} else {
                    STATE=0
                    KEEP=0
		}
            } else {
                KEEP=0
                STATE=0
            }
        }

# ----------------------
# the sequence:
#	pushl %eax
#	call  ___MKREALCONTEXT4
#	addl  $n,%esp
#       ret
#
# is replaced by:
#
#	addl  $(n-4), %esp
#	jmp   ___MKREAL4_eax
#
# for a (tiny) space saving
#
# ----------------------

/ret$/ {
	    if (VERBOSE==1) printf "# got ret in STATE %d\n", STATE

	    if ((STATE == 73) || (STATE == 74)) {
		if (OFFSET2 == 0) {
		    printf " addl $%d,%%esp\n", OFFSET1-4
		} else {
		    printf " addl $%d,%%esp\n", OFFSET1+OFFSET2-4
		}
		printf " jmp ___MKREAL4_%s\n", PUSHEDREG
                NBUFFER=0
		SKIP=1
		PUSHRETSELIMINATED++
	    }

	    KEEP=0
	    STATE=0
	}

# ----------------------
# the code:
#       movl n(%esp),%eax
#       movl %eax,n(%xxx)
#       movl n(%esp),%eax
#
# is replaced by:
#       movl n(%esp),%eax
#       movl %eax,n(%xxx)
#
# gcc generates this since it does not know
# that xxx is not an alias to stack variables.
# ----------------------

/movl [0-9]*\(%esp\),%eax/ {
	    if (STATE == 0) {
		STATE=401
		split($2,RIGHT,",");
		split(RIGHT[1],O,"(");
		OFFSET1=O[1]
		if (VERBOSE == 1) printf "# got mov [->401] offset=%s\n" , OFFSET1
		KEEP=1
	    } else if (STATE == 402) {
		split($2,RIGHT,",");
		split(RIGHT[1],O,"(");
		OFFSET2=O[1]
		if (VERBOSE == 1) printf "# got mov [in 402] offset=%s\n" , OFFSET2
		if (OFFSET2 == OFFSET1) {
		    if (VERBOSE == 1) printf "# eliminated reload here\n"
		    RELOADSREMOVED=RELOADSREMOVED+1
		    SKIP=1
		    KEEP=0
		    STATE=0
		}
	    } else {
                KEEP=0
                STATE=0
	    }
	}

/movl %eax,[0-9]*\(%ebx\)/ {
	    if (STATE == 401) {
		if (VERBOSE == 1) printf "# got mov %%eax OFFS(%%ebx) [->402]\n"
		KEEP=1;
		STATE=402
	    } else {
                KEEP=0
                STATE=0
	    }
	}

/movl %eax,\(%ebx\)/ {
	    if (STATE == 401) {
                if (VERBOSE == 1) printf "# got mov %%eax (%%ebx) [->402]\n"
                KEEP=1;
                STATE=402
            } else {
                if (VERBOSE == 1) printf "# got mov %%eax (%%ebx) in wrong state\n"
                KEEP=0
                STATE=0
            }
        }

# ----------------------
# the code:
# 	movl %eax,n(%esp)
#	movl n(%esp),%eax
#
# is replaced by:
#       movl %eax,n(%esp)
#
# and:
#       movl %eax,n(%esp)
#       movl n(%esp),%reg
#
# is replaced by:
#       movl %eax,n(%esp)
#       movl %eax,%reg
#
# gcc sometimes generates this stupidity
# ----------------------

/movl %eax,[0-9]*\(%esp\)/ {
            if (STATE == 0) {
		if (VERBOSE == 1) printf "# got mov %%eax OFFS(%%ebx) [->41]\n"
		STATE=41
		split($2,RIGHT,",");
		split(RIGHT[2],O,"(");
		OFFSET=O[1]
		KEEP=1
            } else {
		if (VERBOSE == 1) printf "# got mov %%eax OFFS(%%ebx) in wrong state\n"
                KEEP=0
                STATE=0
	    }
	}

/movl [0-9]*\(%esp\),%e[abcd]x/ {
	    if (STATE == 41) {
		if (VERBOSE == 1) printf "# got mov OFFS(%%esp),%%eax in 41 [->0]\n"
		split($2,RIGHT,",");
		split(RIGHT[1],O,"(");
		OFFSET2=O[1]
		if (OFFSET == OFFSET2) {
		    if (RIGHT[2] == "%eax") {
			printf " movl %%eax,%d(%%esp)\n", OFFSET
		        if (VERBOSE == 1) printf "# eliminated redundant move here\n"
			MOVESELIMINATED=MOVESELIMINATED+1
		    } else {
			printf " movl %%eax,%d(%%esp)\n", OFFSET
			printf " movl %%eax,%s\n", RIGHT[2]
		        if (VERBOSE == 1) printf "# made it a reg-reg move here\n"
			MOVESRELAXED=MOVESRELAXED+1
		    }
                    NBUFFER=0
		    SKIP=1
		    KEEP=0
		    STATE=0
		} else {
		    if (VERBOSE == 1) printf "# oops - different offsets\n"
		    KEEP=0
		    STATE=0
		}
	    } else {
		if (VERBOSE == 1) printf "# got mov OFFS(%%esp),%%eax in wrong state [->0]\n"
		KEEP=0
		STATE=0
	    }
	}

# ----------------------
# common & default rule
# ----------------------

        {
	    if (KEEP == 1) {
		if (SKIP == 0) {
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
		if (SKIP == 0) print
	    }
	    SKIP=0
	    if (KEEP != 1) {
		if (VERBOSE2==1) printf "# reset state for:%s\n", $0
		STATE=0
	    }
	    KEEP=0
	}
