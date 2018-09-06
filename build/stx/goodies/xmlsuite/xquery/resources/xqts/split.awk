# splits input file into several files
# files in the input are separated by
#    ##########~<file-name>


BEGIN{FS="~"}

(match ($1, "##########")){
file=$2".st"; i=1}
{
if (i == 1)
  i=0
else
  print $0 >file
}

