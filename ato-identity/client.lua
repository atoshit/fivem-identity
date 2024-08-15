AddEventHandler('playerSpawned', function ()
    TriggerServerEvent('ato::RegisterPlayer')
end)

RegisterCommand('addarmour', function (source, args, raw)
    SetPedArmour(PlayerPedId(), 100)
end)