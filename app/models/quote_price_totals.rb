class QuotePriceTotals
    include ActiveModel::Model
    
    attr_accessor :hours, :rate, :dollars
    
    def initialize
        @hours = 0
        @rate = 0
        @dollars = 0
    end
    
    def hours
        @hours
    end
    
    def rate
        @rate
    end
    
    def dollars
        @dollars
    end
    
end