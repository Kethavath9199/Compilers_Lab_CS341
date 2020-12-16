from __future__ import print_function #Only for Python2

with open('file1.txt') as f1, open('file2.txt') as f2, open('outfile.txt', 'w') as outfile:
    for line1, line2 in zip(f1, f2):
        if line1 == line2:
            print(line1, end='', file=outfile)
