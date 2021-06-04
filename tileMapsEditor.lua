--------------DOCUMENTATION DU FRAMEWORK------------------------

-- 1) Quand on lance l'éditeur on'as aucune map créer encore, le niveau de la map est affichée si c'est : 'MAP_NIVEAU : ?' c'est que c'est une nouvelle map non sauvegarder.
-- 2) Donc quand on n'as : '?' il faut configurer la LARGEUR/HAUTEUR de la MAP/TILES puis aller sur 'GENERATE MAP' et faire 'ENTER' pour générer la MAP.
-- 3) Quand on créer un niveau de Map on'as normalement : 'MAP_NIVEAU' : 1.. 2.. avec le niveau actuelle de la TileMap du niveau.
-- 4) Quand on n'es sur un niveau de map en cours sur l'éditeur de Map il faut faire : 'NEW MAP' ça va regénérer une nouvelle map VIDE et faut la reconfigurer et faire GENERATE_MAP.
-- 5) On peux Load une Map créer avant en la chargeant en mettant le numéro du niveau.
-- 6) On peux supprimer un niveau de Map qui a était créer et sauvegarder.


-- IMPORTANT (POSSIBILITER) :
-- Remettre la possibilité de pouvoir changer la LARGEUR/HAUTEUR DE LA MAP même après création du niveau de la MAP.
 -----------------------------------------------------------------


local tileMapsEditor = {}

local utf8 = require("utf8")


--
ORIENTATION_TILES = "Orthogonale"
MAP_WIDTH = 0
MAP_HEIGHT = 0
TILE_WIDTH = 0
TILE_HEIGHT = 0
NOMBRE_LIGNE = MAP_HEIGHT * TILE_HEIGHT 
NOMBRE_COLONNE = MAP_WIDTH * TILE_WIDTH
MAP_PIXELS = NOMBRE_LIGNE .. ' x ' .. NOMBRE_COLONNE .. ' pixels'
CURRENT_LIGNE = 0
CURRENT_COLONNE = 0
MAP_NIVEAU = "?"
LOAD_MAP = "" 
DELETE_MAP = ""


--
Game = {}
Game.TileSheets = {}
Game.Tiles = {}
Game.TileActive = nil
Game.MapNiveau = {}
Game.MapNiveauActive = nil


--
local backgroundColor = {}
backgroundColor.red = 137/255
backgroundColor.green = 137/255
backgroundColor.blue = 137/255
backgroundColor.alpha = 1


--
local colorLinesGrilleMap = {}
colorLinesGrilleMap.red = nil
colorLinesGrilleMap.green = nil
colorLinesGrilleMap.blue = nil
colorLinesGrilleMap.alpha = 1


--
local font = love.graphics.getFont()

local inputText = {}
inputText.ORIENTATION_TILES = { txt = ORIENTATION_TILES, widthFont = font:getWidth("ORIENTATION_TILES : " .. ORIENTATION_TILES) }
inputText.MAP_WIDTH = { txt = MAP_WIDTH, widthFont = font:getWidth('MAP_WIDTH : ' .. MAP_WIDTH) }
inputText.MAP_HEIGHT = { txt = MAP_HEIGHT, widthFont = font:getWidth('MAP_HEIGHT : ' .. MAP_HEIGHT) }
inputText.TILE_WIDTH = { txt = TILE_WIDTH, widthFont = font:getWidth('TILE_WIDTH : ' .. TILE_WIDTH) }
inputText.TILE_HEIGHT = { txt = TILE_HEIGHT, widthFont = font:getWidth('TILE_HEIGHT : ' .. TILE_HEIGHT) }

inputText.GENERATE_MAP = { widthFont = font:getWidth('GENERATE MAP :') }
inputText.NEW_MAP = { widthFont = font:getWidth('NEW MAP :') }
inputText.LOAD_MAP = { txt = "", widthFont = font:getWidth('LOAD_MAP : ' .. LOAD_MAP) }
inputText.DELETE_MAP = { txt = DELETE_MAP, widthFont = font:getWidth('DELETE_MAP : ' .. DELETE_MAP) }

inputText.backgroundColorRed = { widthFont = font:getWidth('Background-color (r) : ' .. backgroundColor.red) }
inputText.backgroundColorGreen = { widthFont = font:getWidth('Background-color (r) : ' .. backgroundColor.green) }
inputText.backgroundColorBlue = { widthFont = font:getWidth('Background-color (r) : ' .. backgroundColor.blue) }
inputText.backgroundColorAlpha = { widthFont = font:getWidth('Background-color (r) : ' .. backgroundColor.alpha) }

inputText.LinesGrilleAlpha = { widthFont = font:getWidth('Lines GrilleMap - Opacity : ' .. backgroundColor.alpha) }

local inputTextActive = "ORIENTATION_TILES"


--
local GUI = {}
GUI.grilleMapActive = true
GUI.grilleMapLines = true
GUI.grilleMapPointiller = false
GUI.grilleMapStyleLinesPointiller = "smooth" -- "fin/doux" (rough) ou "épais/gras"(smooth) -> natif a Love2D
GUI.grilleMapColor = "black"
GUI.grilleMapChangedColorWhite = love.graphics.setColor(1, 1, 1)
GUI.grilleMapChangedColorBlack = love.graphics.setColor(0, 0, 0)
GUI.drawGUIandText = true
GUI.imgFleche = { img = nil, x = inputText.ORIENTATION_TILES.widthFont + 15, y = 0 }


--
local mouse = {}
mouse.posX = love.mouse.getX()
mouse.posY = love.mouse.getY()


--
local cursorImg = {}
cursorImg.deplacementMapEditor = nil
cursorImg.mouvementHautBasInMapEditor = nil
cursorImg.mouvementGaucheDroiteInMapEditor = nil
cursorImg.mouvementHautDroiteBasGaucheInMapEditor = nil
cursorImg.mouvementHautGaucheBasDroiteInMapEditor = nil

local cursorPersoActive = false


--
local mouseXClick = nil
local mouseYClick = nil


--
local clickRightIsDown = false


--
local window = {}
window.translate = { x = 0, y = 0 } 
window.zoom = 1
dscale = 2^(1/6) -- Le mouvement de la roue six fois change le zoom deux fois (zoom exponentiel uniquement)





--[[   
███████ ██    ██ ███    ██  ██████ ████████ ██  ██████  ███    ██ ███████     ███████ ██████  ██ ████████  ██████  ██████  ███    ███  █████  ██████  
██      ██    ██ ████   ██ ██         ██    ██ ██    ██ ████   ██ ██          ██      ██   ██ ██    ██    ██    ██ ██   ██ ████  ████ ██   ██ ██   ██ 
█████   ██    ██ ██ ██  ██ ██         ██    ██ ██    ██ ██ ██  ██ ███████     █████   ██   ██ ██    ██    ██    ██ ██████  ██ ████ ██ ███████ ██████  
██      ██    ██ ██  ██ ██ ██         ██    ██ ██    ██ ██  ██ ██      ██     ██      ██   ██ ██    ██    ██    ██ ██   ██ ██  ██  ██ ██   ██ ██      
██       ██████  ██   ████  ██████    ██    ██  ██████  ██   ████ ███████     ███████ ██████  ██    ██     ██████  ██   ██ ██      ██ ██   ██ ██                                                                                                                                                                                                                                                                                                                 
]]


--
function updateMouseXandY()
    mouse.posX = love.mouse.getX() - window.translate.x
    mouse.posY = love.mouse.getY() - window.translate.y
end


-- 
function getPositionCursorInGrilleMap()
    if window.zoom < 1 then
        newTileWidthForZoomX = (window.zoom * 100) / 100 * TILE_WIDTH
        newTileHeightForZoomY = (window.zoom * 100) / 100 * TILE_HEIGHT

        colonnesCursorInGrilleMap = mouse.posX / newTileWidthForZoomX
        lignesCursorInGrilleMap = mouse.posY / newTileHeightForZoomY
    elseif window.zoom > 1 then
        colonnesCursorInGrilleMap = mouse.posX / (TILE_WIDTH * window.zoom)
        lignesCursorInGrilleMap = mouse.posY / (TILE_HEIGHT * window.zoom)
    else
        colonnesCursorInGrilleMap = mouse.posX  / TILE_WIDTH 
        lignesCursorInGrilleMap = mouse.posY / TILE_HEIGHT
    end

    lignesCursorInGrilleMap = math.floor(lignesCursorInGrilleMap)
    colonnesCursorInGrilleMap = math.floor(colonnesCursorInGrilleMap)

    CURRENT_LIGNE = lignesCursorInGrilleMap
    CURRENT_COLONNE = colonnesCursorInGrilleMap

    resultLignesCursorGrilleMap = lignesCursorInGrilleMap

    if MAP_WIDTH == 0 and MAP_HEIGHT == 0 or TILE_WIDTH == 0 and TILE_HEIGHT == 0 then
        resultLignesCursorGrilleMap = ''
        resultColonnesCursorGrilleMap = ''
    else
        if lignesCursorInGrilleMap < 0 or lignesCursorInGrilleMap > MAP_HEIGHT - 1 then
            resultLignesCursorGrilleMap = 'En dehors de la Grille Map'
        end
    
        resultColonnesCursorGrilleMap = colonnesCursorInGrilleMap
        if colonnesCursorInGrilleMap < 0 or colonnesCursorInGrilleMap > MAP_WIDTH - 1 then
            resultColonnesCursorGrilleMap = 'En dehors de la Grille Map'
        end
    end
end


-- 
function drawTileRedOrTexture()
    local offsetXColonne = colonnesCursorInGrilleMap * TILE_WIDTH
    local offsetYLigne = lignesCursorInGrilleMap * TILE_HEIGHT

    if not love.mouse.isDown(2) then
        -- Affiche la taille d'une Tile en rouge quand on veux poser la Tile avec de la transparence.
        if resultLignesCursorGrilleMap == "En dehors de la Grille Map" or resultColonnesCursorGrilleMap == "En dehors de la Grille Map" then
            love.graphics.setColor(255, 0, 0, 0.3)    
            love.graphics.rectangle("fill", offsetXColonne, offsetYLigne, TILE_WIDTH, TILE_HEIGHT)
            love.graphics.setColor(1, 1, 1, 1)

        else
            -- Affiche la taille d'une Tile a l'écrans sur la grille au survol on vois apparaitre la Tile en transparent qui a était choisi.
            --love.graphics.setColor(1, 1, 1, 0.5)    
            --love.graphics.draw(Game.TileSheets[Game.TileSheetActive], Game.TileTextures[Game.TileSheetActive][1], offsetXColonne, offsetYLigne)
            --love.graphics.setColor(1, 1, 1, 1)
        end
    end
end


-- Le tracer des colonnes et lignes de la map : Grille Map
function drawTheLinesOrPointiller()
    if GUI.grilleMapActive == true then

        if GUI.grilleMapLines == true then
            
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
        elseif GUI.grilleMapPointiller == true then

        end

    end 
end


--
function colorGrilleMap()
    -- Change la couleur des grille de la Map noir ou blanc
    if GUI.grilleMapColor == 'black' then
        love.graphics.setColor(0, 0, 0, colorLinesGrilleMap.alpha)
    else
        love.graphics.setColor(1, 1, 1, colorLinesGrilleMap.alpha)
    end 
end


-- Change la couleur d'arrière plan de l'éditeur de Map.
function colorBackgroundMap(pRed, pGreen, pBlue, pAlpha)
    love.graphics.setBackgroundColor(pRed, pGreen, pBlue, pAlpha)
end


-- Je charge une TileSheets et l'envoie dans la table : Game.TileSheets
function loadTileSheets(pNomDossierRessources, pNomFicherTileSheet)
    local tileSheet = love.graphics.newImage(pNomDossierRessources .. "/" .. pNomFicherTileSheet .. ".png")
    Game.TileSheets[pNomFicherTileSheet] = tileSheet
end


-- GUI tileMapsEditor
function guiTileMapEditor()
    -- inputText + Affichage de certaines données
    love.graphics.print('ORIENTATION_TILES : ' .. ORIENTATION_TILES, 0 - window.translate.x, 0 - window.translate.y)
    love.graphics.printf('MAP_WIDTH : ' .. inputText.MAP_WIDTH.txt, 0 - window.translate.x, 20 - window.translate.y, love.graphics.getWidth())
    love.graphics.printf('MAP_HEIGHT : ' .. inputText.MAP_HEIGHT.txt, 0 - window.translate.x, 40 - window.translate.y, love.graphics.getWidth())
    love.graphics.printf('TILE_WIDTH : ' .. inputText.TILE_WIDTH.txt, 0 - window.translate.x, 60 - window.translate.y, love.graphics.getWidth())
    love.graphics.printf('TILE_HEIGHT : ' .. inputText.TILE_HEIGHT.txt, 0 - window.translate.x, 80 - window.translate.y, love.graphics.getWidth())
    love.graphics.print('MAP_PIXELS : ' .. MAP_PIXELS, 0 - window.translate.x, 100 - window.translate.y)
    love.graphics.print('MAP_LIGNE : ' .. resultLignesCursorGrilleMap, 0 - window.translate.x, 120 - window.translate.y)
    love.graphics.print('MAP_COLONNE : ' .. resultColonnesCursorGrilleMap, 0 - window.translate.x, 140 - window.translate.y)
    love.graphics.print('MAP_NIVEAU : ' .. MAP_NIVEAU, 0 - window.translate.x, 160 - window.translate.y)

    love.graphics.print('GENERATE MAP', 0 - window.translate.x, 200 - window.translate.y)
    love.graphics.print('NEW MAP', 0 - window.translate.x, 220 - window.translate.y)
    love.graphics.printf('LOAD_MAP : ' .. inputText.LOAD_MAP.txt, 0 - window.translate.x, 240 - window.translate.y, love.graphics.getWidth())
    love.graphics.printf('DELETE_MAP : '  .. inputText.DELETE_MAP.txt, 0 - window.translate.x, 260 - window.translate.y, love.graphics.getWidth())
    
    love.graphics.print('Background-color (r) : ' .. backgroundColor.red, 0 - window.translate.x, 300 - window.translate.y)
    love.graphics.print('Background-color (g) : ' .. backgroundColor.green, 0 - window.translate.x, 320 - window.translate.y)
    love.graphics.print('Background-color (b) : ' .. backgroundColor.blue, 0 - window.translate.x, 340 - window.translate.y)
    love.graphics.print('Background-color (a) : ' .. backgroundColor.alpha, 0 - window.translate.x, 360 - window.translate.y)

    love.graphics.print('Opacity - Lines Grille Map : ' .. colorLinesGrilleMap.alpha, 0 - window.translate.x, 400 - window.translate.y)

    love.graphics.print('MOUSE.X : ' .. mouse.posX, 0 - window.translate.x, 440 - window.translate.y)
    love.graphics.print('MOUSE.Y : ' .. mouse.posY, 0 - window.translate.x, 460 - window.translate.y)
    love.graphics.print('ZOOM : ' .. window.zoom, 0 - window.translate.x, 480 - window.translate.y)

    love.graphics.print('F1 : Editor/Gameplay ', 0 - window.translate.x, 520 - window.translate.y)
    love.graphics.print('F2 : Change la couleur des Lines/Pointiller de la GrilleMap', 0 - window.translate.x, 540 - window.translate.y)
    love.graphics.print('F3 : Active/Désactive la Grille de la Map', 0 - window.translate.x, 560 - window.translate.y)
    love.graphics.print('F4 : Camera + Zoom par défault', 0 - window.translate.x, 580 - window.translate.y)
    love.graphics.print('F5 : Active/Désactive la GUI', 0 - window.translate.x, 600 - window.translate.y)
    love.graphics.print('F6 : Remet par défault toute la GUI (background-color..)', 0 - window.translate.x, 620 - window.translate.y)
    love.graphics.print('F7 : Les Lines/Pointiller de la Grille en mode doux/gras', 0 - window.translate.x, 640 - window.translate.y)
    love.graphics.print('Boutton Molette : Remet le Zoom par défault', 0 - window.translate.x, 660 - window.translate.y)


    --love.graphics.draw(GUI.imgGrilleMapActive, largeurEcran - GUI.imgGrilleMapActive:getWidth(), GUI.imgGrilleMapActive:getHeight(), 0, 1, 1, GUI.imgGrilleMapActive:getWidth() / 2, GUI.imgGrilleMapActive:getHeight() / 2)
    --love.graphics.draw(GU    --love.graphics.draw(GUI.imgGrilleMapColor, largeurEcran - GUI.imgGrilleMapColor:getWidth(), GUI.imgGrilleMapColor:getHeight() + GUI.imgGrilleMapColor:getHeight() * 2, 0, 1, 1, GUI.imgGrilleMapColor:getWidth() / 2, GUI.imgGrilleMapColor:getHeight() / 2)
    love.graphics.draw(GUI.imgFleche.img, GUI.imgFleche.x - window.translate.x, GUI.imgFleche.y - window.translate.y)
end


-- reset GUI/Texte par défault (color des Lines, background color..)
function resetGUITextDefault()
    GUI.grilleMapActive = true
    GUI.grilleMapLines = true
    GUI.grilleMapPointiller = false
    GUI.grilleMapStyleLinesPointiller = "smooth"
    GUI.grilleMapColor = 'black'
    GUI.drawGUIandText = true
end


-- 
function deplacementInGrilleMapZQSD()
    if love.keyboard.isDown('z') and love.keyboard.isDown('d') then -- Déplacement : Haut Droite
        cursorPersoActive = true
        love.mouse.setCursor(cursorImg.mouvementHautDroiteBasGaucheInMapEditor)
        window.translate.y = window.translate.y + 5
        window.translate.x = window.translate.x + -5
    elseif love.keyboard.isDown('z') and love.keyboard.isDown('q') then -- Déplacement : Haut Gauche
        cursorPersoActive = true
        love.mouse.setCursor(cursorImg.mouvementHautGaucheBasDroiteInMapEditor)
        window.translate.y = window.translate.y + 5
        window.translate.x = window.translate.x + 5
    elseif love.keyboard.isDown('s') and love.keyboard.isDown('q') then -- Déplacement : Bas Gauche
        cursorPersoActive = true
        love.mouse.setCursor(cursorImg.mouvementHautDroiteBasGaucheInMapEditor)
        window.translate.y = window.translate.y + -5
        window.translate.x = window.translate.x + 5
    elseif love.keyboard.isDown('s') and love.keyboard.isDown('d') then -- Déplacement : Bas Droite
        cursorPersoActive = true
        love.mouse.setCursor(cursorImg.mouvementHautGaucheBasDroiteInMapEditor)
        window.translate.y = window.translate.y + -5
        window.translate.x = window.translate.x + -5
    elseif love.keyboard.isDown('q') then -- Déplacement : Gauche
        cursorPersoActive = true
        love.mouse.setCursor(cursorImg.mouvementGaucheDroiteInMapEditor)
        window.translate.x = window.translate.x + 5
    elseif love.keyboard.isDown('d') then -- Déplacement : Droite
        cursorPersoActive = true
        love.mouse.setCursor(cursorImg.mouvementGaucheDroiteInMapEditor)
        window.translate.x = window.translate.x + -5
    elseif love.keyboard.isDown('z') then -- Déplacement : Haut
        cursorPersoActive = true
        love.mouse.setCursor(cursorImg.mouvementHautBasInMapEditor)
        window.translate.y = window.translate.y + 5
    elseif love.keyboard.isDown('s') then -- Déplacement : Bas
        cursorPersoActive = true
        love.mouse.setCursor(cursorImg.mouvementHautBasInMapEditor)
        window.translate.y = window.translate.y + -5
    elseif not love.mouse.isDown(2) then
        cursorPersoActive = false
    end
end


--
function deplacerGrilleMapClickRight()
    -- BUG : QUAND LES 4 IF SONT ACTIF LE DEPLACEMENT EST BUG, SI DEUX IF LE DEPLACEMENT EST OK -> ?? / REFAIRE EN 8 DIRECTION PEU ETRE
    -- Clique droit enfoncée en continue 
    if love.mouse.isDown(2) then
        cursorPersoActive = true
        love.mouse.setCursor(cursorImg.deplacementMapEditor)

        if GUI.drawGUIandText == true then
            clickRightIsDown = true
            GUI.drawGUIandText = false
        end

        if mouse.posX > mouseXClick then
            window.translate.x = window.translate.x + 10
        end
        
        if mouse.posX < mouseXClick then
            window.translate.x = window.translate.x + -10
        end
        
        if mouse.posY > mouseYClick then
            window.translate.y = window.translate.y + 10
        end
        
        if mouse.posY < mouseYClick then
            window.translate.y = window.translate.y + -10
        end
    end

    -- Remettre GUI.drawGUIandText a true, puisque que quand on déplace la GrilleMap on met GUI.drawGUIandText a false.
    if clickRightIsDown == true and not love.mouse.isDown(2) then
        GUI.drawGUIandText = true
        clickRightIsDown = false
    end
end


-- Draw Tiles in the GrilleMap / Mousepressed draw Tile
function drawTilesInTheGrilleMap()
    if CURRENT_LIGNE >= 0 and CURRENT_LIGNE <= (MAP_HEIGHT - 1) and CURRENT_COLONNE >= 0 and CURRENT_COLONNE <= (MAP_WIDTH - 1) then
        
    else
        --print("ENDEHORS DE LA GRILLE MAP")
    end
end


-- Génere une Map avec largeur/hauteur de la Map et des Tiles souhaitée en changeant les valeurs et ensuite en cliquant sur le boutton "Generate Map".
function generateMap()
    -- Itere sur la table qui contient toute les TileSheets, puis découpe chaque images d'une TileSheet et les envoie dans la table : Game.TileTextures (tableaux a deux dimensions)
    -- Decoupage une TileSheet en fonction des TILE_WIDTH et TILE_HEIGHT qui a était générer pour la map.
    for nomTileSheet, imgTileSheet in pairs(Game.TileSheets) do
        local tableTileSheetDecouper = decoupeSpriteSheet(0, 0, TILE_WIDTH, TILE_HEIGHT, 8, 14, 2, imgTileSheet) -- decoupeSpriteSheet() renvoie une table
        Game.Tiles[nomTileSheet] = tableTileSheetDecouper
    end


    -- Génére la Map.
    local map = {}
    map.MAP_WIDTH = tonumber(inputText.MAP_WIDTH.txt)
    map.MAP_HEIGHT = tonumber(inputText.MAP_HEIGHT.txt)
    map.TILE_WIDTH = tonumber(inputText.TILE_WIDTH.txt)
    map.TILE_HEIGHT = tonumber(inputText.TILE_HEIGHT.txt)

    for l=0,MAP_HEIGHT do
        local lineTable = {}

        for c=0,MAP_WIDTH do
            local colonne = 0 -- 0 = aucune Tile
            lineTable[c] = colonne
        end

        map[l] = lineTable
    end

    table.insert(Game.MapNiveau, map)

    Game.MapNiveauActive = #Game.MapNiveau
    MAP_NIVEAU = Game.MapNiveauActive
end


-- LoadMap
function loadMap(pNiveauMap)
    pNiveauMap = tonumber(pNiveauMap)
    
    if Game.MapNiveau[pNiveauMap] ~= nil then
        MAP_WIDTH = Game.MapNiveau[pNiveauMap].MAP_WIDTH 
        MAP_HEIGHT = Game.MapNiveau[pNiveauMap].MAP_HEIGHT 

        TILE_WIDTH = Game.MapNiveau[pNiveauMap].TILE_WIDTH 
        TILE_HEIGHT = Game.MapNiveau[pNiveauMap].TILE_HEIGHT

        inputText.MAP_WIDTH.txt = MAP_WIDTH
        inputText.MAP_HEIGHT.txt = MAP_HEIGHT
        inputText.TILE_WIDTH.txt = TILE_WIDTH
        inputText.TILE_HEIGHT.txt = TILE_HEIGHT

        NOMBRE_LIGNE = MAP_HEIGHT * TILE_HEIGHT 
        NOMBRE_COLONNE = MAP_WIDTH * TILE_WIDTH
        MAP_PIXELS = NOMBRE_LIGNE .. ' x ' .. NOMBRE_COLONNE .. ' pixels'

        Game.MapNiveauActive = pNiveauMap
        MAP_NIVEAU = Game.MapNiveauActive
    end
end


-- Delete un niveau de map
function deleteMap(pNiveauMap)
    pNiveauMap = tonumber(pNiveauMap)

    if Game.MapNiveau[pNiveauMap] ~= nil then
        if pNiveauMap == Game.MapNiveauActive then
            newMap()
            table.remove(Game.MapNiveau, pNiveauMap) 
        else
            table.remove(Game.MapNiveau, pNiveauMap) 
        end
    end

end


-- Delete un niveau de map
function newMap()
    MAP_WIDTH = 0
    MAP_HEIGHT = 0

    TILE_WIDTH = 0
    TILE_HEIGHT = 0

    inputText.MAP_WIDTH.txt = MAP_WIDTH
    inputText.MAP_HEIGHT.txt = MAP_HEIGHT
    inputText.TILE_WIDTH.txt = TILE_WIDTH
    inputText.TILE_HEIGHT.txt = TILE_HEIGHT

    NOMBRE_LIGNE = MAP_HEIGHT * TILE_HEIGHT 
    NOMBRE_COLONNE = MAP_WIDTH * TILE_WIDTH
    MAP_PIXELS = NOMBRE_LIGNE .. ' x ' .. NOMBRE_COLONNE .. ' pixels'

    MAP_NIVEAU = "?"
end








--[[   
██       ██████   █████  ██████  
██      ██    ██ ██   ██ ██   ██ 
██      ██    ██ ███████ ██   ██ 
██      ██    ██ ██   ██ ██   ██ 
███████  ██████  ██   ██ ██████                                                                    
]]

function tileMapsEditor.Load()
    -- Je charge toutes mes TileSheets (Une SpriteSheet qui contient des Tiles (Textures))
    -- loadTileSheets(nomDuDossier, nomFichierImg)
    loadTileSheets('assets', 'tileSet')
                
    
    -- Je charge les images de la GUI de l'éditeur de Map
    GUI.imgButtonGrilleMapActive = love.graphics.newImage("assets/grilleButton.png")
    GUI.imgButtonGrilleMapColor = love.graphics.newImage("assets/grilleColorButton.png")
    GUI.imgFleche.img = love.graphics.newImage("assets/flecheGauche.png")


    -- Je charge les images différentes pour le cursor.
    cursorImg.deplacementMapEditor = love.mouse.newCursor("assets/cursor_deplacementTileMapEditor.png", 10, 10)
    cursorImg.mouvementHautBasInMapEditor = love.mouse.newCursor("assets/cursor_HautBas.png", 10, 10)
    cursorImg.mouvementGaucheDroiteInMapEditor = love.mouse.newCursor("assets/cursor_GaucheDroite.png", 10, 10)
    cursorImg.mouvementHautDroiteBasGaucheInMapEditor = love.mouse.newCursor("assets/cursor_HautDroiteBasGauche.png", 10, 10)
    cursorImg.mouvementHautGaucheBasDroiteInMapEditor = love.mouse.newCursor("assets/cursor_HautGaucheBasDroite.png", 10, 10)


    --
    love.keyboard.setKeyRepeat(true)
end




--[[   
██    ██ ██████  ██████   █████  ████████ ███████ 
██    ██ ██   ██ ██   ██ ██   ██    ██    ██      
██    ██ ██████  ██   ██ ███████    ██    █████   
██    ██ ██      ██   ██ ██   ██    ██    ██      
 ██████  ██      ██████  ██   ██    ██    ███████                                                                                                                                                                      
]]

function tileMapsEditor.Update(dt)
    -- Mise à jour de la position X et Y de la souris en continue. 
    updateMouseXandY()


    -- Calcule par rapport au pointeur de la souris la position de la ligne et colonne de la GrilleMap.
    getPositionCursorInGrilleMap()


    -- Si il y a un cursor personnaliser en cours alors je désactive le cursor par défault.
    if cursorPersoActive == false then
        love.mouse.setCursor()
    end


    --
    deplacerGrilleMapClickRight()
    
    
    -- ASSOCIER LES FLECHES GUI A CES BOUTTONS CI DESSOUS
    deplacementInGrilleMapZQSD()


    --
    drawTilesInTheGrilleMap()
end




--[[   
██████  ██████   █████  ██     ██ 
██   ██ ██   ██ ██   ██ ██     ██ 
██   ██ ██████  ███████ ██  █  ██ 
██   ██ ██   ██ ██   ██ ██ ███ ██ 
██████  ██   ██ ██   ██  ███ ███                                                                                                                                                                                                                                    
]]

function tileMapsEditor.Draw()
    -- Set un background color
    colorBackgroundMap(backgroundColor.red, backgroundColor.green, backgroundColor.blue, backgroundColor.alpha)    

    -- Change la couleur des Lines/Pointiller de la grille de la Map (noir ou blanc)
    colorGrilleMap()


    -- Translation par rapport au Zoom. 
    -- Initialiser la mise a l'échelle (Scale). 
    -- Puis je défini le Scale pour X et Y à la fois.
    love.graphics.translate(window.translate.x, window.translate.y)
    love.graphics.push()
	love.graphics.scale(window.zoom)


    -- Le style des Lines/Pointiller de la GrilleMap -> fin/doux ou épais/gras.
    love.graphics.setLineStyle(GUI.grilleMapStyleLinesPointiller)


    -- Le tracer des Lines ou Pointillées -> des colonnes et lignes de la map : Grille Map
    drawTheLinesOrPointiller()


    -- Remet la palette de couleur par défault après avoir appliquer une palette de couleur pour les Lines/Pointiller de la grille de la Map.
    love.graphics.setColor(1, 1, 1)    


    -- Affichage de la Texture sur la Tile en transparent si je suis sur la GrilleMap ou en rouge transparent si je suis en-dehors de la GrilleMap.
    drawTileRedOrTexture()    


    -- Remettre la mise à l'échelle normale (Scale x,y : 1 - Obligatoire pour retrouver un Scale normal)
    love.graphics.pop()


    -- Si GUI.drawGUIandText == true : alors la GUI + Texte a l'écran est affichée.
    if GUI.drawGUIandText == true then
        guiTileMapEditor()
    end
end




--[[   
████████ ███████ ██   ██ ████████     ██ ███    ██ ██████  ██    ██ ████████ 
   ██    ██       ██ ██     ██        ██ ████   ██ ██   ██ ██    ██    ██    
   ██    █████     ███      ██        ██ ██ ██  ██ ██████  ██    ██    ██    
   ██    ██       ██ ██     ██        ██ ██  ██ ██ ██      ██    ██    ██    
   ██    ███████ ██   ██    ██        ██ ██   ████ ██       ██████     ██                                                                                                                                                                                                                                                                                                                                                                                            
]]

function tileMapsEditor.textinput(event)

    event = tonumber(event)

    if type(event) == "number" then
        if inputTextActive == "MAP_WIDTH" and MAP_NIVEAU == "?" then
            if MAP_WIDTH <= 8000 then
                inputText.MAP_WIDTH.txt = inputText.MAP_WIDTH.txt .. event
            end
        elseif inputTextActive == "MAP_HEIGHT" and MAP_NIVEAU == "?" then
            if MAP_HEIGHT <= 8000 then
                inputText.MAP_HEIGHT.txt = inputText.MAP_HEIGHT.txt .. event
            end
        elseif inputTextActive == "TILE_WIDTH" and MAP_NIVEAU == "?" then
            inputText.TILE_WIDTH.txt = inputText.TILE_WIDTH.txt .. event
        elseif inputTextActive == "TILE_HEIGHT" and MAP_NIVEAU == "?" then
            inputText.TILE_HEIGHT.txt = inputText.TILE_HEIGHT.txt .. event
        elseif inputTextActive == "LOAD_MAP" then
            inputText.LOAD_MAP.txt = inputText.LOAD_MAP.txt .. event
        elseif inputTextActive == "DELETE_MAP" then
            inputText.DELETE_MAP.txt = inputText.DELETE_MAP.txt .. event
        end
    end

    MAP_WIDTH = tonumber(inputText.MAP_WIDTH.txt)
    MAP_HEIGHT = tonumber(inputText.MAP_HEIGHT.txt)
    TILE_WIDTH = tonumber(inputText.TILE_WIDTH.txt)
    TILE_HEIGHT = tonumber(inputText.TILE_HEIGHT.txt)
    NOMBRE_LIGNE = MAP_HEIGHT * TILE_HEIGHT 
    NOMBRE_COLONNE = MAP_WIDTH * TILE_WIDTH
    MAP_PIXELS = NOMBRE_LIGNE .. ' x ' .. NOMBRE_COLONNE .. ' pixels'
    LOAD_MAP = tonumber(inputText.LOAD_MAP.txt)
    DELETE_MAP = tonumber(inputText.DELETE_MAP.txt)
end




--[[   
██   ██ ███████ ██    ██     ██████  ██████  ███████ ███████ ███████ ███████ ██████  
██  ██  ██       ██  ██      ██   ██ ██   ██ ██      ██      ██      ██      ██   ██ 
█████   █████     ████       ██████  ██████  █████   ███████ ███████ █████   ██   ██ 
██  ██  ██         ██        ██      ██   ██ ██           ██      ██ ██      ██   ██ 
██   ██ ███████    ██        ██      ██   ██ ███████ ███████ ███████ ███████ ██████                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
]]

function tileMapsEditor.keypressed(key, isrepeat)
  
    -- En mode Editeur ou Gameplay (Change de Scenes)
    if key == "f1" then 
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


    -- Change la couleur des Lines/Pointiller de la GrilleMap. (noir ou blanc)
    if key == "f2" then
        if GUI.grilleMapColor == 'black' then 
            GUI.grilleMapColor = 'white'
        else
           GUI.grilleMapColor = 'black'
        end
    end


    -- Active ou désactive le tracer des Lines/Pointiller de la GrilleMap.
    if key == "f3" then
        if GUI.grilleMapActive == true then 
            GUI.grilleMapActive = false
        else
            GUI.grilleMapActive = true
        end
    end


    -- Remet le ZoomX et ZoomY par défault et remettre la map avec la premier Tile en haut a gauche de l'écran a 0,0 (x,y) 
    if key == "f4" then
        window.zoom = 1
        window.translate.x = 0
        window.translate.y = 0
    end


    -- Active ou désactive la GUI/Texte a l'écran
    if key == "f5" then
        if GUI.drawGUIandText == true then
            GUI.drawGUIandText = false
        else
            GUI.drawGUIandText = true
        end
    end


    -- Remet par défault toute la GUI/Texte avec les couleur de base, background color..etc
    if key == "f6" then
        resetGUITextDefault()
    end


    -- Style des Lines/Pointiller sois en doux/épais.
    if key == "f7" then
        if GUI.grilleMapStyleLinesPointiller == "smooth" then
            GUI.grilleMapStyleLinesPointiller = "rough"
        else
            GUI.grilleMapStyleLinesPointiller = "smooth"
        end
    end


    -- Permet a la fleche de bouger (GUI)
    if key == "down" then
        if GUI.imgFleche.x == inputText.ORIENTATION_TILES.widthFont + 15 then
            GUI.imgFleche.x = inputText.MAP_WIDTH.widthFont + 15
            GUI.imgFleche.y = GUI.imgFleche.y + 20
            inputTextActive = "MAP_WIDTH"
        elseif GUI.imgFleche.x == inputText.MAP_WIDTH.widthFont + 15 then
            GUI.imgFleche.x = inputText.MAP_HEIGHT.widthFont + 15
            GUI.imgFleche.y = GUI.imgFleche.y + 20
            inputTextActive = "MAP_HEIGHT"
        elseif GUI.imgFleche.x == inputText.MAP_HEIGHT.widthFont + 15 then
            GUI.imgFleche.x = inputText.TILE_WIDTH.widthFont + 15
            GUI.imgFleche.y = GUI.imgFleche.y + 20
            inputTextActive = "TILE_WIDTH"
        elseif GUI.imgFleche.x == inputText.TILE_WIDTH.widthFont + 15 then
            GUI.imgFleche.x = inputText.TILE_HEIGHT.widthFont + 15
            GUI.imgFleche.y = GUI.imgFleche.y + 20
            inputTextActive = "TILE_HEIGHT"
        elseif GUI.imgFleche.x == inputText.TILE_HEIGHT.widthFont + 15 then
            GUI.imgFleche.x = inputText.GENERATE_MAP.widthFont + 15
            GUI.imgFleche.y = GUI.imgFleche.y + 120
            inputTextActive = "GENERATE_MAP"
        elseif GUI.imgFleche.x == inputText.GENERATE_MAP.widthFont + 15 then
            GUI.imgFleche.x = inputText.NEW_MAP.widthFont + 15
            GUI.imgFleche.y = GUI.imgFleche.y + 20
            inputTextActive = "NEW_MAP"
        elseif GUI.imgFleche.x == inputText.NEW_MAP.widthFont + 15 then
            GUI.imgFleche.x = inputText.LOAD_MAP.widthFont + 15
            GUI.imgFleche.y = GUI.imgFleche.y + 20
            inputTextActive = "LOAD_MAP"
        elseif GUI.imgFleche.x == inputText.LOAD_MAP.widthFont + 15 then
            GUI.imgFleche.x = inputText.DELETE_MAP.widthFont + 15
            GUI.imgFleche.y = GUI.imgFleche.y + 20
            inputTextActive = "DELETE_MAP"
           ---------BUG A PARTIR D ICI ------------
        --[[elseif GUI.imgFleche.x == inputText.DELETE_MAP.widthFont + 15 then
            GUI.imgFleche.x = inputText.backgroundColorRed.widthFont + 15
            GUI.imgFleche.y = GUI.imgFleche.y + 40
            inputTextActive = "backgroundColorRed"
        elseif GUI.imgFleche.x == inputText.backgroundColorRed.widthFont + 15 then
            GUI.imgFleche.x = inputText.backgroundColorGreen.widthFont + 15
            GUI.imgFleche.y = GUI.imgFleche.y + 20
            inputTextActive = "backgroundColorGreen"
        elseif GUI.imgFleche.x == inputText.backgroundColorRed.widthFont + 15 then
            GUI.imgFleche.x = inputText.backgroundColorGreen.widthFont + 15
            GUI.imgFleche.y = GUI.imgFleche.y + 20
            inputTextActive = "backgroundColorGreen"]]
        else
            GUI.imgFleche.x = inputText.ORIENTATION_TILES.widthFont + 15
            GUI.imgFleche.y = 0
            inputTextActive = "ORIENTATION_TILES"
        end
    end


    -- InputText pour changer la LARGEUR/HAUTEUR des TILES/MAP.
    if key == "backspace" then
        -- get the byte offset to the last UTF-8 character in the string.
        local byteoffsetMAP_WIDTH = utf8.offset(inputText.MAP_WIDTH.txt, -1)
        local byteoffsetMAP_HEIGHT = utf8.offset(inputText.MAP_HEIGHT.txt, -1)
        local byteoffsetTILE_WIDTH = utf8.offset(inputText.TILE_WIDTH.txt, -1)
        local byteoffsetTILE_HEIGHT = utf8.offset(inputText.TILE_HEIGHT.txt, -1)
        local byteoffsetLOAD_MAP = utf8.offset(inputText.LOAD_MAP.txt, -1)
        local byteoffsetDELETE_MAP = utf8.offset(inputText.DELETE_MAP.txt, -1)

        -- remove the last UTF-8 character.
        if byteoffsetMAP_WIDTH and inputTextActive == "MAP_WIDTH" then
            if tonumber(inputText.MAP_WIDTH.txt) <= 9 then
                inputText.MAP_WIDTH.txt = 0
                MAP_WIDTH = inputText.MAP_WIDTH.txt
            else
                inputText.MAP_WIDTH.txt = string.sub(inputText.MAP_WIDTH.txt, 1, byteoffsetMAP_WIDTH - 1)
                inputText.MAP_WIDTH.txt = tonumber(inputText.MAP_WIDTH.txt)
                MAP_WIDTH = inputText.MAP_WIDTH.txt
            end
        elseif byteoffsetMAP_HEIGHT and inputTextActive == "MAP_HEIGHT" then
            if tonumber(inputText.MAP_HEIGHT.txt) <= 9 then
                inputText.MAP_HEIGHT.txt = 0
                MAP_HEIGHT = inputText.MAP_HEIGHT.txt
            else
                inputText.MAP_HEIGHT.txt = string.sub(inputText.MAP_HEIGHT.txt, 1, byteoffsetMAP_HEIGHT - 1)
                inputText.MAP_HEIGHT.txt = tonumber(inputText.MAP_HEIGHT.txt)
                MAP_HEIGHT = inputText.MAP_HEIGHT.txt
            end
        elseif byteoffsetTILE_WIDTH and inputTextActive == "TILE_WIDTH" then
            if tonumber(inputText.TILE_WIDTH.txt) <= 9 then
                inputText.TILE_WIDTH.txt = 0
                TILE_WIDTH = inputText.TILE_WIDTH.txt
            else
                inputText.TILE_WIDTH.txt = string.sub(inputText.TILE_WIDTH.txt, 1, byteoffsetTILE_WIDTH - 1)
                inputText.TILE_WIDTH.txt = tonumber(inputText.TILE_WIDTH.txt)
                TILE_WIDTH = inputText.TILE_WIDTH.txt
            end
        elseif byteoffsetTILE_HEIGHT and inputTextActive == "TILE_HEIGHT" then
            if tonumber(inputText.TILE_HEIGHT.txt) <= 9 then
                inputText.TILE_HEIGHT.txt = 0
                TILE_HEIGHT = inputText.TILE_HEIGHT.txt
            else
                inputText.TILE_HEIGHT.txt = string.sub(inputText.TILE_HEIGHT.txt, 1, byteoffsetTILE_HEIGHT - 1)
                inputText.TILE_HEIGHT.txt = tonumber(inputText.TILE_HEIGHT.txt)
                TILE_HEIGHT = inputText.TILE_HEIGHT.txt
            end
        elseif byteoffsetLOAD_MAP and inputTextActive == "LOAD_MAP" then
            if tonumber(inputText.LOAD_MAP.txt) <= 9 then
                inputText.LOAD_MAP.txt = ""
                LOAD_MAP = inputText.LOAD_MAP.txt
            else
                inputText.LOAD_MAP.txt = string.sub(inputText.LOAD_MAP.txt, 1, byteoffsetTILE_HEIGHT - 1)
                inputText.LOAD_MAP.txt = tonumber(inputText.LOAD_MAP.txt)
                LOAD_MAP = inputText.LOAD_MAP.txt
            end
        elseif byteoffsetDELETE_MAP and inputTextActive == "DELETE_MAP" then
            if tonumber(inputText.DELETE_MAP.txt) <= 9 then
                inputText.DELETE_MAP.txt = ""
                DELETE_MAP = inputText.DELETE_MAP.txt
            else
                inputText.DELETE_MAP.txt = string.sub(inputText.DELETE_MAP.txt, 1, byteoffsetTILE_HEIGHT - 1)
                inputText.DELETE_MAP.txt = tonumber(inputText.DELETE_MAP.txt)
                DELETE_MAP = inputText.DELETE_MAP.txt
            end
        end

        NOMBRE_LIGNE = MAP_HEIGHT * TILE_HEIGHT 
        NOMBRE_COLONNE = MAP_WIDTH * TILE_WIDTH
        MAP_PIXELS = NOMBRE_LIGNE .. ' x ' .. NOMBRE_COLONNE .. ' pixels'
    end


    -- Generate Map
    if key == "return" then
        if inputTextActive == "ORIENTATION_TILES" then
            if ORIENTATION_TILES == "Orthogonale" then
                ORIENTATION_TILES = "Isometric" -- FAKE RIEN ES FAIT
            else
                ORIENTATION_TILES = "Orthogonale"
            end
        elseif inputTextActive == "GENERATE_MAP" then 
            generateMap()
        elseif inputTextActive == "NEW_MAP" then 
            newMap()
        elseif inputTextActive == "LOAD_MAP" then 
            loadMap(inputText.LOAD_MAP.txt)
        elseif inputTextActive == "DELETE_MAP" then 
            print(inputTextActive)
            deleteMap(inputText.DELETE_MAP.txt)
        end
    end


    --
    if key == "left" or key == "right" then
        if inputTextActive == "backgroundColorRed" then
            if key == "left" then
                backgroundColor.red = backgroundColor.red - 1
            elseif key == "right" then
                backgroundColor.red = backgroundColor.red + 1
            end
        elseif inputTextActive == "backgroundColorGreen" then
            if key == "left" then
                backgroundColor.green = backgroundColor.green - 1
            elseif key == "right" then
                backgroundColor.green = backgroundColor.green + 1
            end
        elseif inputTextActive == "backgroundColorBlue" then
            if key == "left" then
                backgroundColor.blue = backgroundColor.blue - 1
            elseif key == "right" then
                backgroundColor.blue = backgroundColor.blue + 1
            end
        elseif inputTextActive == "backgroundColorAlpha" then
            if key == "left" then
                backgroundColor.alpha = backgroundColor.alpha - 0.2
            elseif key == "right" then
                backgroundColor.alpha = backgroundColor.alpha + 0.2
            end
        elseif inputTextActive == "colorLinesGrilleMapAlpha" then
            if key == "left" then
                colorLinesGrilleMap.alpha = colorLinesGrilleMap.alpha - 0.2
            elseif key == "right" then
                colorLinesGrilleMap.alpha = colorLinesGrilleMap.alpha + 0.2
            end
        end
    end
      
end




--[[   
███    ███  ██████  ██    ██ ███████ ███████     ██████  ██████  ███████ ███████ ███████ ███████ ██████  
████  ████ ██    ██ ██    ██ ██      ██          ██   ██ ██   ██ ██      ██      ██      ██      ██   ██ 
██ ████ ██ ██    ██ ██    ██ ███████ █████       ██████  ██████  █████   ███████ ███████ █████   ██   ██ 
██  ██  ██ ██    ██ ██    ██      ██ ██          ██      ██   ██ ██           ██      ██ ██      ██   ██ 
██      ██  ██████   ██████  ███████ ███████     ██      ██   ██ ███████ ███████ ███████ ███████ ██████                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
]]

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


    -- Appuie sur le boutton de la roulette = Remet le ZoomX et ZoomY par défault
    if button == 3 then
        window.zoom = 1
    end


    -- Récupère la position de la souris X et Y a partir du moment ou on fait un clique à la souris (clique gauche ou droite)
    mouseXClick = mouse.posX
    mouseYClick = mouse.posY
end




--[[   
██     ██ ██   ██ ███████ ███████ ██          ███    ███  ██████  ██    ██ ███████ ██████  
██     ██ ██   ██ ██      ██      ██          ████  ████ ██    ██ ██    ██ ██      ██   ██ 
██  █  ██ ███████ █████   █████   ██          ██ ████ ██ ██    ██ ██    ██ █████   ██   ██ 
██ ███ ██ ██   ██ ██      ██      ██          ██  ██  ██ ██    ██  ██  ██  ██      ██   ██ 
 ███ ███  ██   ██ ███████ ███████ ███████     ██      ██  ██████    ████   ███████ ██████                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
]]

function love.wheelmoved(x, y)
    -- Zoom avant sur un point ou Zoom arrière sur un point 
    if not (y == 0) then
		local mouse_x = mouse.posX
		local mouse_y = mouse.posY
		local k = dscale^y

		window.zoom = window.zoom * k
		window.translate.x = math.floor(window.translate.x + mouse_x * (1-k))
		window.translate.y = math.floor(window.translate.y + mouse_y * (1-k))
    end
end

return tileMapsEditor 