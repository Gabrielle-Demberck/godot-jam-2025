extends CharacterBody2D

# Define a velocidade do jogador.
# @export permite que você mude esse valor no Inspetor.
@export var speed = 100.0
@export var walk_speed = 30.0
@onready var animated_sprite = $animation
# Força do pulo (para cima, por isso é negativo)
@export var jump_velocity = -200.0
# @export permite ajustar no Inspetor.
# Quão rápido o player chega na vel. máxima.
@export var acceleration = 1500.0
# Quão rápido o player para (fricção).
@export var friction = 1200.0
# Pega o valor da gravidade definido nas Configurações do Projeto
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var target_speed

func _physics_process(delta):
	
	if not is_on_floor():
			velocity.y += gravity * delta
			animated_sprite.play("jump"  if velocity.y < 0  else "falling")
		
	# "ui_accept" é a ação padrão para a tecla Espaço.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor(): 
		velocity.y = jump_velocity
	
	# Pega o input do jogador usando o Input Map que configuramos.
	# Isso cria um "vetor" (direção) normalizado.
	# Ex: Pressionar "direita" e "cima" ao mesmo tempo = (1, -1)
	var direction = Input.get_axis("move_left", "move_right")

	# Define a velocidade baseada na direção.
	# velocity.x = direction * speed
	# A 'velocidade alvo' é a velocidade máxima na direção que queremos ir.
	if Input.is_action_pressed("shift"):
		target_speed = walk_speed 
	else:
		target_speed = speed
	
 	
	
	if direction != 0 :
	
		#... use 'move_toward' para acelerar
		# 'move_toward' move o valor atual (velocity.x) em direção
		# ao alvo (target_speed), sem ultrapassar o 'delta' (acceleration * delta).
		velocity.x = move_toward(velocity.x, direction * target_speed, acceleration * delta)
		if  is_on_floor():
			animated_sprite.play("walk") 
		animated_sprite.flip_h = direction < 0
	else:
		if  is_on_floor():
			animated_sprite.play("idle") 
		 
	#... se não houver comando, use a fricção para parar.
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)

		
	# move_and_slide() é a função mágica do Godot.
	# Ela move o CharacterBody2D e faz ele parar e deslizar
	# automaticamente ao colidir com outros corpos (como paredes).
	# move_and_slide() aplica a 'velocity' (com gravidade e input)
	# ao personagem e cuida de todas as colisões.
	move_and_slide()
