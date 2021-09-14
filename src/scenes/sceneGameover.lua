local sceneGameover = {}


function sceneGameover.load()

end

function sceneGameover.update(dt)

end


function sceneGameover.draw()
    love.graphics.setColor(255, 0, 0)
    love.graphics.print("PERDU !", largeurEcran / 2, hauteurEcran / 2)
end





-- Fonction de rappel déclenchée lorsqu'une touche est enfoncée.
function sceneGameover.keypressed(key, scancode, isrepeat)

end
  

-- Fonction de rappel déclenchée lorsqu'une touche du clavier est relâchée.
function sceneGameover.keyreleased(key, scancode, isrepeat)
 
end


-- Appelé lorsque du texte est saisi par l'utilisateur.
function sceneGameover.textinput(event)
 
end


-- Fonction de rappel déclenchée lorsqu'un bouton de la souris est enfoncé.
function sceneGameover.mousepressed(x, y, button, istouch, presses)
 
end


-- Fonction de rappel déclenchée lorsqu'un bouton de la souris est relâché.
function sceneGameover.mousereleased(x, y, button, istouch, presses)
 
end


-- Fonction de rappel déclenchée lorsque la souris est déplacée.
function sceneGameover.mousemoved(x, y, dx, dy)

end


-- Fonction de rappel déclenchée lorsque la molette de la souris est déplacer.
function sceneGameover.wheelmoved(x, y)
 
end


-- Appelé lorsque le bouton de la manette de jeu virtuelle d'un joystick est enfoncé.
function sceneGameover.gamepadpressed(joystick, button)
  
end


-- Appelé lorsque le bouton de la manette de jeu virtuelle d'un joystick est relâché.
function sceneGameover.gamepadreleased(joystick, button)
 
end


-- Appelé lorsqu'un bouton du joystick est enfoncé.
function sceneGameover.joystickpressed(joystick, button)
 
end


-- Appelé lorsqu'un bouton du joystick est relâché.
function sceneGameover.joystickreleased(joystick, button)
 
end


-- Appelé lorsqu'un joystick est connecté.
function sceneGameover.joystickadded(joystick)

end


-- Appelé lorsqu'un joystick est déconnecté.
function sceneGameover.joystickremoved(joystick)

end


return sceneGameover