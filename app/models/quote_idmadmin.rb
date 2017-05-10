class QuoteIdmadmin 
    include ActiveModel::Model
     
     def initialize
        @quote_array = Array.new
        resettotals
     end
    
     
     def generate_quote(basic, idmadmin, qa, assump)
         @quote_array = qa
         @assumption_array = assump
         
         puts "idmadmin: #{idmadmin.inspect}"
         
        case idmadmin.rardesign
            when "none"
            when "low"
                addrow(true, section="Rules", activity="Rules Architecture & Design", pm=2, ba=0, arch=4, con=4)
            when "medium"
                addrow(true, section="Rules", activity="Rules Architecture & Design", pm=2, ba=0, arch=8, con=4)
            when "complex"
                addrow(true, section="Rules", activity="Rules Architecture & Design", pm=4, ba=0, arch=16, con=4)
        end
         
        # addassumption("JML hours will not exceed 24")
        
         #RULES 
        addrow(idmadmin.usarules.to_i > 0, section="Rules", activity="Out-of-Box Rule Creation", pm=1, ba=0, arch=0, con=1 * idmadmin.usarules.to_i)
        addrow(true, section="Rules", activity="JML Policy", pm=32, ba=32, arch=4, con=4)
        addrow(idmadmin.ruleemail.to_i > 0, section="Rules", activity="Workflows/Escalations/Emails", pm=2 * idmadmin.ruleemail.to_i, ba=0, arch=0, con=8 * idmadmin.ruleemail.to_i)
        addrow((idmadmin.addlcomplex.to_i + idmadmin.addlmod.to_i + idmadmin.addlsimple.to_i)>0, section="Rules", activity="Additional Custom Rules", pm=roundup(0.5 * (idmadmin.addlcomplex.to_i + idmadmin.addlmod.to_i + idmadmin.addlsimple.to_i),1), ba=0, arch=4* (idmadmin.addlcomplex.to_i + idmadmin.addlmod.to_i + idmadmin.addlsimple.to_i), con=4 * (idmadmin.addlcomplex.to_i + idmadmin.addlmod.to_i + idmadmin.addlsimple.to_i))
         
        addrow(true, section="Rules", activity="Solution Testing", pm=roundup(0.15 * @pmtotals,1), ba=roundup(@batotals, 1), arch=roundup(0.15 * @archtotals,1), con= roundup(0.15 * @contotals,1))
        addrow(true, section="Rules", activity="Runbook", pm=roundup(0.10 * @pmtotals,1), ba=0, arch=0, con=roundup(0.10 * @contotals,1))
        addrow(true, section="Rules", activity="Production Migration Support", pm=roundup(0.15 * @pmtotals,1), ba= 0, arch=0, con=roundup(0.15 * @contotals,1))
        addrow(true, section="Rules", activity="Handover/Transfer Support", pm=2, ba=0, arch=0, con=8)
        resettotals
 
        case idmadmin.fcomplex
            when "none"
            when "low"
                addrow(true, section="Fulfillment", activity="Architecture & Design", pm=6, ba=0, arch=24, con=8)
            when "medium"
                addrow(true, section="Fulfillment", activity="Architecture & Design", pm=10, ba=0, arch=40, con=8)
            when "complex"
                addrow(true, section="Fulfillment", activity="Architecture & Design", pm=13, ba=0, arch=56, con=8)
        end
        addrow(idmadmin.stdconn.to_i > 0, section="Fulfillment", activity="Standard Connector Configuration (#{idmadmin.stdconn} x OOB or delimited file)", pm=3*idmadmin.stdconn.to_i, ba=0, arch=0, con=8 * idmadmin.stdconn.to_i)
        addrow(idmadmin.modconn.to_i > 0, section="Fulfillment", activity="Moderately Complex Connector Configuration (#{idmadmin.modconn} x JDBC, MySQL, or ServiceNow)", pm=5*idmadmin.modconn.to_i, ba=0, arch=0, con=24 * idmadmin.modconn.to_i)
        addrow(idmadmin.complexconn.to_i > 0, section="Fulfillment", activity="Complex Connector Configuration (#{idmadmin.complexconn} x custom)", pm=9*idmadmin.complexconn.to_i, ba=0, arch=0, con=40 * idmadmin.complexconn.to_i)
        addrow(idmadmin.custticket.to_i > 0, section="Fulfillment", activity="Custom Ticketing Integrations", pm=34*idmadmin.custticket.to_i, ba=0, arch=0, con=160 * idmadmin.custticket.to_i)
         
        addrow(true, section="Fulfillment", activity="Solution Testing", pm=roundup(0.15 * @pmtotals,1), ba=roundup(@batotals, 1), arch=roundup(0.15 * @archtotals,1), con= roundup(0.15 * @contotals,1))
        addrow(true, section="Fulfillment", activity="Runbook", pm=roundup(0.10 * @pmtotals,1), ba=0, arch=0, con=roundup(0.10 * @contotals,1))
        addrow(true, section="Fulfillment", activity="Production Migration Support", pm=roundup(0.15 * @pmtotals,1), ba= 0, arch=0, con=roundup(0.15 * @contotals,1))
        addrow(true, section="Fulfillment", activity="Handover/Transfer Support", pm=2, ba=0, arch=0, con=8)
        resettotals
         
        addrow(idmadmin.pwmgt != "none", section="Other", activity="Password Management Architecture & Design", pm=2, ba=0, arch=0, con=8)
        addrow(idmadmin.async != "none", section="Other", activity="Attribute Synch Architecture & Design", pm=2, ba=0, arch=0, con=8)
        addrow(idmadmin.fgtpass.to_i > 0, section="Other", activity="Forgotten Password", pm=3 * idmadmin.fgtpass.to_i, ba=0, arch=0, con=16 * idmadmin.fgtpass.to_i)
        addrow(idmadmin.passpol.to_i > 0, section="Other", activity="Password Composition Policies", pm=2 * idmadmin.passpol.to_i, ba=0, arch=0, con=8 * idmadmin.passpol.to_i)
         
        addrow(idmadmin.pret == "on", section="Other", activity="Password Retrieval", pm=4, ba=0, arch=4, con=16)
        addrow(idmadmin.psync == "on", section="Other", activity="Password Synch", pm=5, ba=0, arch=8, con=16)
        addrow(idmadmin.wdesk == "on", section="Other", activity="Windows Desktop Reset", pm=6, ba=0, arch=16, con=16)
         
        addrow(idmadmin.targets.to_i > 0, section="Other", activity="Attribute Sync Targets", pm=1 * idmadmin.targets.to_i, ba=0, arch=2 * idmadmin.targets.to_i, con=4 * idmadmin.targets.to_i)
        addrow(idmadmin.astrans.to_i > 0, section="Other", activity="Attribute Sync Transforms", pm=1 * idmadmin.astrans.to_i, ba=0, arch=1 * idmadmin.astrans.to_i, con=2 * idmadmin.astrans.to_i)
         
        addrow(idmadmin.wdesk == "on", section="Other", activity="User Onboarding", pm=16, ba=0, arch=16, con=80)
         
        addrow((idmadmin.cswfpm.to_i + idmadmin.cswfba.to_i + idmadmin.cswfcon.to_i) > 0, section="Other", activity="Custom Work", pm=idmadmin.cswfpm.to_i, ba=idmadmin.cswfba.to_i, arch=idmadmin.cswfarch.to_i, con=idmadmin.cswfcon.to_i)
         
        addrow(true, section="Other", activity="Solution Testing", pm=roundup(0.15 * @pmtotals,1), ba=roundup(@batotals, 1), arch=roundup(0.15 * @archtotals,1), con= roundup(0.15 * @contotals,1))
        addrow(true, section="Other", activity="Runbook", pm=roundup(0.10 * @pmtotals,1), ba=0, arch=0, con=roundup(0.10 * @contotals,1))
        addrow(true, section="Other", activity="Production Migration Support", pm=roundup(0.15 * @pmtotals,1), ba= 0, arch=0, con=roundup(0.15 * @contotals,1))
        addrow(true, section="Other", activity="Handover/Transfer Support", pm=2, ba=0, arch=0, con=8)
        resettotals
                  
        return @quote_array, @assumption_array
    end
    
    private
    
    def addrow(test, section, activity, pm, ba, arch, con)
        if test 
            quoterow = QuoteRow.new()
            @pmtotals += pm
            @batotals += ba
            @archtotals += arch
            @contotals += con
            quoterow.pop_row(section, activity, pm, ba, arch, con, @quote_array)
        end
    end
    
    def addassumption(assumption)
        assume = Assumption.new(assumption)
        @assumption_array.push(assume)
    end
    
    def resettotals
        @pmtotals = 0
        @batotals = 0
        @archtotals = 0
        @contotals = 0
    end
    
    def roundup(number, block)
        nearest = (number/ block).ceil * block
        nearest
    end
        
            
end
        