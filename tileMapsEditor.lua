local tileMapsEditor = {}

local utf8 = require("utf8")

MAP_WIDTH = 50
MAP_HEIGHT = 50
TILE_WIDTH = 64
TILE_HEIGHT = 64
NOMBRE_LIGNE = MAP_HEIGHT * TILE_HEIGHT 
NOMBRE_COLONNE = MAP_WIDTH * TILE_WIDTH


local Game = {}
Game.TileSheets = {}
Game.TileSheetActive = nil
Game.TileTextures = {}
Game.MapNiveau = {}


local GUI = {}
GUI.imgGrilleMapActive = nil
GUI.grilleMapActive = true
GUI.imgGrilleMapColor = nil
GUI.grilleMapColor = 'black'
GUI.grilleMapChangedColorWhite = love.graphics.setColor(1, 1, 1)
GUI.grilleMapChangedColorBlack = love.graphics.setColor(0, 0, 0)


--
local inputText = {}
inputText.MAP_WIDTH = MAP_WIDTH
inputText.MAP_HEIGHT = MAP_HEIGHT
inputText.TILE_WIDTH = TILE_WIDTH
inputText.TILE_HEIGHT = TILE_HEIGHT


local mouse = {}
mouse.posX = love.mouse.getX()
mouse.posY = love.mouse.getY()

local zoomX = 1
local zoomY = 1

local offsetXInWorld = 0
local offsetYInWorld = 0


-- Camera de l'editeur de Map.
local camera = {}
camera.x = nil
camera.y = nil


--
function updateMouseXandY()
    mouse.posX = love.mouse.getX()
    mouse.posY = love.mouse.getY() 
end


-- 
function zoomDeZoom(pZoomX, pZoomY)
    love.graphics.scale(pZoomX, pZoomY)
end


-- 
function getPositionCursorInGrilleMap()
    if zoomX < 1 and zoomY < 1 then
        newTileWidthForZoomX = (zoomX * 100) / 100 * TILE_WIDTH
        newTileHeightForZoomY = (zoomY * 100) / 100 * TILE_HEIGHT

        colonnesCursorInGrilleMap = mouse.posX / newTileWidthForZoomX
        lignesCursorInGrilleMap = mouse.posY / newTileHeightForZoomY
    elseif zoomX > 1 and zoomY > 1 then
        colonnesCursorInGrilleMap = mouse.posX / (TILE_WIDTH * zoomX)
        lignesCursorInGrilleMap = mouse.posY / (TILE_HEIGHT * zoomY)
    else
        colonnesCursorInGrilleMap = mouse.posX  / TILE_WIDTH 
        lignesCursorInGrilleMap = mouse.posY / TILE_HEIGHT
    end

    lignesCursorInGrilleMap = math.floor(lignesCursorInGrilleMap)
    colonnesCursorInGrilleMap = math.floor(colonnesCursorInGrilleMap)

    resultLignesCursorGrilleMap = lignesCursorInGrilleMap
    if lignesCursorInGrilleMap < 0 or lignesCursorInGrilleMap > MAP_HEIGHT - 1 then
        resultLignesCursorGrilleMap = 'En dehors de la Grille Map'
    end

    resultColonnesCursorGrilleMap = colonnesCursorInGrilleMap
    if colonnesCursorInGrilleMap < 0 or colonnesCursorInGrilleMap > MAP_WIDTH - 1 then
        resultColonnesCursorGrilleMap = 'En dehors de la Grille Map'
    end
end


-- 
function drawTileRedOrTexture()
    local offsetXColonne = colonnesCursorInGrilleMap * TILE_WIDTH
    local offsetYLigne = lignesCursorInGrilleMap * TILE_HEIGHT

    -- Affiche la taille d'une Tile en rouge quand on veux poser la Tile avec de la transparence.
    if resultLignesCursorGrilleMap == "En dehors de la Grille Map" or resultColonnesCursorGrilleMap == "En dehors de la Grille Map" then
        love.graphics.setColor(255, 0, 0, 0.35)    
        love.graphics.rectangle("fill", offsetXColonne, offsetYLigne, TILE_WIDTH, TILE_HEIGHT)
        love.graphics.setColor(1, 1, 1, 1)
    else
        -- Affiche la taille d'une Tile a l'écrans sur la grille au survol on vois apparaitre la Tile en transparent qui a était choisi.
        love.graphics.setColor(1, 1, 1, 0.5)    
        love.graphics.draw(Game.TileSheets[Game.TileSheetActive], Game.TileTextures[Game.TileSheetActive][1], offsetXColonne, offsetYLigne)
        love.graphics.setColor(1, 1, 1, 1)
    end
end


-- Le tracer des colonnes et lignes de la map : Grille Map
function drawTheLines()
    if (GUI.grilleMapActive == true) then

        local counterHeight = TILE_HEIGHT
        for i=0,MAP_HEIGHT do
            if i == 0 then
                love.graphics.line(0, 0, NOMBRE_COLONNE, 0)
                love.graphics.line(0, TILE_HEIGHT, NOMBRE_COLONNE, TILE_HEIGHT)
            elseif i < MAP_HEIGHT then
                counterHeight = counterHeight + TILE_HEIGHT
                love.graphics.line(0, counterHeight, NOMBRE_COLONNE, counterHeight)
            end

        end 

        local counterWidth = TILE_WIDTH
        for i=0,MAP_WIDTH do
            if i == 0 then
                love.graphics.line(0, 0, 0, NOMBRE_LIGNE)
                love.graphics.line(TILE_WIDTH, 0, TILE_WIDTH, NOMBRE_LIGNE)
            elseif i < MAP_WIDTH then
                counterWidth = counterWidth + TILE_WIDTH
                love.graphics.line(counterWidth, 0, counterWidth, NOMBRE_LIGNE)
            end
        end  

    end 
end


--
function colorGrilleMap()
    -- Change la couleur des grille de la Map noir ou blanc
    if (GUI.grilleMapColor == 'black') then
        love.graphics.setColor(0, 0, 0)
    else
        love.graphics.setColor(1, 1, 1)
    end 
end


-- Change la couleur d'arrière plan de l'éditeur de Map.
function colorBackgroundMap()
    local red = 137/255
    local green = 137/255
    local blue = 137/255
    local alpha = 1

    love.graphics.setBackgroundColor(red, green, blue, alpha)
end


-- Je charge une TileSheets et l'envoie dans la table : Game.TileSheets
function loadTileSheets(pNomDossierRessources, pNomFicherTileSheet)
    local tileSheet = love.graphics.newImage(pNomDossierRessources .. "/" .. pNomFicherTileSheet .. ".png")
    Game.TileSheets[pNomFicherTileSheet] = tileSheet
end


-- GUI tileMapsEditor
function guiTileMapEditor()
    --love.graphics.draw(GUI.imgGrilleMapActive, largeurEcran - GUI.imgGrilleMapActive:getWidth(), GUI.imgGrilleMapActive:getHeight(), 0, 1, 1, GUI.imgGrilleMapActive:getWidth() / 2, GUI.imgGrilleMapActive:getHeight() / 2)
    --love.graphics.draw(GUI.imgGrilleMapColor, largeurEcran - GUI.imgGrilleMapColor:getWidth(), GUI.imgGrilleMapColor:getHeight() + GUI.imgGrilleMapColor:getHeight() * 2, 0, 1, 1, GUI.imgGrilleMapColor:getWidth() / 2, GUI.imgGrilleMapColor:getHeight() / 2)
end









function tileMapsEditor.Load()
    -- Je charge toutes mes TileSheets (Une SpriteSheet qui contient des Tiles (Textures))
    -- loadTileSheets(nomDuDossier, nomFichierImg)
    loadTileSheets('assets', 'tileSet')


    -- Itere sur la table qui contient toute les TileSheets, puis découpe chaque images d'une TileSheet et les envoie dans la table : Game.TileTextures (tableaux a deux dimensions)
    for nomTileSheet, imgTileSheet in pairs(Game.TileSheets) do
        local tableTileSheetDecouper = decoupeSpriteSheet(0, 0, TILE_WIDTH, TILE_HEIGHT, 8, 14, 2, imgTileSheet) -- decoupeSpriteSheet() renvoie une table
        Game.TileTextures[nomTileSheet] = tableTileSheetDecouper
    end

    
    -- La TileSheet par défault choisi donc le choix des Tiles pour dessiner seront par rapport a cette TileSheet.
    Game.TileSheetActive = 'tileSet';

    
    -- Je charge la GUI de l'éditeur de Map
    GUI.imgGrilleMapActive = love.graphics.newImage("assets/grilleButton.png")
    GUI.imgGrilleMapColor = love.graphics.newImage("assets/grilleColorButton.png")


    --
    love.keyboard.setKeyRepeat(true)
end


function tileMapsEditor.Update(dt)
    --
    updateMouseXandY()

    --
    getPositionCursorInGrilleMap()
end


function tileMapsEditor.Draw()
    -- Set un background color
    colorBackgroundMap()
    

    -- Change la couleur des grille de la Map noir ou blanc
    colorGrilleMap()


    -- Initialiser la mise a l'échelle (Scale) - ZoomX et ZoomY de l'éditeur de Map.
    love.graphics.push()
    love.graphics.scale(zoomX, zoomY)


    -- Le tracer des colonnes et lignes de la map : Grille Map
    drawTheLines()


    -- Remet la palette de couleur par défault après avoir appliquer une palette de couleur pour les traits de la grille de la Map.
    love.graphics.setColor(1, 1, 1)    


    -- Test TileTextures
    love.graphics.draw(Game.TileSheets[Game.TileSheetActive], Game.TileTextures[Game.TileSheetActive][1], 0, 512)
    love.graphics.draw(Game.TileSheets[Game.TileSheetActive], Game.TileTextures[Game.TileSheetActive][1], 64, 512)
    love.graphics.draw(Game.TileSheets[Game.TileSheetActive], Game.TileTextures[Game.TileSheetActive][1], 128, 512)


    -- Affichage de la Texture sur la Tile en transparent ou en rouge transparent si je suis en-dehors de la GrilleMap.
    drawTileRedOrTexture()    


    -- Remettre la mise à l'échelle normale - (Scale x,y : 1)
    love.graphics.pop()


    -- Affichages de la GUI de l'éditeur de TileMap
    guiTileMapEditor()


    -- Test InputText
    love.graphics.printf('MAP_WIDTH : ' .. inputText.MAP_WIDTH, 0, 0, love.graphics.getWidth())
    love.graphics.printf('MAP_HEIGHT : ' .. inputText.MAP_HEIGHT, 0, 20, love.graphics.getWidth())
    love.graphics.printf('TILE_WIDTH : ' .. inputText.TILE_WIDTH, 0, 40, love.graphics.getWidth())
    love.graphics.printf('TILE_HEIGHT : ' .. inputText.TILE_HEIGHT, 0, 60, love.graphics.getWidth())

    love.graphics.printf('MAP_LIGNE : ' .. resultLignesCursorGrilleMap, 0, 80, love.graphics.getWidth())
    love.graphics.printf('MAP_COLONNE : ' .. resultColonnesCursorGrilleMap, 0, 100, love.graphics.getWidth())

    love.graphics.printf('Coords - mouseX : ' .. mouse.posX, 0, 120, love.graphics.getWidth())
    love.graphics.printf('Coords - mouseY : ' .. mouse.posY, 0, 140, love.graphics.getWidth())

    love.graphics.printf('Zoom : ' .. zoomX, 0, 160, love.graphics.getWidth())
end



function tileMapsEditor.keypressed(key, isrepeat)
  
    if key == "f2" then 
        if sceneTileMapEditor == false then
            sceneMenu = false
            sceneGameplay = false
            sceneGameOver = false
            sceneTileMapEditor = true
        else
            sceneMenu = false
            sceneGameplay = true
            sceneGameOver = false
            sceneTileMapEditor = false
        end
    end

    if key == "f3" then
        if GUI.grilleMapColor == 'black' then 
            GUI.grilleMapColor = 'white'
        else
           GUI.grilleMapColor = 'black'
        end
    end

    if key == "f4" then
        if GUI.grilleMapActive == true then 
            GUI.grilleMapActive = false
        else
            GUI.grilleMapActive = true
        end
    end

    if key == "f5" then
        zoomX = 1
        zoomY = 1
    end

    if key == "backspace" then
        -- get the byte offset to the last UTF-8 character in the string.
        local byteoffset = utf8.offset(inputText.MAP_WIDTH, -1)

        if byteoffset then
            -- remove the last UTF-8 character.
            -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
            inputText.MAP_WIDTH = string.sub(inputText.MAP_WIDTH, 1, byteoffset - 1)
            inputText.MAP_HEIGHT = string.sub(inputText.MAP_WIDTH, 1, byteoffset - 1)
            inputText.TILE_WIDTH = string.sub(inputText.MAP_WIDTH, 1, byteoffset - 1)
            inputText.TILE_HEIGHT = string.sub(inputText.MAP_WIDTH, 1, byteoffset - 1)

            inputText.MAP_WIDTH = tonumber(inputText.MAP_WIDTH)
            inputText.MAP_HEIGHT = tonumber(inputText.MAP_WIDTH)
            inputText.TILE_WIDTH = tonumber(inputText.MAP_WIDTH)
            inputText.TILE_HEIGHT = tonumber(inputText.MAP_WIDTH)

            MAP_WIDTH = inputText.MAP_WIDTH
            MAP_HEIGHT = inputText.MAP_HEIGHT
            TILE_WIDTH = inputText.TILE_WIDTH
            TILE_HEIGHT = inputText.TILE_HEIGHT

            NOMBRE_LIGNE = MAP_HEIGHT * TILE_HEIGHT 
            NOMBRE_COLONNE = MAP_WIDTH * TILE_WIDTH
        end
    end
      
end


function tileMapsEditor.mousepressed(x, y, button, isTouch)

    -- Img boutton imgGrilleMap  / La map avec grille ou sans grille
    --if x <= largeurEcran - GUI.imgGrilleMapActive:getWidth() / 2 and x >= largeurEcran - (GUI.imgGrilleMapActive:getWidth() + (GUI.imgGrilleMapActive:getWidth() / 2)) and
       --y >= largeurEcran - GUI.imgGrilleMapActive:getHeight() / 2 and y <= GUI.imgGrilleMapActive:getHeight() + (GUI.imgGrilleMapActive:getHeight() / 2) and sceneTileMapEditor == true then
    
        --if GUI.grilleMapActive == true then 
            --GUI.grilleMapActive = false
        --else
            --GUI.grilleMapActive = true
       -- end
    --end 
    
    
    -- Img boutton GrilleMapColor  / Changer la couleur blanc ou noir 
    --if x <= largeurEcran - GUI.imgGrilleMapColor:getWidth() / 2 and x >= largeurEcran - (GUI.imgGrilleMapColor:getWidth() + (GUI.imgGrilleMapColor:getWidth() / 2)) then
    
        --if GUI. == 'black' then 
            --GUI.grilleMapColor = 'white'
        --else
           -- GUI.grilleMapColor = 'black'
        --end
    --end


    -- Remet le ZoomX et ZoomY par défault.
    if button == 3 then
        zoomX = 1
        zoomY = 1
    end
end


function tileMapsEditor.textinput(event)

    inputText.MAP_WIDTH = inputText.MAP_WIDTH .. event
    inputText.MAP_HEIGHT = inputText.MAP_HEIGHT .. event
    inputText.TILE_WIDTH = inputText.TILE_WIDTH .. event
    inputText.TILE_HEIGHT = inputText.TILE_HEIGHT .. event

    inputText.MAP_WIDTH = tonumber(inputText.MAP_WIDTH)
    inputText.MAP_HEIGHT = tonumber(inputText.MAP_HEIGHT)
    inputText.TILE_WIDTH = tonumber(inputText.TILE_WIDTH)
    inputText.TILE_HEIGHT = tonumber(inputText.TILE_HEIGHT)

    MAP_WIDTH = inputText.MAP_WIDTH
    MAP_HEIGHT = inputText.MAP_HEIGHT
    TILE_WIDTH = inputText.TILE_WIDTH
    TILE_HEIGHT = inputText.TILE_HEIGHT

    NOMBRE_LIGNE = MAP_HEIGHT * TILE_HEIGHT 
    NOMBRE_COLONNE = MAP_WIDTH * TILE_WIDTH
    
end


function love.wheelmoved(x, y)
    if y > 0 then
        zoomX = zoomX + 0.05
        zoomY = zoomY + 0.05
        zoomDeZoom(zoomX, zoomY)
    elseif y < 0 and zoomX > 0.05 and zoomY > 0.05 then
        zoomX = zoomX - 0.05
        zoomY = zoomY - 0.05
        zoomDeZoom(zoomX, zoomY)
    end
end

return tileMapsEditor