-- works as of Wireshark Version 1.6.8 (lua 5.1) on Testing MacOSX
-- author keijir
-- version 3
--  3 fix query packet
--  2 test add custom displayfilter
--  1 test add custom protocol
do
    --make Protocol
    custom_proto = Proto("tdscustom", "Tabular Data Stream Custom")
    
    --make Protocol fields
    custom_proto.fields.type   = ProtoField.uint8("tdscustom.type" , "TYPE")
    custom_proto.fields.status = ProtoField.uint8("tdscustom.status" , "STATUS")  
    custom_proto.fields.size   = ProtoField.uint16("tdscustom.size" , "SIZE")
    custom_proto.fields.channel= ProtoField.uint16("tdscustom.channel" , "CHANNEL")
    custom_proto.fields.packet = ProtoField.uint8("tdscustom.packet" , "PACKET")
    custom_proto.fields.window = ProtoField.uint8("tdscustom.window" , "WINDOW")
    custom_proto.fields.query  = ProtoField.string("tdscustom.query" , "QUERY")
    
    --make dissector
    custom_proto.dissector = function(buffer, pinfo, tree)
        local type_range = buffer(0,1)
        local ttype = type_range:uint()
        local type_names = { 
            [0x01] = "Query Packet (0x01)",
            [0x02] = "No Name (0x02)",
            [0x03] = "Remote Procedure Call Packet (0x03)",
            [0x04] = "Response Packet (0x04)", 
        }

        local status_range = buffer(1,1)
        local status = status_range:uint()
        
        local size_range = buffer(2,2)
        local size = size_range:uint()
        
        local channel_range = buffer(4,2)
        local channel = channel_range:uint()
        
        local packet_range = buffer(6,1)
        local packet = packet_range:uint()
        
        local window_range = buffer(7,1)
        local window = window_range:uint()
        
        local query_range = buffer(8,size-8)
      
        --make tree view
        --add(proto( displayfiltername,text) , PacketBytePane_range , value ,text,Åc )
        local subtree = tree:add(custom_proto,buffer(0,buffer:len())) --Tree name
        subtree:add(custom_proto.fields.type    , type_range    , ttype,"TYPE:",ttype,"=",type_names[ttype]):set_generated()
        subtree:add(custom_proto.fields.status  , status_range  , status):set_generated()
        subtree:add(custom_proto.fields.size    , size_range    , size):set_generated()
        subtree:add(custom_proto.fields.channel , channel_range , channel):set_generated()
        subtree:add(custom_proto.fields.packet  , packet_range  , packet):set_generated()
        subtree:add(custom_proto.fields.window  , window_range  , window):set_generated()
        --make subtree view
        if ttype == 0x01 then
          subsubtree = subtree:add(query_range,"TDS Query Packet")
          --query string
          local query_text = ""
          for i=1,size-8 do
            if i%2==1 then
              local n =buffer(8+i-1,1):uint()
              if 32<=n and n<=126 then
                query_text = query_text .. tostring(buffer(8+i-1,1):string())
              else
			    query_text = query_text .. "."
			  end
			  
            end
          end
          subsubtree:add(custom_proto.fields.query , query_range , query_text):set_generated()
          subsubtree:add(query_range,"Bytes: ",tostring(buffer(8,size-8):bytes()))

        else
          subsubtree = subtree:add("This Type Don't Make yet.")
        end
        
        --make list view
        pinfo.cols.protocol = "TDS Custom"  --Protocol name
        pinfo.cols.info = type_names[ttype]
    end
    
    --add wireshark Dissector Protocol
    tcp_table = DissectorTable.get("tcp.port")
    tcp_table:add(1433, custom_proto)
end