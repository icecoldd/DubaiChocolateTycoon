local PlotService = require(script.Parent.Services.PlotService)

local Players = game:GetService("Players")

PlotService.Init()

Players.PlayerAdded:Connect(function(player)
    print("Player added:", player.Name)
    PlotService:AssignPlayer(player)
end)

Players.PlayerRemoving:Connect(function(player)
    print("Player removed:", player.Name)
    PlotService:ReleasePlayer(player)
end)