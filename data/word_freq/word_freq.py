######################################################
#This is used for splitting up the titles to classes.#
######################################################
#Example: ANCIENTPHILOSOPHYHONORS --> Ancient Philosophy Honors#

from math import log
import csv
from os import remove, close 

# Build a cost dictionary, assuming Zipf's law and cost = -math.log(probability).
words = open("words-by-frequency.txt").read().split()
print(len(words))
wordcost = dict((k, log((i+1)*log(len(words)))) for i,k in enumerate(words))
maxword = max(len(x) for x in words)

def infer_spaces(s):
    """Uses dynamic programming to infer the location of spaces in a string
    without spaces."""

    # Find the best match for the i first characters, assuming cost has
    # been built for the i-1 first characters.
    # Returns a pair (match_cost, match_length).
    def best_match(i):
        candidates = enumerate(reversed(cost[max(0, i-maxword):i]))
        return min((c + wordcost.get(s[i-k-1:i], 9e999), k+1) for k,c in candidates)

    # Build the cost array.
    cost = [0]
    for i in range(1,len(s)+1):
        c,k = best_match(i)
        cost.append(c)

    # Backtrack to recover the minimal-cost string.
    out = []
    i = len(s)
    while i>0:
        c,k = best_match(i)
        assert c == cost[i]
        out.append(s[i-k:i])
        i -= k

    return " ".join(reversed(out))


def split_csv(input_csv, column):
    mod_title = input_csv.split('.csv')[0] + '_NEW.csv'
    print mod_title
    f = open(input_csv, 'rt')
    writer = open(mod_title,'w')
    counter = 0

    try:

        reader = csv.reader(f)
        for row in reader:

            original = row[column]
            split = infer_spaces(row[column].lower()).title()

            if (split.count(' ') > 5 or counter == 0):
                split = original
                 
            else:
                row[column] = split

            new_row = ', '.join(str(x) for x in row)  
            counter += 1 
            writer.write(new_row + "\n")

    finally:
        f.close()
        writer.close()

    remove(input_csv)



a = 'MYNAMEISGOD'
b = 'ADVANCEDMATH'
s = 'PHIL&SCIFICTION-HONRS'
print(infer_spaces(a.lower()).title())
print(infer_spaces(b.lower()).title())
print(infer_spaces(s.lower()).title())


split_csv('../output/PHIL_NEW.csv',22)
