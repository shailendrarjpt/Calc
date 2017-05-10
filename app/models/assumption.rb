class Assumption
    include ActiveModel::Model
    
    def assumption
        @assumption
    end
    
    def initialize(assumption)
        @assumption = assumption
    end
    
end