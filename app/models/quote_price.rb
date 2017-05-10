class QuotePrice
    include ActiveModel::Model
    
    attr_accessor :role, :hours, :rate, :total
    
    def initialize
        @role = 0
        @hours = 0
        @rate = 0
        @total = 0
    end
    
    
    def role
        @role
    end
    
    def hours
        @hours
    end
    
    def rate
        @rate
    end
    
    def total
        @total
    end

end