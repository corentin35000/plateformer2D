local sceneGameplay = {}


function sceneGameplay.load()
    -- Module animationsCharacter.lua (Load)
    animationsCharactersSpinesModule.load()


    -- Module player.lua (Load)
    playerModule.load()


    -- Module mapsInGame.lua
    --mapsInGameModule.load()
end


function sceneGameplay.update(dt)
    -- Module mapsInGame.lua
    --mapsInGameModule.update()


    -- Le module animationsCharacters.lua de la fonction Update
    animationsCharactersSpinesModule.update(dt)
  

    -- Le module player.lua de la fonction Update
    playerModule.update(dt)
end


function sceneGameplay.draw()
    --
    love.graphics.setBackgroundColor(255, 255, 255, 1)


    -- Module mapsInGame.lua
    --mapsInGameModule.draw()
 
 
    -- Le module player.lua de la fonction Draw
    playerModule.draw()
 
 
    -- Le module animationsCharacters.lua de la fonction Draw
    animationsCharactersSpinesModule.draw()
   
     
    -- Effet de transition d'écran
    --ecransTransitionsModule.Draw.GamePlay()
end





-- Fonction de rappel déclenchée lorsqu'une touche est enfoncée.
function sceneGameplay.keypressed(key, scancode, isrepeat)

end
  

-- Fonction de rappel déclenchée lorsqu'une touche du clavier est relâchée.
function sceneGameplay.keyreleased(key, scancode, isrepeat)
 
end


-- Appelé lorsque du texte est saisi par l'utilisateur.
function sceneGameplay.textinput(event)
 
end


-- Fonction de rappel déclenchée lorsqu'un bouton de la souris est enfoncé.
function sceneGameplay.mousepressed(x, y, button, istouch, presses)
 
end


-- Fonction de rappel déclenchée lorsqu'un bouton de la souris est relâché.
function sceneGameplay.mousereleased(x, y, button, istouch, presses)
 
end


-- Fonction de rappel déclenchée lorsque la souris est déplacée.
function sceneGameplay.mousemoved(x, y, dx, dy)

end


-- Fonction de rappel déclenchée lorsque la molette de la souris est déplacer.
function sceneGameplay.wheelmoved(x, y)
 
end


-- Appelé lorsque le bouton de la manette de jeu virtuelle d'un joystick est enfoncé.
function sceneGameplay.gamepadpressed(joystick, button)
  
end


-- Appelé lorsque le bouton de la manette de jeu virtuelle d'un joystick est relâché.
function sceneGameplay.gamepadreleased(joystick, button)
 
end


-- Appelé lorsqu'un bouton du joystick est enfoncé.
function sceneGameplay.joystickpressed(joystick, button)
 
end


-- Appelé lorsqu'un bouton du joystick est relâché.
function sceneGameplay.joystickreleased(joystick, button)
 
end


-- Appelé lorsqu'un joystick est connecté.
function sceneGameplay.joystickadded(joystick)

end


-- Appelé lorsqu'un joystick est déconnecté.
function sceneGameplay.joystickremoved(joystick)

end


return sceneGameplay