class PhonebrowserService < ActiveRecord::Base
    belongs_to :room
    belongs_to :service
    has_many :participants, :through => :room

    before_save :default_service

    def default_service
        self.service = Service.find_by_name("phonebrowser")
    end

    def update_status
        #service =  Service.find_by_name(servi)
        pb = PhonebrowserApi.new(self.service.url, self.service.port.to_s)
        if !self.phonebrowser_number.nil? and !self.phonebrowser_number.empty?
            response = pb.get_room self.phonebrowser_number
            participants_response_array = get_participants_from_response response
            participants_response_array.each do |participant_response|
                p_tmp = Participant.find(participant_response["name"].to_i)
                p_tmp.pb_call_state = participant_response["call"]["state"]
                p_tmp.pb_call_finished = participant_response["call"]["finished"] if participant_response["call"]["finished"]
                p_tmp.pb_call_started = participant_response["call"]["started"] if participant_response["call"]["started"]
                if participant_response["type"].downcase == "phone"
                    
                elsif participant_response["type"].downcase == "sip"
                    
                elsif participant_response["type"].downcase == "browser"
                    
                end
                p_tmp.save
            end
        end
    end

=begin
    Starts the phone browser service.
=end
    def start
        pb = PhonebrowserApi.new('http://arpamet2.parcien.uv.es', '5080')
        participants_array = []
        participants.all.each do |participant|
            if participant.contact =~ /^\+[0-9]+/
                participants_array << { :name => participant.id.to_s, :phone => participant.contact}
            elsif participant.contact =~ /^.+@.+$/
                participants_array << { :name => participant.id.to_s, :sip => participant.contact}
            elsif participant.contact.downcase == 'browser'
                participants_array << { :name => participant.id.to_s, :browser => participant.contact}
            end
        end
        response = pb.new_room participants_array
        # Room data
        self.phonebrowser_number = response["room"]["number"]
        self.listener_uri = response["room"]["audio"]
        # Participant data
        participants_response_array = get_participants_from_response response
        participants_response_array.each do |participant_response|
            p_tmp = Participant.find(participant_response["name"].to_i)
            p_tmp.pb_call_state = participant_response["call"]["state"]
            p_tmp.pb_output_recording = participant_response["call"]["output"]
            p_tmp.pb_input_recording = participant_response["call"]["input"]
            if participant_response["type"] == "PHONE"
                # Special 
            elsif participant_response["type"] == "SIP"
                # Special
            elsif participant_response["type"] == "BROWSER"
                p_tmp.pb_input_output_flash = participant_response["url"]
            end
            p_tmp.save
        end
        save
        return response
    end
    
    private
    
    def get_participants_from_response(response)
        participants_response_array = []
        if response["room"]["participant"].class == Hash
            participants_response_array << response["room"]["participant"]
        else
            participants_response_array = response["room"]["participant"]
        end
        return participants_response_array
    end
    
end
