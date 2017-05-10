class QuoteTotals 
    include ActiveModel::Model
    
    attr_accessor :tpm, :tba, :tarch, :tcon
    
    def initialize
        @tpm = 0
        @tba = 0
        @tarch = 0
        @tcon = 0
    end
    
    
    def tpm
        @tpm
    end
    
    def tba
        @tba
    end
    
    def tarch
        @tarch
    end
    
    def tcon
        @tcon
    end

end