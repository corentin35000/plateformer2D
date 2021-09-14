local reseau = {}


-- Librairies externes / Requires
local http = require("socket.http")
local ltn12 = require("ltn12")


-- Resultats qui contient la responses de la request HTTP de type GET qui contiendras la clé d'accès pour jouer, version du jeu en temps réel..
keyAccessOfficiel = {}
versionJeuOfficiel = {}

-- Requests HTTP - GET
local body, code, headers, status = http.request { 
    url = "http://crz-gamestudio.com/jeu/keyBeta.php", 
    method = "GET",
    sink = ltn12.sink.table(keyAccessOfficiel)
}

local body2, code2, headers2, status2 = http.request { 
    url = "http://crz-gamestudio.com/jeu/versionJeu.php", 
    method = "GET",
    sink = ltn12.sink.table(versionJeu)
}

-- Log status, code..etc :
--print('code:' .. tostring(code))
--print('status:' .. tostring(status))

-- Print result for Request
keyAccessOfficiel = table.concat(keyAccessOfficiel)
versionJeuOfficiel = table.concat(versionJeuOfficiel)

print(keyAccessOfficiel)
print(versionJeuOfficiel)


return reseau