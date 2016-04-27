-- original: shooter-combination-classifier.lua included in OpenVibe (bci-examples/ssvep/scripts)
-- modified to send decisions to a second output box (in our case, an OSC module)

-- modified by Krish Ravindranath, krish@gatech.edu
-- Georgia Tech VIP Program, Robotic Musicianship
-- Georgia Tech Center for Music Technology
-- last updated: 4/27/2016


class_count = 0

-- this function is called when the box is initialized
function initialize(box)
	box:log("Trace", "initialize has been called")
	
	-- loads the stimulator code labels, eg. OVTK_StimulationId_Label_00
	dofile(box:get_config("${Path_Data}") .. "/plugins/stimulation/lua-stimulator-stim-codes.lua")

	class_count = box:get_setting(2)
	
	-- inspects the box topology, for debugging
        box:log("Info", string.format("box has %i input(s)", box:get_input_count()))
        box:log("Info", string.format("box has %i output(s)", box:get_output_count()))
        box:log("Info", string.format("box has %i setting(s)", box:get_setting_count()))
        for i = 1, box:get_setting_count() do
                box:log("Info", string.format(" - setting %i has value [%s]", i, box:get_setting(i)))
        end
end

-- this function is called when the box is uninitialized
function uninitialize(box)
	box:log("Trace", "uninitialize has been called")
end

-- this function is called after initialization
function process(box)
	box:log("Trace", "process has been called")
	
	-- enters infinite loop
    	-- cpu will be released with a call to sleep
    	-- at the end of the loop
	while box:keep_processing() do

	-- gets current simulated time
	t = box:get_current_time()

		while box:keep_processing() and box:get_stimulation_count(1) > 0 do

			local decision = 0
			local decided = false

			-- check each input
			for i = 1, class_count do
				-- if the frequency is considered as stimulated
				if (box:get_stimulation(i, 1) - OVTK_StimulationId_Label_00 == 1) then
					if not decided then
						decision = i
						-- sends the decision to the second output of the box
						box:send_stimulation(2, i, t,0)
						decided = true
					else
						decision = 0
						-- sends 0, lack of decision, to the second output of the box
						box:send_stimulation(2, 0, t,0)
						
					end

				end
				box:remove_stimulation(i, 1)
			end
			
			if decision ~= 0 then
				-- sends decision to the VPRN server, to control the GUI
				box:send_stimulation(1, OVTK_StimulationId_Label_00 + decision - 1, box:get_current_time() + 0.01, 0)
			end

		end
		-- send -1 to the second output, to debug, can be commented out
		box:send_stimulation(2, -1, t,0)
		box:sleep()
	end
end
