-- Pong

-- TODO:
--
-- +1. Create field, 2 paddles, and 1 ball
-- -2. Randomly choose a side to launch ball towards
-- +3. Ball bounces off walls and paddles
-- -4. Game ends when the goal behind one of the paddles has been hit
--
-- + Multi-touch
-- + Version Control

blip = audio.loadSound("bullet1.wav")
explode = audio.loadSound("hurt.wav")

local paddle_width = 100
local player1
local player2
local ball
local ball2

player1 = { x0 = 0, score = 0 }
player2 = { x0 = 0, score = 0 }

local physics = require('physics')
physics.start( )
physics.setScale( 10 )
physics.setGravity( 0, 0 )

system.activate( "multitouch" )

-- Draw Field

local endzone1 = display.newRect( display.contentWidth/2, display.contentHeight-100, display.contentWidth, 200 )
endzone1.alpha = 0.5

local endzone2 = display.newRect( display.contentWidth/2, 100, display.contentWidth, 200 )
endzone2.alpha = 0.5

local player_wall_1 = display.newRect( display.contentWidth/2, 2.5+200, display.contentWidth, 5 )
physics.addBody( player_wall_1, "static", {density = 1, friction = 0, bounce = 1, isSensor = false})

local goal1 = display.newRect( display.contentWidth/2, 2.5+200, 400, 5 )
physics.addBody( goal1, "static", {density = 1, friction = 0, bounce = 1, isSensor = false})
goal1:setFillColor( 0, 0, 0 )

local player_wall_2 = display.newRect( display.contentWidth/2, display.contentHeight-2.5-200, display.contentWidth, 5)
physics.addBody( player_wall_2, "static", {density = 1, friction = 0, bounce = 1, isSensor = false})

local goal2 = display.newRect( display.contentWidth/2, display.contentHeight-2.5-200, 400, 5)
physics.addBody( goal2, "static", {density = 1, friction = 0, bounce = 1, isSensor = false})
goal2:setFillColor( 0, 0, 0 )

local wall_left = display.newRect( 2.5, display.contentHeight/2, 5, display.contentHeight-400, {density = 1, friction = 0, bounce = 1, isSensor = false} )
physics.addBody( wall_left, "static")

local wall_right = display.newRect( display.contentWidth-2.5, display.contentHeight/2, 5, display.contentHeight-400, {density = 1, friction = 0, bounce = 1, isSensor = false} )
physics.addBody( wall_right, "static")

local player1score = display.newText( player1.score, display.contentWidth/2, display.contentHeight/2 - 25, native.systemfont, 40)


local player2score = display.newText( player2.score, display.contentWidth/2, display.contentHeight/2 + 25, native.systemfont, 40)


-- Place moving objects

local paddle1 = display.newRect( display.contentWidth/2, display.contentHeight-25-200, paddle_width, 10 )
physics.addBody( paddle1, "static", {friction=0} )

local paddle2 = display.newRect( display.contentWidth/2, 25+200, paddle_width, 10 )
physics.addBody( paddle2, "static", {friction=0} )


-- Randomly choose direction and force on ball

function bulletBounce( event )
  if event.phase=="began" then
    audio.play( blip )
  end
end

function launchBall()
  ball = display.newCircle( display.contentWidth/2, display.contentHeight/2, 10, 10)
  ball.isBullet = true
  physics.addBody( ball, "dynamic", {density = 1, friction = 0, radius = 5, isSensor = false, bounce = 1} )

  ball:addEventListener( "collision", bulletBounce )

  local launchx = math.random(90,110)
  local launchy = math.random(90,110)

  if (math.random(0,1)==0) then
    launchx = -launchx
  end

  if (math.random(0,1)==0) then
    launchy = -launchy
  end

  ball:applyLinearImpulse(launchx, launchy)
end


-- Functions

function refreshScore()
  player1score.text = player1.score
  player2score.text = player2.score
end

-- Listeners


function goal1struck( event )
  if event.phase=="began" then
    player2.score = player2.score + 1
    refreshScore()
    ball:removeSelf()
    audio.play( explode )
    timer.performWithDelay( 1000, launchBall )
  end
end

goal1:addEventListener( "collision", goal1struck )

function goal2struck( event )
  if event.phase=="began" then
    player1.score = player1.score + 1
    refreshScore()
    ball:removeSelf()
    audio.play( explode )
    timer.performWithDelay( 1000, launchBall )
  end
end

goal2:addEventListener( "collision", goal2struck )


coerceOnScreen = function( object )--{{{
  if object.x < object.width/2 then
    object.x = object.width/2
  end
  if object.x > display.viewableContentWidth - object.width/2 then
    object.x = display.viewableContentWidth - object.width/2
  end
end


function paddle1touch (event)
  if "began" == event.phase then
    player1.x0 = event.x - paddle1.x

  elseif "moved" == event.phase then
    paddle1.x = event.x - player1.x0
    coerceOnScreen( paddle1 )

  elseif "ended" == phase or "cancelled" == phase then
  end

  -- Return true if touch event has been handled.
  return true
end

endzone1:addEventListener("touch", paddle1touch)

function paddle2touch (event)
  if "began" == event.phase then
    player2.x0 = event.x - paddle2.x

  elseif "moved" == event.phase then
    paddle2.x = event.x - player2.x0
    coerceOnScreen( paddle2 )

  elseif "ended" == phase or "cancelled" == phase then
  end

  -- Return true if touch event has been handled.
  return true
end

endzone2:addEventListener("touch", paddle2touch)



-- Start Game
launchBall()

