module (..., package.seeall)

local enemy   	= require("enemy")
local physics 	= require("physics")
local cannon  	= require("cannon")
local director	= require ("director")
local highscore	= require ("highscore")
local easyfb 	= require("easyfb")

local timerID

local globalLayer
local scoreLabel
local heartLayer
local endedLayer
local startingLives = 3
local lives = 3
local startingX = 600
local heartDist = 45

local endedScoreLabel

local _H = display.contentHeight
local _W = display.contentWidth

-- spawning variables
local spawnTime = 10000
local startingEnemiesToSpawn = 5
local enemiesToSpawn = 5
local enemiesToAdd = 1

_G.gameEnded = false
local endedOnce = false

function createHearts()
	
	startingX = 600
	
	for i=1, lives do
		
		local heart = display.newImage("heart.png")
		--heart:scale(0.25,0.25)
		heartLayer:insert(heart)
		heart.x = startingX 
		startingX = startingX + heartDist
		heart.y = 25
		
	end
end

function restart()
	
	_G.firstTouch = true
	_G.gameEnded = false
	setScore(0)
	
	enemiesToSpawn = startingEnemiesToSpawn
	
	lives = startingLives
	createHearts()
	
	startSpawningEnemies()
	physics.start()
	
	endedLayer.isVisible = false
	
end

function facebook()
	
	local messageTopost = "I'm playing Central Defence on my iPhone! My highscore is " .. highscore.getHighScore() .. ", try to beat me!!!"
	easyfb.publishOnFacebook(messageTopost)
end

function new()
	
	endedLayer = display.newGroup()
	globalLayer = display.newGroup()
	heartLayer = display.newGroup()
	
	globalLayer:insert(heartLayer)
	--globalLayer:insert(endedLayer)
	
	enemy.init()
	
	-- score
	local scoreTextLabel = display.newText("SCORE:", 0,0, "Spaceboy", 30)
	scoreTextLabel:setTextColor(255, 255, 255)
	scoreTextLabel:setReferencePoint(display.TopLeftReferencePoint)
	
	scoreLabel = display.newText("0", 0,0, "Spaceboy", 30)
	scoreLabel:setTextColor(255, 255, 255)
	scoreLabel:setReferencePoint(display.TopLeftReferencePoint)
	
	globalLayer:insert(scoreTextLabel)
	globalLayer:insert(scoreLabel)
	
	scoreTextLabel.x = 0
	scoreTextLabel.y = 0
	
	scoreLabel.x = 170
	scoreLabel.y = 0
	
	-- lives
	
	createHearts()
	
	globalLayer.x = - display.contentWidth + 130
	
	return globalLayer
	
end

function setScore(newScore)
	
	scoreLabel.text = newScore
	scoreLabel:setReferencePoint(display.TopLeftReferencePoint)
	scoreLabel.x = 170
	
end

function addScore(points)
	local oldScore = scoreLabel.text
	local _newScore = oldScore + points 
	setScore(_newScore)
end

function removeHeart()
	
	if lives == 1 then
		local index = heartLayer.numChildren-lives+1
		heartLayer[index]:removeSelf()
		lives = lives - 1
		-- end game
		gameEnded()
	else
		local index = heartLayer.numChildren-lives+1
		heartLayer[index]:removeSelf()
		lives = lives - 1
	end
	
end

function startSpawningEnemies()
	
	timerID = timer.performWithDelay(spawnTime, startSpawningEnemies)
	
	for i=1,enemiesToSpawn do
		
		enemy.new()
		
	end
	
	enemiesToSpawn = enemiesToSpawn + enemiesToAdd
	
end

function stopSpawningEnemies()
	timer.cancel(timerID)
end

function showPopUp()
	

	
	if not endedOnce then
		
		endedOnce = true
		
		endedLayer.x = -_W/2 - 32
		endedLayer.y = 0
		
		local popup = display.newImage("popup.png")
		endedLayer:insert(popup)
		popup.x = _W/2 + 190
		popup.y = _H/2
		popup:scale(1.5, 1.5)
	
		endedScoreLabel = display.newText("SCORE: " .. scoreLabel.text, 0,0, "Spaceboy", 30)
		endedScoreLabel:setTextColor(255, 255, 255)
		endedScoreLabel:setReferencePoint(display.TopLeftReferencePoint)
	
		endedLayer:insert(endedScoreLabel)
		endedScoreLabel.x = _W/2 + 70
		endedScoreLabel.y = _H/2 - 100
	
		-- check highscore
	
		local score = scoreLabel.text + 0
	
		if highscore.checkHighscore( score ) then
			-- new highscore
			local highscoreLabel = display.newText("-- NEW HIGHSCORE --", 0,0, "Spaceboy", 30)
			highscoreLabel:setTextColor(255, 255, 255)
			highscoreLabel:setReferencePoint(display.TopCenterReferencePoint)

			endedLayer:insert(highscoreLabel)
			highscoreLabel.x = _W/2 + 210
			highscoreLabel.y = _H/2 - 50
		end
	
		local fbButton = ui.newButton {
			default = "fboff.png",
			over = "fbon.png",
			onPress = facebook
		}
		
		endedLayer:insert(fbButton)
		fbButton.x = _W + 330
		fbButton.y = _H - 50
	
		local restartButton = ui.newButton {
			default = "restartoff.png",
			over = "restarton.png",
			onPress = restart
		}
		
		endedLayer:insert(restartButton)
		restartButton.x = _W + 30
		restartButton.y = _H - 150
		
	else
		
		endedScoreLabel.text = "SCORE: " .. scoreLabel.text 
		endedScoreLabel:setTextColor(255, 255, 255)
		endedScoreLabel:setReferencePoint(display.TopLeftReferencePoint)
		
		endedLayer.isVisible = true
		
	end
	
end

function gameEnded()
	
	if not _G.gameEnded then
		
		_G.gameEnded = true
		
		cannon.stopShooting()
		stopSpawningEnemies()
		
		cannon.removeAllProjectiles()
		enemy.removeAllEnemies()
		
		physics.pause()
		
		-- showpop up
		
		showPopUp()
		
	end
	
end