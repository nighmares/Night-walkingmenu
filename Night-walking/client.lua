local PlayerData = {}
local currentwalkingstyle = 'default'

RegisterCommand('walking-style', function()
  OpenWalkMenu()
end)

function OpenWalkMenu()
	for k, v in pairs(Config.Styles) do
		TriggerEvent('nh-context:sendMenu', {
			{
				id = k,
				header = v.label,
				txt = "Choose",
				params = {
					event = "esx-walkstyles:setwalkstyle",
					args = v.value
				}
			},
		})
	end
end

RegisterNetEvent('esx-walkstyles:setwalkstyle')
AddEventHandler('esx-walkstyles:setwalkstyle', function(anim)
	currentwalkingstyle = anim
	setwalkstyle(anim)
	TriggerServerEvent('assynu_animacje:stylchodzeniaserver', 'update', anim)
end)

function setwalkstyle(anim)
	local playerped = PlayerPedId()

	if anim == 'default' then
		ResetPedMovementClipset(playerped)
		ResetPedWeaponMovementClipset(playerped)
		ResetPedStrafeClipset(playerped)
	else
		RequestAnimSet(anim)
		while not HasAnimSetLoaded(anim) do Citizen.Wait(0) end
		SetPedMovementClipset(playerped, anim)
		ResetPedWeaponMovementClipset(playerped)
		ResetPedStrafeClipset(playerped)
	end
end

Citizen.CreateThread(function()
	while true do
		local playerhp = GetEntityHealth(PlayerPedId())-100
		if (playerhp > 50) then
			setwalkstyle(currentwalkingstyle)
		else
			setwalkstyle('move_m@injured')
		end
		Wait(10000)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	TriggerServerEvent('assynu_animacje:stylchodzeniaserver', 'get')
end)  

RegisterNetEvent('assynu_animacje:stylchodzeniaclient')
AddEventHandler('assynu_animacje:stylchodzeniaclient', function(walkstyle)
	setwalkstyle(walkstyle)
	currentwalkingstyle = walkstyle
end)
