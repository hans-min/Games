extends GridMap

@export var possibleGen : Array[GenFile]
@export var size: int = 256
var gfile : GenFile
var noise : NoiseTexture2D = null
var layers : Array[int] = []
@export var noiseSeed: int = -1

func _ready():
	size = GameOptions.worldSize
	generateMap()

func generateMap():
	assignGenData()
	setGridMapCells()

func assignGenData():
	var biome: Biome = GameOptions.biomeIndex as Biome
	var rng: int
	match biome:
		Biome.Random:
			rng = randi_range(0, possibleGen.size() - 1)
			print(rng)
		Biome.Forest:
			rng = 0
		Biome.Desert:
			rng = 1
	gfile = possibleGen[rng]
	ALTC.world_biome = gfile.resource_name
	# MESHLIB
	mesh_library = gfile.meshlib

	# WATER
	var waterplane : MeshInstance3D = get_parent().get_node("WaterPlane")
	waterplane.visible = gfile.isWater
	waterplane.set_surface_override_material(0,gfile.waterShader)
	waterplane.position.y = gfile.waterHeight

	# NOISE
	noise = gfile.noiseMap

	# LAYERS
	layers = gfile.layers

	# SPAWNER
	$Spawner.spawned_ai = gfile.spawnableAI
	$Spawner.spawned_objects = gfile.spawnableOBJ
	$Spawner.size = size

	# Environment
	get_parent().get_node("Skybox").environment = gfile.environment

#set the blocks for the grid map
func setGridMapCells():
	self.clear()
	var noiseMap = createNoiseMap()

	for x in range(size):
		for y in range(size):
			var noiseHeight = noiseMap[x][y]
			set_cell_item(Vector3i(x,0,y), layers[0]) # "bedrock"

			for layer in range(layers.size()):
				if noiseHeight >= layer * 1.25:
					set_cell_item(Vector3i(x,layer,y), layers[layer])

	if gfile.isWaterBorder : setOuterSand()

#create a noiseMap with range from (0-1)
func createNoiseMap():
	var noiseMap = []
	#self.set_meta("NoiseColorMap.seed", randi())
	var noisefile = noise.noise
	ALTC.world_seed = noisefile.seed
	noisefile.seed = randi() if noiseSeed == -1 else noiseSeed
	var maxNoiseHeight:float = -1
	var minNoiseHeight:float = 1

	for i in range(size):
		noiseMap.append([])
		for j in range(size):
			var noiseHeight: float = noisefile.get_noise_2d(i,j)
			if noiseHeight > maxNoiseHeight:
				maxNoiseHeight = noiseHeight
			elif noiseHeight < minNoiseHeight:
				minNoiseHeight = noiseHeight

			noiseMap[i].append(noiseHeight)

	for x in range(size):
		for y in range(size):
			noiseMap[x][y] = inverse_lerp(minNoiseHeight, maxNoiseHeight, noiseMap[x][y])*4

	return noiseMap

#turn the blocks next to the the sea into sand
func setOuterSand():
	var cells = self.get_used_cells()
	for cellCoord in cells:
		if cellCoord.y == 1:
			for i in range(cellCoord.x - 1, cellCoord.x + 2):
				for j in range(cellCoord.z - 1, cellCoord.z + 2):
					var neighborCell = Vector3i(i, cellCoord.y, j)
					if get_cell_item(neighborCell) == self.INVALID_CELL_ITEM:
						set_cell_item(cellCoord, gfile.waterBorderBloc)
						break

func get_heighest_cell(x: int, z: int) -> int:
	for y in range(3, -1, -1):
		if get_cell_item(Vector3i(x,y,z)) != INVALID_CELL_ITEM:
			return y
	return 3

# enum Block {
# 	Grass = 0,
# 	Dirt,
# 	Stone,
# 	StoneGrass,
# 	Sand,
# 	Berries
# }

enum Biome {
	Random = 0,
	Forest,
	Desert
}
