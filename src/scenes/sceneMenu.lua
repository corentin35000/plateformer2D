local sceneMenu = {}


-- Les images du background du Menu et les bouttons du Menu.
imgMenu = {} 
imgMenu.background = nil
imgMenu.play = nil
imgMenu.options = nil
imgMenu.exit = nil



function sceneMenu.load()
  -- Initialiser/Charger les images du Menu
  imgMenu.background = love.graphics.newImage("assets/background_menu.jpg")
  imgMenu.play = love.graphics.newImage("assets/menu_play.png")
  imgMenu.options = love.graphics.newImage("assets/menu_options.png")
  imgMenu.exit = love.graphics.newImage("assets/menu_exit.png")


  -- Récupère le scaleX et scaleY pour adapter le background a n'importe quel taille d'écran.
  imgBackgroundMenuScaleX, imgBackgroundMenuScaleY = adaptImageToScreenSize(imgMenu.background)
end


function sceneMenu.update()

  
end


function sceneMenu.draw()
  -- Affichage du background du Menu.
  love.graphics.draw(imgMenu.background, 0, 0, 0, imgBackgroundMenuScaleX, imgBackgroundMenuScaleY)


  -- Affichages des bouttons du Menu.
  love.graphics.draw(imgMenu.play, (largeurEcran / 2), (hauteurEcran / 3), 0, 1, 1, imgMenu.play:getWidth() / 2, imgMenu.play:getHeight() / 2)
  love.graphics.draw(imgMenu.options, (largeurEcran / 2), (hauteurEcran / 2), 0, 1, 1, imgMenu.options:getWidth() / 2, imgMenu.options:getHeight() / 2)
  love.graphics.draw(imgMenu.exit, (largeurEcran / 2), (hauteurEcran / 1.5), 0, 1, 1, imgMenu.exit:getWidth() / 2, imgMenu.exit:getHeight() / 2)


  --
  love.graphics.print("Version : " .. versionJeuLocal, largeurEcran - 80, hauteurEcran - 30)


  -- 
  if versionJeuLocal < tonumber(versionJeuOfficiel) then
    love.graphics.print("Une mise à jour est disponible pour la version : " .. versionJeu, largeurEcran - 350, 10)
  end
end





-- Fonction de rappel déclenchée lorsqu'une touche est enfoncée.
function sceneMenu.keypressed(key, scancode, isrepeat)
  if key == "space" then
    stateScene = "Gameplay"
  end
end
  

-- Fonction de rappel déclenchée lorsqu'une touche du clavier est relâchée.
function sceneMenu.keyreleased(key, scancode, isrepeat)
 
end


-- Appelé lorsque du texte est saisi par l'utilisateur.
function sceneMenu.textinput(event)
 
end


-- Fonction de rappel déclenchée lorsqu'un bouton de la souris est enfoncé.
function sceneMenu.mousepressed(x, y, button, istouch, presses)
 
end


-- Fonction de rappel déclenchée lorsqu'un bouton de la souris est relâché.
function sceneMenu.mousereleased(x, y, button, istouch, presses)
 
end


-- Fonction de rappel déclenchée lorsque la souris est déplacée.
function sceneMenu.mousemoved(x, y, dx, dy)

end


-- Fonction de rappel déclenchée lorsque la molette de la souris est déplacer.
function sceneMenu.wheelmoved(x, y)
 
end


-- Appelé lorsque le bouton de la manette de jeu virtuelle d'un joystick est enfoncé.
function sceneMenu.gamepadpressed(joystick, button)
  
end


-- Appelé lorsque le bouton de la manette de jeu virtuelle d'un joystick est relâché.
function sceneMenu.gamepadreleased(joystick, button)
 
end


-- Appelé lorsqu'un bouton du joystick est enfoncé.
function sceneMenu.joystickpressed(joystick, button)
 
end


-- Appelé lorsqu'un bouton du joystick est relâché.
function sceneMenu.joystickreleased(joystick, button)
 
end


-- Appelé lorsqu'un joystick est connecté.
function sceneMenu.joystickadded(joystick)

end


-- Appelé lorsqu'un joystick est déconnecté.
function sceneMenu.joystickremoved(joystick)

end


return sceneMenu