-Luaスクリプトの使い方
 Luaの有効化
  init.luaを編集
   disable_lua = false
   run_user_scripts_when_superuser = true
   
  init.luaの場所
  Mac OSX /Applications/Wireshark.app/Contents/Resources/share/wireshark/init.lua
  Windows C:\Program Files\Wireshark\init.lua

 作成したLuaスクリプトの読み込み
  init.lua最後へ追記
   dofile("filename")
  
-ファイルの説明
 TDSDissector.lua
  TDSプロトコル(TCP 1433)を表示する用
  tds.type==1 (0x01) : TDS Query Packetの中身表示のみに対応
  
  DisplayFilterに対応
   tdscustom.query 他
   
 capture.sh
  Wiresharkでパケットキャプチャ
   開始
  　 $ capture.sh
   終了
    Ctrl + C