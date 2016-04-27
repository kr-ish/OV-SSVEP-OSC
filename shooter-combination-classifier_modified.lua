
class_count = 0

-- this function is called when the box is initialized
function initialize(box)
	box:log("Trace", "initialize has been called")
	
	dofile(box:get_config("${Path_Data}") .. "/plugins/stimulation/lua-stimulator-stim-codes.lua")

	class_count = box:get_setting(2)
	
	-- inspects the box topology
        box:log("Info", string.format("box has %i input(s)", box:get_input_count()))
        box:log("Info", string.format("box has %i output(s)", box:get_output_count()))
        box:log("Info", string.format("box has %i setting(s)", box:get_setting_count()))
        for i = 1, box:get_setting_count() do
                box:log("Info", string.format(" - setting %i has value [%s]", i, box:get_setting(i)))
        end
end

function uninitialize(box)
	box:log("Trace", "uninitialize has been called")
end

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
						box:send_stimulation(2, i, t,0)
						--io.write(decision,"\n")
						--io.write("1\n")
						decided = true
					else
						decision = 0
						--io.write(decision,"\n")
						--io.write("0\n")
						box:send_stimulation(2, 0, t,0)
						
					end

				end
				box:remove_stimulation(i, 1)
			end
			
			if decision ~= 0 then
				box:send_stimulation(1, OVTK_StimulationId_Label_00 + decision - 1, box:get_current_time() + 0.01, 0)
			end

		end
		box:send_stimulation(2, -1, t,0)
		box:sleep()
	end
end
