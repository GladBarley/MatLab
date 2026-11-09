# Robotiq-Gripper-with-UR10e-using-RoboDK

# Problem Statement:
In this repository, I will guide you on how to establish stable communication between the Robotiq gripper and UR10e using RoboDK. Currently, we are facing various issues with the gripper integration, where it works fine in simulation but fails in the real environment. Attempts to modify the "programrobodk.script" library and make necessary amendments have not yielded successful results. When calling the gripper open/close functions in the RoboDK tree, it sometimes gets stuck, disconnects from the robot, and halts the entire process.

# Solution:
To resolve this, we will follow these steps:
1. Generate a script for the gripper to activate, close, and open. The relevant scripts have been shared in this repository.
2. Develop a program to send the gripper script via a socket program, which is also available in the repository.
3. Create a RoboDK program to move from one position to another. We will begin by activating the gripper, then moving to target 1, opening the jaws, and finally moving to target 2 and closing the jaws.

All the necessary files, including script files, RoboDK files, python socket program, and python program for RoboDK, have been included in the repository.

# Instructions for Setup:
1. Disable firewalls to avoid communication issues.
2. Change controls to Remote Control on the Tech Pendant.
3. Activate the Adaptive Grippers from Tech Pendant.
4. Obtain the Robot IP from the Tech Pendant's "About" section (located in the upper right corner).
5. Connect your Robot in RoboDK by clicking "Connect" in the toolbar and selecting the appropriate Robot UR10e.
6. If you have added the Robotiq Gripper Mechanism from the RoboDK library, it will prompt you to select the Robot UR10e.
7. In the RoboDK Tree, right-click on "Program" and select "Edit Python Script."
8. Use VSCodium to run the program. Press the "Run" button in the toolbar and select the debug configuration "Python."
9. This will execute the program both in RoboDK simulation and the real environment.

By following these steps and utilizing the provided resources, we aim to achieve seamless communication and functionality between the gripper and the UR10e robot.

Note:
a) It may give you error of Robot not Connected, for that please adjust some delays. You will achieve your result more precisely.

Thanks!
