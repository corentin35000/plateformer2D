local sceneKeyAccess = {}


local inputClient = ""



function sceneKeyAccess.load()

end

function sceneKeyAccess.update(dt)

end


function sceneKeyAccess.draw()
    love.graphics.setColor(255, 0, 0)
    love.graphics.print("KEY PRE-ALPHA : ", largeurEcran / 2, hauteurEcran / 2)
    love.graphics.print("ENTER KEY FOR ACCESS : " .. inputClient, largeurEcran / 2, hauteurEcran / 3)

end





function sceneKeyAccess.keypressed(key, scancode, isrepeat)
    if key == "space" then
        if inputClient == keyAccessOfficiel then
            print("KEY PRE-ALPHA VALID !")
        else
            print("KEY PRE-ALPHA NO VALID !")
        end
    end
end


-- Fonction de rappel déclenchée lorsqu'une touche du clavier est relâchée.
function sceneKeyAccess.keyreleased(key, scancode, isrepeat)
 
end


-- Appelé lorsque du texte est saisi par l'utilisateur.
function sceneKeyAccess.textinput(event)
    inputClient = inputClient .. event
end


-- Fonction de rappel déclenchée lorsqu'un bouton de la souris est enfoncé.
function sceneKeyAccess.mousepressed(x, y, button, istouch, presses)
 
end


-- Fonction de rappel déclenchée lorsqu'un bouton de la souris est relâché.
function sceneKeyAccess.mousereleased(x, y, button, istouch, presses)
 
end


-- Fonction de rappel déclenchée lorsque la souris est déplacée.
function sceneKeyAccess.mousemoved(x, y, dx, dy)

end


-- Fonction de rappel déclenchée lorsque la molette de la souris est déplacer.
function sceneKeyAccess.wheelmoved(x, y)
 
end


-- Appelé lorsque le bouton de la manette de jeu virtuelle d'un joystick est enfoncé.
function sceneKeyAccess.gamepadpressed(joystick, button)
  
end


-- Appelé lorsque le bouton de la manette de jeu virtuelle d'un joystick est relâché.
function sceneKeyAccess.gamepadreleased(joystick, button)
 
end


-- Appelé lorsqu'un bouton du joystick est enfoncé.
function sceneKeyAccess.joystickpressed(joystick, button)
 
end


-- Appelé lorsqu'un bouton du joystick est relâché.
function sceneKeyAccess.joystickreleased(joystick, button)
 
end


-- Appelé lorsqu'un joystick est connecté.
function sceneKeyAccess.joystickadded(joystick)

end


-- Appelé lorsqu'un joystick est déconnecté.
function sceneKeyAccess.joystickremoved(joystick)

end


return sceneKeyAccess