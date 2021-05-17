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


-- Les Modules
ecransTransitionsModule = require("ecransTransitions")
playerModule = require("player")
splashcreenModule = require("splashscreen")
menuModule = require("menu")
tileMapsModule = require("tileMaps")
gameoverModule = require("gameover")
gameplayModule = require("gameplay")
controlesModule = require("controles")
collisionsModule = require("collisions")


-- Scènes de jeu différentes
sceneMenu = false
sceneGameplay = false
sceneGameOver = false


-- Par rapport au click et au Menu.
sceneGameplayActiver = false
sceneInGameplayActiver = false


-- L'objet principale qui contient le joueur.
Hero = {}
Hero.x = 0
Hero.y = 0
Hero.vx = 0
Hero.vy = 0
Hero.img = nil


-- Les images du background du Menu et les bouttons du Menu.
imgMenu = {} 
imgMenu.background = nil
imgMenu.play = nil
imgMenu.options = nil
imgMenu.exit = nil







function love.load()
  
  -- Set Title game
  love.window.setTitle("Unstable World")
  
  
  -- Set Icon Game
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
  
  
  -- Video SplashScreen for Studio.
  -- La variable video est un Objet, qui contient le SplashScreen du Studio, il prend en parametre un boolean qui prend true si le son de la vidéo doit être activé.
  -- Une variable pour compter la durer de la video et puis ensuite jouer le SplashScreen.
  video = love.graphics.newVideo("video/splashScreenStudio.ogv", {audio = true, dpiscale = 1})
  videoWidth = video:getWidth()
  videoHeight = video:getHeight()
  counterTimeSplashScreen = 0
  video:play()
  
  
  -- Get Size Screen for Player
  largeurEcran = love.graphics.getWidth()   
  hauteurEcran = love.graphics.getHeight()
  
  
  -- Initialisation de la Inertie / Gravité
  Hero.vx = Hero.vx + Hero.x
  Hero.vy = Hero.vy + Hero.y
  
  
  -- Initialiser/Charger les images du jeu --
  -- Images du Menu :
  imgMenu.background = love.graphics.newImage("assets/background_menu.jpg")
  imgMenu.play = love.graphics.newImage("assets/menu_play.png")
  imgMenu.options = love.graphics.newImage("assets/menu_options.png")
  imgMenu.exit = love.graphics.newImage("assets/menu_exit.png")
  -- Images du Player :
  Hero.img = love.graphics.newImage("assets/hero.png")


  -- Charger le positionement du joueur sur l'écran au démarrage
  Hero.x = Hero.x + (largeurEcran / 2) - (Hero.img:getWidth() / 2)
  Hero.y = Hero.y + (hauteurEcran - (Hero.img:getHeight() / 2))

end






function love.update(dt)
  
  -- Le module splashscreen.lua de la fonction Update
  splashcreenModule.Update()
  
  -- Inertie / Gravité du Player
  -- Hero.vy = Hero.vy + 8 * dt

  -- Le module player.lua de la fonction Update
  playerModule.Update(dt)

  -- Le module ecransTransitions.lua de la fonction Update
  ecransTransitionsModule.Update()

end






function love.draw()

  if playingVideo == true then
    -- Affichage de la video du SplashScreen
    love.graphics.draw(video, (largeurEcran / 2), (hauteurEcran / 2), 0, 1, 1, (videoWidth / 2), (videoHeight / 2))
    
    
    -- Effet de transition d'écran
    ecransTransitionsModule.Draw.SplashScreen()

  elseif playingVideo == false and sceneMenu == true then
    -- Tout le module de la fonction Draw de menu.lua
    menuModule.Draw()
    
    
    -- Effet de transition d'écran
    ecransTransitionsModule.Draw.Menu()

  elseif sceneGameplay == true then
    -- Détails du joueur (statistiques, keys..)
    playerModule.Draw()    
    
    
    -- Afficher le Player par default sur la map.
    love.graphics.draw(Hero.img, Hero.x, Hero.y, 0, 1, 1, Hero.img:getWidth() / 2, Hero.img:getHeight() / 2)
    
    
    -- Effet de transition d'écran
    ecransTransitionsModule.Draw.GamePlay()
    
  elseif sceneGameOver == true then
    love.graphics.graphics("PERDU", largeurEcran / 2, hauteurEcran / 2)
  end

end






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
  
  if x >= largeurEcran / 2  and sceneMenu == true then
    sceneGameplayActiver = true
  end
  
  print ("x : " .. x .. " - y : " .. y)

end