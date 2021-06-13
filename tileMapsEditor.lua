----------------------------------------------DOCUMENTATION DU FRAMEWORK-----------------------------------------------------------------------------------------------------

-- 1) Quand on lance l'éditeur on'as aucune map créer encore, si le niveau de la map est affichée comme ceci : 'MAP_NIVEAU : ?' c'est que c'est une nouvelle map non sauvegarder.
-- 2) Donc quand on n'as : '?' il faut configurer la LARGEUR/HAUTEUR de la MAP/TILES puis aller sur 'GENERATE MAP' et faire 'ENTER' pour générer la MAP.
-- 3) Quand on créer un niveau de Map on'as normalement : 'MAP_NIVEAU' : 1.. 2.. avec le niveau actuelle de la TileMap du niveau.
-- 4) Quand on n'es sur un niveau de map en cours sur l'éditeur de Map il faut faire : 'NEW MAP' ça va regénérer une nouvelle map VIDE et faut la reconfigurer et faire GENERATE_MAP.
-- 5) On peux Load une Map créer auparavant en la chargeant en mettant le numéro du niveau.



-- A FAIRE MANUELLEMENT / IMPORTANT : 

-- 1) Il faudra charger manuellement les TileSheets dans la fonction de LOVE qui est LOAD, a la ligne 940 comme ci-dessous a la suite des autres : 
-- Description de la fonction : loadTileSheets(nomDuDossier, nomFichierImgTileSheet)
-- Exemple : loadTileSheets('assets', 'tileSet')
-- IMPORTANT : Toujours ajouter les TileSheets à la suite des autres
-- IMPORTANT/PROBLEME : Si on supprime une TileSheet tout les numéro sont décaler dans les tableau a deux dimensions, donc ajouter les TileSheets a la suite des autres sans supprimer.


-- 2) Il faudra ensuite aller dans la fonction : loadTiles() pour choisir la configuration du découpage de la TileSheet comme ci-dessous comme exemple :
    --local tableTileSheetDecouper2 = decoupeSpriteSheet(0, 0, TILE_WIDTH, TILE_HEIGHT, 16, 6, 12, Game.TileSheets[2])
    --table.insert(tablesTileSheetsDecouperAll, tableTileSheetDecouper2)


-- 3) Supprimer une map il faudra le faire manuellement dans le fichier : map.lua -> IMPORTANT IL FAUT BIEN LAISSER UN ESPACE ENTRE CHAQUE TABLEAU A DEUX DIMENSIONS.

-- 4) Créer au minimum un fichier : map.lua à la racine du projet -> local map = {} return map : Puis faire un -> require("map") dans main.lua

-- 5) Les TileSet doivent être extremement bien faite, que chaque Tile sois bien coller entre eux et bien configurer la fonction pour découpé la SpriteSheet. 

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local tileMapsEditor = {}

require("map")
  

-- Toute les données importante de l'éditeur de Map.
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
SAVE_MAP = ""


--
Game = {}
Game.TileSheets = {}
Game.TileSheetsActive = {}
Game.Tiles = {}
Game.TileActive = nil
Game.MapNiveau = {}
Game.MapNiveauActive = nil
Game.Calques = {}
Game.CalquesActive = nil


-- Données View Tiles
ligneViewTile = 0
colonneViewTile = 0
grilleViewTilesWidth = 0
grilleViewTilesHeight = 0
inGrilleMapViewTiles = false
clickInOneTile = false
clickTileCurrentColonne = 0
clickTileCurrentLigne = 0
scrollY_ViewTile = 0
scrollY_counterMax = 0
scrollY_counter = 0
scrollY_TileAlphaSortZone = 1


-- L'outils actuellement activé (Pinceau, gomme...)
pinceauAlpha = 1 -- alpha
gommeAlpha = 1 -- alpha
outilsActive = nil


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
inputText.NEW_MAP = { widthFont = font:getWidth('NEW MAP') }
inputText.LOAD_MAP = { txt = "", widthFont = font:getWidth('LOAD_MAP : ' .. LOAD_MAP) }
inputText.SAVE_MAP = { txt = SAVE_MAP, widthFont = font:getWidth('SAVE_MAP') }

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
GUI.imgButtonDessinerGrille = nil
GUI.imgButtonGommeGrille = nil
GUI.imgButtonNone = nil


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
    love.graphics.printf('SAVE_MAP'  .. inputText.SAVE_MAP.txt, 0 - window.translate.x, 260 - window.translate.y, love.graphics.getWidth())

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


    --
    love.graphics.draw(GUI.imgFleche.img, GUI.imgFleche.x - window.translate.x, GUI.imgFleche.y - window.translate.y)

    love.graphics.setColor(1, 1, 1, pinceauAlpha)
    love.graphics.draw(GUI.imgButtonDessinerGrille, largeurEcran - GUI.imgButtonDessinerGrille:getWidth() - window.translate.x, GUI.imgButtonDessinerGrille:getHeight() - window.translate.y, 0, 1, 1, GUI.imgButtonDessinerGrille:getWidth() / 2, GUI.imgButtonDessinerGrille:getHeight() / 2)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setColor(1, 1, 1, gommeAlpha)
    love.graphics.draw(GUI.imgButtonGommeGrille, largeurEcran - GUI.imgButtonGommeGrille:getWidth() - window.translate.x, GUI.imgButtonDessinerGrille:getHeight() + GUI.imgButtonGommeGrille:getHeight() - window.translate.y, 0, 1, 1, GUI.imgButtonGommeGrille:getWidth() / 2, GUI.imgButtonGommeGrille:getHeight() / 2)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.draw(GUI.imgButtonNone, largeurEcran - (GUI.imgButtonNone:getWidth() - 5) - window.translate.x, GUI.imgButtonGommeGrille:getHeight() + GUI.imgButtonGommeGrille:getHeight() + GUI.imgButtonNone:getHeight() + - window.translate.y, 0, 1, 1, GUI.imgButtonNone:getWidth() / 2, GUI.imgButtonNone:getHeight() / 2)


    --
    drawViewTiles()


    --
    getPositionCursorInGrilleMapViewTilesandDraw()
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


-- Génere une Map avec largeur/hauteur de la Map et des Tiles souhaitée en changeant les valeurs et ensuite en cliquant sur le boutton "Generate Map".
function generateMap()
    -- Génére la Map.
    local map = {}
    map.MAP_WIDTH = tonumber(inputText.MAP_WIDTH.txt)
    map.MAP_HEIGHT = tonumber(inputText.MAP_HEIGHT.txt)
    map.TILE_WIDTH = tonumber(inputText.TILE_WIDTH.txt)
    map.TILE_HEIGHT = tonumber(inputText.TILE_HEIGHT.txt)

    for l=1,MAP_HEIGHT do
        local lineTable = {}

        for c=1,MAP_WIDTH do
            local colonne = 0 -- 0 = aucune Tile
            lineTable[c] = colonne
        end

        map[l] = lineTable
    end

    table.insert(Game.MapNiveau, map)

    if TileMaps == nil then
        Game.MapNiveauActive = 1
        MAP_NIVEAU = Game.MapNiveauActive
    else
        Game.MapNiveauActive = #TileMaps + 1
        MAP_NIVEAU = Game.MapNiveauActive
    end

    -- Je commence a reparcourir ma map qui a était créer précédement plus haut, 
    -- pour permettre d'inserer dans le fichier avec une indentation propre..etc
    data = nil
    lengthLigneMap = #Game.MapNiveau[#Game.MapNiveau]
    lengthColonneMap = #Game.MapNiveau[#Game.MapNiveau][1]

    for l=1,lengthLigneMap do
        local ligne = "                    { "

        for c=1,lengthColonneMap do
            if c == lengthColonneMap then
                ligne = ligne .. Game.MapNiveau[#Game.MapNiveau][lengthLigneMap][lengthColonneMap]
            else
                ligne = ligne .. Game.MapNiveau[#Game.MapNiveau][lengthLigneMap][lengthColonneMap] .. ", "
            end
        end

        ligne = ligne .. " },"
        
        if l ~= 1 then
            data = data .. "\n" .. ligne
        else
            data = ligne
        end
    end

    dataMap = "                {" .. "\n" ..
                    data .. "\n" .. "\n" ..
                    "                    MAP_WIDTH = " .. MAP_WIDTH .. "," .. "\n" ..
                    "                    MAP_HEIGHT = " .. MAP_HEIGHT .. "," .. "\n" ..
                    "                    TILE_WIDTH = " .. TILE_WIDTH .. "," .. "\n" ..
                    "                    TILE_HEIGHT = " .. TILE_HEIGHT .. "," .. "\n" ..
              "                },"

    fileData = "local map = {}" .. "\n" .. "\n" ..
               "ORIENTATION_TILES = " .. '"' .. ORIENTATION_TILES .. '"' .. "\n" ..
               "TILE_OFFSETX = " .. 0 .. "\n" ..
               "TILE_OFFSETY = " .. 0 .. "\n" ..
               "TileMaps = {" .. "\n" .. dataMap .. "\n" .. "           }" .. "\n" .. "\n" ..
               "return map"

    -- Bugs je suis obliger de déclarer deux fichiers pour récupèrer la longueur du fichier et toute la chaîne de caractères.
    file1 = io.open(pathCurrent .. '/map.lua', "r")
    file2 = io.open(pathCurrent .. '/map.lua', "r")
    fileDataLength = #file1:read("*all")
    fileDataCurrent = file2:read("*all")

    -- Si il y a au moins une map de créer alors..
    if fileDataLength >= 50 then
        fileDataCurrent = string.sub(fileDataCurrent, 1, fileDataLength - 15)
        fileData = fileDataCurrent .. "\n" .. dataMap .. "\n" .. "           }" .. "\n" .. "\n" .. "return map"

        file = io.open(pathCurrent .. '/map.lua', 'w+')
        file:write(fileData)
        file:close()
    else
        -- Si jamais il n'y a encore aucune Map 
        -- J'ouvre le fichier, puis j'écrase ce qui a dessus et j'écris les nouvelles données.
        file = io.open(pathCurrent .. '/map.lua', 'w+')
        file:write(fileData)
        file:close()
    end

    -- Après avoir générer une map, le fichier map.lua est modifier mais en mémoire dans Love2D rien n'est modifier donc on le charge a nouveau et on l'éxecute
    love.filesystem.load("map.lua")()
end


-- LoadMap
function loadMap(pNiveauMap)
    pNiveauMap = tonumber(pNiveauMap)
    
    if TileMaps[pNiveauMap] ~= nil then
        MAP_WIDTH = TileMaps[pNiveauMap].MAP_WIDTH 
        MAP_HEIGHT = TileMaps[pNiveauMap].MAP_HEIGHT 

        TILE_WIDTH = TileMaps[pNiveauMap].TILE_WIDTH 
        TILE_HEIGHT = TileMaps[pNiveauMap].TILE_HEIGHT

        inputText.MAP_WIDTH.txt = MAP_WIDTH
        inputText.MAP_HEIGHT.txt = MAP_HEIGHT
        inputText.TILE_WIDTH.txt = TILE_WIDTH
        inputText.TILE_HEIGHT.txt = TILE_HEIGHT

        NOMBRE_LIGNE = MAP_HEIGHT * TILE_HEIGHT 
        NOMBRE_COLONNE = MAP_WIDTH * TILE_WIDTH
        MAP_PIXELS = NOMBRE_LIGNE .. ' x ' .. NOMBRE_COLONNE .. ' pixels'

        Game.MapNiveauActive = pNiveauMap
        MAP_NIVEAU = Game.MapNiveauActive

        scrollY_counter = 0
        scrollY_ViewTile = 0

        clickInOneTile = false
        Game.TileActive = nil
    end
end


-- Sauvegarde la Map actuellement chargée dans l'éditeur de niveau.
function saveMap(pNiveauMap)
    pNiveauMap = tonumber(pNiveauMap)

    if TileMaps[pNiveauMap] ~= nil then
        local lengthLigneMap = TileMaps[pNiveauMap].MAP_HEIGHT
        local lengthColonneMap = TileMaps[pNiveauMap].MAP_WIDTH

        --
        local data = nil

        for l=1,lengthLigneMap do
            local ligne = "                    { "

            for c=1,lengthColonneMap do
                if c == lengthColonneMap then
                    ligne = ligne .. TileMaps[pNiveauMap][l][c]
                else
                    ligne = ligne .. TileMaps[pNiveauMap][l][c] .. ", "
                end
            end

            ligne = ligne .. " },"
            
            if l ~= 1 then
                data = data .. "\n" .. ligne
            else
                data = ligne
            end
        end

        dataMapChanger = "                {" .. "\n" ..
                                            data .. "\n" .. "\n" ..
                        "                    MAP_WIDTH = " .. MAP_WIDTH .. "," .. "\n" ..
                        "                    MAP_HEIGHT = " .. MAP_HEIGHT .. "," .. "\n" ..
                        "                    TILE_WIDTH = " .. TILE_WIDTH .. "," .. "\n" ..
                        "                    TILE_HEIGHT = " .. TILE_HEIGHT .. "," .. "\n" ..
                        "                },"

        saveMapCurrent = pNiveauMap
        lengthMaps = #TileMaps

        dataMapsRestant = ""
        dataMapsRestant2 = ""

        dataDebutARecuperer = saveMapCurrent - 1 -- Le numéro du niveau - 1 pour récupèrer tout les niveaux avant 
        dataFinARecuperer = lengthMaps
        
        --
        file = io.open(pathCurrent .. '/map.lua', "r")
        file2 = io.open(pathCurrent .. '/map.lua', "r")
        counterLines = 0
        counterLines2 = 0


        leNumeroLigneACommencer = 6
        leNumeroLigneDeFin = 0

        -- Les données des maps a récupèrer au début
        for n=1,dataDebutARecuperer do
            leNumeroLigneDeFin = leNumeroLigneDeFin + (TileMaps[n].MAP_HEIGHT + 7)
        end

        -- Les données des maps a récupèrer après la map qui a était changer jusqu'a la fin du fichier.
        leNumeroLigneACommencer2 = leNumeroLigneACommencer + leNumeroLigneDeFin + TileMaps[saveMapCurrent].MAP_HEIGHT + 7

        if saveMapCurrent >= 3 then
            leNumeroLigneDeFin = leNumeroLigneDeFin + saveMapCurrent - 2
            leNumeroLigneACommencer2 = leNumeroLigneACommencer2 + saveMapCurrent - 2
        end

        --
        for line in file2:lines() do
            counterLines2 = counterLines2 + 1
        end

        for line in file:lines() do
            if counterLines >= 6 then

                if saveMapCurrent == 1 then
                    leNumeroLigneACommencer = TileMaps[pNiveauMap].MAP_HEIGHT + 7 + 6

                    if counterLines >= leNumeroLigneACommencer then
                        dataMapsRestant = dataMapsRestant .. line .. "\n"
                    end
                elseif saveMapCurrent == lengthMaps then
                    if counterLines < counterLines2 - (TileMaps[lengthMaps].MAP_HEIGHT + 10) then
                        dataMapsRestant = dataMapsRestant .. line .. "\n"
                    end
                else
                    if counterLines <= (leNumeroLigneACommencer + leNumeroLigneDeFin) then
                        dataMapsRestant = dataMapsRestant .. line .. "\n"
                    elseif counterLines > leNumeroLigneACommencer2 then -- BUG POUR RECUPERER LE RESTE.
                        dataMapsRestant2 = dataMapsRestant2 .. line .. "\n"
                    end
                end

            end

            counterLines = counterLines + 1
        end


        if saveMapCurrent == 1 then -- Si c'est la map 1 de mon niveau.
            fileData = "local map = {}" .. "\n" .. "\n" ..
                        "ORIENTATION_TILES = " .. '"' .. ORIENTATION_TILES .. '"' .. "\n" ..
                        "TILE_OFFSETX = " .. 0 .. "\n" ..
                        "TILE_OFFSETY = " .. 0 .. "\n" ..
                        "TileMaps = {" .. "\n" .. dataMapChanger .. "\n" .. dataMapsRestant

        elseif saveMapCurrent == lengthMaps then -- Si c'est la derniere de mon niveau.
            fileData = "local map = {}" .. "\n" .. "\n" ..
                        "ORIENTATION_TILES = " .. '"' .. ORIENTATION_TILES .. '"' .. "\n" ..
                        "TILE_OFFSETX = " .. 0 .. "\n" ..
                        "TILE_OFFSETY = " .. 0 .. "\n" ..
                        "TileMaps = {" .. "\n" .. dataMapsRestant .. dataMapChanger .. "\n" .. "           }" .. "\n" .. "\n" ..
                        "return map"
        else
            fileData = "local map = {}" .. "\n" .. "\n" ..
                        "ORIENTATION_TILES = " .. '"' .. ORIENTATION_TILES .. '"' .. "\n" ..
                        "TILE_OFFSETX = " .. 0 .. "\n" ..
                        "TILE_OFFSETY = " .. 0 .. "\n" ..
                        "TileMaps = {" .. "\n" .. dataMapsRestant .. dataMapChanger .. "\n" .. dataMapsRestant2
        end

        file = io.open(pathCurrent .. '/map.lua', 'w+')
        file:write(fileData)
        file:close()

        -- Après avoir sauvegarder les changement de la map, le fichier map.lua est modifier mais en mémoire dans Love2D rien n'est modifier 
        -- Donc on le charge a nouveau et on l'éxecute
        love.filesystem.load("map.lua")()
    end
end


-- New map (reset)
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

    inGrilleMapViewTiles = false
    clickInOneTile = false

    pinceauAlpha = 1
    gommeAlpha = 1
    outilsActive = nil

    scrollY_counter = 0
    scrollY_ViewTile = 0
    
    clickInOneTile = false
    Game.TileActive = nil
end


-- Je charge une TileSheets et l'envoie dans la table : Game.TileSheets
function loadTileSheets(pNomDossierRessources, pNomFicherTileSheet)
    local tileSheet = love.graphics.newImage(pNomDossierRessources .. "/" .. pNomFicherTileSheet .. ".png")
    table.insert(Game.TileSheets, tileSheet)
end


--
function drawViewTiles()
    if MAP_NIVEAU ~= "?" and TILE_HEIGHT ~= 0 and TILE_WIDTH ~= 0 then
        -- Nombre de lignes et colonne de la GrilleMap de la View des Tiles.
        ligneViewTile = 5
        colonneViewTile = 5


        -- La taille de la Grille de la View des Tiles
        grilleViewTilesWidth = ligneViewTile * TILE_WIDTH
        grilleViewTilesHeight = colonneViewTile * TILE_HEIGHT


        -- Fond noir (rect)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("fill", largeurEcran - grilleViewTilesWidth - window.translate.x, hauteurEcran - grilleViewTilesWidth - window.translate.y, grilleViewTilesWidth, grilleViewTilesHeight)
        love.graphics.setColor(1, 1, 1, 1)


        -- Dessine toute les Tiles des SpriteSheet dans la View Tiles.
        local ligneViewForTile = #Game.Tiles / colonneViewTile

        -- BUG : si la grille est de 5 par 5, il faut que la totalité des Tiles sois un compte rond (5, 10, 15..etc)
        if ligneViewForTile ~= math.floor(ligneViewForTile) then
            ligneViewForTile = math.floor(ligneViewForTile)
            ligneViewForTile = ligneViewForTile + 1
        end

        local counterTileWidth2 = 0
        local counterTileHeight2 = 0

        local counterTiles = 1
        local currentTileSheet = 0


        -- Dessine les Tiles dans la Grille de la ViewTiles
        for l=1,ligneViewForTile do 
            if l < scrollY_counter + 1 then
                love.graphics.setColor(1, 1, 1, 0)
            end

            for c=1,colonneViewTile do
                for key, valeur in pairs(Game.TileSheetsActive) do
                    if counterTiles <= valeur then
                        currentTileSheet = key
                        
                        break
                    end
                end 
 
                if counterTiles <= #Game.Tiles then
                    love.graphics.draw(Game.TileSheets[currentTileSheet], Game.Tiles[counterTiles], largeurEcran - (grilleViewTilesWidth - counterTileWidth2) - window.translate.x, hauteurEcran - (grilleViewTilesHeight + counterTileHeight2) - scrollY_ViewTile - window.translate.y)
                end

                counterTileWidth2 = counterTileWidth2 + TILE_WIDTH
                counterTiles = counterTiles + 1
            end

            counterTileWidth2 = 0
            counterTileHeight2 = counterTileHeight2 - TILE_HEIGHT
            love.graphics.setColor(1, 1, 1, 1)
        end

        scrollY_counterMax = ligneViewForTile - ligneViewTile

        

        -- Je set la couleur pour les lignes de la GrilleMap de la View des Tiles, pour ci-dessous.
        love.graphics.setColor(137, 137, 137, 1)

        -- Dessiner la GrilleMap de la ViewTiles
        local counterHeight = grilleViewTilesHeight - TILE_HEIGHT
        for l=0,grilleViewTilesHeight do
            if l == 0 then
                love.graphics.line(largeurEcran - grilleViewTilesHeight - window.translate.x, hauteurEcran - grilleViewTilesHeight - window.translate.y, largeurEcran - window.translate.x, hauteurEcran - grilleViewTilesHeight - window.translate.y)
                love.graphics.line(largeurEcran - grilleViewTilesHeight - window.translate.x, (hauteurEcran - counterHeight) - window.translate.y, largeurEcran - window.translate.x, (hauteurEcran - counterHeight) - window.translate.y)
            elseif l <= MAP_HEIGHT then
                counterHeight = counterHeight - TILE_HEIGHT
                love.graphics.line(largeurEcran - grilleViewTilesHeight - window.translate.x, (hauteurEcran - counterHeight) - window.translate.y, largeurEcran - window.translate.x, (hauteurEcran - counterHeight) - window.translate.y)
            end
        end 

        local counterWidth = grilleViewTilesWidth - TILE_WIDTH
        for c=0,grilleViewTilesWidth do
            if c == 0 then
                love.graphics.line(largeurEcran - grilleViewTilesWidth - window.translate.x, hauteurEcran - grilleViewTilesWidth - window.translate.y, largeurEcran - grilleViewTilesWidth - window.translate.x, hauteurEcran - window.translate.y)
                love.graphics.line((largeurEcran - counterWidth) - window.translate.x, hauteurEcran - grilleViewTilesWidth - window.translate.y, (largeurEcran - counterWidth) - window.translate.x, hauteurEcran - window.translate.y)
            elseif c <= MAP_WIDTH then
                counterWidth = counterWidth - TILE_WIDTH
                love.graphics.line((largeurEcran - counterWidth) - window.translate.x, hauteurEcran - grilleViewTilesWidth - window.translate.y, (largeurEcran - counterWidth) - window.translate.x, hauteurEcran - window.translate.y)
            end
        end

        -- Remet la palette de couleur par défault.
        love.graphics.setColor(1, 1, 1, 1)
    end
end


-- 
function getPositionCursorInGrilleMapViewTilesandDraw()
    mouseX = love.mouse.getX()
    mouseY = love.mouse.getY()
    
    colonnesCursorInGrilleMap2 = ((mouseX - largeurEcran) + grilleViewTilesWidth) / TILE_WIDTH
    lignesCursorInGrilleMap2 = ((mouseY - hauteurEcran) + grilleViewTilesHeight) / TILE_HEIGHT

    lignesCursorInGrilleMap2 = math.floor(lignesCursorInGrilleMap2)
    colonnesCursorInGrilleMap2 = math.floor(colonnesCursorInGrilleMap2)

    CURRENT_LIGNE2 = lignesCursorInGrilleMap2
    CURRENT_COLONNE2 = colonnesCursorInGrilleMap2


    if mouseX >= (largeurEcran - grilleViewTilesWidth) and mouseY >= (hauteurEcran - grilleViewTilesHeight) then
        inGrilleMapViewTiles = true

        --print("LIGNE : " .. CURRENT_LIGNE2)
        --print("COLONNE : " .. CURRENT_COLONNE2)

        if clickInOneTile == false then
            love.graphics.setColor(255, 0, 0, 1)
            love.graphics.rectangle("line", (CURRENT_COLONNE2 * TILE_WIDTH) + ((largeurEcran - grilleViewTilesWidth) - window.translate.x), (CURRENT_LIGNE2 * TILE_HEIGHT) + ((hauteurEcran - grilleViewTilesWidth) - window.translate.y), TILE_WIDTH, TILE_HEIGHT)
        end
    else
        inGrilleMapViewTiles = false
    end

    if clickInOneTile == true and Game.TileActive ~= nil then
        love.graphics.setColor(255, 0, 0, 1)
        love.graphics.rectangle("line", (clickTileCurrentColonne * TILE_WIDTH) + ((largeurEcran - grilleViewTilesWidth) - window.translate.x), (clickTileCurrentLigne * TILE_HEIGHT) + ((hauteurEcran - grilleViewTilesWidth) - window.translate.y), TILE_WIDTH, TILE_HEIGHT)
    end

    love.graphics.setColor(1, 1, 1, 1)
end


-- Draw Tiles in the GrilleMap / Mousepressed draw Tile
function drawTilesInTheGrilleMap()
    testTILE_WIDTH = 0
    testTILE_HEIGHT = 0

    love.graphics.setColor(1, 1, 1, 1)

    if MAP_NIVEAU ~= "?" then 
        for l=1,MAP_HEIGHT do
            for c=1,MAP_WIDTH do
                tileCurrent = TileMaps[MAP_NIVEAU][l][c]

                local currentTileSheet = 1
                for key, valeur in pairs(Game.TileSheetsActive) do
                    if TileMaps[MAP_NIVEAU][l][c] <= valeur then
                        currentTileSheet = key
                        
                        break
                    end
                end 

                if tileCurrent ~= 0 then
                    love.graphics.draw(Game.TileSheets[currentTileSheet], Game.Tiles[tileCurrent], testTILE_WIDTH, testTILE_HEIGHT)
                end

                testTILE_WIDTH = testTILE_WIDTH + TILE_WIDTH
            end

            testTILE_WIDTH = 0
            testTILE_HEIGHT = testTILE_HEIGHT + TILE_HEIGHT
        end
    end
end


-- Draw Tiles in the GrilleMap / Mousepressed draw Tile
function gommeTilesInTheGrilleMap()
    if CURRENT_LIGNE >= 0 and CURRENT_LIGNE <= (MAP_HEIGHT - 1) and CURRENT_COLONNE >= 0 and CURRENT_COLONNE <= (MAP_WIDTH - 1) and inGrilleMapViewTiles == false and outilsActive == 'Gomme' then
        
    else
        --print("ENDEHORS DE LA GRILLE MAP")
    end
end


-- 
function drawTileRedOrTexture()
    local offsetXColonne = colonnesCursorInGrilleMap * TILE_WIDTH
    local offsetYLigne = lignesCursorInGrilleMap * TILE_HEIGHT

    if not love.mouse.isDown(2) then
        -- Affiche la taille d'une Tile en rouge quand on veux poser la Tile avec de la transparence quand on'es en dehors de la GrilleMap
        if resultLignesCursorGrilleMap == "En dehors de la Grille Map" or resultColonnesCursorGrilleMap == "En dehors de la Grille Map" then
            love.graphics.setColor(255, 0, 0, 0.3)    
            love.graphics.rectangle("fill", offsetXColonne, offsetYLigne, TILE_WIDTH, TILE_HEIGHT)
            love.graphics.setColor(1, 1, 1, 1)

        -- Affiche la taille d'une Tile a l'écrans sur la grille au survol on vois apparaitre la Tile en transparent si l'outils de la Gomme est selectionner
        elseif resultLignesCursorGrilleMap ~= "En dehors de la Grille Map" and resultColonnesCursorGrilleMap ~= "En dehors de la Grille Map" and outilsActive == 'Gomme' then
        love.graphics.setColor(48, 140, 198, 0.3)    
        love.graphics.rectangle("fill", offsetXColonne, offsetYLigne, TILE_WIDTH, TILE_HEIGHT)
        love.graphics.setColor(1, 1, 1, 1)

        -- Affiche la taille d'une Tile a l'écrans sur la grille au survol on vois apparaitre la Tile en transparent si aucune Tile a était choisi.
        elseif resultLignesCursorGrilleMap ~= "En dehors de la Grille Map" and resultColonnesCursorGrilleMap ~= "En dehors de la Grille Map" and clickInOneTile == false then
            love.graphics.setColor(48, 140, 198, 0.3)    
            love.graphics.rectangle("fill", offsetXColonne, offsetYLigne, TILE_WIDTH, TILE_HEIGHT)
            love.graphics.setColor(1, 1, 1, 1)

        -- Affiche la taille d'une Tile a l'écrans sur la grille au survol on vois apparaitre la Tile qui à était choisi dans la View Tile.
        elseif resultLignesCursorGrilleMap ~= "En dehors de la Grille Map" and resultColonnesCursorGrilleMap ~= "En dehors de la Grille Map" and clickInOneTile == true and outilsActive ~= 'Gomme' then
            local currentTileSheet2 = 1
            for key, valeur in pairs(Game.TileSheetsActive) do
                if Game.TileActive <= valeur then
                    currentTileSheet2 = key
                    
                    break
                end
            end 

            if Game.TileActive ~= nil then
                love.graphics.setColor(48, 140, 198, 0.3)   
                love.graphics.draw(Game.TileSheets[currentTileSheet2], Game.Tiles[Game.TileActive], offsetXColonne, offsetYLigne)
                love.graphics.setColor(1, 1, 1, 1)
            end
        end
    end
end


-- Charge les Tiles par rapport au TILE_WIDTH et TILE_HEIGHT de la map actuellement chargée.
function loadTiles()
    -- Reset la liste des Tiles a chaque nouveau chargement d'une nouvelle map si jamais les TILES_WIDTH et TILE_HEIGHT ne sont pas les mêmes
    Game.Tiles = {}
    Game.TileSheetsActive = {}

    -- Itere sur la table qui contient toute les TileSheets, puis découpe chaque images d'une TileSheet et les envoie dans la table : Game.TileTextures (tableaux a deux dimensions)
    -- Decoupage une TileSheet en fonction des TILE_WIDTH et TILE_HEIGHT qui a était générer pour la map.
    local tablesTileSheetsDecouperAll = {}

    -- IMPORTANT -> C'est ici qu'il faut rajouter manuellement les SpriteSheets pour les TileSets ci-dessous a la suite des autres : 
    local tableTileSheetDecouper1 = decoupeSpriteSheet(0, 0, TILE_WIDTH, TILE_HEIGHT, 8, 14, 2, Game.TileSheets[1]) 
    table.insert(tablesTileSheetsDecouperAll, tableTileSheetDecouper1)

    local tableTileSheetDecouper2 = decoupeSpriteSheet(0, 0, TILE_WIDTH, TILE_HEIGHT, 16, 6, 12, Game.TileSheets[2])
    table.insert(tablesTileSheetsDecouperAll, tableTileSheetDecouper2)

    local currentTable = 1
    for key, imgTile in pairs(tablesTileSheetsDecouperAll) do
        for key, imgTile in pairs(tablesTileSheetsDecouperAll[currentTable]) do
            table.insert(Game.Tiles, imgTile)
        end 

        table.insert(Game.TileSheetsActive, #Game.Tiles)

        currentTable = currentTable + 1
        if currentTable > #Game.TileSheets then
            break
        end
    end 

    print("\n")
    print("Nombre de Tiles : " .. #Game.Tiles)
end










--[[   
██       ██████   █████  ██████  
██      ██    ██ ██   ██ ██   ██ 
██      ██    ██ ███████ ██   ██ 
██      ██    ██ ██   ██ ██   ██ 
███████  ██████  ██   ██ ██████                                                                    
]]

function tileMapsEditor.Load()
    -- Récupère le chemin jusqu'a avant le dossier du jeu, puis je récupère le nom du dossier du jeu.
    path = love.filesystem.getSourceBaseDirectory()
    dirNameGame = love.filesystem.getIdentity()
    pathCurrent = path .. "/" .. dirNameGame


    -- Je charge toutes mes TileSheets (Une SpriteSheet qui contient des Tiles (Textures))
    -- loadTileSheets(nomDuDossier, nomFichierImgTileSheet)
    loadTileSheets('assets', 'tileSet')
    loadTileSheets('assets', 'tileSet2')


    -- Je charge les images de la GUI de l'éditeur de Map
    GUI.imgButtonDessinerGrille = love.graphics.newImage("assets/dessinerGrille.png")
    GUI.imgButtonGommeGrille = love.graphics.newImage("assets/gommeGrille.png")
    GUI.imgButtonNone = love.graphics.newImage("assets/buttonNone.png")
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


    -- REFAIRE UNE FONCTION - DESSINER GRILLE MAP BOUTTON SOURIS EN CONTINUE
    if love.mouse.isDown(1) and CURRENT_LIGNE >= 0 and CURRENT_LIGNE <= (MAP_HEIGHT - 1) and CURRENT_COLONNE >= 0 and CURRENT_COLONNE <= (MAP_WIDTH - 1) and inGrilleMapViewTiles == false and outilsActive == 'Pinceau' and Game.TileActive ~= nil and MAP_NIVEAU ~= "?" then
        LIGNE = CURRENT_LIGNE + 1 
        COLONNE = CURRENT_COLONNE + 1 

        TileMaps[MAP_NIVEAU][LIGNE][COLONNE] = Game.TileActive 
    end


    --
    deplacerGrilleMapClickRight()
    
    
    --
    deplacementInGrilleMapZQSD()
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

    
    -- Translation par rapport au Zoom. 
    -- Initialiser la mise a l'échelle (Scale). 
    -- Puis je défini le Scale pour X et Y à la fois.
    love.graphics.translate(window.translate.x, window.translate.y)
    love.graphics.push()
	love.graphics.scale(window.zoom)


    -- Le style des Lines/Pointiller de la GrilleMap -> fin/doux ou épais/gras.
    love.graphics.setLineStyle(GUI.grilleMapStyleLinesPointiller)


    --
    drawTilesInTheGrilleMap()


    --
    colorGrilleMap()


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
            GUI.imgFleche.x = inputText.SAVE_MAP.widthFont + 15
            GUI.imgFleche.y = GUI.imgFleche.y + 20
            inputTextActive = "SAVE_MAP"
           ---------BUG A PARTIR D ICI ------------
        --[[elseif GUI.imgFleche.x == inputText.SAVE_MAP.widthFont + 15 then
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
                inputText.LOAD_MAP.txt = string.sub(inputText.LOAD_MAP.txt, 1, byteoffsetLOAD_MAP - 1)
                inputText.LOAD_MAP.txt = tonumber(inputText.LOAD_MAP.txt)
                LOAD_MAP = inputText.LOAD_MAP.txt
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
            if MAP_NIVEAU == "?" then
                generateMap()
                loadTiles()
            end
        elseif inputTextActive == "NEW_MAP" then
            newMap()
            inputText.LOAD_MAP.txt = ""
            LOAD_MAP = inputText.LOAD_MAP.txt
        elseif inputTextActive == "LOAD_MAP" then 
            loadMap(inputText.LOAD_MAP.txt)
            loadTiles()
        
            inputText.LOAD_MAP.txt = ""
            LOAD_MAP = inputText.LOAD_MAP.txt
        elseif inputTextActive == "SAVE_MAP" and MAP_NIVEAU ~= "?" then 
            saveMap(MAP_NIVEAU)
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
    -- Appuie sur le boutton de la roulette = Remet le ZoomX et ZoomY par défault
    if button == 3 then
        window.zoom = 1
    end


    -- Récupère la position de la souris X et Y a partir du moment ou on fait un clique à la souris (clique gauche ou droite)
    mouseXClick = mouse.posX
    mouseYClick = mouse.posY


    -- Click in GrilleMap for View Tiles
    if inGrilleMapViewTiles == true and button == 1 then
        clickInOneTile = true

        clickTileCurrentColonne = CURRENT_COLONNE2
        clickTileCurrentLigne = CURRENT_LIGNE2
    end


    -- Button du pinceau (Draw Tile)
    if x <= largeurEcran - GUI.imgButtonDessinerGrille:getWidth() / 2 and x >= largeurEcran - (GUI.imgButtonDessinerGrille:getWidth() + (GUI.imgButtonDessinerGrille:getWidth() / 2)) and
       y >= GUI.imgButtonDessinerGrille:getHeight() / 2 and y <= GUI.imgButtonDessinerGrille:getHeight() + (GUI.imgButtonDessinerGrille:getHeight() / 2) then
    
        outilsActive = 'Pinceau'
        pinceauAlpha = 0.3
        gommeAlpha = 1
    end 
    
    
    -- Button de la gomme (effacer une Tile)
    if x <= largeurEcran - GUI.imgButtonGommeGrille:getWidth() / 2 and x >= largeurEcran - (GUI.imgButtonGommeGrille:getWidth() + (GUI.imgButtonGommeGrille:getWidth() / 2)) and
       y >= GUI.imgButtonDessinerGrille:getHeight() / 2 + GUI.imgButtonDessinerGrille:getHeight() and y <= GUI.imgButtonDessinerGrille:getHeight() / 2 + GUI.imgButtonDessinerGrille:getHeight() + GUI.imgButtonGommeGrille:getHeight() then    
        
        outilsActive = 'Gomme'
        pinceauAlpha = 1
        gommeAlpha = 0.3
    end


    -- Button 'None', remet la variable -> outilsActive = nil (aucun outils sélectionner)
    if x <= largeurEcran - GUI.imgButtonNone:getWidth() / 2 and x >= largeurEcran - (GUI.imgButtonNone:getWidth() + (GUI.imgButtonNone:getWidth() / 2)) and
       y >= GUI.imgButtonDessinerGrille:getHeight() / 2 + GUI.imgButtonDessinerGrille:getHeight() + GUI.imgButtonGommeGrille:getHeight() and y <= GUI.imgButtonDessinerGrille:getHeight() / 2 + GUI.imgButtonDessinerGrille:getHeight() + GUI.imgButtonGommeGrille:getHeight() + GUI.imgButtonNone:getHeight() then    
        
        outilsActive = nil
        pinceauAlpha = 1
        gommeAlpha = 1
    end


    -- Récupère la Tile choisi - multiplier : (CURRENT_COLONNE2 * scrollY_counter) + CURRENT_COLONNE2
    if mouseX >= (largeurEcran - grilleViewTilesWidth) and mouseY >= (hauteurEcran - grilleViewTilesHeight) then
        numeroTileCurrent = ((CURRENT_LIGNE2 + scrollY_counter) * colonneViewTile) + (CURRENT_COLONNE2 + 1)

        if numeroTileCurrent <= #Game.Tiles then
            Game.TileActive = numeroTileCurrent
            print("TILE ACTIVE : " .. Game.TileActive)
        else
            Game.TileActive = nil
            clickInOneTile = false
        end
    end


    --  Click sur la Grille Map avec la Tile qui a était choisi.
    if button == 1 and CURRENT_LIGNE >= 0 and CURRENT_LIGNE <= (MAP_HEIGHT - 1) and CURRENT_COLONNE >= 0 and CURRENT_COLONNE <= (MAP_WIDTH - 1) and inGrilleMapViewTiles == false and outilsActive == 'Pinceau' and Game.TileActive ~= nil and MAP_NIVEAU ~= "?" then
        LIGNE = CURRENT_LIGNE + 1 
        COLONNE = CURRENT_COLONNE + 1 

        TileMaps[MAP_NIVEAU][LIGNE][COLONNE] = Game.TileActive 
    end
end




--[[   
██     ██ ██   ██ ███████ ███████ ██          ███    ███  ██████  ██    ██ ███████ ██████  
██     ██ ██   ██ ██      ██      ██          ████  ████ ██    ██ ██    ██ ██      ██   ██ 
██  █  ██ ███████ █████   █████   ██          ██ ████ ██ ██    ██ ██    ██ █████   ██   ██ 
██ ███ ██ ██   ██ ██      ██      ██          ██  ██  ██ ██    ██  ██  ██  ██      ██   ██ 
 ███ ███  ██   ██ ███████ ███████ ███████     ██      ██  ██████    ████   ███████ ██████                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
]]

function love.wheelmoved(x, y)
    -- Zoom avant sur un point ou Zoom arrière sur un point sauf si on ce trouve sur la View Tile
    if not (y == 0) and inGrilleMapViewTiles == false then
		local mouse_x = mouse.posX
		local mouse_y = mouse.posY
		local k = dscale^y

		window.zoom = window.zoom * k
		window.translate.x = math.floor(window.translate.x + mouse_x * (1-k))
		window.translate.y = math.floor(window.translate.y + mouse_y * (1-k))

    -- Scrolling en Y de la View des Tiles
    elseif y > 0 and inGrilleMapViewTiles == true and MAP_NIVEAU ~= "?" then -- Molette de la souris avec le haut
        if scrollY_counter <= scrollY_counterMax and scrollY_counter ~= 0 then
            scrollY_ViewTile = scrollY_ViewTile - TILE_HEIGHT
            scrollY_counter = scrollY_counter - 1

            clickInOneTile = false
            Game.TileActive = nil
        end
        
    elseif y < 0 and inGrilleMapViewTiles == true and MAP_NIVEAU ~= "?" then -- Molette de la souris avec le bas
        if scrollY_counter < scrollY_counterMax then
            scrollY_ViewTile = scrollY_ViewTile + TILE_HEIGHT
            scrollY_counter = scrollY_counter + 1

            clickInOneTile = false
            Game.TileActive = nil
        end
    end
end

return tileMapsEditor