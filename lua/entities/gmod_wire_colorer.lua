AddCSLuaFile()
DEFINE_BASECLASS( "base_wire_entity" )
ENT.PrintName       = "Wire Colorer"
ENT.RenderGroup		= RENDERGROUP_BOTH
ENT.WireDebugName	= "Colorer"


-- Shared

function ENT:SetupDataTables()
	self:NetworkVar( "Float", 0, "BeamLength" )
end

if CLIENT then return end -- No more client

function ENT:Initialize()
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self.Inputs = WireLib.CreateSpecialInputs(self, { "Fire", "R", "G", "B", "A", "RGB" }, {"NORMAL", "NORMAL", "NORMAL", "NORMAL", "NORMAL", "VECTOR"})
	self.Outputs = Wire_CreateOutputs(self, {"Out"})
	self.InColor = Color(255, 255, 255, 255)
	self:SetBeamLength(2048)
end

function ENT:Setup(outColor,Range)
	if(outColor)then
		self.outColor = outColor
		local onames = {}
		table.insert(onames, "R")
		table.insert(onames, "G")
		table.insert(onames, "B")
		table.insert(onames, "A")
		Wire_AdjustOutputs(self, onames)
	end
	if Range then self:SetBeamLength(Range) end
	self:ShowOutput()
end

local function CheckPP(ply, ent)
	if !IsValid(ply) or !IsValid(ent) then return false end
	if CPPI then
		-- Temporary, done this way due to certain PP implementations not always returning a value for CPPICanTool
		if ent == ply then return true end
		if ent:CPPICanTool( ply, "colour" ) == false then return false end
	end
	return true
end

function ENT:TriggerInput(iname, value)
	if iname == "Fire" then
		if value ~= 0 then
			local vStart = self:GetPos()
			local vForward = self:GetUp()

			local trace = {}
				trace.start = vStart
				trace.endpos = vStart + (vForward * self:GetBeamLength())
				trace.filter = { self }
			local trace = util.TraceLine( trace )

			if !CheckPP( self.pl, trace.Entity ) then return end
			if trace.Entity:IsPlayer() then
				trace.Entity:SetColor(Color(self.InColor.r, self.InColor.g, self.InColor.b, 255))
			else
				trace.Entity:SetColor(Color(self.InColor.r, self.InColor.g, self.InColor.b, self.InColor.a))
				trace.Entity:SetRenderMode(self.InColor.a == 255 and RENDERMODE_NORMAL or RENDERMODE_TRANSALPHA )
			end
		end
	elseif iname == "R" then
		self.InColor.r = math.Clamp(value, 0, 255)
	elseif iname == "G" then
		self.InColor.g = math.Clamp(value, 0, 255)
	elseif iname == "B" then
		self.InColor.b = math.Clamp(value, 0, 255)
	elseif iname == "A" then
		self.InColor.a = math.Clamp(value, 0, 255)
	elseif iname == "RGB" then
		self.InColor = Color( value[1], value[2], value[3], self.InColor.a )
	end
end

function ENT:ShowOutput()
	local text
	if self.Outputs["R"] then
		text = "Color = "
		.. math.Round(self.Outputs["R"].Value*1000)/1000 .. ", "
		.. math.Round(self.Outputs["G"].Value*1000)/1000 .. ", "
		.. math.Round(self.Outputs["B"].Value*1000)/1000 .. ", "
		.. math.Round(self.Outputs["A"].Value*1000)/1000
	end
	self:SetOverlayText( text )
end

function ENT:Think()
	self.BaseClass.Think(self)
	if self.Outputs["R"]then
		local vStart = self:GetPos()
		local vForward = self:GetUp()

		local trace = {}
			trace.start = vStart
			trace.endpos = vStart + (vForward * self:GetBeamLength())
			trace.filter = { self }
		local trace = util.TraceLine( trace )

		if !IsValid( trace.Entity ) then return end
		local c = trace.Entity:GetColor()

		Wire_TriggerOutput(self,"R", c.r)
		Wire_TriggerOutput(self,"G", c.g)
		Wire_TriggerOutput(self,"B", c.b)
		Wire_TriggerOutput(self,"A", c.a)

		self:ShowOutput()
	end
	self:NextThink(CurTime() + 0.05)
	return true
end

function MakeWireColorer( pl, Pos, Ang, model, outColor, Range )
	if !pl:CheckLimit( "wire_colorers" ) then return false end

	local wire_colorer = ents.Create( "gmod_wire_colorer" )
	if !IsValid(wire_colorer) then return false end

	wire_colorer:SetAngles( Ang )
	wire_colorer:SetPos( Pos )
	wire_colorer:SetModel( model )
	wire_colorer:Spawn()
	wire_colorer:Setup( outColor, Range )

	wire_colorer:SetPlayer( pl )

	pl:AddCount( "wire_colorers", wire_colorer )

	return wire_colorer
end
duplicator.RegisterEntityClass("gmod_wire_colorer", MakeWireColorer, "Pos", "Ang", "Model", "outColor", "Range")
