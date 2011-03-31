class ApiV1::RoomsController < ApiV1::APIController
    
    before_filter :check_api_signed_in, :only => [:index, :show, :create, :new, :update, :edit, :destroy]
    before_filter :check_owner, :only => [:show, :update, :edit, :destroy]

    def check_owner
        room = Room.find(params[:id])
        if room.user != current_user
            api_error '401', {:message => 'You must be the owner of the room to perform this action.'}
        end
    end
    
    def index
        if !signed_in?
            # TODO Show API permission error
        else
            @rooms = current_user.rooms
            api_respond @rooms
        end
    end
    
    def show
        @room = Room.find(params[:id])
        @room.phonebrowser_service.update_status
        api_respond @room, {:include => [:phonebrowser_service, :participants]}
        #@participant = Participant.find(params[:id_participant])
    end


    def create
        @room = Room.create(:user => current_user)
    
        participants_array = []
        if params[:room][:participant].class == Array
            participants_array = params[:room][:participant]
        else
            participants_array << params[:room][:participant]
        end
        participants_array.each do |part|
            p = Participant.new
            p.name = part[:name]
            p.phone = part[:phone]
            p.sip = part[:sip]
            p.browser = part[:browser]
            p.save
            @room.participants << p
        end
        @room.phonebrowser_service = PhonebrowserService.create(:room => @room)
        @room.save
        if params[:room][:start_now] and !params[:room][:start_now].nil? and params[:room][:start_now] == "1"
            @room.start
        end
        api_respond @room, {:include => [:phonebrowser_service, :participants]}
    end
    
    def update
        @room = Room.find(params[:id])
        if params[:room][:participant_attributes]
            params[:room][:participant_attributes].each do |part|
                @room.participants.find(part[0].to_i).update_attributes(part[1])
            end
        else
            if params[:room][:start_now] == "1"
                @room.start if !@room.nil?
            end
        end
        api_respond @room, {:include => [:phonebrowser_service, :participants]}
    end
    
    #def destroy
    #    @room = Room.find(params[:id])
    #    @room.destroy
    #    redirect_to rooms_path
    #end
end