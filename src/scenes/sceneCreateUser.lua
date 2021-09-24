local sceneCreateUser = {}


function sceneCreateUser.load()

end


function sceneCreateUser.update()

  
end


function sceneCreateUser.draw()
    love.graphics.setColor(255, 0, 0)
    love.graphics.print("CREATE USER : ", largeurEcran / 2 - 50, 100)
    love.graphics.print("Username : ", largeurEcran / 2 - 50, 300)
    love.graphics.print("Password : ", largeurEcran / 2 - 50, 330)
    love.graphics.print("PasswordConfirm : ", largeurEcran / 2 - 50, 360)
    love.graphics.print("Email : ", largeurEcran / 2 - 50, 390)
end





-- Fonction de rappel déclenchée lorsqu'une touche est enfoncée.
function sceneCreateUser.keypressed(key, scancode, isrepeat)
    if "space" then
        inscriptionUser("toto", "pPassword", "coco@orange.fr")
        print("CREATE USER")
    end
end
  

-- Fonction de rappel déclenchée lorsqu'une touche du clavier est relâchée.
function sceneCreateUser.keyreleased(key, scancode, isrepeat)
 
end


-- Appelé lorsque du texte est saisi par l'utilisateur.
function sceneCreateUser.textinput(event)
 
end


-- Fonction de rappel déclenchée lorsqu'un bouton de la souris est enfoncé.
function sceneCreateUser.mousepressed(x, y, button, istouch, presses)
 
end


-- Fonction de rappel déclenchée lorsqu'un bouton de la souris est relâché.
function sceneCreateUser.mousereleased(x, y, button, istouch, presses)
 
end


-- Fonction de rappel déclenchée lorsque la souris est déplacée.
function sceneCreateUser.mousemoved(x, y, dx, dy)

end


-- Fonction de rappel déclenchée lorsque la molette de la souris est déplacer.
function sceneCreateUser.wheelmoved(x, y)
 
end


-- Appelé lorsque le bouton de la manette de jeu virtuelle d'un joystick est enfoncé.
function sceneCreateUser.gamepadpressed(joystick, button)
  
end


-- Appelé lorsque le bouton de la manette de jeu virtuelle d'un joystick est relâché.
function sceneCreateUser.gamepadreleased(joystick, button)
 
end


-- Appelé lorsqu'un bouton du joystick est enfoncé.
function sceneCreateUser.joystickpressed(joystick, button)
 
end


-- Appelé lorsqu'un bouton du joystick est relâché.
function sceneCreateUser.joystickreleased(joystick, button)
 
end


-- Appelé lorsqu'un joystick est connecté.
function sceneCreateUser.joystickadded(joystick)

end


-- Appelé lorsqu'un joystick est déconnecté.
function sceneCreateUser.joystickremoved(joystick)

end


return sceneCreateUser