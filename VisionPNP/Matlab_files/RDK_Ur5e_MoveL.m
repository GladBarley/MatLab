function RDK_Ur5e_MoveL(Target)
    %replaced by global
    %RDK = Robolink;
    global RDK;
    
    rdk_real_robot = RDK.getParam('RUN_MODE');
    
    if rdk_real_robot == "0"
        RDK.setRunMode(RDK.RUNMODE_SIMULATE);
    else
        RDK.setRunMode(RDK.RUNMODE_RUN_ROBOT);
    end

    % Get the robot item:
    robot = RDK.Item('UR5e');
    Target = RDK.Item(Target);

    robot.setPoseFrame(Target.Parent())
    robot.MoveL(Target)
    pause(0.05)
end