-- Services
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

-- Modules
local Plot = require(ServerScriptService.Server.Classes.Plot)
--local PlotConfig = require(script.Parent.Parent.Shared.Configs.PlotConfigs)


local PlotService = {}
PlotService.__index = PlotService

-- Plot Cache (For quick lookup)
local _plotsByPlotID = {} -- [plotID] = Plot
local _plotsByOwnerID = {} -- [ownerID] = Plot

local function indexFactoryPlots()
    for _, FactoryPlot in ipairs(Workspace.FactoryPlots:GetChildren()) do
        if FactoryPlot:IsA("BasePart") then
            local plotObj = Plot.new(FactoryPlot)
            local id = FactoryPlot:GetAttribute("PlotID")
            assert(id, ("ERROR"))
            _plotsByPlotID[id] = plotObj
        end
    end
end

function PlotService:AssignPlayer(player)
    print("Assigning plot to player:", player.Name)
    if _plotsByOwnerID[player.UserId] then
        warn("Player already has a plot assigned:", player.Name)
        return
    end

    for _, plot in pairs(_plotsByPlotID) do
        if not plot.OwnerID then
            plot:AssignOwner(player)
            _plotsByOwnerID[player.UserId] = plot
            break
        end
    end
end

function PlotService:ReleasePlayer(player)
    print("Releasing plot for player:", player.Name)
    local plot = _plotsByOwnerID[player.UserId]
    if plot then
        plot:ReleaseOwner(player)
        _plotsByOwnerID[player.UserId] = nil
    else
        warn("No plot found for player:", player.Name)
    end
end

function PlotService.Init()
    print("Initializing PlotService...")
    indexFactoryPlots()
end

return PlotService