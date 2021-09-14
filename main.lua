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

-- Les Modules / Requires
sceneManagerModule = require("src/scenes/sceneManager")
sceneSplashScreenModule = require("src/scenes/sceneSplashScreen")
sceneKeyAccessModule = require("src/scenes/sceneKeyAccess")
sceneMenuModule = require("src/scenes/sceneMenu")
sceneGameplayModule = require("src/scenes/sceneGameplay")
sceneGameoverModule = require("src/scenes/sceneGameover")
sceneEditorMapsModule = require("src/scenes/sceneEditorMaps")
controlesModule = require("src/controles")
animationsCharactersSpinesModule = require("src/animationsCharactersSpine")
ecransTransitionsModule = require("src/ecransTransitions")
playerModule = require("src/player")
cameraModule = require("src/camera")
animationsParticulesFXEffetsModule = require("src/animationsCharactersEffectsFX")
sauvegardeModule = require("src/sauvegarde")
mapsInGameModule = require("src/mapsInGame")
reseauModule = require("src/reseau")
require("src/utils")

-- Librairies externes / Requires
utf8 = require("utf8")
json = require("src/libs/json")
socket = require("socket")
http = require("socket.http")
ltn12 = require("ltn12")
spine = require("spine-love.spine")



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
  love.window.setMode(0, 0, {fullscreen = false, fullscreentype = ("desktop"), vsync = 0, resizable = false, 
                      borderless = false, centered = true, highdpi = true, usedpiscale = true, display = 1}
                     )

  
  -- Get Size Screen for Player
  largeurEcran = love.graphics.getWidth()   
  hauteurEcran = love.graphics.getHeight()


  sceneManagerModule.load()
end


function love.update(dt)
  sceneManagerModule.update(dt)
end


function love.draw()
  sceneManagerModule.draw()
end


function love.keypressed(key, isrepeat)
  sceneManagerModule.keypressed(key, isrepeat)

  if key == "escape" then 
	  love.event.quit() 
  end
  
  if key == "w" then 
    love.event.quit('restart')
  end

  if key == "f1" then 
    if stateScene ~= "Editor" then
      stateScene = "Editor"
    elseif stateScene == "Editor" then
      stateScene = "Gameplay"
    end
  end
end


function love.mousepressed(x, y, button)
  sceneManagerModule.mousepressed(x, y, button)
end


function love.textinput(event)
  sceneManagerModule.textinput(event)
end


function love.wheelmoved(x, y)
  sceneManagerModule.wheelmoved(x, y)
end