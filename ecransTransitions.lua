local ecransTransitions = {}
ecransTransitions.Draw = {}


EcranTransitionMenu = true
EcranTransitionInMenu = false
EcranTransitionGamePlay = true
EcranTransitionInGamePlay = false
EcranTransitionGameOver = false


counterOpacitySplashScreen = 0;
counterOpacityMenu = 1;

counterOpacityInMenu = 0;
counterOpacityGamePlay = 1;

counterOpacityInGamePlay= 0;
counterOpacityGameOver = 1;





function ecransTransitions.Update(dt)
  
  -- Ecran de transition (opacity) a la fin du SplashScreen et au début de la scène du Menu.
  --if playingVideo == true and counterOpacitySplashScreen <= 1 and counterTimeSplashScreen >= 1400 then 
    --counterOpacitySplashScreen = counterOpacitySplashScreen + 0.009
    
  --elseif counterOpacitySplashScreen >= 1 then
    --counterOpacitySplashScreen = 0
  --end
  
  if playingVideo == false and counterOpacityMenu > 0  and EcranTransitionMenu == true then
    sceneMenu = true
    counterOpacityMenu = counterOpacityMenu - 0.005
    
  elseif counterOpacityMenu <= 0 then
    counterOpacityMenu = 1
    EcranTransitionMenu = false
  end
  
  
  
  -- Ecran de transition (opacity) a la fin du Menu et au début de la scène de GamePlay.
  if counterOpacityInMenu <= 1 and sceneGameplayActiver == true then
    EcranTransitionInMenu = true
    counterOpacityInMenu = counterOpacityInMenu + 0.005
  elseif counterOpacityInMenu >= 1 then
    counterOpacityInMenu = 0
    EcranTransitionInMenu = false
    sceneMenu = false
    sceneGameplay = true
  end
  
  -- Remettre la variable EcranTransitionGamePlay a true si il quitte le GamePlay
  if counterOpacityGamePlay > 0 and sceneGameplay == true and EcranTransitionGamePlay == true then
    counterOpacityGamePlay = counterOpacityGamePlay - 0.005
    
  elseif counterOpacityGamePlay <= 0 then
    counterOpacityGamePlay = 1
    EcranTransitionGamePlay = false
  end


  
  -- Manque a faire la transition quand on perd vers l'écran de gameover
  
end








function ecransTransitions.Draw.SplashScreen()
  love.graphics.setColor(0, 0, 0, counterOpacitySplashScreen)
  love.graphics.rectangle("fill", 0, 0, largeurEcran, hauteurEcran)
  love.graphics.setColor(1, 1, 1, 1)
end


function ecransTransitions.Draw.Menu()
  if EcranTransitionMenu == true then
    love.graphics.setColor(0, 0, 0, counterOpacityMenu)
    love.graphics.rectangle("fill", 0, 0, largeurEcran, hauteurEcran)
    love.graphics.setColor(1, 1, 1, 1)
  end
  
  if EcranTransitionInMenu == true then
    love.graphics.setColor(0, 0, 0, counterOpacityInMenu)
    love.graphics.rectangle("fill", 0, 0, largeurEcran, hauteurEcran)
    love.graphics.setColor(1, 1, 1, 1)
  end
end


function ecransTransitions.Draw.GamePlay()
  if EcranTransitionGamePlay == true then
    love.graphics.setColor(0, 0, 0, counterOpacityGamePlay)
    love.graphics.rectangle("fill", 0, 0, largeurEcran, hauteurEcran)
    love.graphics.setColor(1, 1, 1, 1)
  end
  
  if EcranTransitionInGamePlay == true then
    love.graphics.setColor(0, 0, 0, counterOpacityInGamePlay)
    love.graphics.rectangle("fill", 0, 0, largeurEcran, hauteurEcran)
    love.graphics.setColor(1, 1, 1, 1)
  end
end


function ecransTransitions.Draw.GameOver()
  
end
  
return ecransTransitions