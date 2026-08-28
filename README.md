# DrillDown 3D - Godot 版本

基于原 DrillDown 游戏的 Godot 4.x Android 移植版。

## 项目结构

```
DrillDown3D_Godot/
├── project.godot           # 项目配置
├── scripts/
│   ├── core/
│   │   ├── game_manager.gd  # 游戏状态管理
│   │   └── scene_manager.gd # 场景管理
│   ├── game/
│   │   ├── world_grid.gd    # 三维世界网格
│   │   └── terrain_generator.gd # 地形生成
│   ├── building/
│   │   ├── building.gd      # 建筑基类
│   │   ├── furnace.gd       # 熔炉
│   │   ├── assembler.gd     # 组装机
│   │   └── storage.gd       # 存储
│   ├── logistics/
│   │   └── conveyor.gd      # 传送带
│   ├── power/
│   │   └── power_network.gd # 电力系统
│   ├── fluid/
│   │   └── fluid_grid.gd    # 流体系统
│   ├── ui/
│   │   └── game_hud.gd      # 游戏界面
│   ├── utils/
│   │   └── object_pool.gd   # 对象池
│   └── main.gd             # 游戏主入口
├── scenes/
│   └── main.tscn           # 主场景
└── resources/              # 资源文件夹
```

## 系统特性

### 已实现系统

1. **核心系统**
   - 游戏状态管理（主菜单、游戏中、暂停、游戏结束）
   - 场景加载与切换
   - 游戏存档/读档

2. **地图系统**
   - 三维瓦片网格
   - 地形生成算法

3. **建筑系统**
   - 建筑基类
   - 熔炉（冶炼矿石）
   - 存储系统

4. **物流系统**
   - 传送带系统

5. **电力系统**
   - 电力网络
   - 电源管理
   - 电力分配

6. **流体系统**
   - 流体网格
   - 流体流动模拟

7. **UI系统**
   - 资源显示
   - 电力状态
   - 游戏时间

## 运行方式

### 方法 1: 使用 Godot Editor

1. 安装 Godot 4.2+
2. 打开项目文件夹
3. 点击 "运行" 按钮

### 方法 2: 命令行运行

```bash
godot --path . --headless --remote-debug
```

## 导出 Android APK

1. Project → Export → Add Export Preset
2. 选择 Android
3. 配置：
   - Architecture: ARM64
   - Scripting Backend: GDScript
   - Architecture: arm64-v8a
4. 点击 "Export Android App Bundle"

## Python 到 GDScript 转换参考

所有 Python 代码已转换为 GDScript，逻辑保持一致。

## 文件统计

- GDScript 文件: 10+
- 代码行数: ~500+
- 系统模块: 9个

## 后续开发

1. 添加 3D 渲染
2. 导入美术资源
3. 实现触摸控制
4. 添加音效
5. 导出 APK

## 相关链接

- Godot 引擎: https://godotengine.org/
- Godot 文档: https://docs.godotengine.org/
- 官方 Discord: https://discord.gg/godotengine

---
*创建于: 2025-08-28*
*Godot 版本: 4.2+*
