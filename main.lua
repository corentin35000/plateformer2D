-- Documentation : [Wiki Love2D](https://love2d.org/wiki/Main_Page), [Wiki LUA](https://www.lua.org/docs.html)
-- Documentation : [Fonction mathématiques Love2D](https://love2d.org/wiki/General_math)

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love2D de filtrer les contours des images quand elles sont redimentionnées / Pas d'alliasing
-- Indispensable pour du Pixel Art
-- Indispensable pour des effets de Pixels Shaders
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end


sceneMenu = true
sceneGameplay = false
sceneFinGameplay = false


Hero = {}
Hero.x = 0
Hero.y = 0
Hero.vx = 0
Hero.vy = 0
Hero.img = love.graphics.newImage("assets/hero-reverse.png")


imgMenu = love.graphics.newImage("assets/background_menu.jpg");


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

counterTest = 0


function drawDetailsPlayer()
  
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
    
    
    -- Test
    love.graphics.print('currentTimerDash (Couldown skills - Dash) : ' .. currentTimerDash, 1, 56)
    love.graphics.print('currentTimerJump (Couldown skills - Jump) : ' .. currentTimerJump, 1, 80)
    
    
    -- Position x, y for Player 
    love.graphics.print('posX : ' .. Hero.x, 1, 104)
    love.graphics.print('posY : ' .. Hero.y, 1, 128)
    
    
    -- Affichage du DeltaTime
    love.graphics.print('deltaTime : ' .. deltaTime, 1, 152)


    -- Affichage du nombre de FPS
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 1, 176)


    -- Affichage du nombre de FPS
    love.graphics.print("timerGameSeconds :" .. timerGameSeconds, 1, 200)
    
    
    -- Affichage du bouton pour reload le jeu
    love.graphics.print("Controls (resetGame) : W", 1, 224)
  
end


function mouvementPlayer(dt)
  -- Déplacement GAUCHE
  if love.keyboard.isDown('left') and love.keyboard.isDown('right') == false and Hero.x >= 0 + (Hero.img:getWidth() / 2) then
    
    testLeft = true;
    Hero.x = Hero.x + (-7 * (60 * dt))
    
  end


  -- Déplacement DROITE
  if love.keyboard.isDown('right') and love.keyboard.isDown('left') == false  and Hero.x <= largeurEcran - (Hero.img:getWidth() / 2) then
    
    testRight = true
    Hero.x = Hero.x + (7 * (60 * dt))
    
  end
  
  
  -- Déplacement SAUTER vers le HAUT
  if keySpace == true and love.keyboard.isDown('left') == false and love.keyboard.isDown('right') == false and love.keyboard.isDown('up') == false 
     and Hero.y > 0 + (Hero.img:getHeight() / 2) then
    
    testSpace = true
    bonusJump = true
    
    if currentTimerJump < 0.1 then
      Hero.y = Hero.y - 250 + dt;
    else
      Hero.y = Hero.y + 0
    end
    
    keySpace = false

  end
    
  
  -- Déplacement SAUTER vers le HAUT - LEFT 
  if keySpace == true and love.keyboard.isDown('left') and love.keyboard.isDown('right') == false and Hero.x >= 0 + (Hero.img:getWidth() / 2) 
     and Hero.x >= 0 + (Hero.img:getWidth() / 2) then
    
    testLeft = true;
    testSpace = true
    bonusJump = true
      
    if currentTimerJump < 0.1 then
      Hero.x = Hero.x - 100 + dt
      Hero.y = Hero.y - 250 + dt;
    else
      Hero.x = Hero.x + 0
      Hero.y = Hero.y + 0
    end
    
    keySpace = false

  end


  -- Déplacement SAUTER vers le HAUT - LEFT 
  if keySpace == true and love.keyboard.isDown('space') and love.keyboard.isDown('right') and love.keyboard.isDown('left') == false and Hero.y > 0 + (Hero.img:getHeight() / 2) 
     and Hero.x <= largeurEcran - (Hero.img:getWidth() / 2) then
    
    testRight = true;
    testSpace = true
    bonusJump = true
    
    if currentTimerJump < 0.1 then
      Hero.x = Hero.x + 100 + dt
      Hero.y = Hero.y - 250 + dt
    else
      Hero.x = Hero.x + 0
      Hero.y = Hero.y + 0
    end
    
    keySpace = false

  end
end


function bonusPlayer(dt)
  
  -- Bonus / Compteur Dash Player
  if (bonusDash == true) then
    
    if currentTimerDash >= 5 then
      currentTimerDash = 0
      bonusDash = false
    end
    
    currentTimerDash = currentTimerDash + 1 * dt   
    
  end
  
  
  -- Bonus / Compteur Jump Player
  if Hero.y >= hauteurEcran - (Hero.img:getHeight() / 2) then
    currentTimerJump = 0
  end
  
  if (bonusJump == true) then
    
    if currentTimerJump >= 1.6 then
      currentTimerJump = 0
      bonusJump = false
    end
    
    if Hero.y >= hauteurEcran - (Hero.img:getHeight() / 2) then
      currentTimerJump = 0
    else
      currentTimerJump = currentTimerJump + 1 * dt   
    end
    
  end
  
  
  -- Touche de raccourcis 'UP' / Inertie du jeu - Inertie réduit (Player réduit sa chute).
  if (Hero.y > hauteurEcran - (Hero.img:getHeight() / 2)) then
    
  else

    if love.keyboard.isDown('up') then
      bonusJump = false
      testUP = true
      Hero.y = Hero.y + (2 * (60 * dt))
      
    elseif currentTimerDash < 0.1 and offInertieDash == true then
      Hero.y = Hero.y + 0
      bonusJump = true
    
    else
      Hero.y = Hero.y + (8 * (60 * dt))
      bonusJump = true
    end
    
    offInertieDash = false
    
  end
  
  
  -- Touche de raccourcis 'Z' / Dash
  if keyZ == true and Hero.y <= hauteurEcran - (Hero.img:getHeight() / 2) and love.keyboard.isDown('up') == false then
    
    testZ = true
    bonusDash = true
    
    if currentTimerDash < 0.1 then
      
      if Hero.x >= 0 + (Hero.img:getWidth() / 2) then
        offInertieDash = true
        Hero.x = Hero.x + -400 + dt
      else
        Hero.x = Hero.x + 0
      end
      
    end
    
    -- REMMETRE ISDOWN SINON
    keyZ = false

  end
  
end




function love.load()
  
  -- Title game / Icon Launcher
  love.window.setTitle("Unstable World")
  
  local imgIcon = love.image.newImageData("assets/Icone_Launcher.png")
  love.window.setIcon(imgIcon)
  
  
  -- Size Screen : (0, 0) -> prends en charge la taille d'écran maximum du moniteur d'affichage actuel de l'utilisateur fullscreentype correspond au type d'écran, 
  -- vsync = -1 équivaut a utiliser vsync adaptatif (si pris en charge), 
  -- resizable = si la fenêtre doit être redimensionnable en mode fenêtré, borderless = si la fenêtre doit être sans bordure en mode fenêtré
  -- Un plus spécifique -> highdpi = active le mode haute résolution doit être utilisé sur les écrans Retina sous macOS et iOS.
  -- Un plus spécifique -> usedpiscale  = active le mode haute résolution doit être utilisé sur les écrans Retina sous macOS et iOS.
  -- display = Lancez le jeu sur le moniteur principale 1, 2 ou 3..
  love.window.setMode(0, 0, {fullscreen = false, fullscreentype = ("desktop"), vsync = -1, resizable = false, 
                      borderless = false, centered = true, highdpi = true, usedpiscale = true, display = 1}
                     )

  width, height, flags = love.window.getMode()
  --print (flags.refreshrate)
  
  
  -- Video SplashScreen for Studio.
  -- La variable video est un Objet, qui contient le SplashScreen du Studio, il prend en parametre un boolean qui prend true si le son de la vidéo doit être activé.
  -- dpiscale = Le facteur d'échelle DPI représente la densité de pixels relative
  video = love.graphics.newVideo("video/splashScreenStudio.ogv", {audio = true, dpiscale = 1})
    
  videoWidth = video:getWidth()
  videoHeight = video:getHeight()
  
  video:play()
  
  
  -- Get Size Screen
  largeurEcran = love.graphics.getWidth()   
  hauteurEcran = love.graphics.getHeight()
  
  
  -- Initialisation vélocité
  Hero.vx = Hero.vx + Hero.x
  Hero.vy = Hero.vy + Hero.y


  -- Charger le positionement du joueur sur l'écran au démarrage
  Hero.x = Hero.x + (largeurEcran / 2) - (Hero.img:getWidth() / 2)
  Hero.y = Hero.y + (hauteurEcran - (Hero.img:getHeight() / 2))

end





function love.update(dt)
  
  -- Video SplashScreen for Studio / isPlaying() return true or false -> Obtient si la vidéo est en cours de lecture.
  playingVideo = video:isPlaying()  
  
  
  -- Inertie general
  -- Hero.vy = Hero.vy + 8 + dt
  
  
  -- get DeltaTime draw screen
  deltaTime = dt
  
  
  -- get timerGameSeconds draw screen
  timerGameSeconds = love.timer.getTime()
  
  if counterTest == 0 then
    timerGameSeconds = timerGameSeconds - timerGameSeconds
  end
  
  counterTest = counterTest + 1


  bonusPlayer(dt);

  mouvementPlayer(dt)
end





function love.draw()

  if playingVideo == true then
    
    love.graphics.draw(video, (largeurEcran / 2), (hauteurEcran / 2), 0, 1, 1, (videoWidth / 2), (videoHeight / 2))
    
  elseif playingVideo == false and sceneMenu == true then
    
    love.graphics.draw(imgMenu, 0, 0)
    love.graphics.print('PLAY', largeurEcran / 2, hauteurEcran / 2)
    
  elseif sceneGameplay == true then
  
    -- Détails du joueur.
    drawDetailsPlayer()
    
    -- Afficher le hero par default sur la map.
    love.graphics.draw(Hero.img, Hero.x, Hero.y, 0, -1, 1, Hero.img:getWidth() / 2, Hero.img:getHeight() / 2)
    
  elseif sceneFinGameplay == true then
 
  end

end





-- isrepeat -> SI cette événement de pression de touche est une répétition.
function love.keypressed(key, isrepeat)
  
  if key == "escape" then 
    
	  love.event.quit() 
    
  end
  
  if key == "space" then 
    
    keySpace = true
    
  end
  
  if key == "z" then 
    
    keyZ = true
  
  end
  
   if key == "w" then 
    
    love.event.quit('restart')
    
  end
  print(key)
  
end




function love.mousepressed(x, y, button, isTouch)
  
  print ("x : " .. x .. " - y : " .. y)

  if x >= 50 and x <= 150 and y >= 50 and y <= 150 then

    sceneMenu = false
    sceneGameplay = true
    
  end
  
end