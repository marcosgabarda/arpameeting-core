class PhonebrowserApi
    include HTTParty
    format :xml
    
    def initialize(host, port)
        self.class.base_uri "#{host}:#{port}/phonebrowser/rest"
    end
    
    def new_room(participants, callbacks=[])
        xml_doc  = Nokogiri::XML("<room></room>")
        room_node = xml_doc.at_css'room'
        participants.each do |participant|
            participant_node = Nokogiri::XML::Node.new "participant", xml_doc
            participant_node.parent = room_node
            name_node = Nokogiri::XML::Node.new "name", xml_doc
            name_node.parent = participant_node
            if participant[:name]
                name_node.content = participant[:name]
            else
                name_node.content = "anonymous"
            end
            if participant[:phone]
                contact_node = Nokogiri::XML::Node.new "phone", xml_doc
                contact_node.parent = participant_node
                contact_node.content = participant[:phone]
                type_node = Nokogiri::XML::Node.new "type", xml_doc
                type_node.parent = participant_node
                type_node.content = "phone"
            elsif participant[:sip]
                contact_node = Nokogiri::XML::Node.new "sip", xml_doc
                contact_node.parent = participant_node
                contact_node.content = participant[:sip]
                type_node = Nokogiri::XML::Node.new "type", xml_doc
                type_node.parent = participant_node
                type_node.content = "sip"
            elsif participant[:browser]
                type_node = Nokogiri::XML::Node.new "type", xml_doc
                type_node.parent = participant_node
                type_node.content = "browser"
            end
        end
        callbacks.each do |callback|
            callback_node = Nokogiri::XML::Node.new "callback", xml_doc
            callback_node.parent = room_node
            callback_node.content = callback
        end
        
        xml = xml_doc.to_s
        resp = self.class.post('/room', {:headers => {"Content-type"=>"application/xml", "Content-Length"=>"#{xml.length}"}, :body => xml})
    end
    
    def get_room(id)
        resp = self.class.get("/room/#{id}")
    end
    
    def add_to_room(id, participants)
        xml_doc  = Nokogiri::XML("<room></room>")
        room_node = xml_doc.at_css'room'
        participants.each do |participant|
            participant_node = Nokogiri::XML::Node.new "participant", xml_doc
            participant_node.parent = room_node
            name_node = Nokogiri::XML::Node.new "name", xml_doc
            name_node.parent = participant_node
            if participant[:name]
                name_node.content = participant[:name]
            else
                name_node.content = "anonymous"
            end
            if participant[:phone]
                contact_node = Nokogiri::XML::Node.new "phone", xml_doc
                contact_node.parent = participant_node
                contact_node.content = participant[:phone]
                type_node = Nokogiri::XML::Node.new "type", xml_doc
                type_node.parent = participant_node
                type_node.content = "phone"
            elsif participant[:sip]
                contact_node = Nokogiri::XML::Node.new "sip", xml_doc
                contact_node.parent = participant_node
                contact_node.content = participant[:sip]
                type_node = Nokogiri::XML::Node.new "type", xml_doc
                type_node.parent = participant_node
                type_node.content = "sip"
            elsif participant[:browser]
                type_node = Nokogiri::XML::Node.new "type", xml_doc
                type_node.parent = participant_node
                type_node.content = "browser"
            end
        end
        xml = xml_doc.to_s
        resp = self.class.put("/room/#{id}", {:headers => {"Content-type"=>"application/xml", "Content-Length"=>"#{xml.length}"}, :body => xml})
    end
    
end
