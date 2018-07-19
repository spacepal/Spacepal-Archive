module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_player_id
 
    def connect
      self.current_player_id = find_verified_player_id
    end
 
    private
      def find_verified_player_id
        if verified_player_id = Player[cookies.encrypted[:player_id]].id
          verified_player_id
        else
          reject_unauthorized_connection
        end
      end
  end
end
