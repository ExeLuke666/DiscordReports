RegisterNetEvent("Reports:CheckPermission:Client")
AddEventHandler("Reports:CheckPermission:Client", function(message, error)
    TriggerServerEvent("Reports:CheckPermission", message, false)
end)

function ShowNotification(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(false, false)
end
