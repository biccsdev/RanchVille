# Lessons

## Do not start the next Linear issue on a merge note

When the user says a device test passed and a PR merged, only close that issue.
Do not pick the next BIC. Another chat may already own it.
Before any new issue work, check Linear status and the current git branch.

## Quest live reload is not Cursor-to-headset

Do not tell the user that `./run_quest_live.sh` starts the game on Quest.
That script only opens the Godot editor and sets `adb reverse`.

The headset updates only after:

1. Godot stays open.
2. Debug menu enables Remote Debug, Small Deploy, Sync Scripts, Sync Scenes.
3. The user clicks the remote deploy button once.
4. A script save happens in Godot (or Godot reloads a Cursor save).

A normal APK install does not watch the disk.

## XRController3D has no is_active()

Godot 4 XRNode3D uses `get_is_active()` and `get_has_tracking_data()`.
`is_active()` is not a method. A call throws every frame in `_process`.
Then the preview cube stays at play-space origin and looks far away.

While seeking a table, parent or place the cube on the right-hand pose.
Do not leave FarmRoot at world origin. Do not prefer the left controller.

## Table offset consts do not move an already-placed cube

Table "toward me" must stay in world XZ toward the camera.
Do not convert that offset through the table basis. Meta table local Z
can eat the toward component, so the cube only slides on local X.
Freeze `_placed_toward` when the table is found. Do not update it from
the camera each frame, or the cube follows the headset.

A `const` on the headset often stays at the packed APK value.
Use `@export var table_offset_right` and edit it in the Remote inspector.
`TABLE_OFFSET_RIGHT` is used in `place_on_table()`. That runs once.
A script reload does not call `_ready()` again. Re-apply the pose in `_process`
while mode is PLACED so a live-reload of those consts actually moves the cube.

After a hot reload, new vars like `_placed_anchor` start as null on the old
instance. Recover the table from `FarmRoot.get_parent()` or the cube never moves.

## Godot MCP needs the editor addon

`godot_mcp` must be installed and enabled. The editor must listen on port 6550.
A leftover `godot-mcp` Node process can hold the single client slot.
Restarting the editor drops the Quest remote-debug session.

## Do not replace FarmRoot Marker with a Grabbable instance

`TableAnchor._style_marker()` casts `Marker` to `MeshInstance3D`.
A packed `Grabbable` scene makes that cast null. Table restyle stops.
The cube then sits at the extra mesh offset and looks off the table.
Keep `Marker` as a `MeshInstance3D`. Put grab props beside it.

## HandInputXr must resolve hands from the scene tree

Godot can drop `@export` NodePaths on save.
If `left_hand` / `right_hand` stay null, pinch never fires.
Use `@onready` paths like `$"../XROrigin3D/RightHand"`.
Select grab targets by group `grabbable`, not `get_script()` identity.

## Godot 4.7 index tip joint is HAND_JOINT_INDEX_FINGER_TIP

`HAND_JOINT_INDEX_TIP` does not exist. Numeric `8` is an intermediate phalanx.
Use `XRHandTracker.HAND_JOINT_INDEX_FINGER_TIP` (10).
Convert joint origin through `XROrigin3D.to_global()`.

## Small Deploy crashes Quest 3

`--remote-fs localhost:6010` plus a stub APK can fail with:
`res://scenes/xr_empty.tscn:1 - Parse Error: Expected '['`.
Then Godot force-quits. Keep Small Deploy off. Use Remote Debug and Sync Scripts.
