----------------------------------------------DOCUMENTATION DU MOTEUR DE JEU-----------------------------------------------------------------------------------------------------

-- 1) Quand on lance l'éditeur on'as aucune map créer encore, si le niveau de la map est affichée comme ceci : 'MAP_NIVEAU : ?' c'est que c'est une map non générer.
-- 2) On ne peut pas changer de calques..etc tant qu'ont n'as pas une map générer ou load un Niveau
-- 2) Donc quand on n'as : '?' il faut configurer la LARGEUR/HAUTEUR de la MAP/TILES puis aller sur 'GENERATE MAP' et faire 'ENTER' pour générer la MAP.
-- 3) Quand on créer un niveau de Map on'as normalement : 'MAP_NIVEAU' : 1.. 2.. avec le niveau actuelle de la TileMap du niveau.
-- 4) Quand on n'es sur un niveau de map déjà charger, sur l'éditeur de Map il faut faire : 'NEW MAP' ça va regénérer une nouvelle map VIDE et faut la reconfigurer et faire GENERATE_MAP.
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

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local sceneEditorMaps = {}


-- Toute les données importante de l'éditeur de Map.
local ORIENTATION_TILES = "Orthogonale"
local MAP_WIDTH = 0
local MAP_HEIGHT = 0
local TILE_WIDTH = 0
local TILE_HEIGHT = 0
local NOMBRE_LIGNE = MAP_HEIGHT * TILE_HEIGHT 
local NOMBRE_COLONNE = MAP_WIDTH * TILE_WIDTH
local MAP_PIXELS = NOMBRE_LIGNE .. ' x ' .. NOMBRE_COLONNE .. ' pixels'
local CURRENT_LIGNE = 0
local CURRENT_COLONNE = 0
local MAP_NIVEAU = "?"
local LOAD_MAP = "" 
local SAVE_MAP = ""
local DELETE_MAP = ""
local CALQUES = 'Calque1'
local TYPE = "Tile"


--
local Game = {}
Game.TileSheets = {}
Game.TileSheetsActive = {}
Game.Tiles = {}
Game.TileActive = nil
Game.MapNiveau = {}
Game.MapNiveauActive = nil


--
local MapsDataLua = {}
MapsDataLua.Calque1 = {}
MapsDataLua.Calque2 = {}
MapsDataLua.Calque3 = {}
MapsDataLua.Calque4 = {}


--
local CalquesActive = {}
CalquesActive.Calque1 = "ON"
CalquesActive.Calque2 = "ON"
CalquesActive.Calque3 = "ON"
CalquesActive.Calque4 = "ON"
CalquesActive.Objects = "ON"
CalquesActive.AnimationsEffectsFX = "ON"
CalquesActive.Collision = "OFF"
CalquesActive.IDCalque1 = "OFF"
CalquesActive.IDCalque2 = "OFF"
CalquesActive.IDCalque3 = "OFF"
CalquesActive.IDCalque4 = "OFF"
CalquesActive.IDObjects = "OFF"
CalquesActive.IDAnimationsEffectsFX = "OFF"


-- Permet de revenir en arrière ou en avant après modification de la Map.
local Historique = {}
Historique.ArriereDonnees = {}
Historique.AvantDonnees = {}
Historique.CounterArriere = 0
Historique.CounterAvant = 0
Historique.Bool = false


-- Données View Tiles
local ligneViewTile = 0
local colonneViewTile = 0
local grilleViewTilesWidth = 0
local grilleViewTilesHeight = 0
local inGrilleMapViewTiles = false
local clickInOneTile = false
local clickTileCurrentColonne = 0
local clickTileCurrentLigne = 0
local scrollY_ViewTile = 0
local scrollY_counterMax = 0
local scrollY_counter = 0
local scrollY_TileAlphaSortZone = 1


-- Données View Files
local inGrilleMapViewFiles = false
local clickInOneFile = false
local clickFile = ""
local scrollY_counterMax2 = 6
local scrollY_counter2 = 0
local counterNombreFiles = 0



-- L'outils actuellement activé (Pinceau, gomme...)
local pinceauAlpha = 1 -- alpha
local gommeAlpha = 1 -- alpha
local mainobjetAlpha = 1 -- alpha
local pipeAlpha = 1 -- alpha
local outilsActive = nil
local mouseOnTheOutils = false


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
inputText.DELETE_MAP = { txt = DELETE_MAP, widthFont = font:getWidth('DELETE_MAP : ' .. DELETE_MAP) }

inputText.CALQUES = { txt = CALQUES, widthFont = font:getWidth('CALQUES : ' .. CALQUES) }
inputText.TYPE = { txt = TYPE, widthFont = font:getWidth('TYPE : ' .. TYPE) }

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
GUI.grilleMapColor = "black"
GUI.grilleMapChangedColorWhite = love.graphics.setColor(1, 1, 1)
GUI.grilleMapChangedColorBlack = love.graphics.setColor(0, 0, 0)
GUI.drawGUIandText = true
GUI.imgFleche = { img = nil, x = inputText.ORIENTATION_TILES.widthFont + 15, y = 0 }
GUI.imgButtonDessinerGrille = nil
GUI.imgButtonGommeGrille = nil
GUI.imgButtonMainObjetGrille = nil
GUI.imgButtonPipeGrille = nil
GUI.imgButtonNone = nil
GUI.imgButtonCalqueOeilOuvert = nil
GUI.imgButtonCalqueOeilOuvert2 = nil
GUI.imgButtonCalqueOeilOuvert3 = nil
GUI.imgButtonCalqueOeilOuvert4 = nil
GUI.imgButtonCalqueOeilOuvert5 = nil
GUI.imgButtonCalqueOeilOuvert6 = nil
GUI.imgButtonCalqueOeilOuvert7 = nil
GUI.imgButtonCalqueOeilFermer = nil
GUI.imgButtonCalqueOeilFermer2 = nil
GUI.imgButtonCalqueOeilFermer3 = nil
GUI.imgButtonCalqueOeilFermer4 = nil
GUI.imgButtonCalqueOeilFermer5 = nil
GUI.imgButtonCalqueOeilFermer6 = nil
GUI.imgButtonCalqueOeilFermer7 = nil
GUI.imgButtonDecoupageSpriteSheet = nil

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
function getAllNameFiles(pDirName)
    local files = love.filesystem.getDirectoryItems(pDirName)

    --for k, file in pairs(files) do
        --print(k .. ". " .. file) 
    --end

    return files
end


--
function getDataMapCalquesAndNiveau(pCalque, pNiveauMap)
    local pNiveauMap = tonumber(pNiveauMap)

    local data = fileDecodeJSON(pCalque)
    local dataMap = data[pNiveauMap]

    return dataMap
end


--
function mapExist(pNiveauMap)
    local pNiveauMap = tonumber(pNiveauMap)

    if mapExistInFile() == true then
        local dataMaps = fileDecodeJSON("mapCalque1.json")

        if dataMaps[pNiveauMap] ~= nil then
            return true
        end
    end
end


--
function mapExistInFile()
    if #fileReadAll("mapCalque1.json") == 0 then
        return false
    else
        return true
    end
end


--
function fileExists(pFileName)
    local file = io.open(pathCurrent .. "/dataMaps/" .. pFileName, "r")

    if file ~= nil then 
        io.close(file) 
        
        return true
    else 
        return false
    end
end


--
function fileReadAll(pNameFile)
    local file = assert(io.open(pathCurrent .. "/dataMaps/" .. pNameFile, "r"))
    local content = file:read("*all")
    file:close()

    return content
end


--
function fileWriteAndEncodeJSON(pNameFile, pContent)
    local dataJSON = json.encode(pContent)

    local file = io.open(pathCurrent .. "/dataMaps/" .. pNameFile, 'w+')
    file:write(dataJSON)
    file:close()
end


--
function fileDecodeJSON(pNameFile)
    local file = assert(io.open(pathCurrent .. "/dataMaps/" .. pNameFile, "r"))
    local content = file:read("*all")
    file:close()

    local dataLua = json.decode(content)

    return dataLua
end


--
function fileWrite(pNameFile)
    local file = io.open(pathCurrent .. "/dataMaps/" .. pNameFile, 'w+')
    file:write("")
    file:close()
end



--
function updateMouseXandY()
    if MAP_NIVEAU ~= "?" then
        mouse.posX = love.mouse.getX() - window.translate.x
        mouse.posY = love.mouse.getY() - window.translate.y
    end
end


-- Empeche de dessiner ou gommer derrière la GUI du pinceau et gomme quand on selectionne un Outils.
function empecheDessinerGommerDerriereGUIOutils()
    local mouseX = love.mouse.getX()
    local mouseY = love.mouse.getY()

    if mouseX <= largeurEcran - GUI.imgButtonDessinerGrille:getWidth() / 2 and mouseX >= largeurEcran - (GUI.imgButtonDessinerGrille:getWidth() + (GUI.imgButtonDessinerGrille:getWidth() / 2)) and
       mouseY >= GUI.imgButtonDessinerGrille:getHeight() / 2 and mouseY <= GUI.imgButtonDessinerGrille:getHeight() + (GUI.imgButtonDessinerGrille:getHeight() / 2) or
       mouseX <= largeurEcran - GUI.imgButtonGommeGrille:getWidth() / 2 and mouseX >= largeurEcran - (GUI.imgButtonGommeGrille:getWidth() + (GUI.imgButtonGommeGrille:getWidth() / 2)) and
       mouseY >= GUI.imgButtonDessinerGrille:getHeight() / 2 + GUI.imgButtonDessinerGrille:getHeight() and mouseY <= GUI.imgButtonDessinerGrille:getHeight() / 2 + GUI.imgButtonDessinerGrille:getHeight() + GUI.imgButtonGommeGrille:getHeight() then
    
        mouseOnTheOutils = true
    else
        mouseOnTheOutils = false
    end
end


-- 
function getPositionCursorInGrilleMap()
    if window.zoom < 1 then
        newTileWidthForZoomX = window.zoom * TILE_WIDTH
        newTileHeightForZoomY = window.zoom * TILE_HEIGHT

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


-- Le tracer des colonnes et lignes de la Grille Map
function drawTheLinesForGrilleMap()
    if GUI.grilleMapActive == true then
            
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


-- Couleur de la GrilleMap (Lines)
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


function calquesViewObjects()
    if MAP_NIVEAU ~= "?" then
        -- Fond noir (rect)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("fill", largeurEcran - 160 - window.translate.x, 0 + 220 - window.translate.y, 160, 300)
        love.graphics.setColor(1, 1, 1, 1)
    end
end


function calquesViewOeil()
    if MAP_NIVEAU ~= "?" then
        -- Fond noir (rect)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("fill", largeurEcran - 160 - window.translate.x, hauteurEcran - grilleViewTilesHeight - 210 - window.translate.y, 160, 207)
        love.graphics.setColor(1, 1, 1, 1)

        love.graphics.print('Calque1 : ', largeurEcran - 150 - window.translate.x, hauteurEcran - grilleViewTilesWidth - 200 - window.translate.y)
        love.graphics.print('Calque2 : ', largeurEcran - 150 - window.translate.x, hauteurEcran - grilleViewTilesWidth - 170 - window.translate.y)
        love.graphics.print('Calque Objects : ', largeurEcran - 150 - window.translate.x, hauteurEcran - grilleViewTilesWidth - 140 - window.translate.y)
        love.graphics.print('Calque Collision : ', largeurEcran - 150 - window.translate.x, hauteurEcran - grilleViewTilesWidth - 110 - window.translate.y)
        love.graphics.print('ID Calque1 : ', largeurEcran - 150 - window.translate.x, hauteurEcran - grilleViewTilesWidth - 80 - window.translate.y)
        love.graphics.print('ID Calque2 : ', largeurEcran - 150 - window.translate.x, hauteurEcran - grilleViewTilesWidth - 50 - window.translate.y)
        love.graphics.print('ID Objects : ', largeurEcran - 150 - window.translate.x, hauteurEcran - grilleViewTilesWidth - 20 - window.translate.y)

        --
        if CalquesActive.Calque1 == "ON" then
            love.graphics.draw(GUI.imgButtonCalqueOeilOuvert, largeurEcran - GUI.imgButtonCalqueOeilOuvert:getWidth() - 20 - window.translate.x, hauteurEcran - grilleViewTilesHeight - 200 + GUI.imgButtonCalqueOeilOuvert:getHeight() / 2 - window.translate.y, 0, 1, 1, GUI.imgButtonCalqueOeilOuvert:getWidth() / 2, GUI.imgButtonCalqueOeilOuvert:getHeight() / 2)
        else
            love.graphics.draw(GUI.imgButtonCalqueOeilFermer, largeurEcran - GUI.imgButtonCalqueOeilFermer:getWidth() - 20 - window.translate.x, hauteurEcran - grilleViewTilesHeight - 200 + GUI.imgButtonCalqueOeilFermer:getHeight() / 2 - window.translate.y, 0, 1, 1, GUI.imgButtonCalqueOeilFermer:getWidth() / 2, GUI.imgButtonCalqueOeilFermer:getHeight() / 2)
        end

        if CalquesActive.Calque2 == "ON" then
            love.graphics.draw(GUI.imgButtonCalqueOeilOuvert2, largeurEcran - GUI.imgButtonCalqueOeilOuvert2:getWidth() - 5 - window.translate.x, hauteurEcran - grilleViewTilesHeight - 200 + GUI.imgButtonCalqueOeilOuvert2:getHeight() + 20 - window.translate.y, 0, 1, 1, GUI.imgButtonCalqueOeilOuvert2:getWidth() / 2, GUI.imgButtonCalqueOeilOuvert2:getHeight() / 2)
        else
            love.graphics.draw(GUI.imgButtonCalqueOeilFermer2, largeurEcran - GUI.imgButtonCalqueOeilFermer2:getWidth() - 5 - window.translate.x, hauteurEcran - grilleViewTilesHeight - 200 + GUI.imgButtonCalqueOeilFermer2:getHeight() + 20 - window.translate.y, 0, 1, 1, GUI.imgButtonCalqueOeilFermer2:getWidth() / 2, GUI.imgButtonCalqueOeilFermer2:getHeight() / 2)
        end

        if CalquesActive.Objects == "ON" then
            love.graphics.draw(GUI.imgButtonCalqueOeilOuvert3, largeurEcran - GUI.imgButtonCalqueOeilOuvert3:getWidth() - window.translate.x, hauteurEcran - grilleViewTilesHeight - 200 + GUI.imgButtonCalqueOeilOuvert3:getHeight() + GUI.imgButtonCalqueOeilOuvert3:getWidth() / 2 + 37 - window.translate.y, 0, 1, 1, GUI.imgButtonCalqueOeilOuvert3:getWidth() / 2, GUI.imgButtonCalqueOeilOuvert3:getHeight() / 2)
        else
            love.graphics.draw(GUI.imgButtonCalqueOeilFermer3, largeurEcran - GUI.imgButtonCalqueOeilFermer3:getWidth() - window.translate.x, hauteurEcran - grilleViewTilesHeight - 200 + GUI.imgButtonCalqueOeilFermer3:getHeight() + GUI.imgButtonCalqueOeilFermer3:getWidth() / 2 + 37 - window.translate.y, 0, 1, 1, GUI.imgButtonCalqueOeilFermer3:getWidth() / 2, GUI.imgButtonCalqueOeilFermer3:getHeight() / 2)
        end

        if CalquesActive.Collision == "ON" then
            love.graphics.draw(GUI.imgButtonCalqueOeilOuvert4, largeurEcran - GUI.imgButtonCalqueOeilOuvert4:getWidth() - window.translate.x, hauteurEcran - grilleViewTilesHeight - 200 + GUI.imgButtonCalqueOeilOuvert4:getHeight() + GUI.imgButtonCalqueOeilOuvert4:getWidth() / 2 + 66 - window.translate.y, 0, 1, 1, GUI.imgButtonCalqueOeilOuvert4:getWidth() / 2, GUI.imgButtonCalqueOeilOuvert4:getHeight() / 2)
        else
            love.graphics.draw(GUI.imgButtonCalqueOeilFermer4, largeurEcran - GUI.imgButtonCalqueOeilFermer4:getWidth() - window.translate.x, hauteurEcran - grilleViewTilesHeight - 200 + GUI.imgButtonCalqueOeilFermer4:getHeight() + GUI.imgButtonCalqueOeilFermer4:getWidth() / 2 + 66 - window.translate.y, 0, 1, 1, GUI.imgButtonCalqueOeilFermer4:getWidth() / 2, GUI.imgButtonCalqueOeilFermer4:getHeight() / 2)
        end

        if CalquesActive.IDCalque1 == "ON" then
            love.graphics.draw(GUI.imgButtonCalqueOeilOuvert5, largeurEcran - GUI.imgButtonCalqueOeilOuvert5:getWidth() - 10 - window.translate.x, hauteurEcran - grilleViewTilesHeight - 200 + GUI.imgButtonCalqueOeilOuvert5:getHeight() + GUI.imgButtonCalqueOeilOuvert5:getWidth() / 2 + 97 - window.translate.y, 0, 1, 1, GUI.imgButtonCalqueOeilOuvert5:getWidth() / 2, GUI.imgButtonCalqueOeilOuvert5:getHeight() / 2)
        else
            love.graphics.draw(GUI.imgButtonCalqueOeilFermer5, largeurEcran - GUI.imgButtonCalqueOeilFermer5:getWidth() - 10 - window.translate.x, hauteurEcran - grilleViewTilesHeight - 200 + GUI.imgButtonCalqueOeilFermer5:getHeight() + GUI.imgButtonCalqueOeilFermer5:getWidth() / 2 + 97 - window.translate.y, 0, 1, 1, GUI.imgButtonCalqueOeilFermer5:getWidth() / 2, GUI.imgButtonCalqueOeilFermer5:getHeight() / 2)
        end

        if CalquesActive.IDCalque2 == "ON" then
            love.graphics.draw(GUI.imgButtonCalqueOeilOuvert6, largeurEcran - GUI.imgButtonCalqueOeilOuvert6:getWidth() - 5 - window.translate.x, hauteurEcran - grilleViewTilesHeight - 200 + GUI.imgButtonCalqueOeilOuvert6:getHeight() + GUI.imgButtonCalqueOeilOuvert6:getWidth() / 2 + 127 - window.translate.y, 0, 1, 1, GUI.imgButtonCalqueOeilOuvert6:getWidth() / 2, GUI.imgButtonCalqueOeilOuvert6:getHeight() / 2)
        else
            love.graphics.draw(GUI.imgButtonCalqueOeilFermer6, largeurEcran - GUI.imgButtonCalqueOeilFermer6:getWidth() - 5 - window.translate.x, hauteurEcran - grilleViewTilesHeight - 200 + GUI.imgButtonCalqueOeilFermer6:getHeight() + GUI.imgButtonCalqueOeilFermer6:getWidth() / 2 + 127 - window.translate.y, 0, 1, 1, GUI.imgButtonCalqueOeilFermer6:getWidth() / 2, GUI.imgButtonCalqueOeilFermer6:getHeight() / 2)
        end

        if CalquesActive.IDObjects == "ON" then
            love.graphics.draw(GUI.imgButtonCalqueOeilOuvert7, largeurEcran - GUI.imgButtonCalqueOeilOuvert7:getWidth() - 30 - window.translate.x, hauteurEcran - grilleViewTilesHeight - 200 + GUI.imgButtonCalqueOeilOuvert7:getHeight() + GUI.imgButtonCalqueOeilOuvert7:getWidth() / 2 + 157 - window.translate.y, 0, 1, 1, GUI.imgButtonCalqueOeilOuvert7:getWidth() / 2, GUI.imgButtonCalqueOeilOuvert7:getHeight() / 2)
        else
            love.graphics.draw(GUI.imgButtonCalqueOeilFermer7, largeurEcran - GUI.imgButtonCalqueOeilFermer7:getWidth() - 30 - window.translate.x, hauteurEcran - grilleViewTilesHeight - 200 + GUI.imgButtonCalqueOeilFermer7:getHeight() + GUI.imgButtonCalqueOeilFermer7:getWidth() / 2 + 157 - window.translate.y, 0, 1, 1, GUI.imgButtonCalqueOeilFermer7:getWidth() / 2, GUI.imgButtonCalqueOeilFermer7:getHeight() / 2)
        end
    end
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
    love.graphics.printf('DELETE_MAP :'  .. inputText.DELETE_MAP.txt, 0 - window.translate.x, 280 - window.translate.y, love.graphics.getWidth())

    love.graphics.print('CALQUES : ' .. CALQUES, 0 - window.translate.x, 320 - window.translate.y)
    love.graphics.print('TYPE : ' .. TYPE, 0 - window.translate.x, 340 - window.translate.y)

    love.graphics.print('Background-color (r) : ' .. backgroundColor.red, 0 - window.translate.x, 380 - window.translate.y)
    love.graphics.print('Background-color (g) : ' .. backgroundColor.green, 0 - window.translate.x, 400 - window.translate.y)
    love.graphics.print('Background-color (b) : ' .. backgroundColor.blue, 0 - window.translate.x, 420 - window.translate.y)
    love.graphics.print('Background-color (a) : ' .. backgroundColor.alpha, 0 - window.translate.x, 440 - window.translate.y)

    love.graphics.print('Opacity - Lines Grille Map : ' .. colorLinesGrilleMap.alpha, 0 - window.translate.x, 480 - window.translate.y)

    love.graphics.print('MOUSE.X : ' .. mouse.posX, 0 - window.translate.x, 520 - window.translate.y)
    love.graphics.print('MOUSE.Y : ' .. mouse.posY, 0 - window.translate.x, 540 - window.translate.y)
    love.graphics.print('ZOOM : ' .. window.zoom, 0 - window.translate.x, 560 - window.translate.y)

    love.graphics.print('F1 : Editor/Gameplay ', 0 - window.translate.x, 600 - window.translate.y)
    love.graphics.print('F2 : Change la couleur des Lines de la GrilleMap', 0 - window.translate.x, 620 - window.translate.y)
    love.graphics.print('F3 : Active/Désactive la Grille de la Map', 0 - window.translate.x, 640 - window.translate.y)
    love.graphics.print('F4 : GrilleMap à 0,0 (x,y) + Zoom par défault', 0 - window.translate.x, 660 - window.translate.y)
    love.graphics.print('F5 : Active/Désactive la GUI', 0 - window.translate.x, 680 - window.translate.y)
    love.graphics.print('F6 : Remet par défault toute la GUI (background-color..)', 0 - window.translate.x, 700 - window.translate.y)
    love.graphics.print('Boutton Molette Souris : Remet le Zoom par défault', 0 - window.translate.x, 720 - window.translate.y)
    love.graphics.print('CTRL - ALT : Permet de revenir en arrière / avant', 0 - window.translate.x, 740 - window.translate.y)
    love.graphics.print('Z-Q-S-D : Pour ce deplacer sur la GrilleMap', 0 - window.translate.x, 760 - window.translate.y)
    love.graphics.print('Click droit enfoncée : Pour déplacer la GrilleMap', 0 - window.translate.x, 780 - window.translate.y)
    love.graphics.print('Molette Souris : Zoom/DeZoom', 0 - window.translate.x, 800 - window.translate.y)


    --
    love.graphics.draw(GUI.imgFleche.img, GUI.imgFleche.x - window.translate.x, GUI.imgFleche.y - window.translate.y)

    love.graphics.setColor(1, 1, 1, pinceauAlpha)
    love.graphics.draw(GUI.imgButtonDessinerGrille, largeurEcran - GUI.imgButtonDessinerGrille:getWidth() - window.translate.x, GUI.imgButtonDessinerGrille:getHeight() - window.translate.y, 0, 1, 1, GUI.imgButtonDessinerGrille:getWidth() / 2, GUI.imgButtonDessinerGrille:getHeight() / 2)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setColor(1, 1, 1, gommeAlpha)
    love.graphics.draw(GUI.imgButtonGommeGrille, largeurEcran - GUI.imgButtonGommeGrille:getWidth() - window.translate.x, GUI.imgButtonDessinerGrille:getHeight() + GUI.imgButtonGommeGrille:getHeight() - window.translate.y, 0, 1, 1, GUI.imgButtonGommeGrille:getWidth() / 2, GUI.imgButtonGommeGrille:getHeight() / 2)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setColor(1, 1, 1, mainobjetAlpha)
    love.graphics.draw(GUI.imgButtonMainObjetGrille, largeurEcran - GUI.imgButtonDessinerGrille:getWidth() - GUI.imgButtonMainObjetGrille:getWidth() - window.translate.x, GUI.imgButtonDessinerGrille:getHeight() - window.translate.y, 0, 1, 1, GUI.imgButtonDessinerGrille:getWidth() / 2, GUI.imgButtonDessinerGrille:getHeight() / 2)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setColor(1, 1, 1, pipeAlpha)
    love.graphics.draw(GUI.imgButtonPipeGrille, largeurEcran - GUI.imgButtonGommeGrille:getWidth() - GUI.imgButtonPipeGrille:getWidth() - window.translate.x, GUI.imgButtonDessinerGrille:getHeight() + GUI.imgButtonGommeGrille:getHeight() - window.translate.y, 0, 1, 1, GUI.imgButtonGommeGrille:getWidth() / 2, GUI.imgButtonGommeGrille:getHeight() / 2)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.draw(GUI.imgButtonNone, largeurEcran - (GUI.imgButtonNone:getWidth() - 5) - window.translate.x, GUI.imgButtonGommeGrille:getHeight() + GUI.imgButtonGommeGrille:getHeight() + GUI.imgButtonNone:getHeight() + - window.translate.y, 0, 1, 1, GUI.imgButtonNone:getWidth() / 2, GUI.imgButtonNone:getHeight() / 2)


    --
    drawViewTiles()

    --
    getPositionCursorInGrilleMapViewTilesandDraw()

    --
    calquesViewOeil()

    --
    calquesViewObjects()

    --
    drawViewFiles("assets")
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
    if not love.keyboard.isDown('lctrl') then
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
            window.translate.x = window.translate.x + 15
        end
        
        if mouse.posX < mouseXClick then
            window.translate.x = window.translate.x + -15
        end
        
        if mouse.posY > mouseYClick then
            window.translate.y = window.translate.y + 15
        end
        
        if mouse.posY < mouseYClick then
            window.translate.y = window.translate.y + -15
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
    local mapProperties = {}
    mapProperties.MAP_WIDTH = tonumber(inputText.MAP_WIDTH.txt)
    mapProperties.MAP_HEIGHT = tonumber(inputText.MAP_HEIGHT.txt)
    mapProperties.TILE_WIDTH = tonumber(inputText.TILE_WIDTH.txt)
    mapProperties.TILE_HEIGHT = tonumber(inputText.TILE_HEIGHT.txt)

    for l=1,MAP_HEIGHT do
        local lineTable = {}

        for c=1,MAP_WIDTH do
            local colonne = 0 -- 0 = du vide
            lineTable[c] = 0
        end

        map[l] = lineTable
    end

    table.insert(map, mapProperties)
    table.insert(Game.MapNiveau, map)


    -- Je regarde si il y a 0 maps créer ALORS je créer toute les maps puis j'encode en JSON.
    -- SINON si il y a au minimum une map créer je récupère toute les data déjà disponible qui viens du JSON et je rajoute la map générer + je récupère le nombre de niveaux.
    if mapExistInFile() == false then
        Game.MapNiveauActive = 1
        MAP_NIVEAU = Game.MapNiveauActive
        
        fileWriteAndEncodeJSON("mapCalque1.json", { map })
        fileWriteAndEncodeJSON("mapCalque2.json", { map })
        fileWriteAndEncodeJSON("mapCalque3.json", { map })
        fileWriteAndEncodeJSON("mapCalque4.json", { map })
    else 
        local data = fileDecodeJSON("mapCalque1.json")
        local data2 = fileDecodeJSON("mapCalque2.json")
        local data3 = fileDecodeJSON("mapCalque3.json")
        local data4 = fileDecodeJSON("mapCalque4.json")

        local nombreMaps = #data -- 1er dimensions ou ce trouve toute les maps / Récupèrer le nombre de maps.

        table.insert(data, map)
        table.insert(data2, map)
        table.insert(data3, map)
        table.insert(data4, map)

        fileWriteAndEncodeJSON("mapCalque1.json", data)
        fileWriteAndEncodeJSON("mapCalque2.json", data2)
        fileWriteAndEncodeJSON("mapCalque3.json", data3)
        fileWriteAndEncodeJSON("mapCalque4.json", data4)

        Game.MapNiveauActive = nombreMaps + 1
        MAP_NIVEAU = Game.MapNiveauActive
    end

    table.insert(MapsDataLua.Calque1, map)
    table.insert(MapsDataLua.Calque2, map)
    table.insert(MapsDataLua.Calque3, map)
    table.insert(MapsDataLua.Calque4, map)
end


-- LoadMap
function loadMap(pNiveauMap)
    pNiveauMap = tonumber(pNiveauMap)

    if LOAD_MAP ~= "" and mapExist(pNiveauMap) == true then
        data = fileDecodeJSON("mapCalque1.json")
        propertiesMap = #data[pNiveauMap]

        MAP_WIDTH = data[pNiveauMap][propertiesMap].MAP_WIDTH 
        MAP_HEIGHT = data[pNiveauMap][propertiesMap].MAP_HEIGHT
        
        TILE_WIDTH = data[pNiveauMap][propertiesMap].TILE_WIDTH 
        TILE_HEIGHT = data[pNiveauMap][propertiesMap].TILE_HEIGHT

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

        CALQUES = "Calque1"

        TYPE = "Tile"

        Historique.ArriereDonnees = {}
        Historique.AvantDonnees = {}
        Historique.CounterArriere = 0
        Historique.CounterAvant = 0
        Historique.Bool = false

        -- Récupère les données des Maps qui viennent du JSON pour les récupèrer en Lua lors du chargement du niveau pour éviter de tout le temps
        -- écrire dans les fichiers ou récupèrer les données et permettra de ne pas sauvegarder à chaque changement et 
        -- laisser la possibilité de sauvegarder manuellement ce qui a était fait ou non.
        Game.MapNiveau = nil
        MapsDataLua.Calque1 = {}
        MapsDataLua.Calque2 = {}
        MapsDataLua.Calque3 = {}
        MapsDataLua.Calque4 = {}
        
        dataMapCalque1 = fileDecodeJSON("mapCalque1.json")
        dataMapCalque2 = fileDecodeJSON("mapCalque2.json")
        dataMapCalque3 = fileDecodeJSON("mapCalque3.json")
        dataMapCalque4 = fileDecodeJSON("mapCalque4.json")

        table.insert(MapsDataLua.Calque1, dataMapCalque1[pNiveauMap])
        table.insert(MapsDataLua.Calque2, dataMapCalque2[pNiveauMap])
        table.insert(MapsDataLua.Calque3, dataMapCalque3[pNiveauMap])
        table.insert(MapsDataLua.Calque4, dataMapCalque4[pNiveauMap])
    end
end


-- Sauvegarde la Map actuellement chargée dans l'éditeur de niveau (Sauvegarde toute les Tiles affichée sur la map, les numéro des Tiles dans les lignes et colonne qui a était dessiner)
function saveMap(pNiveauMap)
    pNiveauMap = tonumber(pNiveauMap)

    if mapExist(pNiveauMap) == true then
        local data = fileDecodeJSON("mapCalque1.json")
        local data2 = fileDecodeJSON("mapCalque2.json")
        local data3 = fileDecodeJSON("mapCalque3.json")
        local data4 = fileDecodeJSON("mapCalque4.json")

        for k=1,4 do
            for l=1,MAP_HEIGHT do
                for c=1,MAP_WIDTH do
                    data[l][c] = MapsDataLua.Calque1[1][l][c]
                end 
            end 
        end

        fileWriteAndEncodeJSON("mapCalque1.json", data)
        fileWriteAndEncodeJSON("mapCalque2.json", data2)
        fileWriteAndEncodeJSON("mapCalque3.json", data3)
        fileWriteAndEncodeJSON("mapCalque4.json", data4)
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
    
    Game.TileActive = nil

    CALQUES = "Calque1"
    
    TYPE = "Tile"

    Historique.ArriereDonnees = {}
    Historique.AvantDonnees = {}
    Historique.CounterArriere = 0
    Historique.CounterAvant = 0
    Historique.Bool = false

    Game.MapNiveau = {}
    MapsDataLua.Calque1 = {}
    MapsDataLua.Calque2 = {}
    MapsDataLua.Calque3 = {}
    MapsDataLua.Calque4 = {}
end


-- Delete Map
function deleteMap(pNiveauMap)
    local pNiveauMap = tonumber(pNiveauMap)

    -- Je regarde si au moins une map existe + (CHECKER SI IL RESTE QUE UN NIVEAU SUPPRIMER TOUT CE QUI AS DANS LE FICHIER)
    if #fileReadAll("mapCalque1.json") ~= 0 then
        local data = fileDecodeJSON("mapCalque1.json")
        local data2 = fileDecodeJSON("mapCalque2.json")
        local data3 = fileDecodeJSON("mapCalque3.json")
        local data4 = fileDecodeJSON("mapCalque4.json")

        if pNiveauMap <= #data then
            if #data == 1 then
                fileWrite("mapCalque1.json")
                fileWrite("mapCalque2.json")
                fileWrite("mapCalque3.json")
                fileWrite("mapCalque4.json")
            else
                table.remove(data, pNiveauMap)
                table.remove(data2, pNiveauMap)
                table.remove(data3, pNiveauMap)
                table.remove(data4, pNiveauMap)
    
                fileWriteAndEncodeJSON("mapCalque1.json", data)
                fileWriteAndEncodeJSON("mapCalque2.json", data2)
                fileWriteAndEncodeJSON("mapCalque3.json", data3)
                fileWriteAndEncodeJSON("mapCalque4.json", data4)
            end
        end
    end
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
        love.graphics.rectangle("fill", largeurEcran - grilleViewTilesWidth - window.translate.x, hauteurEcran - grilleViewTilesHeight - window.translate.y, grilleViewTilesWidth, grilleViewTilesHeight)
        love.graphics.setColor(1, 1, 1, 1)


        -- Dessine toute les Tiles des SpriteSheet dans la View Tiles.
        local ligneViewForTile = #Game.Tiles / colonneViewTile

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


-- Dessine les Tiles/Objects/AnimationsParticlesEffectsFX des Calques.
function drawCalqueInTheGrilleMap(pCalque, pCalqueActive)
    if pCalqueActive == "ON" then
        local mapCalque = pCalque

        local TILE_WIDTH2 = 0
        local TILE_HEIGHT2 = 0

        love.graphics.setColor(1, 1, 1, 1)

        if MAP_NIVEAU ~= "?" then 
            for l=1,MAP_HEIGHT do
                for c=1,MAP_WIDTH do
                    tileCurrent = mapCalque[1][l][c]

                    local currentTileSheet = 1
                    for key, valeur in pairs(Game.TileSheetsActive) do
                        if mapCalque[1][l][c] <= valeur then
                            currentTileSheet = key
                            
                            break
                        end
                    end 

                    if tileCurrent ~= 0 then
                        love.graphics.draw(Game.TileSheets[currentTileSheet], Game.Tiles[tileCurrent], TILE_WIDTH2, TILE_HEIGHT2)
                    end

                    TILE_WIDTH2 = TILE_WIDTH2 + TILE_WIDTH
                end

                TILE_WIDTH2 = 0
                TILE_HEIGHT2 = TILE_HEIGHT2 + TILE_HEIGHT
            end
        end
    end
end


-- Dessine en Jaune par dessus les Tiles/Tiles2 et Objects, ou ce trouvent les collision sur la GrilleMap.
function drawCollisionInTheGrilleMap()
    if CalquesActive.Collision == "ON" then
        local TILE_WIDTH3 = 0
        local TILE_HEIGHT3 = 0

        love.graphics.setColor(1, 1, 1, 1)

        if MAP_NIVEAU ~= "?" then 
            for l=1,MAP_HEIGHT do
                for c=1,MAP_WIDTH do
                    tileCurrent = TileMapsCollision[MAP_NIVEAU][l][c]

                    local currentTileSheet = 1
                    for key, valeur in pairs(Game.TileSheetsActive) do
                        if TileMapsCollision[MAP_NIVEAU][l][c] <= valeur then
                            currentTileSheet = key
                            
                            break
                        end
                    end 

                    if tileCurrent == 1 then
                        love.graphics.setColor(255, 165, 0, 0.4)
                        love.graphics.rectangle("fill", TILE_WIDTH3, TILE_HEIGHT3, TILE_WIDTH, TILE_HEIGHT)
                        love.graphics.setColor(1, 1, 1, 1)
                    end

                    TILE_WIDTH3 = TILE_WIDTH3 + TILE_WIDTH
                end

                TILE_WIDTH3 = 0
                TILE_HEIGHT3 = TILE_HEIGHT3 + TILE_HEIGHT
            end
        end
    end
end


-- Affiche le Numero/ID des Tiles/Objects.
function drawNumeroTilesandTiles2andIDObjectsInTheGrilleMap()
    if MAP_NIVEAU ~= "?" then
        testTILE_WIDTH4 = 0
        testTILE_HEIGHT4 = 0

        love.graphics.setColor(1, 1, 1, 1)
        
        if MAP_NIVEAU ~= "?" then 
            for l=1,MAP_HEIGHT do
                for c=1,MAP_WIDTH do
                    tileCurrent = TileMaps[MAP_NIVEAU][l][c]
                    tileCurrent2 = TileMaps2[MAP_NIVEAU][l][c]
                    --tileCurrent3 = Objects[MAP_NIVEAU][l][c] (POUR LES OBJETS)

                    if tileCurrent ~= 0 and CalquesActive.IDTiles == "ON" and CalquesActive.Tiles == "ON" then
                        love.graphics.print(tileCurrent, testTILE_WIDTH4, testTILE_HEIGHT4)
                    end

                    if tileCurrent2 ~= 0 and CalquesActive.IDTiles2 == "ON" and CalquesActive.Tiles2 == "ON" then
                        love.graphics.print(tileCurrent2, testTILE_WIDTH4, testTILE_HEIGHT4)
                    end

                    testTILE_WIDTH4 = testTILE_WIDTH4 + TILE_WIDTH
                end

                testTILE_WIDTH4 = 0
                testTILE_HEIGHT4 = testTILE_HEIGHT4 + TILE_HEIGHT
            end
        end
    end
end


-- Pinceau GrilleMap pour les Tiles/Objects, button de la souris en continue
function pinceauInTheGrilleMap()
    if love.mouse.isDown(1) and CURRENT_LIGNE >= 0 and CURRENT_LIGNE <= (MAP_HEIGHT - 1) and CURRENT_COLONNE >= 0 and CURRENT_COLONNE <= (MAP_WIDTH - 1) and inGrilleMapViewTiles == false and outilsActive == 'Pinceau' and Game.TileActive ~= nil and MAP_NIVEAU ~= "?" and mouseOnTheOutils == false then
        LIGNE = CURRENT_LIGNE + 1 
        COLONNE = CURRENT_COLONNE + 1

        if CALQUES == "Calque1" and MapsDataLua.Calque1[1][LIGNE][COLONNE] ~= Game.TileActive then
            if Historique.Bool == true then
                Historique.Bool = false
                Historique.AvantDonnees = {}
                Historique.CounterAvant = 0

                local i = Historique.CounterArriere + 1
                for i=i,#Historique.ArriereDonnees do
                    table.remove(Historique.ArriereDonnees, #Historique.ArriereDonnees)
                end
            end

            -- Historique Arriere
            local tab = { LIGNE = LIGNE, COLONNE = COLONNE, CALQUE = "Calque1", DATAMAP = MapsDataLua.Calque1[1][LIGNE][COLONNE] }
            table.insert(Historique.ArriereDonnees, tab)
            Historique.CounterArriere = Historique.CounterArriere + 1

            -- Nouvelle données
            MapsDataLua.Calque1[1][LIGNE][COLONNE] = Game.TileActive
        elseif CALQUES == "Calque2" then
            MapsDataLua.Calque2[1][LIGNE][COLONNE] = Game.TileActive
        elseif CALQUES == "Calque3" then
            MapsDataLua.Calque3[1][LIGNE][COLONNE] = Game.TileActive
        elseif CALQUES == "Calque4" then
            MapsDataLua.Calque4[1][LIGNE][COLONNE] = Game.TileActive
        elseif CALQUES == "Collision" then
            --MapsDataLua.Calque4[1][LIGNE][COLONNE] = Game.TileActive
        end
    end
end


-- Gommer GrilleMap button de la souris en continue
function gommeInTheGrilleMap()
    if love.mouse.isDown(1) and CURRENT_LIGNE >= 0 and CURRENT_LIGNE <= (MAP_HEIGHT - 1) and CURRENT_COLONNE >= 0 and CURRENT_COLONNE <= (MAP_WIDTH - 1) and inGrilleMapViewTiles == false and outilsActive == 'Gomme' and MAP_NIVEAU ~= "?" and mouseOnTheOutils == false then
        LIGNE = CURRENT_LIGNE + 1 
        COLONNE = CURRENT_COLONNE + 1 

        if CALQUES == "Calque1" and MapsDataLua.Calque1[1][LIGNE][COLONNE] ~= 0 then
            if Historique.Bool == true then
                Historique.Bool = false
                Historique.AvantDonnees = {}
                Historique.CounterAvant = 0

                local i = Historique.CounterArriere + 1
                for i=i,#Historique.ArriereDonnees do
                    table.remove(Historique.ArriereDonnees, #Historique.ArriereDonnees)
                end
            end

            -- Historique Arriere
            local tab = { LIGNE = LIGNE, COLONNE = COLONNE, CALQUE = "Calque1", DATAMAP = MapsDataLua.Calque1[1][LIGNE][COLONNE] }
            table.insert(Historique.ArriereDonnees, tab)
            Historique.CounterArriere = Historique.CounterArriere + 1

            -- Nouvelle données
            MapsDataLua.Calque1[1][LIGNE][COLONNE] = 0
        elseif CALQUES == "Calque2" then
            MapsDataLua.Calque2[1][LIGNE][COLONNE] = 0
        elseif CALQUES == "Calque3" then
            MapsDataLua.Calque3[1][LIGNE][COLONNE] = 0
        elseif CALQUES == "Calque4" then
            MapsDataLua.Calque4[1][LIGNE][COLONNE] = 0
        elseif CALQUES == "Collision" then
            --MapsDataLua.Calque4[1][LIGNE][COLONNE] = Game.TileActive
        end
    end
end


-- Au survol de souris la Tile qui a était choisi suis le pointeur de la souris en trasparent et rouge si il est en-dehors de la Map.
function drawTileRedOrTexture()
    local offsetXColonne = colonnesCursorInGrilleMap * TILE_WIDTH
    local offsetYLigne = lignesCursorInGrilleMap * TILE_HEIGHT

    if not love.mouse.isDown(2) then
        if CALQUES ~= "Collision" then 
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
        else
            -- Couleur pour dessiner les Collision
            if resultLignesCursorGrilleMap ~= "En dehors de la Grille Map" and resultColonnesCursorGrilleMap ~= "En dehors de la Grille Map" and outilsActive ~= 'Gomme' then
                love.graphics.setColor(255, 165, 0, 0.3)
                love.graphics.rectangle("fill", offsetXColonne, offsetYLigne, TILE_WIDTH, TILE_HEIGHT)
                love.graphics.setColor(1, 1, 1, 1)
            elseif resultLignesCursorGrilleMap == "En dehors de la Grille Map" or resultColonnesCursorGrilleMap == "En dehors de la Grille Map" then
                love.graphics.setColor(255, 0, 0, 0.3)    
                love.graphics.rectangle("fill", offsetXColonne, offsetYLigne, TILE_WIDTH, TILE_HEIGHT)
                love.graphics.setColor(1, 1, 1, 1)
            else
                love.graphics.setColor(48, 140, 198, 0.3)    
                love.graphics.rectangle("fill", offsetXColonne, offsetYLigne, TILE_WIDTH, TILE_HEIGHT)
                love.graphics.setColor(1, 1, 1, 1)
            end
        end
    end
end


-- drawViewFiles / Découpage SpriteSheet
function drawViewFiles(pDirName)
    local mouseX = love.mouse.getX()
    local mouseY = love.mouse.getY()

    if MAP_NIVEAU ~= "?" then
        -- Fond noir (rect)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("fill", 0 - window.translate.x, hauteurEcran - 200 - window.translate.y, 850, hauteurEcran)
    
        -- Affichage du texte, des bouttons, et des lignes.
        love.graphics.setColor(255, 165, 0, 1)
        love.graphics.print(".EXT :", 1 - window.translate.x, hauteurEcran - 198 - window.translate.y)
        love.graphics.print("NAME FILES", 80 - window.translate.x, hauteurEcran - 198 - window.translate.y)
        love.graphics.print("DECOUPAGE FAIT", 250 - window.translate.x, hauteurEcran - 198 - window.translate.y)
        love.graphics.print("ADD/MODIFY", 400 - window.translate.x, hauteurEcran - 198 - window.translate.y)
        love.graphics.print("VIEW TILES", 500 - window.translate.x, hauteurEcran - 198 - window.translate.y)
        love.graphics.print("VIEW OBJECTS", 600 - window.translate.x, hauteurEcran - 198 - window.translate.y)
        love.graphics.print("VIEW ANIMATIONSFX", 710 - window.translate.x, hauteurEcran - 198 - window.translate.y)
        love.graphics.setColor(1, 1, 1, 1)

        love.graphics.line(35 - window.translate.x, hauteurEcran - 200 - window.translate.y, 35 - window.translate.x, hauteurEcran - window.translate.y)
        love.graphics.line(240 - window.translate.x, hauteurEcran - 200 - window.translate.y, 240 - window.translate.x, hauteurEcran - window.translate.y)
        love.graphics.line(380 - window.translate.x, hauteurEcran - 200 - window.translate.y, 380 - window.translate.x, hauteurEcran - window.translate.y)
        love.graphics.line(490 - window.translate.x, hauteurEcran - 200 - window.translate.y, 490 - window.translate.x, hauteurEcran - window.translate.y)
        love.graphics.line(590 - window.translate.x, hauteurEcran - 200 - window.translate.y, 590 - window.translate.x, hauteurEcran - window.translate.y)
        love.graphics.line(700 - window.translate.x, hauteurEcran - 200 - window.translate.y, 700 - window.translate.x, hauteurEcran - window.translate.y)

        local x = 0
        local y = 20
        local y2 = 35
        
        for k,file in pairs(files) do
            startString = string.find(file, "%p", #file - 4)
            extensionFichier = string.sub(file, startString + 1)
            love.graphics.print(string.upper(extensionFichier), 5 - window.translate.x, hauteurEcran - 205 + y2 - window.translate.y)

            love.graphics.print(file, 40 - window.translate.x, hauteurEcran - 205 + y2 - window.translate.y)

            love.graphics.setColor(255, 0, 0, 1)
            love.graphics.circle("fill", 300 - window.translate.x, hauteurEcran - 200 + y2 - window.translate.y, 10)
            love.graphics.setColor(1, 1, 1, 1)

            love.graphics.setColor(255, 0, 0, 1)
            love.graphics.circle("fill", 540 - window.translate.x, hauteurEcran - 200 + y2 - window.translate.y, 10)
            love.graphics.circle("fill", 640 - window.translate.x, hauteurEcran - 200 + y2 - window.translate.y, 10)
            love.graphics.circle("fill", 780 - window.translate.x, hauteurEcran - 200 + y2 - window.translate.y, 10)
            love.graphics.setColor(1, 1, 1, 1)

            love.graphics.line(0 - window.translate.x, hauteurEcran - 200 + y - window.translate.y, 850 - window.translate.x, hauteurEcran - 200 + y - window.translate.y)

            love.graphics.draw(GUI.imgButtonDecoupageSpriteSheet, 430 - window.translate.x, hauteurEcran - 195 + y - window.translate.y)

            y2 = y2 + 30
            y = y + 30
        end


        if mouseX >= 0 and mouseX <= 850 and mouseY >= hauteurEcran - 200 and mouseY <= hauteurEcran then
            inGrilleMapViewFiles = true
        else
            inGrilleMapViewFiles = false
        end
    end 
end


-- Charge les Tiles par rapport au TILE_WIDTH et TILE_HEIGHT de la map actuellement chargée.
function loadTiles()
    -- Reset la liste des Tiles a chaque nouveau chargement d'une nouvelle map si jamais les TILES_WIDTH et TILE_HEIGHT ne sont pas les mêmes
    Game.Tiles = {}
    Game.TileSheetsActive = {}

    -- Itere sur la table qui contient toute les TileSheets, puis découpe chaque images d'une TileSheet et les envoie dans la table : Game.Tiles (tableaux a deux dimensions)
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
end


-- Je charge une TileSheets et l'envoie dans la table : Game.TileSheets
function loadTileSheets(pNomDossierRessources, pNomFicherTileSheet)
    local tileSheet = love.graphics.newImage(pNomDossierRessources .. "/" .. pNomFicherTileSheet)
    table.insert(Game.TileSheets, tileSheet)
end








--[[   
██       ██████   █████  ██████  
██      ██    ██ ██   ██ ██   ██ 
██      ██    ██ ███████ ██   ██ 
██      ██    ██ ██   ██ ██   ██ 
███████  ██████  ██   ██ ██████                                                                    
]]

function sceneEditorMaps.load()
    -- Récupère le chemin jusqu'a avant le dossier du jeu, puis je récupère le nom du dossier du jeu.
    path = love.filesystem.getSourceBaseDirectory()
    dirNameGame = love.filesystem.getIdentity()
    pathCurrent = path .. "/" .. dirNameGame


    -- Créer les fichiers JSON qui contiendras les données des maps si jamais il ne sont pas créer.
    if fileExists("mapCalque1.json") ~= true then
        local file = io.open(pathCurrent ..  "/dataMaps/mapCalque1.json","w")
        file:close()

        local file2 = io.open(pathCurrent ..  "/dataMaps/mapCalque2.json","w")
        file2:close()

        local file3 = io.open(pathCurrent ..  "/dataMaps/mapCalque3.json","w")
        file3:close()

        local file4 = io.open(pathCurrent ..  "/dataMaps/mapCalque4.json","w")
        file4:close()
    end


    -- Je charge toutes mes TileSheets (Une SpriteSheet qui contient des Tiles)
    -- loadTileSheets(nomDuDossier, nomFichierImgTileSheet)
    loadTileSheets('assets', 'tileSet.png')
    loadTileSheets('assets', 'tileSet2.png')


    -- Je charge les images de la GUI de l'éditeur de Map
    GUI.imgButtonDessinerGrille = love.graphics.newImage("assetsEditor/dessinerGrille.png")
    GUI.imgButtonGommeGrille = love.graphics.newImage("assetsEditor/gommeGrille.png")
    GUI.imgButtonMainObjetGrille = love.graphics.newImage("assetsEditor/mainObject.png")
    GUI.imgButtonPipeGrille = love.graphics.newImage("assetsEditor/pipe.png")
    GUI.imgButtonNone = love.graphics.newImage("assetsEditor/buttonNone.png")
    GUI.imgFleche.img = love.graphics.newImage("assetsEditor/flecheGauche.png")
    GUI.imgButtonCalqueOeilOuvert = love.graphics.newImage("assetsEditor/oeil_ouvert.png")
    GUI.imgButtonCalqueOeilOuvert2 = love.graphics.newImage("assetsEditor/oeil_ouvert.png")
    GUI.imgButtonCalqueOeilOuvert3 = love.graphics.newImage("assetsEditor/oeil_ouvert.png")
    GUI.imgButtonCalqueOeilOuvert4 = love.graphics.newImage("assetsEditor/oeil_ouvert.png")
    GUI.imgButtonCalqueOeilOuvert5 = love.graphics.newImage("assetsEditor/oeil_ouvert.png")
    GUI.imgButtonCalqueOeilOuvert6 = love.graphics.newImage("assetsEditor/oeil_ouvert.png")
    GUI.imgButtonCalqueOeilOuvert7 = love.graphics.newImage("assetsEditor/oeil_ouvert.png")
    GUI.imgButtonCalqueOeilFermer = love.graphics.newImage("assetsEditor/oeil_fermer.png")
    GUI.imgButtonCalqueOeilFermer2 = love.graphics.newImage("assetsEditor/oeil_fermer.png")
    GUI.imgButtonCalqueOeilFermer3 = love.graphics.newImage("assetsEditor/oeil_fermer.png")
    GUI.imgButtonCalqueOeilFermer4 = love.graphics.newImage("assetsEditor/oeil_fermer.png")
    GUI.imgButtonCalqueOeilFermer5 = love.graphics.newImage("assetsEditor/oeil_fermer.png")
    GUI.imgButtonCalqueOeilFermer6 = love.graphics.newImage("assetsEditor/oeil_fermer.png")
    GUI.imgButtonCalqueOeilFermer7 = love.graphics.newImage("assetsEditor/oeil_fermer.png")
    GUI.imgButtonDecoupageSpriteSheet = love.graphics.newImage("assetsEditor/buttonConfigDecoupage.png")


    -- Je charge les images différentes pour le cursor.
    cursorImg.deplacementMapEditor = love.mouse.newCursor("assetsEditor/cursor_deplacementTileMapEditor.png", 10, 10)
    cursorImg.mouvementHautBasInMapEditor = love.mouse.newCursor("assetsEditor/cursor_HautBas.png", 10, 10)
    cursorImg.mouvementGaucheDroiteInMapEditor = love.mouse.newCursor("assetsEditor/cursor_GaucheDroite.png", 10, 10)
    cursorImg.mouvementHautDroiteBasGaucheInMapEditor = love.mouse.newCursor("assetsEditor/cursor_HautDroiteBasGauche.png", 10, 10)
    cursorImg.mouvementHautGaucheBasDroiteInMapEditor = love.mouse.newCursor("assetsEditor/cursor_HautGaucheBasDroite.png", 10, 10)


    --
    love.keyboard.setKeyRepeat(true)

        
    -- Récupère tout les noms des fichiers.    
    getAllNameFiles("assets")
    files = love.filesystem.getDirectoryItems("assets")
    counterNombreFiles = #files 
    scrollY_counterMax2 = counterNombreFiles - 6
    tableTempoFileScroll = nil
end     




--[[   
██    ██ ██████  ██████   █████  ████████ ███████ 
██    ██ ██   ██ ██   ██ ██   ██    ██    ██      
██    ██ ██████  ██   ██ ███████    ██    █████   
██    ██ ██      ██   ██ ██   ██    ██    ██      
 ██████  ██      ██████  ██   ██    ██    ███████                                                                                                                                                                      
]]

function sceneEditorMaps.update(dt)
    --
    timerr(dt)


    -- Mise à jour de la position X et Y de la souris en continue. 
    updateMouseXandY()


    -- Calcule par rapport au pointeur de la souris la position de la ligne et colonne de la GrilleMap.
    getPositionCursorInGrilleMap()


    -- Si il y a un cursor personnaliser en cours alors je désactive le cursor par défault.
    if cursorPersoActive == false then
        love.mouse.setCursor()
    end


    --
    pinceauInTheGrilleMap()
    --pinceauCollisionInTheGrilleMap()


    --
    gommeInTheGrilleMap()
    --gommeCollisionInTheGrilleMap()


    --
    deplacerGrilleMapClickRight()
    
    
    --
    deplacementInGrilleMapZQSD()


    -- Empeche de dessiner ou gommer derrière la GUI du pinceau et gomme quand on selectionne un Outils.
    empecheDessinerGommerDerriereGUIOutils()
end




--[[   
██████  ██████   █████  ██     ██ 
██   ██ ██   ██ ██   ██ ██     ██ 
██   ██ ██████  ███████ ██  █  ██ 
██   ██ ██   ██ ██   ██ ██ ███ ██ 
██████  ██   ██ ██   ██  ███ ███                                                                                                                                                                                                                                    
]]

function sceneEditorMaps.draw()
    -- Set un background color
    colorBackgroundMap(backgroundColor.red, backgroundColor.green, backgroundColor.blue, backgroundColor.alpha)    

    
    -- Translation par rapport au Zoom. 
    -- Initialiser la mise a l'échelle (Scale). 
    -- Puis je défini le Scale pour X et Y à la fois.
    love.graphics.translate(window.translate.x, window.translate.y)
    love.graphics.push()
	love.graphics.scale(window.zoom)


    --
    drawCalqueInTheGrilleMap(MapsDataLua.Calque1, CalquesActive.Calque1)
    drawCalqueInTheGrilleMap(MapsDataLua.Calque2, CalquesActive.Calque2)
    drawCalqueInTheGrilleMap(MapsDataLua.Calque3, CalquesActive.Calque3)
    drawCalqueInTheGrilleMap(MapsDataLua.Calque4, CalquesActive.Calque4)
    --drawCollisionInTheGrilleMap()
    --drawNumeroTilesandTiles2andIDObjectsInTheGrilleMap()


    --
    colorGrilleMap()


    -- Le tracer des Lines des colonnes et lignes de la map : Grille Map
    drawTheLinesForGrilleMap()


    -- Remet la palette de couleur par défault après avoir appliquer une palette de couleur pour les Lines de la grille de la Map.
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

function sceneEditorMaps.textinput(event)
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

function sceneEditorMaps.keypressed(key, isrepeat)
  
    -- Change la couleur des Lines de la GrilleMap
    if key == "f2" then
        if GUI.grilleMapColor == 'black' then 
            GUI.grilleMapColor = 'white'
        else
           GUI.grilleMapColor = 'black'
        end
    end


    -- Active ou désactive le tracer des Lines de la GrilleMap.
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
            GUI.imgFleche.x = inputText.LOAD_MAP.widthFont + 22
            GUI.imgFleche.y = GUI.imgFleche.y + 20
            inputTextActive = "LOAD_MAP"
        elseif GUI.imgFleche.x == inputText.LOAD_MAP.widthFont + 22 then
            GUI.imgFleche.x = inputText.SAVE_MAP.widthFont + 15
            GUI.imgFleche.y = GUI.imgFleche.y + 20
            inputTextActive = "SAVE_MAP"
        elseif GUI.imgFleche.x == inputText.SAVE_MAP.widthFont + 15 then
            GUI.imgFleche.x = inputText.DELETE_MAP.widthFont + 20
            GUI.imgFleche.y = GUI.imgFleche.y + 20
            inputTextActive = "DELETE_MAP"
        elseif GUI.imgFleche.x == inputText.DELETE_MAP.widthFont + 20 then
            GUI.imgFleche.x = inputText.CALQUES.widthFont + 10
            GUI.imgFleche.y = GUI.imgFleche.y + 40
            inputTextActive = "CALQUES"
        elseif GUI.imgFleche.x == inputText.CALQUES.widthFont + 10 then
            GUI.imgFleche.x = inputText.TYPE.widthFont + 5
            GUI.imgFleche.y = GUI.imgFleche.y + 20
            inputTextActive = "TYPE"
        --[[elseif GUI.imgFleche.x == inputText.TYPE.widthFont + 5 then
            GUI.imgFleche.x = inputText.backgroundColorRed.widthFont + 15
            GUI.imgFleche.y = GUI.imgFleche.y + 40
            inputTextActive = "backgroundColorRed"
        elseif GUI.imgFleche.x == inputText.backgroundColorRed.widthFont + 15 then
            GUI.imgFleche.x = inputText.backgroundColorGreen.widthFont + 15
            GUI.imgFleche.y = GUI.imgFleche.y + 20
            inputTextActive = "backgroundColorGreen"
        elseif GUI.imgFleche.x == inputText.backgroundColorGreen.widthFont + 15 then
            GUI.imgFleche.x = inputText.backgroundColorBlue.widthFont + 15
            GUI.imgFleche.y = GUI.imgFleche.y + 20
            inputTextActive = "backgroundColorBlue"
        elseif GUI.imgFleche.x == inputText.backgroundColorBlue.widthFont + 15 then
            GUI.imgFleche.x = inputText.backgroundColorAlpha.widthFont + 15
            GUI.imgFleche.y = GUI.imgFleche.y + 20
            inputTextActive = "backgroundColorAlpha"]]
        elseif GUI.imgFleche.x == inputText.TYPE.widthFont + 5 then
            GUI.imgFleche.x = inputText.LinesGrilleAlpha.widthFont + 20
            GUI.imgFleche.y = GUI.imgFleche.y + 140
            inputTextActive = "LinesGrilleAlpha"
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
                inputText.LOAD_MAP.txt = string.sub(inputText.LOAD_MAP.txt, 1, byteoffsetLOAD_MAP - 1)
                inputText.LOAD_MAP.txt = tonumber(inputText.LOAD_MAP.txt)
                LOAD_MAP = inputText.LOAD_MAP.txt
            end
        elseif byteoffsetDELETE_MAP and inputTextActive == "DELETE_MAP" then
            if tonumber(inputText.DELETE_MAP.txt) <= 9 then
                inputText.DELETE_MAP.txt = ""
                DELETE_MAP = inputText.DELETE_MAP.txt
            else
                inputText.DELETE_MAP.txt = string.sub(inputText.DELETE_MAP.txt, 1, byteoffsetDELETE_MAP - 1)
                inputText.DELETE_MAP.txt = tonumber(inputText.DELETE_MAP.txt)
                DELETE_MAP = inputText.DELETE_MAP.txt
            end
        end

        NOMBRE_LIGNE = MAP_HEIGHT * TILE_HEIGHT 
        NOMBRE_COLONNE = MAP_WIDTH * TILE_WIDTH
        MAP_PIXELS = NOMBRE_LIGNE .. ' x ' .. NOMBRE_COLONNE .. ' pixels'
    end


    -- Generate Map etc avec la touche ENTER
    if key == "return" then
        if inputTextActive == "ORIENTATION_TILES" then
            if ORIENTATION_TILES == "Orthogonale" then
                ORIENTATION_TILES = "Isometric" -- FAKE RIEN ES FAIT
            else
                ORIENTATION_TILES = "Orthogonale"
            end
        elseif inputTextActive == "GENERATE_MAP" then 
            if MAP_NIVEAU == "?" and MAP_WIDTH >= 2 and MAP_HEIGHT >= 2 and TILE_WIDTH >= 1 and TILE_HEIGHT >= 1 then
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
        elseif inputTextActive == "DELETE_MAP" then
            if DELETE_MAP == MAP_NIVEAU then
                deleteMap(inputText.DELETE_MAP.txt)
                newMap()
            else
                deleteMap(inputText.DELETE_MAP.txt)
            end

            inputText.DELETE_MAP.txt = ""
            DELETE_MAP = inputText.DELETE_MAP.txt
        elseif inputTextActive == "CALQUES" and MAP_NIVEAU ~= "?" then
            if CALQUES == "Calque1" then
                CALQUES = "Calque2"
            elseif CALQUES == "Calque2" then
                CALQUES = "Calque3"
            elseif CALQUES == "Calque3" then
                CALQUES = "Calque4"
            else
                CALQUES = "Calque1"
            end
        elseif inputTextActive == "TYPE" and MAP_NIVEAU ~= "?" then
            if TYPE == "Tile" then
                GUI.imgFleche.x = GUI.imgFleche.x + 20
                TYPE = "Object"
            elseif TYPE == "Object" then
                GUI.imgFleche.x = GUI.imgFleche.x + 50
                TYPE = "AnimationsFX"
            elseif TYPE == "AnimationsFX" then
                GUI.imgFleche.x = GUI.imgFleche.x - 70
                TYPE = "Tile"
            end
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
        elseif inputTextActive == "LinesGrilleAlpha" then
            if key == "left" then
                if colorLinesGrilleMap.alpha > 0.15 then
                    colorLinesGrilleMap.alpha = colorLinesGrilleMap.alpha - 0.1
                end
            elseif key == "right" then
                if colorLinesGrilleMap.alpha ~= 1 then
                    colorLinesGrilleMap.alpha = colorLinesGrilleMap.alpha + 0.1
                end
            end
        end
    end


    -- Permet de revenir en Arrière après modification de la Map.
    if key == "lctrl" and Historique.CounterArriere ~= 0 and Historique.CounterArriere <= #Historique.ArriereDonnees then      
        local VALUE_DATAMAP = Historique.ArriereDonnees[Historique.CounterArriere].DATAMAP
        local LIGNE = Historique.ArriereDonnees[Historique.CounterArriere].LIGNE
        local COLONNE = Historique.ArriereDonnees[Historique.CounterArriere].COLONNE
        local CALQUE = Historique.ArriereDonnees[Historique.CounterArriere].CALQUE

        if CALQUE == "Calque1" then
            -- Historique Avant
            local tab = { LIGNE = LIGNE, COLONNE = COLONNE, CALQUE = "Calque1", DATAMAP = MapsDataLua.Calque1[1][LIGNE][COLONNE] }
            table.insert(Historique.AvantDonnees, tab)

            MapsDataLua.Calque1[1][LIGNE][COLONNE] = VALUE_DATAMAP

            Historique.CounterArriere = Historique.CounterArriere - 1
            Historique.CounterAvant = Historique.CounterAvant + 1
            Historique.Bool = true
        elseif CALQUE == "Calque2" then

        end
    end


    -- Permet de revenir en Avant après modification de la Map.
    if key == "lalt" and Historique.CounterAvant ~= 0 and Historique.CounterAvant <= #Historique.AvantDonnees then      
        local VALUE_DATAMAP = Historique.AvantDonnees[Historique.CounterAvant].DATAMAP
        local LIGNE = Historique.AvantDonnees[Historique.CounterAvant].LIGNE
        local COLONNE = Historique.AvantDonnees[Historique.CounterAvant].COLONNE        
        local CALQUE = Historique.AvantDonnees[Historique.CounterAvant].CALQUE

        if CALQUE == "Calque1" then
            MapsDataLua.Calque1[1][LIGNE][COLONNE] = VALUE_DATAMAP

            table.remove(Historique.AvantDonnees, #Historique.AvantDonnees)

            Historique.CounterArriere = Historique.CounterArriere + 1
            Historique.CounterAvant = Historique.CounterAvant - 1
        elseif CALQUE == "Calque2" then

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

function sceneEditorMaps.mousepressed(x, y, button)
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
        mainobjetAlpha = 1
        pipeAlpha = 1
    end 
    
    
    -- Button de la gomme (effacer une Tile)
    if x <= largeurEcran - GUI.imgButtonGommeGrille:getWidth() / 2 and x >= largeurEcran - (GUI.imgButtonGommeGrille:getWidth() + (GUI.imgButtonGommeGrille:getWidth() / 2)) and
       y >= GUI.imgButtonDessinerGrille:getHeight() / 2 + GUI.imgButtonDessinerGrille:getHeight() and y <= GUI.imgButtonDessinerGrille:getHeight() / 2 + GUI.imgButtonDessinerGrille:getHeight() + GUI.imgButtonGommeGrille:getHeight() then    
        
        outilsActive = 'Gomme'
        gommeAlpha = 0.3
        pinceauAlpha = 1
        mainobjetAlpha = 1
        pipeAlpha = 1
    end


    -- Button de déplacement d'Objets
    if x <= largeurEcran - GUI.imgButtonDessinerGrille:getWidth() - GUI.imgButtonDessinerGrille:getWidth() / 2 and x >= largeurEcran - (GUI.imgButtonDessinerGrille:getWidth() + GUI.imgButtonDessinerGrille:getWidth() / 2 + GUI.imgButtonMainObjetGrille:getWidth()) and
       y >= GUI.imgButtonMainObjetGrille:getHeight() / 2 and y <= GUI.imgButtonMainObjetGrille:getHeight() + (GUI.imgButtonMainObjetGrille:getHeight() / 2) then
    
        outilsActive = 'MainObjet'
        mainobjetAlpha = 0.3
        pinceauAlpha = 1
        gommeAlpha = 1
        pipeAlpha = 1
    end 


    -- Button de la pipe (pour récupèrer une Tile/Objects/AnimationsFX..) au lieu de récupèrer et cliquer dans les Views Tiles..etc
    if x <= largeurEcran - GUI.imgButtonGommeGrille:getWidth() - GUI.imgButtonGommeGrille:getWidth() / 2 and x >= largeurEcran - (GUI.imgButtonGommeGrille:getWidth() + GUI.imgButtonGommeGrille:getWidth() / 2 + GUI.imgButtonPipeGrille:getWidth()) and
       y >= GUI.imgButtonMainObjetGrille:getHeight() / 2 + GUI.imgButtonMainObjetGrille:getHeight() and y <= GUI.imgButtonMainObjetGrille:getHeight() / 2 + GUI.imgButtonDessinerGrille:getHeight() + GUI.imgButtonGommeGrille:getHeight() then    
        
        outilsActive = 'Pipe'
        pipeAlpha = 0.3
        gommeAlpha = 1
        pinceauAlpha = 1
        mainobjetAlpha = 1
    end


    -- Button 'None', remet la variable -> outilsActive = nil (aucun outils sélectionner)
    if x <= largeurEcran - GUI.imgButtonNone:getWidth() / 2 and x >= largeurEcran - (GUI.imgButtonNone:getWidth() + (GUI.imgButtonNone:getWidth() / 2)) and
       y >= GUI.imgButtonDessinerGrille:getHeight() / 2 + GUI.imgButtonDessinerGrille:getHeight() + GUI.imgButtonGommeGrille:getHeight() and y <= GUI.imgButtonDessinerGrille:getHeight() / 2 
       + GUI.imgButtonDessinerGrille:getHeight() + GUI.imgButtonGommeGrille:getHeight() + GUI.imgButtonNone:getHeight() then    
        
        outilsActive = nil
        pinceauAlpha = 1
        gommeAlpha = 1
        mainobjetAlpha = 1
        pipeAlpha = 1
    end


    -- Récupère la Tile choisi dans la View des Tiles
    if MAP_NIVEAU ~= "?" and mouseX >= (largeurEcran - grilleViewTilesWidth) and mouseY >= (hauteurEcran - grilleViewTilesHeight) then
        numeroTileCurrent = ((CURRENT_LIGNE2 + scrollY_counter) * colonneViewTile) + (CURRENT_COLONNE2 + 1)

        if numeroTileCurrent <= #Game.Tiles then
            Game.TileActive = numeroTileCurrent
            print("TILE ACTIVE : " .. Game.TileActive)
        else
            Game.TileActive = nil
            clickInOneTile = false
        end
    end


    -- Click sur l'image de l'oeil de la GUI pour afficher / enlever l'affichage des Tiles    
    if x <= largeurEcran - GUI.imgButtonCalqueOeilOuvert:getWidth() / 2 - 25 and x >= largeurEcran - (GUI.imgButtonCalqueOeilOuvert:getWidth() + (GUI.imgButtonCalqueOeilOuvert:getWidth() / 2)) - 25 and
       y >= hauteurEcran - grilleViewTilesHeight - 200 and y <= hauteurEcran - grilleViewTilesHeight - 200 + GUI.imgButtonCalqueOeilOuvert:getHeight() then    
        
        if CalquesActive.Calque1 == "ON" then
            CalquesActive.Calque1 = "OFF"
        else
            CalquesActive.Calque1 = "ON"
        end
    end

    -- Click sur l'image de l'oeil de la GUI pour afficher / enlever l'affichage des Objects
    if x <= largeurEcran - GUI.imgButtonCalqueOeilOuvert:getWidth() / 2 + GUI.imgButtonCalqueOeilOuvert2:getWidth() / 2 - 25 and x >= largeurEcran - (GUI.imgButtonCalqueOeilOuvert2:getWidth() + (GUI.imgButtonCalqueOeilOuvert2:getWidth() / 2)) - 10 and
       y >= hauteurEcran - grilleViewTilesHeight - 200 + GUI.imgButtonCalqueOeilOuvert2:getHeight() + 10 and y <= hauteurEcran - grilleViewTilesHeight - 200 + GUI.imgButtonCalqueOeilOuvert:getHeight() + GUI.imgButtonCalqueOeilOuvert2:getHeight() + 10 then    
        
        if CalquesActive.Calque2 == "ON" then
            CalquesActive.Calque2 = "OFF"
        else
            CalquesActive.Calque2 = "ON"
        end
    end

    -- Click sur l'image de l'oeil de la GUI pour afficher / enlever l'affichage des Objects
    if x <= largeurEcran - GUI.imgButtonCalqueOeilOuvert:getWidth() / 2 + GUI.imgButtonCalqueOeilOuvert2:getWidth() / 2 - 20 and x >= largeurEcran - (GUI.imgButtonCalqueOeilOuvert2:getWidth() + (GUI.imgButtonCalqueOeilOuvert2:getWidth() / 2)) - 10 and
       y >= hauteurEcran - grilleViewTilesHeight - 200 + GUI.imgButtonCalqueOeilOuvert2:getHeight() + GUI.imgButtonCalqueOeilOuvert3:getHeight() + 20 and y <= hauteurEcran - grilleViewTilesHeight - 200 + GUI.imgButtonCalqueOeilOuvert:getHeight() + GUI.imgButtonCalqueOeilOuvert2:getHeight() + GUI.imgButtonCalqueOeilOuvert3:getHeight() + 25 then    
        
        if CalquesActive.Objects == "ON" then
            CalquesActive.Objects = "OFF"
        else
            CalquesActive.Objects = "ON"
        end
    end

    -- Click sur l'image de l'oeil de la GUI pour afficher / enlever l'affichage des Collision
    if x <= largeurEcran - GUI.imgButtonCalqueOeilOuvert:getWidth() / 2 + GUI.imgButtonCalqueOeilOuvert2:getWidth() / 2 - 20 and x >= largeurEcran - (GUI.imgButtonCalqueOeilOuvert2:getWidth() + (GUI.imgButtonCalqueOeilOuvert2:getWidth() / 2)) and
       y >= hauteurEcran - grilleViewTilesHeight - 200 + GUI.imgButtonCalqueOeilOuvert2:getHeight() + GUI.imgButtonCalqueOeilOuvert3:getHeight() + GUI.imgButtonCalqueOeilOuvert4:getHeight() + 30 and y <= hauteurEcran - grilleViewTilesHeight - 200 + GUI.imgButtonCalqueOeilOuvert:getHeight() + GUI.imgButtonCalqueOeilOuvert2:getHeight() + GUI.imgButtonCalqueOeilOuvert3:getHeight() + GUI.imgButtonCalqueOeilOuvert3:getHeight() + 35 then    
        
        if CalquesActive.Collision == "ON" then
            CalquesActive.Collision = "OFF"
        else
            CalquesActive.Collision = "ON"
        end
    end

    -- Click sur l'image de l'oeil de la GUI pour afficher / enlever l'affichage des Numero des Tiles
    if x <= largeurEcran - GUI.imgButtonCalqueOeilOuvert:getWidth() / 2 + GUI.imgButtonCalqueOeilOuvert2:getWidth() / 2 - 20 and x >= largeurEcran - (GUI.imgButtonCalqueOeilOuvert2:getWidth() + (GUI.imgButtonCalqueOeilOuvert2:getWidth() / 2)) and
       y >= hauteurEcran - grilleViewTilesHeight - 200 + GUI.imgButtonCalqueOeilOuvert2:getHeight() + GUI.imgButtonCalqueOeilOuvert3:getHeight() + GUI.imgButtonCalqueOeilOuvert4:getHeight() + GUI.imgButtonCalqueOeilOuvert4:getHeight() + 40 and y <= hauteurEcran - grilleViewTilesHeight - 200 + GUI.imgButtonCalqueOeilOuvert:getHeight() + GUI.imgButtonCalqueOeilOuvert2:getHeight() + GUI.imgButtonCalqueOeilOuvert3:getHeight() + GUI.imgButtonCalqueOeilOuvert4:getHeight() + GUI.imgButtonCalqueOeilOuvert5:getHeight() + 45 then    
        
        if CalquesActive.IDCalque1 == "ON" then
            CalquesActive.IDCalque1 = "OFF"
        else
            CalquesActive.IDCalque1 = "ON"
        end
    end

    -- Click sur l'image de l'oeil de la GUI pour afficher / enlever l'affichage des Numero des Tiles2
    if x <= largeurEcran - GUI.imgButtonCalqueOeilOuvert:getWidth() / 2 + GUI.imgButtonCalqueOeilOuvert2:getWidth() / 2 - 20 and x >= largeurEcran - (GUI.imgButtonCalqueOeilOuvert2:getWidth() + (GUI.imgButtonCalqueOeilOuvert2:getWidth() / 2)) and
       y >= hauteurEcran - grilleViewTilesHeight - 200 + GUI.imgButtonCalqueOeilOuvert2:getHeight() + GUI.imgButtonCalqueOeilOuvert3:getHeight() + GUI.imgButtonCalqueOeilOuvert4:getHeight() + GUI.imgButtonCalqueOeilOuvert5:getHeight() + GUI.imgButtonCalqueOeilOuvert6:getHeight() + 55 and y <= hauteurEcran - grilleViewTilesHeight - 200 + GUI.imgButtonCalqueOeilOuvert:getHeight() + GUI.imgButtonCalqueOeilOuvert2:getHeight() + GUI.imgButtonCalqueOeilOuvert3:getHeight() + GUI.imgButtonCalqueOeilOuvert4:getHeight() + GUI.imgButtonCalqueOeilOuvert5:getHeight() + GUI.imgButtonCalqueOeilOuvert6:getHeight() + 65 then    
        
        if CalquesActive.IDCalque2 == "ON" then
            CalquesActive.IDCalque2 = "OFF"
        else
            CalquesActive.IDCalque2 = "ON"
        end
    end

    -- Click sur l'image de l'oeil de la GUI pour afficher / enlever l'affichage l'ID des Objects
    if x <= largeurEcran - GUI.imgButtonCalqueOeilOuvert:getWidth() / 2 + GUI.imgButtonCalqueOeilOuvert2:getWidth() / 2 - 50 and x >= largeurEcran - (GUI.imgButtonCalqueOeilOuvert2:getWidth() + (GUI.imgButtonCalqueOeilOuvert2:getWidth() / 2)) - 30 and
       y >= hauteurEcran - grilleViewTilesHeight - 200 + GUI.imgButtonCalqueOeilOuvert2:getHeight() + GUI.imgButtonCalqueOeilOuvert3:getHeight() + GUI.imgButtonCalqueOeilOuvert4:getHeight() + GUI.imgButtonCalqueOeilOuvert5:getHeight() + GUI.imgButtonCalqueOeilOuvert6:getHeight() + GUI.imgButtonCalqueOeilOuvert6:getHeight() + 65 and y <= hauteurEcran - grilleViewTilesHeight - 200 + GUI.imgButtonCalqueOeilOuvert:getHeight() + GUI.imgButtonCalqueOeilOuvert2:getHeight() + GUI.imgButtonCalqueOeilOuvert3:getHeight() + GUI.imgButtonCalqueOeilOuvert4:getHeight() + GUI.imgButtonCalqueOeilOuvert5:getHeight() + GUI.imgButtonCalqueOeilOuvert6:getHeight() + GUI.imgButtonCalqueOeilOuvert6:getHeight() + 65 then    
        
        if CalquesActive.IDObjects == "ON" then
            CalquesActive.IDObjects = "OFF"
        else
            CalquesActive.IDObjects = "ON"
        end
    end
end




--[[   
██     ██ ██   ██ ███████ ███████ ██          ███    ███  ██████  ██    ██ ███████ ██████  
██     ██ ██   ██ ██      ██      ██          ████  ████ ██    ██ ██    ██ ██      ██   ██ 
██  █  ██ ███████ █████   █████   ██          ██ ████ ██ ██    ██ ██    ██ █████   ██   ██ 
██ ███ ██ ██   ██ ██      ██      ██          ██  ██  ██ ██    ██  ██  ██  ██      ██   ██ 
 ███ ███  ██   ██ ███████ ███████ ███████     ██      ██  ██████    ████   ███████ ██████                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
]]

function sceneEditorMaps.wheelmoved(x, y)
    -- Zoom avant sur un point ou Zoom arrière sur un point sauf si on ce trouve sur la View Tile
    if not (y == 0) and inGrilleMapViewTiles == false and inGrilleMapViewFiles == false then
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

    -- Scrolling en Y de la View des Files
    elseif y > 0 and inGrilleMapViewFiles == true and MAP_NIVEAU ~= "?" then -- Molette de la souris avec le haut
        if scrollY_counter2 < scrollY_counterMax2 then
            table.insert(files, tableTempoFileScroll[#tableTempoFileScroll])
            table.remove(tableTempoFileScroll, #tableTempoFileScroll)
            table.insert(files, tableTempo)

            scrollY_counter2 = scrollY_counter2 + 1
        end
    elseif y < 0 and MAP_NIVEAU ~= "?" then -- Molette de la souris avec le bas        
        if scrollY_counter2 < scrollY_counterMax2 then

            tableTempoFileScroll = files[1]
            table.remove(files, 1) 
            table.insert(files, tableTempo)

            scrollY_counter2 = scrollY_counter2 + 1
        end
    end
end


return sceneEditorMaps