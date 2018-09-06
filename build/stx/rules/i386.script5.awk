# $Header: /cvs/stx/stx/rules/i386.script5.awk,v 1.2 1999-12-01 10:53:31 cg Exp $
#
# awk assembler output processing.
# this little awk script rewrites the interruptL call sequence
# to a slightly shorter code sequence.
# the code:
#       pushl $const
#       call ___interruptL
#       addl  $4,%esp
#
# is replaced by:
#       movl $const, %eax
#       call ___interruptL_eax
#

BEGIN   {
	    VERBOSE=0

	    STATE=0
	    KEEP=0
	    NBUFFER=0
	    SKIP=0
	    PUSHESSELIMINATED=0
	}

END     {
	    printf "# %d pushes eliminated\n",PUSHESELIMINATED
	}

/pushl \$[0-9]*/ {
	    if (STATE == 0) {
		VALUE=$2
		STATE=1
		if (VERBOSE==1) printf "# got a pushl\n"
		KEEP=1
	    } else {
		KEEP=0
	    }
	}

/ call ___interruptL$/ {
	    if (STATE == 1) {
		STATE=2
		if (VERBOSE==1) printf "# got call interruptL\n"
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/addl \$4,%esp/ {
	    if (STATE == 2) {
		if (VERBOSE==1) printf "# got addl\n",$2
		printf " movl %s,%%eax\n",$2
		printf " call ___interruptL_eax\n"
		PUSHESELIMINATED++
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
		if (VERBOSE==1) printf "# reset state for:%s\n", $0
		STATE=0
	    }
	    KEEP=0
	}

