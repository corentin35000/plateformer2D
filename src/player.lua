local player = {}


function mouvementPlayer(dt)
  -- Inertie
  player.x = player.x + player.vx
  player.vx = player.vx * 0.88

  if math.abs(player.vx) < 0.1 then
    player.vx = 0
  end


  -- Gravité
  --player.vy = player.vy + (0.7 * dt)


  -- Mise a jour pour lui set la Gravité / Inertie en continue
  player.x = player.x + player.vx
  player.y = player.y + player.vy


  -- Déplacement GAUCHE
  if love.keyboard.isDown('left') == true then
    testLeft = true;

    if player.scaleX == math.abs(player.scaleX)  then
      player.scaleX = -player.scaleX
    end

    if player.activeAnimation ~= player.activeAnimation then
      player.activeAnimation = player.activeAnimation
    end

    if player.vx > -4 then
      player.vx = player.vx - (60 * dt)
    end
  end


  -- Déplacement DROITE
  if love.keyboard.isDown('right') == true then
    testRight = true

    if player.scaleX == player.scaleX  then
      player.scaleX = math.abs(player.scaleX) -- math.abs() pour convertir le nombre négatif en positif
    end

    if player.activeAnimation ~= player.activeAnimation then
      player.activeAnimation = player.activeAnimation²
    end

    if player.vx < 4 then
      player.vx = player.vx + (60 * dt)
    end
  end
  
  
  -- Déplacement SAUTER vers le HAUT
  if keySpace == true then
    
    testSpace = true
    bonusJump = true

    if currentTimerJump < 0.1 then
      player.y = player.y - 250 + dt;
    else
      player.y = player.y + 0
    end
    
    keySpace = false
  end
  
end



function player.load()
  
end


function player.update(dt)
  --mouvementPlayer(dt)
  --player.bonusPlayer(dt)  
end


function player.draw()

end


return player