class MsTotals 
    include ActiveModel::Model
    
    attr_accessor :tcv, :pmv, :ppi, :infcost, :includeimp
    
    def initialize
        @tcv = 0
        @pmv = 0
        @ppi = 0
        @infcost = 0
        @includeimp = "Implementation Not Included"
    end
    
    
    def tcv
        @tcv
    end
    
    def pmv
        @pmv
    end
    
    def ppi
        @ppi
    end
    
    def infcost
        @infcost
    end
    
    def includeimp
        @includeimp
    end

end