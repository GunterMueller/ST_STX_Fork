/*
 * for systems where expr does not support substr (i.e. SYSV4)
 *
 * usage:
 *     rightstr <string> <n>
 * is the same as:
 *      expr substr <string> <n> 9999
 *
 * i.e. the right part of the 1st arg is echoed.
 */

main(argc, argv)
    char *argv[];
{
    int idx = atoi(argv[2]);

    puts(argv[1] + idx - 1);
}

