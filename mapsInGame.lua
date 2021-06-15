local mapsInGame = {}

-- Charge les fichiers que j'ai besoins.
require("map")
require("mapObjects")
require("mapCollision")


-- Les données de la map InGame équivalent a l'éditeur de Map.
InGame = {}
InGame.TileSheets = {}
InGame.TileSheetsActive = {}
InGame.Tiles = {}
InGame.MapNiveauActive = 1


--
local MAP_WIDTH = TileMaps[InGame.MapNiveauActive].MAP_WIDTH
local MAP_HEIGHT = TileMaps[InGame.MapNiveauActive].MAP_HEIGHT
local TILE_WIDTH = TileMaps[InGame.MapNiveauActive].TILE_WIDTH
local TILE_HEIGHT = TileMaps[InGame.MapNiveauActive].TILE_HEIGHT



-- Dessine les Tiles qui a était ajouter dans le tableaux à deux dimensions des maps dans le fichier : map.lua
function drawTilesInTheGrilleMapInGame()
    local total_TILE_WIDTH = 0
    local total_TILE_HEIGHT = 0

    for l=1,MAP_HEIGHT do
        for c=1,MAP_WIDTH do
            local tileCurrent = TileMaps[InGame.MapNiveauActive][l][c]

            local currentTileSheet = 1
            for key, valeur in pairs(InGame.TileSheetsActive) do
                if TileMaps[InGame.MapNiveauActive][l][c] <= valeur then
                    currentTileSheet = key
                    
                    break
                end
            end 

            if tileCurrent ~= 0 then
                love.graphics.draw(InGame.TileSheets[currentTileSheet], InGame.Tiles[tileCurrent], total_TILE_WIDTH, total_TILE_HEIGHT)
            end

            total_TILE_WIDTH = total_TILE_WIDTH + TILE_WIDTH
        end

        total_TILE_WIDTH = 0
        total_TILE_HEIGHT = total_TILE_HEIGHT + TILE_HEIGHT
    end
end


-- Dessine les Objects qui a était ajouter dans le tableaux à deux dimensions des maps dans le fichier : mapObjects.lua
function drawObjectsInTheGrilleMapInGame()
    local total_TILE_WIDTH = 0
    local total_TILE_HEIGHT = 0

    for l=1,MAP_HEIGHT do
        for c=1,MAP_WIDTH do
            local tileCurrent = TileMapsObjects[InGame.MapNiveauActive][l][c]

            local currentTileSheet = 1
            for key, valeur in pairs(InGame.TileSheetsActive) do
                if TileMapsObjects[InGame.MapNiveauActive][l][c] <= valeur then
                    currentTileSheet = key
                    
                    break
                end
            end 

            if tileCurrent ~= 0 then
                love.graphics.draw(InGame.TileSheets[currentTileSheet], InGame.Tiles[tileCurrent], total_TILE_WIDTH, total_TILE_HEIGHT)
            end

            total_TILE_WIDTH = total_TILE_WIDTH + TILE_WIDTH
        end

        total_TILE_WIDTH = 0
        total_TILE_HEIGHT = total_TILE_HEIGHT + TILE_HEIGHT
    end
end


-- Charge les Tiles par rapport au TILE_WIDTH et TILE_HEIGHT de la map actuellement chargée.
function loadTilesInGame()
    -- Itere sur la table qui contient toute les TileSheets, puis découpe chaque images d'une TileSheet et les envoie dans la table : Game.Tiles (tableaux a deux dimensions)
    -- Decoupage une TileSheet en fonction des TILE_WIDTH et TILE_HEIGHT qui a était générer pour la map.
    local tablesTileSheetsDecouperAll = {}

    -- IMPORTANT -> C'est ici qu'il faut rajouter manuellement les SpriteSheets pour les TileSets ci-dessous a la suite des autres : 
    local tableTileSheetDecouper1 = decoupeSpriteSheet(0, 0, TILE_WIDTH, TILE_HEIGHT, 8, 14, 2, InGame.TileSheets[1]) 
    table.insert(tablesTileSheetsDecouperAll, tableTileSheetDecouper1)

    local tableTileSheetDecouper2 = decoupeSpriteSheet(0, 0, TILE_WIDTH, TILE_HEIGHT, 16, 6, 12, InGame.TileSheets[2])
    table.insert(tablesTileSheetsDecouperAll, tableTileSheetDecouper2)

    local currentTable = 1
    for key, imgTile in pairs(tablesTileSheetsDecouperAll) do
        for key, imgTile in pairs(tablesTileSheetsDecouperAll[currentTable]) do
            table.insert(InGame.Tiles, imgTile)
        end 

        table.insert(InGame.TileSheetsActive, #InGame.Tiles)

        local currentTable = currentTable + 1
        if currentTable > #InGame.TileSheets then
            break
        end
    end 

    print("\n")
    print("Nombre de Tiles IN GAME : " .. #InGame.Tiles)
    for key, valeur in pairs(InGame.TileSheetsActive) do
        print(key, valeur)
    end
end


-- Je charge une TileSheets et l'envoie dans la table : Game.TileSheets
function loadTileSheetsInGame(pNomDossierRessources, pNomFicherTileSheet)
    local tileSheet = love.graphics.newImage(pNomDossierRessources .. "/" .. pNomFicherTileSheet .. ".png")
    table.insert(InGame.TileSheets, tileSheet)
end










function mapsInGame.Load()
    -- Je charge toutes mes TileSheets (Une SpriteSheet qui contient des Tiles (Textures))
    -- loadTileSheets(nomDuDossier, nomFichierImgTileSheet)
    loadTileSheetsInGame('assets', 'tileSet')
    loadTileSheetsInGame('assets', 'tileSet2')


    --
    loadTilesInGame()
end

function mapsInGame.Update()

end

function mapsInGame.Draw()
    drawTilesInTheGrilleMapInGame()
    drawObjectsInTheGrilleMapInGame()
end

return mapsInGame