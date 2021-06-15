-- Cette ligne permet de déboguer pas à pas (plugin Lua)
if pcall(require, "lldebugger") then
  require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love2D de filtrer les contours des images quand elles sont redimentionnées / Pas d'alliasing
-- Indispensable pour du Pixel Art
-- Indispensable pour des effets de Pixels Shaders
love.graphics.setDefaultFilter("nearest")


-- Les Modules
ecransTransitionsModule = require("ecransTransitions")
playerModule = require("player")
splashcreenModule = require("splashscreen")
menuModule = require("menu")
gameoverModule = require("gameover")
gameplayModule = require("gameplay")
controlesModule = require("controles")
collisionsModule = require("collisions")
animationsCharactersModule = require("animationsCharacters")
decoupageSpriteSheetModule = require("decoupageSpriteSheet")
cameraModule = require("camera")
tileMapsEditorModule = require("tileMapsEditor")
scenesModule = require("scenes")
animationsParticulesFXEffetsModule = require("animationsParticulesFXEffets")
sauvegardeModule = require("sauvegarde")
adaptImageToScreenSizeModule = require("adaptImageToScreenSize")
utf8 = require("utf8")
mapModule = require("map")
mapObjectsModule = require("mapObjects")
mapCollisionModule = require("mapCollision")


-- Scènes de jeu différentes
sceneMenu = false
sceneGameplay = true
sceneGameOver = false
sceneTileMapEditor = false


-- Par rapport au click et au Menu.
sceneGameplayActiver = false
sceneInGameplayActiver = false







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

  
  -- Get Size Screen for Player
  largeurEcran = love.graphics.getWidth()   
  hauteurEcran = love.graphics.getHeight()


  -- Module splashscreen.lua (Load)
  --splashcreenModule.Load() 


  -- Module menu.lua (Load)
  menuModule.Load()

  
  -- Module animationsCharacter.lua (Load)
  animationsCharactersModule.Load()


  -- Module player.lua (Load)
  playerModule.Load()


  -- Module tileMapsEditor.lua (Load)
  tileMapsEditorModule.Load()

end






function love.update(dt)
  
  -- Le module splashscreen.lua de la fonction Update
  --splashcreenModule.Update()


  -- Le module animationsCharacters.lua de la fonction Update
  animationsCharactersModule.Update(dt)
  

  -- Le module player.lua de la fonction Update
  playerModule.Update(dt)


  -- Le module tileMapsEditor.lua de la fonction Update
  tileMapsEditorModule.Update(dt)


  -- Le module ecransTransitions.lua de la fonction Update
  ecransTransitionsModule.Update(dt)
end






function love.draw()

  if sceneTileMapEditor == true then
  -- Le module tileMapEditor.lua de la fonction Draw
  tileMapsEditorModule.Draw()

  elseif playingVideo == true then
    -- Le module splashscreen.lua de la fonction Draw
    --splashcreenModule.Draw()    


    -- Effet de transition d'écran
    ecransTransitionsModule.Draw.SplashScreen()

  elseif playingVideo == false and sceneMenu == true then
    -- Le module menu.lua de la fonction Draw
    menuModule.Draw()
    

    -- Effet de transition d'écran
    ecransTransitionsModule.Draw.Menu()
 
  elseif sceneGameplay == true then
    -- Le module player.lua de la fonction Draw
    playerModule.Draw()


    -- Le module animationsCharacters.lua de la fonction Draw
    animationsCharactersModule.Draw()
  
    
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

  tileMapsEditorModule.keypressed(key, isrepeat)

  --print(key)

end






function love.mousepressed(x, y, button, isTouch)
  
  if x >= largeurEcran / 2  and sceneMenu == true then
    sceneGameplayActiver = true
  end

  tileMapsEditorModule.mousepressed(x, y, button, isTouch)

  --print ("x : " .. x .. " - y : " .. y)

end





function love.textinput(event)

  tileMapsEditorModule.textinput(event)

end