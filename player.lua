local player = {}

testLeft = false
testRight = false
testSpace = false
testZ = false
testUP = false


currentTimerDash = 0
bonusDash = false

currentTimerJump = 0
bonusJump = false

currentTimerUP = 0
bonusJump = false

offInertieDash = false

keySpace = false
keyTrue = false


-- function player.bonusPlayer(dt)
--   -- Bonus / Compteur Dash Player
--   if (bonusDash == true) then
    
--     if currentTimerDash >= 5 then
--       currentTimerDash = 0
--       bonusDash = false
--     end
    
--     currentTimerDash = currentTimerDash + 1 * dt   
--   end
  
  
--   -- Bonus / Compteur Jump Player
--   if Hero.y >= hauteurEcran - (Hero.img:getHeight() / 2) then
--     currentTimerJump = 0
--   end
  
--   if (bonusJump == true) then
    
--     if currentTimerJump >= 1.6 then
--       currentTimerJump = 0
--       bonusJump = false
--     end
    
--     if Hero.y >= hauteurEcran - (Hero.img:getHeight() / 2) then
--       currentTimerJump = 0
--     else
--       currentTimerJump = currentTimerJump + 1 * dt   
--     end
  
--   end
  
  
--   -- Touche de raccourcis 'UP' / Inertie du jeu - Inertie réduit (Player réduit sa chute).
--   if (Hero.y > hauteurEcran - (Hero.img:getHeight() / 2)) then
    
--   else

--     if love.keyboard.isDown('up') then
--       bonusJump = false
--       testUP = true
--       Hero.y = Hero.y + (2 * (60 * dt))
      
--     elseif currentTimerDash < 0.1 and offInertieDash == true then
--       Hero.y = Hero.y + 0
--       bonusJump = true
    
--     else
--       Hero.y = Hero.y + (8 * (60 * dt))
--       bonusJump = true
--     end
    
--     offInertieDash = false
    
--   end
  
  
--   -- Touche de raccourcis 'Z' / Dash
--   if keyZ == true and Hero.y <= hauteurEcran - (Hero.img:getHeight() / 2) and love.keyboard.isDown('up') == false then
    
--     testZ = true
--     bonusDash = true
    
--     if currentTimerDash < 0.1 then
      
--       if Hero.x >= 0 + (Hero.img:getWidth() / 2) then
--         offInertieDash = true
--         Hero.x = Hero.x + -400 + dt
--       else
--         Hero.x = Hero.x + 0
--       end
      
--     end
    
--     -- REMMETRE ISDOWN SINON
--     keyZ = false
--   end
-- end


function detailsStatsPlayer()

  -- Affiche les touches de raccourcis du jeu, utiliser par l'utilisateur
  if testLeft == true then
    love.graphics.print('Controls (Direction) : LEFT', 1, 1)
    testLeft = false
  
  elseif testRight == true then
    love.graphics.print('Controls (Direction) : RIGHT', 1, 1)
    testRight = false
  end
  
  
  if testZ == true then
    love.graphics.print('Controls (Dash) : Z', 1, 14)
    testZ = false
  end


  if testUP == true then
    love.graphics.print('Controls (Inertie - Ralentisement Player) : UP', 1, 28)
    testUP = false
  end


  if testSpace == true then
    love.graphics.print('Controls (Jump) : SPACE', 1, 42)
    testSpace = false
  end
  
  
  -- Affiche version du jeu.
  love.graphics.print('v0.1.1a ', largeurEcran - 48, hauteurEcran - 15)
  
  
  -- Le timer des skills du Player
  --love.graphics.print('currentTimerDash (Couldown skills - Dash) : ' .. currentTimerDash, 1, 56)
  --love.graphics.print('currentTimerJump (Couldown skills - Jump) : ' .. currentTimerJump, 1, 80)
  
  
  -- Position x, y for Player 
  --love.graphics.print('posX : ' .. player.x, 1, 104)
  --love.graphics.print('posY : ' .. player.y, 1, 128)
  

  -- Affichage du nombre de FPS
  love.graphics.print("FPS : " .. love.timer.getFPS(), largeurEcran - 70, 10)
  
  
  -- Affichage du bouton pour reload le jeu
  --love.graphics.print("Controls (resetGame) : W", 1, 224)

end






function player.Load()
  
end

function player.Update(dt)
  --player.bonusPlayer(dt)  
end

function player.Draw()
  detailsStatsPlayer()
end

return player