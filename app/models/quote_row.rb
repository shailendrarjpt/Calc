class QuoteRow
    include ActiveModel::Model
    
    def pop_row(sect, act, pm, ba, arch, con, ary)
        @section = sect
        @act = act
        @pm = pm
        @ba = ba
        @arch = arch
        @con = con
        ary.push(self)
    end
    
    def section
        @section
    end
    
    def act
        @act
    end
    
    def pm
        @pm
    end
    
    def ba
        @ba
    end
    
    def arch
        @arch
    end
    
    def con
        @con
    end

end