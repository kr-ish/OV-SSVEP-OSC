# OV-SSVEP-OSC
Sends decisions from the SSVEP OpenVibe BCI demo as OSC messages over a network (local or other).

SSVEP demo in OpenVibe: http://openvibe.inria.fr/steady-state-visual-evoked-potentials/

Follows the same steps, but the final scenario is modified:

ssvep-bci-5-online-shooter-modified.xml runs the shooter demo using a generic file reader, allowing a stored recording to be run. It can be used to demo a working recording and is particularly useful to debug changes in the scenario and the Lua file as it doesn't require a live EEG setup. 

ssvep-bci-5-online-shooter-modified-live.xml uses live EEG data from a user.


Both scenarios include an OSC module that sends the decision data from the Lua Script module as OSC messages to any UDP/OSC reciever in any other application on the network.

Before running either scenario, the SSVEP Voter Lua Script module must be modified to replace the shooter-combination-classifier.lua file with the shooter-combination-classifier_modified.lua file.

shooter-combination-classifier_modified.lua has added code to send the decisions made based on the EEG readings to the OSC module.
