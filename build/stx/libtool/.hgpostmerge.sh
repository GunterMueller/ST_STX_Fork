#!/bin/bash
# 
# A simple script that has to be run after hg merge due to 
# missing renames in history
#
#

MY_BRANCH=$(hg branch)
BAD_FILES=$(ls Tools_[A-Z]*.st)
LAST_MERGE_REV=$(hg log -r "children(ancestor(default, $MY_BRANCH)) and merge() and branch($MY_BRANCH)" --template "{node|short}\n")
LAST_MERGED_REV=$(hg log -r $LAST_MERGE_REV --template "{parents}" | cut -d ' ' -f 2 | cut -d ':' -f 2)

echo "Last merge with default was $LAST_MERGE_REV"
echo "Last merged default     was $LAST_MERGED_REV:"
hg log -r $LAST_MERGED_REV

for bad_file in $BAD_FILES; do
	good_file=$(echo $bad_file | sed -e 's/_/__/g')
	echo "Fixing $bad_file -> $good_file"
	default_last_change_rev=$(hg log -b default $bad_file -l 1 --template "{node|short}\n")
	if [ "$default_last_change_rev" != "$LAST_MERGED_REV" ]; then
		echo " Changed since last merge (latest is $default_last_change_rev)"
		cp $good_file $good_file.orig
		cp $good_file $good_file.local
		hg cat -r "$default_last_change_rev" "$bad_file" > "$good_file.other"
		hg cat -r "$LAST_MERGED_REV" "$bad_file" > "$good_file.base"
		hg resolve --unmark "$good_file"
	fi
done