#
# This awk script serves to check for particular features
# in an awk program.
#

BEGIN	\
	{
		failures = 0;

		# Check 1: existance of a working "sub" function:
		pattern = "test";
		result = pattern;
		OK = "OK";
		sub(pattern, OK, result);
		#printf ("%s\n", result);
		if (result != OK)
			++failures;

		# Show the number of failures to the user:
		exit failures;
	}
