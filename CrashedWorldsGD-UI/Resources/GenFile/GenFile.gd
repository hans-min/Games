extends Resource
class_name GenFile
# ------------------------------------------------------------------------------ PUBLIC PROPERTIES
@export_group("Mesh Librairy")
@export var meshlib : MeshLibrary = null # blocs

@export_group("WaterParameters")
@export var isWater : bool = true # is there water on this world
@export var waterShader : ShaderMaterial = null
@export var waterHeight : float = 0.75
@export var isWaterBorder : bool = true
@export var waterBorderBloc : int = 0

@export_group("Noise")
@export var noiseMap : NoiseTexture2D = null
@export var layers : Array[int]

@export_group("Spawnables")
@export var spawnableAI : Array[Spawnable]
@export var spawnableOBJ : Array[Spawnable]

@export_group("Environment")
@export var environment : Environment = null

# ------------------------------------------------------------------------------ PRIVATE PROPERTIES

# ------------------------------------------------------------------------------ BASIC METHODS

func _init(
	mlib : MeshLibrary = null,
	water : bool = true,
	shader : ShaderMaterial = null,
	water_height : float = 0.75,
	water_border : bool = true,
	water_border_bloc : int = 0,
	noise_map : NoiseTexture2D = null,
	layer_array : Array[int] = [],
	spawnable_ai : Array[Spawnable] = [],
	spawnable_obj : Array[Spawnable] = [],
	enviro : Environment = null):
		
		meshlib = mlib
		isWater = water
		waterShader = shader
		waterHeight = water_height
		isWaterBorder = water_border
		waterBorderBloc = water_border_bloc
		noiseMap = noise_map
		layers = layer_array
		spawnableAI = spawnable_ai
		spawnable_obj = spawnable_obj
		environment = enviro


# ------------------------------------------------------------------------------ CUSTOM METHODS

# ------------------------------------------------------------------------------ SIGNALS


