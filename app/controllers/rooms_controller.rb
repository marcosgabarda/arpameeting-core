class RoomsController < ApplicationController
    
    before_filter :check_signed_in, :only => [:index, :create, :new, :update, :edit, :destroy]
    before_filter :check_owner, :only => [:update, :edit, :destroy]
    
=begin
    
=end
    def check_owner
        room = Room.find(params[:id])
        if room.user != current_user
            flash[:notice] = 'You are not the owner of this room.'
            redirect_to rooms_path
        end
    end
    
    def start (room)
        user = room.user
        paid_needed = false
        room.participants.each do |participant| 
            paid_needed = (paid_needed or participant.needs_paid?)
        end
        if paid_needed and user.credit <= 0.0
            flash[:error] = 'You don\'t have enough money to start a room with phones.'
        else
            flash[:success] = "Starting room #{room.id}..."
            room.start
        end
    end
    
    def index
        if !signed_in?
            redirect_to '/signin'
        else
            @rooms = current_user.rooms
            respond_to do |format|
                format.html
                format.xml {render :xml => @rooms}
            end
        end
    end
    
    def show
        @room = Room.find(params[:id_room])
        @room.phonebrowser_service.update_status
        @participant = Participant.find(params[:id_participant])
    end

    def create
        @room = Room.create(:user => current_user)
        
        # Creation from web form.
        if params[:room][:participant_attributes]
            @room.phonebrowser_service = PhonebrowserService.create(:room => @room)
            @room.video_service = VideoService.create(:room => @room)
            params[:room][:participant_attributes].each do |part|
                p = Participant.new
                if part[:phonebrowser_service] == '1'
                    p.phonebrowser_service_id = Service.find_by_name('phonebrowser').id
                end
                if part[:video_service_id] == '1'
                    p.video_service_id = Service.find_by_name('video').id
                end
                p.name = part[:name]
                p.phone = part[:phone]
                p.sip = part[:sip]
                p.browser = part[:browser]
                p.save
                @room.participants << p
            end
            @room.save
            redirect_to rooms_path
            
        # Creation from RESTful request
        elsif params[:room][:participant]
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
            @room.video_service = VideoService.create(:room => @room)
            @room.save
            if params[:room][:start_now] and !params[:room][:start_now].nil? and params[:room][:start_now] == "1"
                start @room
            end
            # @ltest.to_xml(:include => :sub_tests) 
            respond_to do |format|
                format.html {redirect_to rooms_path}
                format.xml { render :xml => @room.to_xml(:include => [:phonebrowser_service, :participants]) } #.to_xml(:include => :phonebrowser_service)
                format.json {render :json => @room.to_json(:include => [:phonebrowser_service, :participants]) }
            end
        end
    end
    
    def new
        @services = Service.all
        @room = Room.new
        @room.participants << Participant.new
    end
    
    def edit
        @room = Room.find(params[:id])
    end
    
    def update
        @room = Room.find(params[:id])
        if params[:room][:participant_attributes]
            params[:room][:participant_attributes].each do |part|
                @room.participants.find(part[0].to_i).update_attributes(part[1])
            end
        else
            if params[:room][:start_now] == "1"
                start(@room) if !@room.nil?
            end
        end
        respond_to do |format|
            format.html {redirect_to rooms_path}
            format.xml { render :xml => @room.to_xml(:include => [:phonebrowser_service, :participants]) } #.to_xml(:include => :phonebrowser_service)
            format.json {render :json => @room.to_json(:include => [:phonebrowser_service, :participants]) }
        end
    end
    
    def destroy
        @room = Room.find(params[:id])
        @room.destroy
        redirect_to rooms_path
    end
end
