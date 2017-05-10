class QuoteController < ApplicationController
    
    def hours
        @basic = Basic.new(basic_params)
        
        if params[:msagobj] != nil
            @ms = MSAG.new(msag_params)
        end
        if params[:agobj] != nil
            @ag = AG.new(ag_params)
        end
        if params[:idmobj] != nil
            @idm = IdmAdmin.new(idm_params)
        end
        if params[:msidaobj] != nil
            @msida = MSIDA.new(msida_params)
        end
        
        @impcost = 0
        @quote_array = Array.new
        @assumptions = Array.new
        @totals = QuoteTotals.new()
        @quote_pricing = Array.new
        @qpt = QuotePriceTotals.new()
        
        #logger.debug "all: #{params}"        
        #logger.debug "basic: #{@basic.attributes.inspect}"
        #logger.info(@ag.inspect)
        
        #until redesigned, agobj has to go first. Subsequent sections pass in in-progress arrays.
        if params[:agobj] != nil
            quoteag = QuoteAg.new()
            @quote_array, @assumptions = quoteag.generate_quote(@basic, @ag)    # Quote hours
        end
        
        if params[:idmobj] != nil
            quoteidm = QuoteIdmadmin.new
            @quote_array, @assumptions = quoteidm.generate_quote(@basic, @idm, @quote_array, @assumptions)
         end

        @totals = generate_totals(@quote_array)            
        @quote_pricing, @qpt = generate_pricing(@basic, @totals)    # Pricing
        @impcost = @qpt.dollars
       
       if params[:msagobj] != nil
            quotemsag = QuoteMSAG.new()
            @mspricingag = quotemsag.generate_pricing(@basic, @ag, @ms, @impcost)  
        end
        
       if params[:msidaobj] != nil
            quotemsida = QuoteMSIDA.new()
            @mspricingida = quotemsida.generate_pricing(@basic, @idm, @msida, @impcost)
        end
        
        respond_to do |format|
            format.js {render :content_type => 'text/javascript'}
        end
    end
    
        def generate_totals(quote_array)
        qt = QuoteTotals.new()
        quote_array.each do |qr|
            qt.tpm += qr.pm
            qt.tba += qr.ba
            qt.tarch += qr.arch
            qt.tcon += qr.con
        end
        qt
    end
    
    def generate_pricing(basic, qtotals)
        thours = 0
        arate = 0
        tdollars = 0
        uplift = basic.pricing == 'fixed' ? 1.1 : 1
        discount = basic.discount > 0 ? (100 - basic.discount.to_f) / 100 : 1
        
        pricing_array = Array.new
        pricer = QuotePrice.new()
        pricer.role = 'Project Manager'
        pricer.hours = qtotals.tpm
        pricer.rate = basic.pmrate * discount
        pricer.total = basic.pmrate * discount * qtotals.tpm * uplift
        pricing_array.push(pricer)
        thours += pricer.hours
        arate += pricer.rate
        tdollars += pricer.total
        
        pricer = QuotePrice.new()
        pricer.role = 'Architect'
        pricer.hours = qtotals.tarch
        pricer.rate = basic.pmrate * discount
        pricer.total = basic.pmrate * discount * qtotals.tba * uplift
        pricing_array.push(pricer)
        thours += pricer.hours
        arate += pricer.rate
        tdollars += pricer.total
        
        pricer = QuotePrice.new()
        pricer.role = 'Business Analyst'
        pricer.hours = qtotals.tba
        pricer.rate = basic.pmrate * discount  
        pricer.total = basic.pmrate * discount * qtotals.tba * uplift
        pricing_array.push(pricer)
        thours += pricer.hours
        arate += pricer.rate
        tdollars += pricer.total
        
        pricer = QuotePrice.new()
        pricer.role = 'Consultant'
        pricer.hours = qtotals.tcon
        pricer.rate = basic.offconrate * discount  
        pricer.total = basic.offconrate * discount * qtotals.tcon * uplift
        pricing_array.push(pricer)
        thours += pricer.hours
        arate += pricer.rate
        tdollars += pricer.total
        
        qpt = QuotePriceTotals.new
        qpt.hours += thours
        qpt.rate += thours > 0 ? (tdollars / thours) : 0

        pricer = QuotePrice.new()
        pricer.role = 'Expenses'
        pricer.hours = ""
        pricer.rate = "" 
        pricer.total = basic.expense * tdollars / 100
        pricing_array.push(pricer)
        tdollars += pricer.total
        
        qpt.dollars += tdollars
        return pricing_array, qpt
    end

    def createsow       
        puts 'in createsow'
        respond_to do |format|
            format.docx { render docx: @object, filename: 'my_file.docx', word_template:  'my_template.docx'}
        end
    end

    
    private
    
        def basic_params
            params.require(:basic).permit(:customer, :project, :pricing, :numidentities, :userpop, :expense, :fixedcon, :kickoff, :pmrate, :barate, :archrate, :onconrate, :offconrate, :authsource, :discount)
        end
    
        def ag_params
            params.require(:agobj).permit(:envs, :vendor, :complexconn, :modconn, :stdconn, :rwcomplexconn, :rwmodconn, :rwstdconn, :hwsize, :reqmts, :usecases, :arch, :design, :builddoc, :opguide, :schedule, :uat, :custrpt, :usermgrar, :appownar, :artype)
        end
    
        def msag_params
            params.require(:msagobj).permit(:msterms, :mscampaigns, :msinfrastructure, :support, :swcost, :swmcost, :svclvl, :msimplement)
        end

        def msida_params
            params.require(:msidaobj).permit(:intident, :extident, :msterms, :mscampaigns, :msinfrastructure, :msimplement, :svclvl, :swcost, :swmcost, :support)
        end
    
        def idm_params
            puts "params #{params[:idmobj].inspect}"
            params.require(:idmobj).permit(:rardesign, :ruleemail, :usarules, :jmlcomplex, :addlcomplex, :addlmod, :addlsimple, :fxomplex, :otbplatform, :otbappl, :otbticket, :custticket, :pwmgt, :async, :targets, :fgtpass, :pret, :psync, :wdesk, :astrans, :usonboard, :cswfpm, :cswfba, :cswfcon, :vendor, :fcomplex, :passpol, :pretr, :cswfarch, :stdconn, :modconn, :complexconn)
        end
end