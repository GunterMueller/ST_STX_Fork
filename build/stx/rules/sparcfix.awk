# $Header: /cvs/stx/stx/rules/sparcfix.awk,v 1.6 2001-11-06 18:50:33 cg Exp $
#
# awk assembler output processing.
# these are not really required for valid code, but
# slightly speedup / shorten the resulting code.
# Some of it is a bit magic ...
#
# mostly, this is eliminating useless jumps (which result from inline asm code)
# This may be rewritten into a peephole asm processor later ...

BEGIN   {
	    VERBOSE=1
	    VERBOSE2=1
	    VERBOSE=0
	    VERBOSE2=0

	    STATE=0
	    KEEP=0
	    NBUFFER=0
	    SKIP=0
	    JUMPSREMOVED=0
	    GLOBLDECLSREMOVED=0
	}

END     {
	    if (VERBOSE==1) printf "## %d useless entry jumps eliminated\n",JUMPSREMOVED
	    if (VERBOSE==1) printf "## %d .aligns eliminated; %d .globls eliminated\n",ALIGNREMOVED, GLOBLDECLSREMOVED
	}

# ----------------------
# the code:
#       b __x_label
#       nop
#       [optional .section / .align / .type / .proc / .global _x ]
#   __x_label:
#
# is removed from the assembler code.
# This is mostly done for more compact code - a bit for speed.
#
# since the __x label is removed, must patch any .size directove as well.
# ----------------------

/.size[ \t]*__x_M_.*/ {
	    n = split($2,REST,"__x_");
	    if (VERBOSE==1) printf("# REST n = %d is %s/%s/%s/%s\n", n, REST[1], REST[2], REST[3], REST[4]);
	    printf(" .size ");
	    for (i=1 ; i <= n ; i = i + 1) {
		printf(" %s", REST[i]);
	    }
	    printf("\n");
	    SKIP = 1;
	}

/.size[ \t]*_x_M_.*/ {
	    n = split($2,REST,"_x_");
	    if (VERBOSE==1) printf("# REST n = %d is %s/%s/%s/%s\n", n, REST[1], REST[2], REST[3], REST[4]);
	    printf(" .size ");
	    for (i=1 ; i <= n ; i = i + 1) {
		printf(" %s", REST[i]);
	    }
	    printf("\n");
	    SKIP = 1;
	}

/b _x_M_.*/ {
	    if (STATE == 0) {
		STATE=21
		LABEL=$2
		if (VERBOSE==1) printf "# got a b label=%s\n",LABEL
		KEEP=1
	    } else {
		if (VERBOSE==1) printf "# ignored b in state %d\n",STATE
		KEEP=0
	    }
	}

/b __x_M_.*/ {
	    if (STATE == 0) {
		STATE=21
		LABEL=$2
		if (VERBOSE==1) printf "# got a b label=%s\n",LABEL
		KEEP=1
	    } else {
		if (VERBOSE==1) printf "# ignored b in state %d\n",STATE
		KEEP=0
	    }
	}

/nop$/  {
	    if (STATE == 21) {
		if (VERBOSE==1) printf "# got nop\n"
		STATE=22
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/.section/ {
	    if (STATE == 22) {
		if (VERBOSE==1) printf "# got .section\n"
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/.align 4/ {
	    if (STATE == 22) {
		if (VERBOSE==1) printf "# got .align\n"
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/.type/ {
	    if (STATE == 22) {
		if (VERBOSE==1) printf "# got .type\n"
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/.global _x_M_.*/ {
	    if (STATE == 22) {
		if (VERBOSE==1) printf "# got .global\n"
		GLOBLDECLSREMOVED++
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}
 
/.global __x_M_.*/ {
	    if (STATE == 22) {
		if (VERBOSE==1) printf "# got .global\n"
		GLOBLDECLSREMOVED++
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/.proc/ {
	    if (STATE == 22) {
		if (VERBOSE==1) printf "# got .proc\n"
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/^_x_M_.*:/ {
	    if (STATE == 22) {
		if (VERBOSE==1) printf "# label %s\n",$1
		if ($1 == LABEL":") {
		    if (VERBOSE==1) printf "# got jump target %s\n",LABEL
		    if (VERBOSE==1) printf "# %s:\n", LABEL
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
		KEEP=0
		STATE=0
	    }
	}

/^__x_M_.*:/ {
	    if (STATE == 22) {
		if (VERBOSE==1) printf "# label %s\n",$1
		if ($1 == LABEL":") {
		    if (VERBOSE==1) printf "# got jump target %s\n",LABEL
		    if (VERBOSE==1) printf "# %s:\n", LABEL
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
