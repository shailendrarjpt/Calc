class QuoteAg 
    include ActiveModel::Model
    
    def initialize
        @quote_array = Array.new
        @assumption_array = Array.new
    end
    
    def generate_quote(basic, ag)
        # pop_row(heading, activity, pm, ba, arch, con, array)

        addrow(basic.kickoff == "yes", section="Initiation", activity="Project Kickoff", pm=16, ba=8, arch=8, con=8)
        
        # Base Product Install
        addrow(ag.envs.to_i > 0, section="Base Installation",activity=ag.envs + " " + ag.vendor + " Environments", pm=8, ba=0, arch=4, con=ag.envs.to_i * 8)
        addassumption("#{ag.envs.to_i} environments of #{ag.vendor} will be installed")
        
        addrow(true, section="Product Configuration", activity="UI Branding", pm=2, ba=4, arch=0, con=8)
        
        addrow(ag.hwsize == "on", section="Documentation", activity="Hardware Sizing", pm=2, ba=0, arch=8, con=0)

        total_acccess_reviews = ag.appownar.to_i + ag.usermgrar.to_i
        addrow(ag.reqmts == "on", section="Documentation", activity="Requirements", pm=2 * total_acccess_reviews, ba=40 * total_acccess_reviews, arch=16, con=0)

        addrow(ag.design == "on", section="Documentation", activity="Design", pm=2, ba=0, arch=40, con=16)
        
        addrow(ag.builddoc =="on", section="Documentation", activity="Build Guide", pm=2, ba=0, arch=4, con=16)

        addrow(ag.opguide == "on", section="Documentation", activity="Operations Guide", pm=2, ba=0, arch=4, con=16)

        addrow(ag.schedule == "on", section="Documentation", activity="Project Schedule", pm=24, ba=0, arch=4, con=0)
        
        
        addrow(ag.usermgrar.to_i > 0, section="Certifications", activity="User-Manager Access Reviews (#{ag.usermgrar})", pm=2 * ag.usermgrar.to_i, ba=0, arch = 8 * ag.usermgrar.to_i, con=8 * ag.usermgrar.to_i)
        
        addrow(ag.appownar.to_i > 0, section="Certifications", activity="App Owner Access Reviews (#{ag.appownar})", pm=4 * ag.usermgrar.to_i, ba=0, arch = 16 * ag.appownar.to_i, con=16 * ag.appownar.to_i)
        
        if total_acccess_reviews > 0 
            addassumption("Access Reviews will follow a one-step review process where the reviewer is provided from an authoritative source.")
        end
        
        addrow(ag.opguide == "on", section="Certifications", activity="Run one Certification", pm=4, ba=0, arch=20, con=40)
    
        addrow(ag.complexconn.to_i > 0, section="Data Loading", activity="R/O Complex Connector Configuration (#{ag.complexconn} x custom)", 
            pm=(2*ag.complexconn.to_i), ba=(8*ag.complexconn.to_i), arch=(4*ag.complexconn.to_i), con=(48*ag.complexconn.to_i))
        
        addrow(ag.modconn.to_i > 0, section="Data Loading", activity="R/O Moderately Complex Connector Configuration (#{ag.modconn} x JDBC, MySQL, AD, or ServiceNow)", 
            pm=(2*ag.modconn.to_i), ba=(2*ag.modconn.to_i), arch=(2*ag.modconn.to_i), con=(16*ag.modconn.to_i))
        
        addrow(ag.stdconn.to_i > 0, section="Data Loading", activity="R/O Standard Connector Configuration (#{ag.stdconn} x OOB or delimited file)", 
            pm=(2*ag.stdconn.to_i), ba=(2*ag.stdconn.to_i), arch=(2*ag.stdconn.to_i), con=(12*ag.stdconn.to_i))
        
        # addrow(true, section="Operations", activity="Monitoring Tool Integration", pm=2, ba=0, arch=4, con=16)
        
        addrow(true, section="Reporting", activity="Out Of The Box Reporting Configuration", pm=0, ba=0, arch=0, con=4)
        
        addrow(ag.custrpt.to_i > 0, section="Reporting", activity="Custom Reports (Up to #{ag.custrpt})", pm=0, ba=4 * ag.custrpt.to_i, arch=0, con= 8 * ag.custrpt.to_i)

        addrow(ag.uat.to_i > 0, section="Test Support", activity="UAT (#{ag.uat.to_i} weeks)", pm=(2*ag.uat.to_i), ba=(40*ag.uat.to_i), arch=0, con=(40*ag.uat.to_i))
        
        if ag.uat.to_i > 0
            addassumption("UAT support is spread accross #{ag.uat.to_i} continguous weeks.")
        end
        
        addrow(true, section="Production", activity="Production Deployment Support (2 weeks)", pm=8, ba=0, arch=20, con=80)
        
        addrow(true, section="Post-Production", activity="Support (2 weeks)", pm=8, ba=0, arch=20, con=80)
        
        return @quote_array, @assumption_array
    end
    
    private
    
    def addrow(test, section, activity, pm, ba, arch, con)
        if test 
            quoterow = QuoteRow.new()
            quoterow.pop_row(section, activity, pm, ba, arch, con, @quote_array)
        end
    end
    
    def addassumption(assumption)
        assume = Assumption.new(assumption)
        @assumption_array.push(assume)
    end
            
end