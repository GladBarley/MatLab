
import socket
import time

HOST = "192.168.1.100" 
PORT = 30002

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((HOST, PORT))

f = open("[Please Add GripperOpen.script Relative Path Here!!]", "rb")

l = f.read(1024)
while (l):
    s.send(l)
    l = f.read(1024)
s.close()
time.sleep(1)