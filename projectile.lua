module (..., package.seeall)

local director 	= require ("director")
local physics 	= require( "physics" )

local globalLayer

local _H = display.contentHeight
local _W = display.contentWidth

local distance = 60
local bulletSpeed = 10

function new( _newAngle )
	
	globalLayer = display.newGroup()
	globalLayer.name = "projectile"
	local bulletImage = display.newImage("bullet.png")
	globalLayer:insert(bulletImage)
	
	-- center it
	bulletImage.x = 0
	bulletImage.y = 0
	bulletImage:scale(0.8, 0.8)
	
	globalLayer.rotation = _newAngle

	globalLayer.x = (_W/2) + math.cos(math.rad(_newAngle)) * distance
	globalLayer.y = (_H/2) + math.sin(math.rad(_newAngle)) * distance
	
	physics.addBody(globalLayer, "kinematic", {density=0.1, friction=1.0, bounce=0.5, radius=10, isSensor=true});
	
	local forceX = ((_W/2) + math.cos(math.rad(_newAngle)) * distance) - (_W/2) 
	local forceY = ((_H/2) + math.sin(math.rad(_newAngle)) * distance) - (_H/2) 
	
	globalLayer:setLinearVelocity(forceX*bulletSpeed, forceY*bulletSpeed)
	
	local function explode()
		
		
		
		bulletImage.isVisible = false
	end
	
	return globalLayer
	
end