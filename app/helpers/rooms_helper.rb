module RoomsHelper
    def add_participant_link(name)
        link_to_function name do |page|
            page.insert_html :bottom, :participants, :partial => 'participant', :object => Participant.new
        end
    end
end
