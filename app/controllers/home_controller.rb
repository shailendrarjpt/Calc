class HomeController < ApplicationController
  def index
    
  end
    
  def newquote
      respond_to do |format|
        format.js
      end
  end
    
  def agservice
      respond_to do |format|
        format.js
      end
  end
    
  def idmadminservice
      respond_to do |format|
        format.js
      end
  end
    
  def mserviceag
        respond_to do |format|
            format.js
        end
  end  

  def mserviceida
        respond_to do |format|
            format.js
        end
  end  

end
