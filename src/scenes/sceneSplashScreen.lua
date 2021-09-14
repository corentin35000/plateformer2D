local sceneSplashScreen = {}


function sceneSplashScreen.load()

  -- Video SplashScreen for Studio.
  -- La variable video est un Objet, qui contient le SplashScreen du Studio, il prend en parametre un boolean qui prend true si le son de la vidéo doit être activé.
  -- Une variable pour compter la durer de la video et puis ensuite jouer le SplashScreen.
  video = love.graphics.newVideo("video/splashScreenStudio.ogv", {audio = true, dpiscale = 1})
  videoWidth = video:getWidth()
  videoHeight = video:getHeight()
  counterTimeSplashScreen = 0
  video:play()
  
end


function sceneSplashScreen.update(dt)
  
  -- Video SplashScreen for Studio / isPlaying() return true or false -> Obtient si la vidéo est en cours de lecture.
  -- Counter pour la video
  playingVideo = video:isPlaying()
  
  -- Utiliser le deltaTime sinon risque de pas avoir la même vitesse sur tout les PC (A REVOIR)
  if playingVideo == true then
    counterTimeSplashScreen = counterTimeSplashScreen + 1
  end
  
  -- Cursor non visible lors du SplashScreen
  if playingVideo == true then
    love.mouse.setVisible(false)
  else
    love.mouse.setVisible(true)
  end

end


function sceneSplashScreen.draw()

  if playingVideo == true then
    -- Affichage de la video
    love.graphics.draw(video, (largeurEcran / 2), (hauteurEcran / 2), 0, 1, 1, (videoWidth / 2), (videoHeight / 2))

    -- Effet de transition d'ecran
    ecransTransitionsModule.Draw.SplashScreen()
  elseif playingVideo == false then
    stateScene = "Menu"
  end

end





-- Fonction de rappel déclenchée lorsqu'une touche est enfoncée.
function sceneSplashScreen.keypressed(key, scancode, isrepeat)

end
  

-- Fonction de rappel déclenchée lorsqu'une touche du clavier est relâchée.
function sceneSplashScreen.keyreleased(key, scancode, isrepeat)
 
end


-- Appelé lorsque du texte est saisi par l'utilisateur.
function sceneSplashScreen.textinput(event)
 
end


-- Fonction de rappel déclenchée lorsqu'un bouton de la souris est enfoncé.
function sceneSplashScreen.mousepressed(x, y, button, istouch, presses)
 
end


-- Fonction de rappel déclenchée lorsqu'un bouton de la souris est relâché.
function sceneSplashScreen.mousereleased(x, y, button, istouch, presses)
 
end


-- Fonction de rappel déclenchée lorsque la souris est déplacée.
function sceneSplashScreen.mousemoved(x, y, dx, dy)

end


-- Fonction de rappel déclenchée lorsque la molette de la souris est déplacer.
function sceneSplashScreen.wheelmoved(x, y)
 
end


-- Appelé lorsque le bouton de la manette de jeu virtuelle d'un joystick est enfoncé.
function sceneSplashScreen.gamepadpressed(joystick, button)
  
end


-- Appelé lorsque le bouton de la manette de jeu virtuelle d'un joystick est relâché.
function sceneSplashScreen.gamepadreleased(joystick, button)
 
end


-- Appelé lorsqu'un bouton du joystick est enfoncé.
function sceneSplashScreen.joystickpressed(joystick, button)
 
end


-- Appelé lorsqu'un bouton du joystick est relâché.
function sceneSplashScreen.joystickreleased(joystick, button)
 
end


-- Appelé lorsqu'un joystick est connecté.
function sceneSplashScreen.joystickadded(joystick)

end


-- Appelé lorsqu'un joystick est déconnecté.
function sceneSplashScreen.joystickremoved(joystick)

end


return sceneSplashScreen