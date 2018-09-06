# $Header: /cvs/stx/stx/rules/mc88fix.awk,v 1.3 1999-12-01 10:53:36 cg Exp $
#
# awk assembler output processing.
# these are not really required for valid code, but
# slightly speedup / shorten the resulting code.
# Some of it is a bit magic ...
#
# mostly, this is eliminating useless jumps (which result from inline asm code).
# This may be rewritten into a peephole asm processor later ...

BEGIN   {
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
	    printf "; %d useless entry jumps eliminated\n",JUMPSREMOVED
	    printf "; %d .aligns eliminated; %d .globls eliminated\n",ALIGNREMOVED, GLOBLDECLSREMOVED
	}

# ----------------------
# the code:
#       b __x_label
#       nop
#       [optional .section / .align / .type / .proc ]
#   __x_label:
#
# is removed from the assembler code.
# This is mostly done for more compact code - a bit for speed.
# ----------------------

/br[ \t]*_x.*/ {
	    if (STATE == 0) {
		STATE=21
		LABEL=$2
		if (VERBOSE==1) printf "# got a br label=%s\n",LABEL
		KEEP=1
	    } else {
		if (VERBOSE==1) printf "# ignored b in state %d\n",STATE
		KEEP=0
	    }
	}

/br[ \t]*__x.*/ {
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

/align/  {
	    if (STATE == 21) {
		if (VERBOSE==1) printf "# got align\n"
		STATE=22
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/global[ \t]*_x.*/ {
	    if (STATE == 22) {
		if (VERBOSE==1) printf "# got global\n"
		GLOBLDECLSREMOVED++
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/global[ \t]*__x.*/ {
	    if (STATE == 22) {
		if (VERBOSE==1) printf "# got global\n"
		GLOBLDECLSREMOVED++
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}


/^_x.*:/ {
	    if (STATE == 22) {
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
		KEEP=0
		STATE=0
	    }
	}

/^__x.*:/ {
	    if (STATE == 22) {
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
