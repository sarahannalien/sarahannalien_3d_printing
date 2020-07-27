import csv
from collections import Counter
import math

data = {}
#minz = 9999
#maxz = -9999;
with open('xyz_output_step30_working.csv', newline='') as csvfile:
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
        #if z < minz: minz = z
        #if z > maxz: maxz = z
        #print(x,y,z)

xlist = sorted(list(xset))
ylist = sorted(list(yset))

class Shim:
    def __init__(self, name, thickness, description):
        self.name = name
        self.thickness = thickness
        self.description = description

# Shim materials I'm playing with        
aluminum3m3380=Shim('aluminum3m3380', 0.09, "3m 3380 aluminum tape")
kapton2mil=Shim('kapton2mil', 0.0508, "thickness of 2mil kapton tape")
kapton1mil=Shim('kapton1mil', 0.0254, "thickness of 1mil kapton tape")
scotchBlue=Shim('scotchBlue', 0.13716, "scotch blue painters tape")
drawingPaper=Shim('drawingPaper', 0.11, "some big drawing paper I have")
aluminum_0_04in=Shim('aluminum_0_04in', 1.016, "Ponoko 0.04 inch thick aluminum")
aluminum_0_06in=Shim('aluminum_0_06in', 1.524, "Ponoko 0.06 inch thick aluminum")
aluminum_0_13in=Shim('aluminum_0_13in', 3.302, "Ponoko 0.13 inch thick aluminum")
magnet_5x1mm=Shim('magnet_5x1mm', 0.85, "")
veryThinPcb=Shim('veryThinPcb', 0.43, "")
aluminumFoil36ga=Shim('aluminumFoil36ga', 0.13, "found at amazon")
colorbokCardstock=Shim('colorbokCardstock',  .23, "")
ponokoClearSilicone_0_5mm =('ponokoClearSilicone_0_5mm', 0.5, "Ponoko 0.5mm clear silicone")


xlist.reverse()

def findMinMaxZ(data):
    zvalues = [ v for k,v in data.items() ]
    minz = min(zvalues)
    maxz = max(zvalues)
    return (minz, maxz)

def printHeader(xlist,ylist):
    print("     ", end="")
    for x in xlist:
        print(f"{x:5} ", end="")
    print()
    print("     ", end="")
    for x in xlist:
        print("----- ", end="")
    print()
    
def graphit(dataIn, xlist, ylist, shim, showValues=False):
    dataOut = {}
    minz, maxz = findMinMaxZ(dataIn)
    diff = maxz - minz
    print(f"minz={minz}, maxz={maxz}, diff={diff}")
    printHeader(xlist, ylist)
    
    #layerFreq = Counter()
    for y in ylist:
        print(f"{y:3} | ", end="")
        shimmed = False
        for x in xlist:
            z = dataIn[(x,y)]
            q = - maxz + z   # so highest point, maxz, will be zero.
            if showValues:
                print(f"{q:5.02f} ", end="")
            else:
                if q < (-shim.thickness):
                    print(f"##### ", end="")
                    dataOut[(x,y)] = z + shim.thickness
                    shimmed = True
                else:
                    print(f"::::: ", end="")
                    dataOut[(x,y)] = z
        print()
    return (dataOut,shimmed)

d = data
s1 = kapton2mil
s2 = scotchBlue
s3 = kapton2mil
s4 = kapton1mil
shimmed = True
layerNumber = 1
graphit(d, xlist, ylist, s1, showValues = True)
while shimmed:
    print()
    print(f"LAYER {layerNumber} {s1.name}: ({s1.thickness}mm) {s1.description}")
    (d, shimmed) = graphit(d, xlist, ylist, s1)
    layerNumber +=1

shimmed=True
while shimmed:
    print()
    print(f"LAYER {layerNumber} {s2.name}: ({s2.thickness}mm) {s2.description}")
    (d, shimmed) = graphit(d, xlist, ylist, s2)
    layerNumber +=1

shimmed=True
while shimmed:
    print()
    print(f"LAYER {layerNumber} {s3.name}: ({s3.thickness}mm) {s3.description}")
    (d, shimmed) = graphit(d, xlist, ylist, s3)
    layerNumber +=1
    
shimmed=True
while shimmed:
    print()
    print(f"LAYER {layerNumber} {s4.name}: ({s4.thickness}mm) {s4.description}")
    (d, shimmed) = graphit(d, xlist, ylist, s4)
    layerNumber +=1
