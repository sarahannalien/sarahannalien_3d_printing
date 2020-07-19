import serial
import io
import re

class Printer:
    """Sending to and receiving from 3D printer via serial port"""
    
    def __init__(self):
        pass
    def __enter__(self):
        #print("ENTER")
        self.serial_port = serial.Serial('COM8', 38400, timeout=2)
        self.sio = io.TextIOWrapper(
            io.BufferedRWPair(self.serial_port, self.serial_port))
        #self.serial_port.open()
    def __exit__(self, type, value, tb):
        #print("EXIT")
        self.serial_port.close()

    def send(self, cmd):
        cmdline = cmd
        print(f"SEND {cmdline}")
        self.sio.write(cmd + "\n")
        self.sio.flush()
    def receive(self, echo=True):
        n = 1
        lines = []
        while n < 50:
            line = self.sio.readline().rstrip('\n')
            #print("[", n, ":", line.strip(), "]")
            if echo: print(f"{n:04} {line}")
            n+=1
            lines.append(line)
            if line.startswith("ok"):
                return lines
        raise Exception("Too many lines!")    

    def cmd(self, cmd, comment="", echo=True):
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
    raise Exception("Couldn't find Z value")

bedLevelData = {}

bedx = 310
bedxstart = 20
bedxend = 290

bedy = 310
bedystart = 20
bedyend = 290

stepsize = 80


p = Printer()
with p:
    p.cmd("M503",       "Report initial status")
    p.cmd("G29 D1",     "Turn off Unified Bed Leveling")
    p.cmd("G28",        "Auto Home")
    p.cmd("G90",        "Absolute positioning in logical coordinate space")
    p.cmd("G21",        "Units in mm")
    
    #for y in range(20,290,20):
    #    for x in range(20,290,20):
    #        print(f"x:{x}, y:{y}")

    for y in range(bedystart, bedyend, stepsize):
        for x in range(bedxstart, bedxend, stepsize):
            p.cmd(f"G0 F20000.0 X{x} Y{y} Z5", "move printhead")
            zprobe = p.cmd("G30", "single z probe", echo=False)
            coords = extractZProbe(zprobe)
            bedLevelData[(x,y)] = coords[2]
            #print(zprobe)


    p.cmd("M503", "check status at end of commands")

print(bedLevelData)
for y in range(bedystart, bedyend, stepsize):
    for x in range(bedxstart, bedxend, stepsize):
        z = bedLevelData[(x,y)]
        print(f"{z:8.2f}", end="")
    print()
print()


    
