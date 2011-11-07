module (..., package.seeall)

local director 	 = require ("director")
local projectile = require("projectile")
local physics 	 = require( "physics" )
local globalLayer

local _H = display.contentHeight
local _W = display.contentWidth

local cannonInstance
local newAngle
local timerID
local canShoot = false
local delayToShoot = 300
local bulletLayer
local laserSound = audio.loadSound("laser.wav")

local canCreate = true

function removeAllProjectiles()
	
	for i=1, bulletLayer.numChildren do
	
		local child = bulletLayer[i]
		
		if child then
		
			if child.x < -200 or child.x > _W + 200 or child.y < 0 or child.y > _H then
				
				bulletLayer:remove(i)

			end
		
		end
		
	end
	
	bulletLayer:removeSelf()
	
	bulletLayer = display.newGroup()
	globalLayer:insert(bulletLayer)
	
end

function checkOutOfWindow(event)
	
	canCreate = false
	
	for i=1, bulletLayer.numChildren do
	
		local child = bulletLayer[i]
		
		if child then
		
			if child.x < -200 or child.x > _W + 200 or child.y < 0 or child.y > _H then
				
				bulletLayer:remove(i)

			end
		
		end
		
	end
	
	
	canCreate = true

end

function new()
	
	globalLayer = display.newGroup()
	
	
	bulletLayer = display.newGroup()
	globalLayer:insert(bulletLayer)
	
	cannonInstance = display.newImage("cannon.png", true)
	cannonInstance.name = "cannon"
	cannonInstance.x = _W/2
	cannonInstance.y = _H/2
	--cannonInstance:scale(0.5, 0.5)
	
	physics.addBody(cannonInstance, "kinematic", {density=0.1, friction=1.0, bounce=0.5, radius=50, isSensor=true});
	
	globalLayer:insert(cannonInstance)
	
	Runtime:addEventListener("enterFrame", checkOutOfWindow)
	
	return globalLayer
end

function shoot()
	
	canShoot = true
	timerID = timer.performWithDelay(delayToShoot, shoot)
	
	if canCreate then
		audio.play( laserSound )
		bulletLayer:insert(projectile.new(newAngle))
	end
	
end

function startShooting()
	
	if not canShoot then
		shoot()
	end
	
end

function stopShooting()
	
	if timerID then
		timer.cancel(timerID)
		timerID = nil
		canShoot = false
	end
	
end

function setRotation(_x, _y)
	
	local relativeX = cannonInstance.x - _x
	local relativeY = cannonInstance.y - _y
	
	
	-- fix for the left quadrant
	
	if(_x <= _W/2) then

		newAngle = math.deg( math.atan(relativeY/relativeX) + math.pi )
		
	else

		newAngle = math.deg( math.atan(relativeY/relativeX) )
			
	end
	
	cannonInstance.rotation = newAngle
	
end

function getRotation()
	 return cannonInstance.rotation
end