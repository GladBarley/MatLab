function RDK_HandE_DO(run_task,run_part)
    %test_values without global
    %RDK = Robolink;
    %run_task = "activate"; %activate, open, open_20mm, close
    %run_part=["pick" "red"]; %[ "", "pick", "place"] ["", "red", "green", "blue"]
    
    %replaced by global
    global RDK;

    rdk_real_robot = RDK.getParam('RUN_MODE');
    %RUN_Mode "0"=false =>simulation
    %RUN_Mode "1"=true =>real-robot
    
    if rdk_real_robot == "0"
        %SIM
        RDK.setRunMode(RDK.RUNMODE_SIMULATE)
        if run_task == "activate"
            fprintf('SIM: Gripper ' + run_task)
            run = RDK.Item('HandE_CLOSE_SIM'); %dummy
        elseif run_task == "open"
            fprintf('SIM: Gripper ' + run_task)
            run = RDK.Item('HandE_OPEN_SIM');
        elseif run_task == "open_20mm"
            fprintf('SIM: Gripper ' + run_task)
            run = RDK.Item('HandE_OPEN_SIM_20mm');
        elseif run_task == "close"
            fprintf('SIM: Gripper ' + run_task)
            run = RDK.Item('HandE_CLOSE_SIM');
        else
            fprintf(strcat('Error! run_task = activate, open, open_20mm, close ??? \n'))
            return
        end
    else
        %REL
        RDK.setRunMode(RDK.RUNMODE_SIMULATE)
        if run_task == "activate"
            run = RDK.Item('hande_activate_gripper');
            fprintf('REL: Gripper ' + run_task)
            %Run HandE Programm in simulation
            %RDK.Item('hande_activate_gripper').RunProgram();
        elseif run_task == "open"
            run = RDK.Item('hande_open_gripper');
            fprintf('REL: Gripper ' + run_task)
            %run = RDK.Item('HandE_OPEN_DIO');
        elseif run_task == "open_20mm"
            run = RDK.Item('hande_close_gripper');
            fprintf('REL: Gripper ' + run_task)
            %run = RDK.Item('HandE_CLOSE_DIO');
        elseif run_task == "close"
            run = RDK.Item('hande_close_gripper');
            fprintf('REL: Gripper ' + run_task)
            %run = RDK.Item('HandE_CLOSE_DIO');
        else
            fprintf(strcat('Error! run_task = activate, open, open_20mm, close ??? \n'))
            return
        end
    end
    
%     %run selection
    run.RunProgram();
    RDK.setRunMode(RDK.RUNMODE_RUN_ROBOT)
    while run.Busy()
        fprintf('.')
        pause(0.05)
    end
    
    fprintf('_done! \n')
    
    if "0" == "0"
        %SIM %attach part
        RDK.setRunMode(RDK.RUNMODE_SIMULATE)
        if run_part(1) == "pick"
            run = RDK.Item( char( 'pick_'+run_part(2)+'_sim') );
            %run selection
            run.RunProgram();
            fprintf('SIM: PICK: ' + run_part(2) + ' part')
            while run.Busy()
                fprintf('.')
                pause(0.05)
            end
            fprintf('_done! \n')
        elseif run_part(1) == "place"
            run = RDK.Item( char( 'place_'+run_part(2)+'_sim') );
            %run selection
            run.RunProgram();
            fprintf('SIM: PLACE: ' + run_part(2) + ' part')
            while run.Busy()
                fprintf('.')
                pause(0.05)
            end
            fprintf('_done! \n')
        else
            fprintf('SIM: PICK: no part selected!\n')
        end
    end  
end