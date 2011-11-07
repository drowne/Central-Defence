module (..., package.seeall)

local director 	= require ("director")
local physics 	= require( "physics" )
local gamestate	= require( "gamestate" )

local _H = display.contentHeight
local _W = display.contentWidth
local distance = 400

local pointsPerEnemy = 50
local explosionSound = audio.loadSound("explosion.wav")

local enemiesLayer

function init()
	enemiesLayer = display.newGroup()
end

function removeAllEnemies()
	
	for i=1, enemiesLayer.numChildren do
	
		local child = enemiesLayer[i]
		
		if child then

			child:removeSelf()

		end
		
	end
	
	enemiesLayer:removeSelf()
	
	enemiesLayer = display.newGroup()
	
end

function new()
	
	local globalLayer = display.newGroup()
	globalLayer.name = "enemy"
	-- enemy asset
	local enemyImage = display.newImage("enemy.png")
	globalLayer:insert(enemyImage)
	enemyImage.x = 0
	enemyImage.y = 0
	enemyImage:scale(0.8, 0.8)
	
	-- set random position around the center
	local angle = math.random (0, 360)
	
	globalLayer.x = math.cos(angle) * distance + _W/2
	globalLayer.y = math.sin(angle) * distance + _H/2

	local relativeX = _W/2 - globalLayer.x
	local relativeY = _H/2 - globalLayer.y

	-- fix for the left quadrant
	local newAngle
	
	if(globalLayer.x <= _W/2) then

		newAngle = math.deg( math.atan(relativeY/relativeX) + math.pi )

	else

		newAngle = math.deg( math.atan(relativeY/relativeX) )

	end

	globalLayer.rotation = newAngle + math.deg(math.pi/2)

	physics.addBody(globalLayer, "dynamic", {density = 1.0, friction = 0.3, bounce = 0.2, radius=15})
	
	local forceX = globalLayer.x - _W/2
	local forceY = globalLayer.y - _H/2
	
	local enemySpeed = -(math.random(1,20) / 100 )
	globalLayer:setLinearVelocity(forceX*enemySpeed, forceY*enemySpeed)
	
	local function onLocalCollision(self, event)
		
		print(event.other.name)
		
		if ( event.phase == "began" ) then
			
			if event.other.name == "projectile" then
				event.other:removeSelf()
				self:removeSelf()
				gamestate.addScore(pointsPerEnemy)
				audio.play( explosionSound )
			else
				if event.other.name == "cannon" then
					self:removeSelf()
					gamestate.removeHeart()
				end
			end
			
		end
	end
	
	globalLayer.collision = onLocalCollision
	globalLayer:addEventListener("collision", globalLayer)
	
	enemiesLayer:insert(globalLayer)
	
	return globalLayer
end