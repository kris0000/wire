--[[
Copyright 2013 Wiremod Developers
https://github.com/wiremod/

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
]]--

if VERSION < 143 and VERSION > 5 then
	-- VERSION > 5 check added June 2013, to address issues regarding the Steampipe update sometimes setting VERSION to 1.
	ErrorNoHalt("WireMod: This branch of wiremod only supports Gmod13+.\n")
	return
end

if SERVER then
	-- this file
	AddCSLuaFile("autorun/wire_load.lua")

	-- shared includes
	AddCSLuaFile("wire/wireshared.lua")
	AddCSLuaFile("wire/beam_netvars.lua")
	AddCSLuaFile("wire/wiregates.lua")
	AddCSLuaFile("wire/wiremonitors.lua")
	AddCSLuaFile("wire/gpulib.lua")
	AddCSLuaFile("wire/cpulib.lua")
	AddCSLuaFile("wire/timedpairs.lua")
	AddCSLuaFile("wire/default_data_decompressor.lua")

	-- client includes
	AddCSLuaFile("wire/client/cl_wirelib.lua")
	AddCSLuaFile("wire/client/cl_modelplug.lua")
	AddCSLuaFile("wire/client/cl_wire_map_interface.lua")
	AddCSLuaFile("wire/client/wiredermaexts.lua")
	AddCSLuaFile("wire/client/wiremenus.lua")
	AddCSLuaFile("wire/client/texteditor.lua")
	AddCSLuaFile("wire/client/toolscreen.lua")
	AddCSLuaFile("wire/client/wire_expression2_browser.lua")
	AddCSLuaFile("wire/client/wire_expression2_editor.lua")
	AddCSLuaFile("wire/client/wire_filebrowser.lua")
	AddCSLuaFile("wire/client/wire_listeditor.lua")
	AddCSLuaFile("wire/client/e2helper.lua")
	AddCSLuaFile("wire/client/e2descriptions.lua")
	AddCSLuaFile("wire/client/gmod_tool_auto.lua")
	AddCSLuaFile("wire/client/sound_browser.lua")
	AddCSLuaFile("wire/client/rendertarget_fix.lua")

	-- HL-ZASM
	AddCSLuaFile("wire/client/hlzasm/hc_compiler.lua")
	AddCSLuaFile("wire/client/hlzasm/hc_opcodes.lua")
	AddCSLuaFile("wire/client/hlzasm/hc_expression.lua")
	AddCSLuaFile("wire/client/hlzasm/hc_preprocess.lua")
	AddCSLuaFile("wire/client/hlzasm/hc_syntax.lua")
	AddCSLuaFile("wire/client/hlzasm/hc_codetree.lua")
	AddCSLuaFile("wire/client/hlzasm/hc_optimize.lua")
	AddCSLuaFile("wire/client/hlzasm/hc_output.lua")
	AddCSLuaFile("wire/client/hlzasm/hc_tokenizer.lua")

	-- ZVM
	AddCSLuaFile("wire/zvm/zvm_core.lua")
	AddCSLuaFile("wire/zvm/zvm_features.lua")
	AddCSLuaFile("wire/zvm/zvm_opcodes.lua")
	AddCSLuaFile("wire/zvm/zvm_data.lua")

	AddCSLuaFile("von.lua")

	-- resource files
	resource.AddFile("materials/expression 2/cog.vmt")
	resource.AddFile("materials/wirelogo.vmt")
	resource.AddSingleFile("materials/expression 2/cog_world.vmt")
end

-- shared includes
include("wire/wireshared.lua")
include("wire/beam_netvars.lua")
include("wire/wiregates.lua")
include("wire/wiremonitors.lua")
include("wire/gpulib.lua")
include("wire/cpulib.lua")
include("wire/timedpairs.lua")
include("wire/default_data_decompressor.lua")
include("von.lua")

-- server includes
if SERVER then
	include("wire/server/wirelib.lua")
	include("wire/server/modelplug.lua")
	include("wire/server/radiolib.lua")
	include("wire/server/debuggerlib.lua")
end

-- client includes
if CLIENT then
	include("wire/client/cl_wirelib.lua")
	include("wire/client/cl_modelplug.lua")
	include("wire/client/cl_wire_map_interface.lua")
	include("wire/client/wiredermaexts.lua")
	include("wire/client/wiremenus.lua")
	include("wire/client/toolscreen.lua")
	include("wire/client/texteditor.lua")
	include("wire/client/wire_expression2_browser.lua")
	include("wire/client/wire_expression2_editor.lua")
	include("wire/client/wire_filebrowser.lua")
	include("wire/client/wire_listeditor.lua")
	include("wire/client/e2helper.lua")
	include("wire/client/e2descriptions.lua")
	include("wire/client/gmod_tool_auto.lua")
	include("wire/client/sound_browser.lua")
	include("wire/client/rendertarget_fix.lua")
	include("wire/client/hlzasm/hc_compiler.lua")
	
	-- Temporary workaround while OnEntityCreated isn't working...
	timer.Create("OnEntityCreatedWorkaround", 10, 1, function() hook.Call("OnEntityCreated",GAMEMODE,LocalPlayer()) end)
end

-- Load UWSVN, done here so its definitely after Wire is loaded.
if file.Find("wire/uwsvn_load.lua","LUA")[1] then
	if SERVER then AddCSLuaFile( "wire/uwsvn_load.lua" ) end
	include("wire/uwsvn_load.lua")
end
