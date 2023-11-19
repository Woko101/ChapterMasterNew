/* 
    This function generates a X by Y grid for a planet with all the tile information .
        In here 2 basic structures are created: the hexGrid and the tile_info
        Hex grid is just to have the basic hex map
        All the information regarding the tile and if it has buildings or any other feature is in the tile_info. 
            The names are pretty self explenatory in regards to what each does
*/
/* 
    TODO list:
        1. Terrain type be stored as an enums (see if this improves efficiency)
        2. Create a cunstructor for the tile generation
        3. Continue with the definition of the data structure
        4. Do properly the cached distances as a ds_map
        5. Finish changing all values to use ds_map
 */
function scr_planet_map(planet_type,grid_width, grid_height){

    var hexGrid = ds_grid_create(grid_width, grid_height);
    var tile_info = ds_map_create();
    var settlement_count = 0;
    // TODO do properly the cached distances as a ds_map
    var cachedDistancesLand = ds_grid_create(grid_width, grid_height);
    var cachedDistancesAir = ds_grid_create(grid_width, grid_height);

    for (var x = 0; x < grid_width; x++) {
        for (var y = 0; y < grid_height; y++) {
            // Calculate the position of each hexagon
            var hex_size = 32; // Size of each hexagon
            var hex_width = hex_size * sqrt(3); // Width of a hexagon
            var hex_height = hex_size * 2; // Height of a hexagon
            var xpos = x * (hex_width * 0.75);
            var ypos = y * (hex_height + (hex_height / 2)) - (x % 2) * (hex_height / 2);

            var monastery_exists = false;

            // Store the hexagon's position and planet type in the hex grid
            ds_grid_set(hexGrid, x, y, [xpos, ypos, planet_type]);
            // TODO continue with the definition of the data structure
            // Initialize tile_info data structure 
            tile_info[? "movement_cost_land"] = 1;
            tile_info[? "movement_cost_sea"] = 1;
            tile_info[? "movement_cost_air"] = 0.25;
            tile_info[? "movement_by_land"] = true;
            tile_info[? "movement_by_sea"] = false;
            tile_info[? "movement_by_air"] = true;
            tile_info[? "roads"] = false;
            tile_info[? "settlement"] = false;
            tile_info[? "fort"] = false;
            tile_info[? "infrastructure_level"] = 0;
            tile_info[? "buildings"] = ds_list_create();
            tile_info[? "barracks"] = false;
            tile_info[? "astartes_monastery"] = false;
            tile_info[? "terrain_type"] = "grass";
            tile_info[? "height"] = 1;
            tile_info[? "habitable"] = true;
            tile_info[? "radioactive"] = false;
            tile_info[? "ocean"] = false;
            // Associate x and y coordinates
            tile_info[? "x"] = x;
            tile_info[? "y"] = y;
            // Customize the hex grid based on planet type
            switch (planet_type) {
                var terrain = random(100);
                var infrastructure = 0;
                case "Lava":
                    // Defaults to magma
                    tile_info[? "terrain_type"] = "magma";
                    tile_info[? "movement_by_land"] = false;
                    tile_info[? "habitable"] = false;
                    tile_info[? "movement_cost_air"] = 0.5;
                    // Add settlements
                    if(terrain < 15){
                        infrastructure = choose(1,1,1,1,1,2,2,3);
                        tile_info[? "settlement"] = true;
                        tile_info[? "terrain_type"] = "rock";
                        tile_info[? "movement_cost_land"] = 2.5;
                        tile_info[? "infrastructure_level"] = infrastructure;
                        settlement_count++;
                    }
                    // Adds rocks
                    else if (terrain < 30){
                        tile_info[? "terrain_type"] = "rock";
                        tile_info[? "movement_cost_land"] = 2;
                    }
                    break;
                case "Desert":
                    // Defaults to sand while on a desert planet
                    tile_info[? "terrain_type"] = "sand";
                    // Add oasis
                    if (terrain < 5) {
                        tile_info[? "terrain_type"] = "oasis";
                        tile_info[? "height"] = 0;
                    }
                    // Add settlements
                    else if (terrain < 20) {
                        infrastructure = choose(1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3);
                        tile_info[? "settlement"] = true;
                        tile_info[? "movement_cost_land"] = 1.5;
                        tile_info[? "infrastructure_level"] = infrastructure;
                        settlement_count++;
                    }
                    // Add sand dunes
                    else if (terrain < 50) {
                        tile_info[? "terrain_type"] = "sand_dunes";
                        tile_info[? "movement_cost_land"] = 1.2;
                        tile_info[? "height"] = 2;
                    }
                    break;
                case "Hive":
                    // Default is wastelands
                    tile_info[? "terrain_type"] = "waste_land";
                    // Add hive city
                    if (terrain < 10) {
                        infrastructure = choose(3, 3, 3, 4, 4, 5);
                        tile_info[? "terrain_type"] = "hive_city";
                        tile_info[? "settlement"] = true;
                        tile_info[? "movement_cost_land"] = 1.5;
                        tile_info[? "infrastructure_level"] = infrastructure;
                        settlement_count++;
                    }
                    // Add small fort
                    else if (terrain < 20) {
                        infrastructure = choose(1, 1, 1, 1, 1, 2, 2, 2);
                        tile_info[? "fort"] = true;
                        tile_info[? "movement_cost_land"] = 1.5;
                        tile_info[? "infrastructure_level"] = infrastructure;
                    }
                    // Add mountains
                    else if (terrain < 30) {
                        tile_info[? "terrain_type"] = "mountain";
                        tile_info[? "movement_cost_land"] = 1.8;
                        tile_info[? "movement_cost_air"] = 0.75;
                        tile_info[? "height"] = 3;
                    }
                    // Add hills
                    else if (terrain < 50) {
                        tile_info[? "terrain_type"] = "hills";
                        tile_info[? "movement_cost_land"] = 1.3;
                        tile_info[? "movement_cost_air"] = 0.5;
                        tile_info[? "height"] = 2;
                    }
                    // Add forests
                    else if (terrain < 56) {
                        tile_info[? "terrain_type"] = "forest";
                        tile_info[? "movement_cost_land"] = 1.25;
                    }
                    // Adds oceans
                    else if (terrain < 65) {
                        tile_info[? "terrain_type"] = "ocean";
                        tile_info[? "movement_by_land"] = false;
                        tile_info[? "movement_by_sea"] = true;
                        tile_info[? "height"] = 0;
                    }
                    // Adds nuclear waste
                    else if (terrain < 70) {
                        tile_info[? "terrain_type"] = "nuclear_waste";
                        tile_info[? "movement_cost_land"] = 5;
                        tile_info[? "radioactive"] = true;
                    }
                    break;
                case "Death":
                    // Defaults to tall grass
                    tile_info[? "terrain_type"] = "tall_grass";
                    // Add a settlement
                    if (terrain < 10) {
                        infrastructure = choose(1, 1, 1, 1, 1, 2, 2);
                        tile_info[? "settlement"] = true;
                        tile_info[? "movement_cost_land"] = 1.5;
                        tile_info[? "infrastructure_level"] = infrastructure;
                        settlement_count++;
                    }
                    // Add a mountain
                    else if (terrain < 25) {
                        tile_info[? "terrain_type"] = "mountain";
                        tile_info[? "movement_cost_land"] = 1.8;
                        tile_info[? "movement_cost_air"] = 0.75;
                        tile_info[? "height"] = 3;
                    }
                    // Add hills
                    else if (terrain < 35) {
                        tile_info[? "terrain_type"] = "hills";
                        tile_info[? "movement_cost_land"] = 1.3;
                        tile_info[? "movement_cost_air"] = 0.5;
                        tile_info[? "height"] = 2;
                    }
                    // Add a jungle
                    else if (terrain < 60) {
                        tile_info[? "terrain_type"] = "jungle";
                        tile_info[? "movement_cost_land"] = 1.5;
                    }
                    // Add an ocean
                    else if (terrain < 75) {
                        tile_info[? "terrain_type"] = "ocean";
                        tile_info[? "movement_by_land"] = false;
                        tile_info[? "movement_by_sea"] = true;
                        tile_info[? "height"] = 0;
                    }
                    break;
                case "Agri":
                    // Defaults to plains
                    tile_info[? "terrain_type"] = "plains";
                    // Add a settlement
                    if (terrain < 20) {
                        infrastructure = choose(1, 1, 1, 1, 1, 2, 2);
                        tile_info[? "settlement"] = true;
                        tile_info[? "movement_cost_land"] = 1.5;
                        tile_info[? "infrastructure_level"] = infrastructure;
                        settlement_count++;
                    }
                    // Add a field
                    else if (terrain < 50) {
                        tile_info[? "terrain_type"] = "field";
                    }
                    break;
                case "Temperate":
                    // Defaults to grass
                    // Add a settlement
                    if (terrain < 20) {
                        infrastructure = choose(1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3);
                        tile_info[? "settlement"] = true;
                        tile_info[? "movement_cost_land"] = 1.5;
                        tile_info[? "infrastructure_level"] = infrastructure;
                        settlement_count++;
                    }
                    // Add mountains
                    else if (terrain < 30) {
                        tile_info[? "terrain_type"] = "mountain";
                        tile_info[? "movement_cost_land"] = 1.8;
                        tile_info[? "movement_cost_air"] = 0.75;
                        tile_info[? "height"] = 3;
                    }
                    // Add hills
                    else if (terrain < 50) {
                        tile_info[? "terrain_type"] = "hills";
                        tile_info[? "movement_cost_land"] = 1.3;
                        tile_info[? "movement_cost_air"] = 0.5;
                        tile_info[? "height"] = 2;
                    }
                    // Add forests
                    else if (terrain < 53) {
                        tile_info[? "terrain_type"] = "forest";
                        tile_info[? "movement_cost_land"] = 1.25;
                    }
                    // Adds oceans
                    else if (terrain < 65) {
                        tile_info[? "terrain_type"] = "ocean";
                        tile_info[? "movement_by_land"] = false;
                        tile_info[? "movement_by_sea"] = true;
                        tile_info[? "height"] = 0;
                    }
                    break;
                case "Feudal":
                    // Add a settlement
                    if (terrain < 20){
                        infrastructure = choose(1,1,1,1,1,2,2,2);
                        tile_info[? "settlement"] = true;
                        tile_info[? "movement_cost_land"] = 1.5;
                        tile_info[? "infrastructure_level"] = infrastructure;
                        settlement_count++;
                    }
                    // Add mountains
                    else if (terrain < 30) {
                        tile_info[? "terrain_type"] = "mountain";
                        tile_info[? "movement_cost_land"] = 1.8;
                        tile_info[? "movement_cost_air"] = 0.75;
                        tile_info[? "height"] = 3;
                    }
                    // Add hills
                    else if (terrain < 50) {
                        tile_info[? "terrain_type"] = "hills";
                        tile_info[? "movement_cost_land"] = 1.3;
                        tile_info[? "movement_cost_air"] = 0.5;
                        tile_info[? "height"] = 2;
                    }
                    // Add forests
                    else if (terrain < 60) {
                        tile_info[? "terrain_type"] = "forest";
                        tile_info[? "movement_cost_land"] = 1.25;
                    }
                    // Add a field
                    else if (terrain < 70){
                        tile_info[? "terrain_type"] = "field";
                    }
                    // Adds oceans
                    else if (terrain < 80){
                        tile_info[? "terrain_type"] = "ocean";
                        tile_info[? "movement_by_land"] = false;
                        tile_info[? "movement_by_sea"] = true;
                        tile_info[? "height"] = 0;
                    }
                    break;
                case "Shrine":
                    // The sororitas temple and such will be handled on the buildings features 
                    //(which nelson already re wrote so just add them features with the checks)
                    // Defaults to plains
                    tile_info[? "terrain_type"] = "plains";
                    // Adds settlement
                    if (terrain < 10){
                        infrastructure = choose(1,1,1,1,1,2,2,2,3,3);
                        tile_info[? "settlement"] = true;
                        tile_info[? "movement_cost_land"] = 1.5;
                        tile_info[? "infrastructure_level"] = infrastructure;
                        settlement_count++;
                    }
                    // Adds a forest
                    else if (terrain < 20) {
                        tile_info[? "terrain_type"] = "forest";
                        tile_info[? "movement_cost_land"] = 1.25;
                    }
                    // Adds a cementery
                    else if (terrain < 60){
                        tile_info[? "terrain_type"] = "cemetery";
                    }
                    // Adds an ocean
                    else if (terrain < 70){
                        tile_info[? "terrain_type"] = "ocean";
                        tile_info[? "movement_by_land"] = false;
                        tile_info[? "movement_by_sea"] = true;
                        tile_info[? "height"] = 0;
                    }
                    break;
                case "Ice":
                    // Defaults to snow
                    tile_info[? "terrain_type"] = "snow";
                    tile_info[? "movement_cost_land"] = 1.2;
                    // Add a settlement
                    if (terrain < 10){
                        infrastructure = choose(1,1,1,1,1,2,2);
                        tile_info[? "settlement"] = true;
                        tile_info[? "movement_cost_land"] = 1.5;
                        tile_info[? "infrastructure_level"] = infrastructure;
                        settlement_count++;
                    }
                    // Add frozen lake
                    else if (terrain < 20){
                        tile_info[? "terrain_type"] = "frozen_lake";
                        tile_info[? "movement_cost_land"] = 1.5;
                        tile_info[? "height"] = 0;
                    }
                    // Add forests
                    else if (terrain < 40) {
                        tile_info[? "terrain_type"] = "forest";
                        tile_info[? "movement_cost_land"] = 1.4;
                    }
                    // Add snowy hills
                    else if (terrain < 60) {
                        tile_info[? "terrain_type"] = "hills";
                        tile_info[? "movement_cost_land"] = 1.3;
                        tile_info[? "movement_cost_air"] = 0.5;
                        tile_info[? "height"] = 2;
                    }
                    // Add snowy mountains
                    else if (terrain < 70){
                        tile_info[? "terrain_type"] = "snow_mountains";
                        tile_info[? "movement_cost_land"] = 1.8;
                        tile_info[? "movement_cost_air"] = 0.75;
                        tile_info[? "height"] = 3;
                    }
                    break;
                case "Dead":
                    // Defaults to asteroid rocks
                    tile_info[? "terrain_type"] = "asteroid_rocks";
                    tile_info[? "habitable"] = false;
                    // Adds a destroyed city in some areas
                    if (terrain < 10){
                        tile_info[? "terrain_type"] = "destroyed_city";
                        tile_info[? "movement_cost_land"] = 1.5;
                    }
                    // Adds radiation to certain tiles
                    else if (terrain < 15){
                        tile_info[? "terrain_type"] = "nuclear_crater";
                        tile_info[? "movement_cost_land"] = 5;
                        tile_info[? "radioactive"] = true;
                    }
                    break;
            }
        }
    }

    // After generating the entire map, connect the ocean tiles
    connect_ocean_tiles(grid_width, grid_height);

    for (var startX = 0; startX < grid_width; startX++) {
        for (var startY = 0; startY < grid_height; startY++) {
            var settlement = ds_map_find_value(tile_info, "settlement");
            var infrastructure_level = ds_map_find_value(tile_info, "infrastructure_level");
            if (settlement) {
                var infrastructure_max = infrastructure_level + 1;
                if (infrastructure_max > 5) infrastructure_max = 5;
                find_nearest_settlement(startX, startY, infrastructure_level, infrastructure_max);
            }
        }
    }

    // Calculates and caches land and air distances after modifications to the tiles
    for (var x = 0; x < grid_width; x++) {
        for (var y = 0; y < grid_height; y++) {
            // Check if the hex allows ground and air movement
            if (tile_info[? "movement_by_land", x, y]) {
                for (var targetX = 0; targetX < grid_width; targetX++) {
                    for (var targetY = 0; targetY < grid_height; targetY++) {
                        // Only calculate distances if the target hex also allows movement
                        if (tile_info[? "movement_by_land", targetX, targetY]) {
                            cachedDistancesLand[#distances, x, y, targetX, targetY] = calculate_distance(x, y, targetX, targetY, "land");
                        }
                    }
                }
            }
            if (tile_info[? "movement_by_air", x, y]) {
                for (var targetX = 0; targetX < grid_width; targetX++) {
                    for (var targetY = 0; targetY < grid_height; targetY++) {
                        // Only calculate distances if the target hex also allows movement
                        if (tile_info[? "movement_by_air", targetX, targetY]) {
                            cachedDistancesAir[#distances, x, y, targetX, targetY] = calculate_distance(x, y, targetX, targetY, "air");
                        }
                    }
                }
            }
        }
    }
    // Return the hex grid, tile_info data structure AND settlement count for the planet
    return [hexGrid, tile_info, settlement_count];
}

// Recursive flood-fill function to connect ocean tiles
function flood_fill(x, y, tilesToConvert) {
    if (tilesToConvert > 6) tilesToConvert = 6;
    if (x < 0 || x >= grid_width || y < 0 || y >= grid_height) {
        return;
    }
    
    if (tile_info[? "terrain_type"] == "ocean" && !tile_info[? "ocean"]) {
        // Check if any of the neighboring tiles are part of a settlement
        var hasSettlementNeighbor = false;
        for (var dir = 0; dir < 6; dir++) {
            var neighborX = x + hex_neighbor_x(dir, y % 2);
            var neighborY = y + hex_neighbor_y(dir, y % 2);
            
            if (neighborX >= 0 && neighborX < grid_width && neighborY >= 0 && neighborY < grid_height) {
                if (tile_info[#settlement, neighborX, neighborY]) {
                    hasSettlementNeighbor = true;
                    break;
                }
            }
        }
        
        // If there are no neighboring settlements, mark the tile as part of the ocean
        if (!hasSettlementNeighbor) {
            tile_info[? "ocean"] = true;
            tile_info[? "movement_by_land"] = false;
            tile_info[? "movement_by_sea"] = true;
            tile_info[? "height"] = 0;

            // Recursively call flood_fill on neighboring ocean tiles
            var convertedTiles = 0;
            for (var dir = 0; dir < 6; dir++) {
                var neighborX = x + hex_neighbor_x(dir, x % 2);
                var neighborY = y + hex_neighbor_y(dir, y % 2);
                
                if (neighborX >= 0 && neighborX < grid_width && neighborY >= 0 && neighborY < grid_height) {
                    if (convertedTiles < tilesToConvert) {
                        flood_fill(neighborX, neighborY, tilesToConvert);
                        convertedTiles ++ ;
                    }
                }
            }
        }
    }
}

// Find and connect ocean tiles
function connect_ocean_tiles(grid_width, grid_height){
    for (var x = 0; x < grid_width; x++) {
        for (var y = 0; y < grid_height; y++) {
            if (tile_info[? "terrain_type"] == "ocean" && !tile_info[? "ocean"]) {
                // If this tile is ocean and not part of the connected ocean, start a flood-fill
                var tilesToConvert = choose(1,1,2,2,2,3,3);
                flood_fill(x, y, tilesToConvert);
            }
        }
    }
}

// Find the nearest settlement with infrastructure level difference of 1 and connects it via roads
function find_nearest_settlement(x, y, targetInfrastructureLevel, targetInfrastructureLevelMax) {
    var openList = ds_priority_create();
    var closedList = ds_grid_create(grid_width, grid_height);
    var path = ds_list_create();
    var nearestSettlement = null;
    var nearestDistance = -1;
    
    // Initialize open list with the current tile
    var currentG = 0;
    var h = 0;
    var f = currentG + h;
    ds_priority_add(openList, currentG, x, y);
    
    while (!ds_priority_empty(openList)) {
        // Get the tile with the lowest F score
        var currentG = ds_priority_delete_min(openList);
        var currentX = ds_priority_find_value(openList, currentG);
        var currentY = ds_priority_find_priority(openList, currentG);
        closedList[currentX, currentY] = 1;
        
        // Add settlement to the list
        var currentInfrastructureLevel = tile_info[#infrastructure_level, currentX, currentY];
         if ((currentInfrastructureLevel == targetInfrastructureLevel || currentInfrastructureLevel == targetInfrastructureLevel + 1) &&
            currentInfrastructureLevel <= targetInfrastructureLevelMax) {
            ds_list_add(path, [currentX, currentY]);

            // Calculate the distance to this settlement
            var settlementDistance = distance(x, y, currentX, currentY);

            // Check if it's closer than the previous nearest settlement
            if (nearestSettlement == null || settlementDistance < nearestDistance) {
                nearestSettlement = {
                    x: currentX,
                    y: currentY,
                };
                nearestDistance = settlementDistance;
            }
            break;
        }
        
        // Explore neighboring tiles
        for (var dir = 0; dir < 6; dir++) {
            var neighborX = currentX + hex_neighbor_x(dir, currentY % 2);
            var neighborY = currentY + hex_neighbor_y(dir, currentY % 2);
            
            if (neighborX >= 0 && neighborX < grid_width && neighborY >= 0 && neighborY < grid_height) {
                if (closedList[neighborX, neighborY] == 0 && tile_info[#movement_by_land, neighborX, neighborY]) {
                    // Calculate G score and H score for the neighbor
                    var neighborG = currentG + tile_info[#movement_cost_land, neighborX, neighborY];
                    var neighborH = distance(neighborX, neighborY, targetX, targetY);
                    var neighborF = neighborG + neighborH;
                    
                    if (!ds_priority_exists(openList, neighborG)) {
                        ds_priority_add(openList, neighborF, neighborX, neighborY);
                        ds_list_add(path, [neighborX, neighborY]);
                    } else if (neighborG < ds_priority_find_priority(openList, neighborF)) {
                        // Update neighbor's G score and F score
                        ds_priority_change_priority(openList, neighborF, neighborX, neighborY);
                    }
                }
            }
        }
    }

    // After the while loop, connect the path to the nearest settlement
    if (nearestSettlement != null) {
        for (var i=0; i < (ds_list_size(path) - 1); i++) {
            var currentTile = ds_list_find_value(path, i);
            var nextTile = ds_list_find_value(path, i + 1);
            connect_tiles_with_roads(currentTile[0], currentTile[1], nextTile[0], nextTile[1]);
            tile_info[#movement_cost_land, currentTile[0], currentTile[1]] = 0.9;
        }
    }
    
    ds_priority_destroy(openList);
    ds_grid_destroy(closedList);
}

// Connect two tiles with roads
function connect_tiles_with_roads(x1, y1, x2, y2) {
    var currentX = x1;
    var currentY = y1;
    while (currentX != x2 || currentY != y2) {
        // Implement code to connect the two tiles with roads here.
        tile_info[#roads, currentX, currentY] = true;
    }
}

// Function to precompute distances from (0,0) to all other tiles
function precompute_distances(grid_width, grid_height, movement_type) {
    for (var x = 0; x < grid_width; x++) {
        for (var y = 0; y < grid_height; y++) {
            // Check if the hex allows the specified movement type
            if (movement_type == "land" && tile_info[#movement_by_land, x, y]) {
                // Calculate distance from (0,0) to (x, y) and store it
                cachedDistancesLand[#distances, 0, 0, x, y] = calculate_distance(0, 0, x, y, movement_type);
            }
            if (movement_type == "air" && tile_info[#movement_by_air, x, y]) {
                // Calculate distance from (0,0) to (x, y) and store it
                cachedDistancesAir[#distances, 0, 0, x, y] = calculate_distance(0, 0, x, y, movement_type);
            }
        }
    }
}

// Calculates distance
function calculate_distance(x, y, targetX, targetY, movement_type) {
    var movement_costs = ds_list_create();
    var current_x = x;
    var current_y = y;

    if (movement_type == "land") {
        movement_cost = tile_info[#movement_cost_land, x, y];
    } else if (movement_type == "air") {
        movement_cost = tile_info[#movement_cost_air, x, y];
    }

    // Calculate the distance based on movement cost
    var dx = abs(targetX - x);
    var dy = abs(targetY - y);
    var dz = abs(-(x + y) + (targetX + targetY));


}

// Calculate the x-coordinate of a neighboring hex tile
function hex_neighbor_x(direction, yOffset) {
    var xOffsets = [1, 1, 0, -1, 0, 1];
    return x + xOffsets[direction];
}

// Calculate the y-coordinate of a neighboring hex tile
function hex_neighbor_y(direction, yOffset) {
    var yOffsets = [-1, 0, 1, 0, -1, -1];
    return y + yOffsets[direction];
}
