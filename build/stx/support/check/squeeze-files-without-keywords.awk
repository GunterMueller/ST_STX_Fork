BEGIN		{ got_filename = 0; printing = 0; filename = ""; }

/^  [^\n]*$/		\
	{
		# printf ("Got pattern \"%s\"\n", $0);
		if (printing == 0 && got_filename)
		{
			printing = 1;
			printf ("%s:\n", filename);
		}
		if (printing)
			print;
	}

/^[^:\n][^:\n]*:$/	\
	{
		got_filename = 1;
		filename = $1
		sub(":$", "", filename);
		printing = 0;
		# printf ("Got filename \"%s\"\n", filename);
	}

/^$/			\
	{
		# printf ("Got empty line\n");
		if (printing)
			print;
	}
