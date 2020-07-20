import csv
from collections import Counter

data = {}
minz = 9999
maxz = -9999;
with open('xyz_output_step40_shim_proto1.csv', newline='') as csvfile:
    reader = csv.reader(csvfile, delimiter=' ', quotechar='|')
    xset = set()
    yset = set()
    for row in reader:
        r = row[0].split(sep=',')
        x = int(r[0])
        y = int(r[1])
        z = float(r[2])
        xset.add(x)
        yset.add(y)
        data[(x,y)] = z
        if z < minz: minz = z
        if z > maxz: maxz = z
        #print(x,y,z)

xlist = sorted(list(xset))
ylist = sorted(list(yset))
xlist.reverse()

print("      ", end="")
for x in xlist:
    print(f"{x:4} ", end="")
print()
print("      ", end="")
for x in xlist:
    print("---- ", end="")
print()

layerFreq = Counter()
for y in ylist:
    print(f"{y:3} | ", end="")
    for x in xlist:
        z = data[(x,y)]
        q = maxz - z
        print(f"{q:4.2} ", end="")
        kapton2mil = 0.0508   # thickness of 2mil kapton tape
        kapton1mil = 0.0254   # thickness of 1mil kapton tape
        scotchBlue = 0.13716  # scotch blue painters tape
        drawingPaper = 0.11   # some big drawing paper I have
        if q < drawingPaper:
            layers=99
        else:
            layers = int(round((q-drawingPaper)/scotchBlue))
        layerFreq[layers]+=1
        #print(f"{layers:4} ", end="")
    print()

print("minz", minz)
print("maxz", maxz)
print(layerFreq)
