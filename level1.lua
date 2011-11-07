module (..., package.seeall)

local director 	= require ("director")
local physics 	= require( "physics" )
local globalLayer
local gameLayer

-- external modules
local cannon	= require("cannon")
local cannonInstance
local enemy 	= require("enemy")
local gamestate = require("gamestate")

local _H = display.contentHeight
local _W = display.contentWidth

_G.firstTouch = true

function touchListener(event) 
	
	if not _G.firstTouch then

		if not _G.gameEnded then
			if event.phase == "began" then
		
				cannon.setRotation(event.x, event.y)
				cannon.startShooting()
	
			else
	
				if event.phase == "moved" then

					cannon.setRotation(event.x, event.y)

				else

					if event.phase == "ended" then

						cannon.stopShooting()

					end

				end
			
			end
		
		end
	
	else
		
		_G.firstTouch = false
	
	end
	
end

function init()
	--physics.setDrawMode( "hybrid" )
	
	physics.start()
	physics.setGravity( 0, 0 )
	
	globalLayer = display.newGroup()
	gameLayer = display.newGroup()
	globalLayer:insert(gameLayer)
	globalLayer:insert(gamestate.new())
	
end

function setupBackground()
	
	local background = display.newImage("background.png")
	gameLayer:insert(background)
	background.x = _W/2
	background.y = _H/2
	background:scale(1.5, 1.5)
	
end

function new()
	
	init()
	
	setupBackground()
	cannonInstance = cannon.new()
	gameLayer:insert(cannonInstance)
	
	gamestate.startSpawningEnemies()
	
	Runtime:addEventListener( "touch", touchListener )
	
	return globalLayer
end

