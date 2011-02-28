class ParticipantsController < ApplicationController
    def create
        @room = Room.find(params[:room_id])
        @participant = @room.participants.create(params[:participant])
    end
end
