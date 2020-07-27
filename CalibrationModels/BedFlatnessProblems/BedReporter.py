import serial
import io
import re
import csv

class Printer:
    """Sending to and receiving from 3D printer via serial port"""
    
    def __init__(self, port='COM8', baudrate=9600, timeout=2):
        self.port = port
        self.baudrate = baudrate
        self.timeout = timeout
    def __openport(self):
        self.serial_port = serial.Serial(port=self.port,
            baudrate=self.baudrate, timeout=self.timeout)
        self.sio = io.TextIOWrapper(
            io.BufferedRWPair(self.serial_port, self.serial_port))
        #self.serial_port.open()
    def __closeport(self):
        self.serial_port.close()
    def __enter__(self):
        #print("ENTER")
        self.__openport()
    def __exit__(self, type, value, tb):
        #print("EXIT")
        self.__closeport()
    def __reinit(self):
        """Reinitialize communication after a read error"""
        self.__closeport()
        self.__openport()
    def send(self, cmd):
        cmdline = cmd
        print(f"SEND {cmdline}")
        self.sio.write(cmd + "\n")
        self.sio.flush()
    def receive(self, echo=True, maxlines=50):
        n = 1
        lines = []
        while n < maxlines:
            line = self.sio.readline().rstrip('\n')
            #print("[", n, ":", line.strip(), "]")
            if echo: print(f"{n:04} {line}")
            n+=1
            lines.append(line)
            if line.startswith("ok"):
                return lines
        print("!!!! Too many lines! May be truncated.")
        print("!!!! Reinitializing")
        self.__reinit()
        print("!!!! Reinitializing Complete.")
        return lines

    def cmd(self, cmd, comment="", echo=True, maxlines=50):
        print()
        print(f"SEND {cmd}   ({comment})")
        self.sio.write(cmd + "\n")
        self.sio.flush()
        print("------------------------------")
        lines = self.receive(echo=echo)
        return lines

def extractZProbe(linesFromG30):
    for line in linesFromG30:
        if not line.startswith("X:"): continue
        print("#### " + line)
        m = re.search('\AX:([0-9.]+) Y:([0-9.]+) Z:([0-9.]+)', line)
        return (float(m.group(1)), float(m.group(2)), float(m.group(3)))
        #print("#### ", zvalue)
        #return zvalue
    print("!!!! Couldn't find Z value: ", linesFromG30)
    return (-1.0, -1.0, 9999.0)   # FAIL. Prob comms problem


class Prober:
    def __init__(self, printer,
                 bedx = 310, bedxstart = 0, bedxend = None,
                 bedy = 310, bedystart = 15, bedyend = 300,
                 stepsize = 80,
                 sensorXoffset = 30,
                 sensorYoffset = 0     # actually about 3.5. not implementing for now.
                 ):
        self.p = printer
        self.bedx = bedx
        self.bedxstart = bedxstart
        if bedxend is None: self.bedxend = self.bedx - sensorXoffset - 10
        self.bedy = bedy
        self.bedystart = bedystart
        self.bedyend = bedyend
        self.stepsize = stepsize
        self.sensorXoffset = sensorXoffset
        self.sensorYoffset = sensorYoffset
        self.bedLevelData = {}
    def prologue(self):
        self.p.cmd("M503",       "Report initial status")
        self.p.cmd("G29 D1",     "Turn off Unified Bed Leveling")
        self.p.cmd("G28",        "Auto Home")
        self.p.cmd("G90",        "Absolute positioning in logical coordinate space")
        self.p.cmd("G21",        "Units in mm")        
    def __probeOnePoint(self, x, y):
        self.p.cmd(f"G0 F20000.0 X{x} Y{y}", "move printhead")
        zprobe = self.p.cmd("G30", "single z probe", echo=True, maxlines=7)
        (dummy_x, dummy_y, z) = extractZProbe(zprobe)
        if z == 9999.0:
            return None
        else:
            self.bedLevelData[(x,y)] = z
            return z
    def epilogue(self):
        self.p.cmd("M503", "check status at end of commands")
    def probeBed(self, filename, numSamples=1, maxTries=3):
        with open(filename, 'w', newline='') as csvfile:
            csvwriter = csv.writer(csvfile)
            for y in range(self.bedystart, self.bedyend, self.stepsize):
                for x in range(self.bedxstart, self.bedxend, self.stepsize):
                    zvalues = []
                    tries = 0
                    while len(zvalues) < numSamples and tries < maxTries:
                         z = self.__probeOnePoint(x, y)
                         tries += 1
                         if z is None:
                             pass # will already have reinitialized
                         else:
                             zvalues.append(z)
                    if len(zvalues)==0:
                        z = 9999.0
                    else:
                        z = sum(zvalues)/len(zvalues)
                    csvwriter.writerow([x+self.sensorXoffset, y+self.sensorYoffset, z])
            


p = Printer()
prober = Prober(p, stepsize=30)
with p:
    prober.prologue()
    prober.probeBed("xyz_output_step30_working.csv")
    prober.epilogue()
    

print(prober.bedLevelData)

for y in range(prober.bedystart, prober.bedyend, prober.stepsize):
    for x in range(prober.bedxstart, prober.bedxend, prober.stepsize):
        z = prober.bedLevelData[(x,y)]
        print(f"{z:8.2f}", end="")
    print()
print()


    
