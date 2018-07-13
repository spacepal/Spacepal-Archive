module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_player
 
    def connect
      self.current_player = find_verified_player
    end
 
    private
      def find_verified_player
        if verified_player = Player[cookies.encrypted[:player_id]]
          verified_player
        else
          reject_unauthorized_connection
        end
      end
  end
end
