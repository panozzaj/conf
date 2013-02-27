#!/usr/bin/env python

import sys
import os
import fileinput

has_256_color = (os.environ.get('TERM', None) == 'xterm-256color')

index_color      = int(os.environ.get('DIFF_INDEX_COLOR',
	 32 if has_256_color else 36))
old_mode_color   = int(os.environ.get('DIFF_OLD_MODE_COLOR',
	 88 if has_256_color else 31))
new_mode_color   = int(os.environ.get('DIFF_NEW_MODE_COLOR',
	 28 if has_256_color else 32))
removed_color    = int(os.environ.get('DIFF_REMOVED_COLOR',
	160 if has_256_color else 31))
added_color      = int(os.environ.get('DIFF_ADDED_COLOR',
	  2 if has_256_color else 32))
hunk_start_color = int(os.environ.get('DIFF_HUNK_START_COLOR',
	 32 if has_256_color else 36))

RESET_FORMAT = '\033[0m'
COLOR_FORMAT_256 = '\033[38;5;%um'
COLOR_FORMAT_16 = '\033[38;%um'
COLOR_FORMAT = COLOR_FORMAT_256 if has_256_color else COLOR_FORMAT_16
BEGIN_REVERSE_FORMAT = '\033[7m'
END_REVERSE_FORMAT = '\033[27m'

USAGE = """
Usage: diff ... | diff-colorize
   or:            diff-colorize < foo.diff

Reads unified or git-style diff data from standard input, colorizes it, and writes the result to standard output.

You can customize the color numbers used by setting these variables in your environment:
* DIFF_INDEX_COLOR (lines starting with "Index: " or "diff --git ")
* DIFF_OLD_MODE_COLOR (lines starting with "old mode"; these only appear in git-style diffs)
* DIFF_NEW_MODE_COLOR (lines starting with "new mode"; these only appear in git-style diffs)
* DIFF_REMOVED_COLOR (lines starting with "-")
* DIFF_ADDED_COLOR (lines starting with "+")
* DIFF_HUNK_START_COLOR (lines starting with "@@")
""".strip()

# Everything in the unified diff format is identified by a prefix. The prefixes are:
# 'Index: ':    File marker (unified diff)
# 'diff --git': File marker (git-style diff)
# 'old mode':   File permissions mode before change
# 'new mode':   File permissions mode after change
# '---':        Defining '-' (giving the name and modification date of the file before change)
# '+++':        Defining '+' (giving the name and modification date of the file after change)
# '-':          Line before change (i.e., removed)
# '+':          Line after change (i.e., added)
# ' ':          Line that hasn't changed
# '@@':         Hunk start (@@ -start,length +start, length @@)
#
# We need to look for these prefixes in order, in order to handle '---'/'+++' before '-'/'+'. Hence the OrderedDict.
class OrderedDict(dict):
	def __init__(self, input=None):
		if input is None:
			self.keys = []
			super(OrderedDict, self).__init__()
		elif isinstance(input, dict):
			self.keys = list(input)
			super(OrderedDict, self).__init__(input)
		else:
			self.keys = [k for k, v in input]
			super(OrderedDict, self).__init__(input)
	def __iter__(self):
		return iter(self.keys)
	def __setitem__(self, k, v):
		if k not in self:
			self.keys.append(k)
		super(OrderedDict, self).__setitem__(k, v)
	def __delitem__(self, k):
		super(OrderedDict, self).__delitem__(k)
		self.keys.remove(k)

# Each value includes not only the terminal-config characters, but also the key, somewhere within it (possibly between two terminal-config strings).
# Theoretically, you could replace the key with some other string or leave it out entirely, if you wanted to, but I wouldn't recommend it.
prefixes = OrderedDict()
prefixes['---'] = (
	COLOR_FORMAT % (removed_color,)
	+ BEGIN_REVERSE_FORMAT 
	+ '---'
	+ END_REVERSE_FORMAT
)
prefixes['+++'] = (
	COLOR_FORMAT % (added_color,)
	+ BEGIN_REVERSE_FORMAT 
	+ '+++'
	+ END_REVERSE_FORMAT
)
prefixes['-'] = (
	COLOR_FORMAT % (removed_color,)
	+ BEGIN_REVERSE_FORMAT 
	+ '-'
	+ END_REVERSE_FORMAT
)
prefixes['+'] = (
	COLOR_FORMAT % (added_color,)
	+ BEGIN_REVERSE_FORMAT 
	+ '+'
	+ END_REVERSE_FORMAT
)
prefixes['old mode'] = ( # Git-style diffs only
	COLOR_FORMAT % (old_mode_color,)
	+ BEGIN_REVERSE_FORMAT 
	+ 'old mode'
	+ END_REVERSE_FORMAT
)
prefixes['new mode'] = ( # Git-style diffs only
	COLOR_FORMAT % (new_mode_color,)
	+ BEGIN_REVERSE_FORMAT 
	+ 'new mode'
	+ END_REVERSE_FORMAT
)
prefixes['Index: '] = COLOR_FORMAT % (index_color,) + 'Index: '
prefixes['diff --git '] = COLOR_FORMAT % (index_color,) + 'diff --git '
prefixes['@@'] = (
	COLOR_FORMAT % (hunk_start_color,)
	+ BEGIN_REVERSE_FORMAT
	+ '@@'
)

if sys.stdin.isatty():
	# Standard input is a TTY, meaning that the user ran 'diff-colorize' at the shell prompt, without redirecting anything into it. Print usage info and exit.
	sys.exit(USAGE)

for line in fileinput.input():
	for prefix_to_test in prefixes:
		if line.startswith(prefix_to_test):
			sys.stdout.write(prefixes[prefix_to_test])
			line = line[len(prefix_to_test):]

	sys.stdout.write(line)

	sys.stdout.write(RESET_FORMAT)
