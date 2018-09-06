# $Header: /cvs/stx/stx/rules/interpret.sparc.awk,v 1.4 1999-12-01 10:53:35 cg Exp $
#
# awk assembler output processing.
# this little awk script removes a nonsense
# code sequence checking the boundary of a switch statement
#
# The code sequence only appears in interpret.c
#
#
#       ldub [%l1],%o1
#       cmp %o1,255
#       bgu .LL51


BEGIN   {
	    VERBOSE=0

	    STATE=0
	    KEEP=0
	    NBUFFER=0
	    SKIP=0
	}

/ldub[\t ]*\[%[giol][0-7]\],%[giol][0-7]/  {
	    if (STATE == 0) {
		INSN1=$0
		HASINSN2=0
		STATE=1
		if (VERBOSE==1) printf "# got ldub\n"
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/L[0-9]*:$/ {
	    if (STATE == 1) {
		INSN2=$0
		HASINSN2=1
		if (VERBOSE==1) printf "# got label\n"
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/\.L[0-9]*:$/ {
	    if (STATE == 1) {
		INSN2=$0
		HASINSN2=1
		if (VERBOSE==1) printf "# got label\n"
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/cmp[\t ]*%[giol][0-7],17/  {
	    if (STATE == 1) {
		STATE=2
		if (VERBOSE==1) printf "# got cmp xx,17\n"
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}
 

/cmp[\t ]*%[giol][0-7],255/  {
	    if (STATE == 1) {
		STATE=2
		if (VERBOSE==1) printf "# got cmp xx,255\n"
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/bgu[\t ]*L/ {
	    if (STATE == 2) {
		STATE=0
		if (VERBOSE==1) printf "# got bgu\n"
		print INSN1
		if (HASINSN2==1) {
		    print INSN2
		}
		NBUFFER=0
		KEEP=0
		STATE=0
		SKIP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/bgu[\t ]*\.L/ {
	    if (STATE == 2) {
		STATE=0
		if (VERBOSE==1) printf "# got bgu\n"
		print INSN1
		if (HASINSN2==1) {
		    print INSN2
		}
		NBUFFER=0
		KEEP=0
		STATE=0
		SKIP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/bleu[\t ]*LY/ {
	    if (STATE == 2) {
		STATE=0
		if (VERBOSE==1) printf "# got bleu\n"
		print INSN1
		if (HASINSN2==1) {
		    print INSN2
		}
		printf " b %s\n", $2
		NBUFFER=0
		KEEP=0
		STATE=0
		SKIP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

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
