class QueueController < ApplicationController
    
    def loadqueue
      respond_to do |format|
        format.js
      end
  end
end
