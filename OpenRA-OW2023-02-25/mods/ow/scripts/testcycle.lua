
DayLighting = function()
	DaylightRed = 1.0
	DaylightGreen = 1.0
	DaylightBlue = 1.0
	DaylightAmbient = 1.0
end

NightLighting = function()
	DaylightRed = 0.75
	DaylightGreen = 0.85
	DaylightBlue = 1.5
	DaylightAmbient = 0.55
end

AdjustLighting = function()
	if (Lighting.Red < DaylightRed + TargetRed) then
		Lighting.Red = Lighting.Red + 0.0001
	elseif (Lighting.Red > DaylightRed + TargetRed) then
		Lighting.Red = Lighting.Red - 0.0001
	end

	if (Lighting.Green < DaylightGreen + TargetGreen) then
		Lighting.Green = Lighting.Green + 0.0001
	elseif (Lighting.Green > DaylightGreen + TargetGreen) then
		Lighting.Green = Lighting.Green - 0.0001
	end

	if (Lighting.Blue < DaylightBlue + TargetBlue) then
		Lighting.Blue = Lighting.Blue + 0.0001
	elseif (Lighting.Blue > DaylightBlue + TargetBlue) then
		Lighting.Blue = Lighting.Blue - 0.0001
	end

	if (Lighting.Ambient < DaylightAmbient + TargetAmbient) then
		Lighting.Ambient = Lighting.Ambient + 0.0001
	elseif (Lighting.Ambient > DaylightAmbient + TargetAmbient) then
		Lighting.Ambient = Lighting.Ambient - 0.0001
	end
end

ticks = 0

Tick = function()
	if (Creeps.HasPrerequisites({"environment.days"})) then
		ticks = ticks + 1
		if (Time >= SunRise) then
			DayLighting()
			Time = 0
		elseif (Time == SunSet) then
			NightLighting()
		end

		Time = Time + 1

		AdjustLighting()
	end

	if (Creeps.HasPrerequisites({"environment.weather"})) then
			if (Utils.RandomInteger(1, 200) == 10) then
			local delay = Utils.RandomInteger(1, 10)
			Lighting.Flash("LightningStrike", delay)
			DoStrike()
			Trigger.AfterDelay(delay, function()
				Media.PlaySound("thunder" .. Utils.RandomInteger(1,6) .. ".aud")
			end)
		end
		if (Utils.RandomInteger(1, 200) == 10) then
			Media.PlaySound("thunder-ambient.aud")
		end
	end
end
Time = 0

TargetRed = 0.0
TargetGreen = 0.0
TargetBlue = 0.0
TargetAmbient = 0.0

DaylightRed = 1.0
DaylightGreen = 1.0
DaylightBlue = 1.0
DaylightAmbient = 1.0

SunRise = 30000
SunSet = 15000

DoStrike = function()
	Reinforcements.Reinforce(Creeps, {"1tnk.lightning"}, {Map.RandomCell()}, 1)
end

SpawnWaterDerricks = function(amount)
	local i = 0;
	while (i < amount) do
		NewCell = Map.RandomCell()
		if(Map.TerrainType(NewCell) == "Water") then
			Reinforcements.Reinforce(Neutral, {"1tnk.oil2"}, {NewCell}, 1)
		end
		i = i+1
	end
end

WorldLoaded = function()
	Neutral = Player.GetPlayer("Neutral")
	Creeps = Player.GetPlayer("Creeps")
	if (Creeps.HasPrerequisites({"environment.days"})) then
		Time = Utils.RandomInteger(0, SunRise)
		if (Time >= SunSet) then
			Lighting.Red = 0.75
			Lighting.Green = 0.85
			Lighting.Blue = 1.5
			Lighting.Ambient = 0.75
		end
	end
	if (not Creeps.HasPrerequisites({"techlevel.noboats"})) then
		SpawnWaterDerricks(12)
	end
end