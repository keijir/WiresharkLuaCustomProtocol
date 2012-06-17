Luaの有効化
 init.luaを編集
  disable_lua = false
  run_user_scripts_when_superuser = true

作成したLuaスクリプトの読み込み
 init.lua最後へ追記
  dofile("filename")
  
スクリプトの説明
 TDSDissector.lua
  TDSプロトコルを表示する用
  tds.type==1 (0x01) : TDS Query Packetの中身表示のみに対応