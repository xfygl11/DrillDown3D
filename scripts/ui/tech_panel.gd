# 科技面板 - 研究界面
extends CanvasLayer

class_name TechPanel

@onready var tech_list: VBoxContainer = $Panel/VBox/TechList
@onready var selected_info: RichTextLabel = $Panel/VBox/SelectedInfo
@onready var research_btn: Button = $Panel/VBox/ResearchBtn

var selected_tech: String = ""

func _ready() -> void:
	_setup_tech_list()
	research_btn.pressed.connect(_on_research_pressed)

func _setup_tech_list() -> void:
	for tech_id in TechnologyTree.technologies:
		var tech = TechnologyTree.technologies[tech_id]
		var btn = Button.new()
		btn.text = "%s %s" % [
			"🔓" if tech["unlocked"] else "🔒",
			tech["name"]
		]
		btn.pressed.connect(_on_tech_selected.bind(tech_id))
		tech_list.add_child(btn)

func _on_tech_selected(tech_id: String) -> void:
	selected_tech = tech_id
	var tech = TechnologyTree.technologies[tech_id]
	selected_info.text = """
<b>%s</b>

%s

<b>成本:</b>
%s
	""" % [
		tech["name"],
		tech["description"],
		_format_cost(tech["cost"])
	]
	research_btn.disabled = not TechnologyTree.can_research(tech_id)

func _format_cost(cost: Dictionary) -> String:
	var text = ""
	for resource in cost:
		text += "%s: %d\n" % [resource, cost[resource]]
	return text

func _on_research_pressed() -> void:
	if TechnologyTree.can_research(selected_tech):
		TechnologyTree.start_research(selected_tech)
		AudioManager.play_success()

func show_panel() -> void:
	visible = true

func hide_panel() -> void:
	visible = false
