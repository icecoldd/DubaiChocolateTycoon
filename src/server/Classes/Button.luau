--!strict
-- ServerScriptService/Server/Domain/UI/Button.lua

--[[
Button
- Encapsulates one purchase button tied to a specific plot and itemId
- Server authoritative: validates owner, calls PurchaseController, cleans up
- Reads identity from attributes (e.g., stand:SetAttribute("ItemIdToUnlock", "..."))
- Visual transport via ProximityPrompt (or Touch pad), but logic lives here

Public API:
  Button.new(args) -> Button
  :Show() -> ()
  :Hide() -> ()
  :Destroy() -> ()
  :SetAffordable(isAffordable: boolean) -> ()
  :RefreshLabels() -> () -- e.g., update cost/object text
  :OnPrereqsChanged() -> () -- dependencies met/not met
  :OnCashChanged(newCash: number) -> ()

Internal helpers (private):
  :_wirePrompt() -> ()
  :_unwirePrompt() -> ()
  :_onTriggered(player: Player) -> ()
  :_validateInteractor(player: Player) -> (boolean, string?)
  :_canShow() -> boolean
  :_isOwned() -> boolean
  :_depsSatisfied() -> boolean
  :_getCost() -> number
  :_updateVisualState() -> ()
]]

-- local ItemCatalog = require(path.to.ItemCatalog)
-- local PurchaseController = require(path.to.PurchaseController)
-- local ProfileGateway = require(path.to.ProfileGateway)
-- local EventBus = require(path.to.EventBus) -- optional

export type Button = {
	-- immutable-ish construction args
	plot: any, -- your Plot class/interface
	ownerPlayer: Player,
	itemId: string,
	stand: Instance, -- Model/Part that hosts the prompt

	-- internals
	_prompt: ProximityPrompt?,
	_busy: boolean,
	_visible: boolean,

	-- lifecycle
	Show: (self: Button) -> (),
	Hide: (self: Button) -> (),
	Destroy: (self: Button) -> (),

	-- dynamic state hooks
	SetAffordable: (self: Button, isAffordable: boolean) -> (),
	RefreshLabels: (self: Button) -> (),
	OnPrereqsChanged: (self: Button) -> (),
	OnCashChanged: (self: Button, newCash: number) -> (),

	-- private
	_wirePrompt: (self: Button) -> (),
	_unwirePrompt: (self: Button) -> (),
	_onTriggered: (self: Button, player: Player) -> (),
	_validateInteractor: (self: Button, player: Player) -> (boolean, string?),
	_canShow: (self: Button) -> boolean,
	_isOwned: (self: Button) -> boolean,
	_depsSatisfied: (self: Button) -> boolean,
	_getCost: (self: Button) -> number,
	_updateVisualState: (self: Button) -> (),
}

local Button = {}
Button.__index = Button

type NewArgs = {
	plot: any,
	ownerPlayer: Player,
	itemId: string,
	stand: Instance,
}

function Button.new(args: NewArgs): Button
	-- initialize fields (plot, ownerPlayer, itemId, stand, etc.)
	-- set default flags (_busy, _visible)
	-- optionally read/write stand attributes (ItemIdToUnlock)
	-- call self:_wirePrompt() and self:RefreshLabels()
    local self = setmetatable({}, Button)
    self.plot = args.plot
    self.ownerPlayer = args.ownerPlayer
    self.itemId = args.itemId
    self.stand = args.stand
end

-- ===== Public lifecycle =====

function Button:Show(): ()
	-- make prompt/stand visible & interactive
	-- update internal _visible state and call self:_updateVisualState()
end

function Button:Hide(): ()
	-- hide prompt/stand, disable interactions
	-- update internal _visible state and call self:_updateVisualState()
end

function Button:Destroy(): ()
	-- disconnect events, destroy prompt if owned by this class
	-- clear references to help GC
end

-- ===== Dynamic state hooks =====

function Button:SetAffordable(isAffordable: boolean): ()
	-- cosmetically reflect affordability
	-- DO NOT trust this for security (PurchaseController is source of truth)
end

function Button:RefreshLabels(): ()
	-- refresh ActionText/ObjectText/Adornments based on catalog data
end

function Button:OnPrereqsChanged(): ()
	-- react to dependency changes (show/hide/disable)
end

function Button:OnCashChanged(newCash: number): ()
	-- adjust affordability visuals; keep final checks server-side in PurchaseController
end

-- ===== Private helpers =====

function Button:_wirePrompt(): ()
	-- create/find ProximityPrompt under stand
	-- connect Triggered -> self:_onTriggered(player)
end

function Button:_unwirePrompt(): ()
	-- disconnect Triggered, cleanup prompt if owned here
end

function Button:_onTriggered(player: Player): ()
	-- debounce via self._busy
	-- validate interactor via self:_validateInteractor(player)
	-- call PurchaseController.Buy(player, self.itemId)
	-- on success: destroy button (and optionally emit an event)
end

function Button:_validateInteractor(player: Player): (boolean, string?)
	-- ensure player is the plot owner (and in same server, near stand, etc.)
	-- return true/false, and optional reason
end

function Button:_canShow(): boolean
	-- return false if owned or deps not satisfied; true otherwise
end

function Button:_isOwned(): boolean
	-- query ProfileGateway.HasItem(ownerPlayer, itemId)
end

function Button:_depsSatisfied(): boolean
	-- check ItemCatalog.Get(itemId).Dependencies against ProfileGateway
end

function Button:_getCost(): number
	-- return cost from ItemCatalog
end

function Button:_updateVisualState(): ()
	-- consolidate visibility, affordability, lock state into visuals
end

return Button
