
import time
import os

from robodk import robolink    # RoboDK API
from robodk import robomath    # Robot toolbox
from robodk.robolink import ITEM_TYPE_ROBOT, ITEM_TYPE_TARGET

RDK = robolink.Robolink()
RDK.setRunMode(6)
from robodk import *      # RoboDK API
from robolink import *    # Robot toolbox

# Get the robot item from the RoboDK station
robot = RDK.Item('UR10e', ITEM_TYPE_ROBOT)

while(1):
    target1 = RDK.Item('Target 1')
    target1 = target1.Joints().list()
    print(target1)

    pause(3)
    ## Getting Current Joint Value
    getJoints = robot.Joints().list()
    print(getJoints)


    ## Moving Robot to Start Position
    if getJoints != target1:
        print("Moving Robot to Target 1")
        try:
            robot.MoveL(target1)
        except:
            pause(5)
        finally:
            robot.MoveL(target1)
    else:
        print("Robot is at Target 1")

    # Gripper Open
    RDK.Disconnect()
    pause(2)
    os.system('python "Gripper Programs/GripperOpen.py"') # Please note, you have to give a correct path of the GripperOpen.py file. It's better to give relative path.
    pause(3)
    RDK.Connect()
    RDK.setRunMode(6)
    
    # Getting Target 2
    target2 = RDK.Item('Target 2')
    target2 = target2.Joints().list()
    print(target2)
    
    ## Getting Current Joint Value
    getJoints = robot.Joints().list()
    print(getJoints)


    ## Moving Robot to Start Position
    if getJoints != target2:
        print("Moving Robot to Target 2")
        try:
            robot.MoveL(target2)
        except:
            pause(5)
        finally:
            robot.MoveL(target2)
        
    else:
        print("Robot is at Target 2")
    
    # Gripper Close
    RDK.Disconnect()
    pause(2)
    os.system('python "Gripper Programs/GripperClose.py"') # Please note, you have to give a correct path of the GripperClose.py file. It's better to give relative path.
    pause(3)
    RDK.Connect()
    RDK.setRunMode(6)