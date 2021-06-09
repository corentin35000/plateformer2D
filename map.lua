local map = {}

ORIENTATION_TILES = "Orthogonale"
TILE_OFFSETX = 0
TILE_OFFSETY = 0
TileMaps = {
                {
                    { 1, 0, 0 },
                    { 0, 0, 0 },
                    { 0, 0, 0 },

                    MAP_WIDTH = 3,
                    MAP_HEIGHT = 3,
                    TILE_WIDTH = 64,
                    TILE_HEIGHT = 64,
                },
          
                {
                    { 1, 0, 0, 0, 0 },
                    { 0, 0, 0, 0, 0 },
                    { 0, 0, 0, 0, 0 },
                    { 0, 0, 0, 0, 0 },
                    { 0, 0, 0, 0, 0 },

                    MAP_WIDTH = 5,
                    MAP_HEIGHT = 5,
                    TILE_WIDTH = 64,
                    TILE_HEIGHT = 64,
                },
         
                {
                    { 0, 0, 0, 0, 0, 0 },
                    { 0, 0, 0, 0, 0, 0 },
                    { 0, 0, 0, 0, 0, 0 },
                    { 0, 0, 0, 0, 0, 0 },
                    { 0, 0, 0, 0, 0, 0 },
                    { 0, 0, 0, 0, 0, 0 },

                    MAP_WIDTH = 6,
                    MAP_HEIGHT = 6,
                    TILE_WIDTH = 64,
                    TILE_HEIGHT = 64,
                },
           }

return map