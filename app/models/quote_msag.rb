class QuoteMSAG
    
    include ActiveModel::Model
    
    def generate_pricing(basic, ag, ms, impcost)
        mstotals = MsTotals.new
        
        # "msobj"=>{"msterms"=>"36", "mscampaigns"=>"4", "nfrastructure"=>"cloud"}}
        
        block = MSPricingInputs::INCREMENTAL_IDENTITY_BLOCK.to_f
        appblock = MSPricingInputs::INCREMENTAL_IDENTITY_BLOCK.to_f
        identities_for_pricing = roundup(basic.numidentities.to_f, block).to_i
        apps_for_pricing = roundup((ag.complexconn.to_i + ag.modconn.to_i + ag.stdconn.to_i).to_f, 10.0)
        
        puts "ifp #{identities_for_pricing}"
        puts "afp #{apps_for_pricing}"
        
        non_campaign_mths_count = (ms.msterms.to_i - (ms.msterms.to_i / 12) * ms.mscampaigns.to_i)
        total_cost_non_campaign_mths = MSPricingInputs::COST_OF_NON_CAMPAIGN_MONTH * non_campaign_mths_count
        
        number_campaign_months = (ms.msterms.to_i / 12) * ms.mscampaigns.to_i
        cost_campaign_mths = MSPricingInputs::COST_OF_CAMPAIGN_MONTH
        cost_incremental_id = (identities_for_pricing - MSPricingInputs::MINIMUM_IDENTITIES) / MSPricingInputs::INCREMENTAL_IDENTITY_BLOCK * MSPricingInputs::ADDL_ID_BLOCK_COST_CAMPAIGN_MONTH
        cost_incremental_apps = (apps_for_pricing - MSPricingInputs::MINIMUM_APPLICATIONS) / MSPricingInputs::INCREMENTAL_APPLICATIONS_BLOCK * MSPricingInputs::ADDL_APPL_BLOCK_COST_CAMPAIGN_MONTH
        total_cost_campaign_mth = cost_campaign_mths + cost_incremental_id + cost_incremental_apps
        total_cost_campaign_mths = total_cost_campaign_mth * number_campaign_months
        
        #puts "CCM #{cost_campaign_mths} #{cost_incremental_id} #{cost_incremental_apps}"
        puts "tcnc #{total_cost_non_campaign_mths}"
        puts "tccm #{total_cost_campaign_mth}"
        puts "tccms #{total_cost_campaign_mths}"
        
        base_services_cost = total_cost_non_campaign_mths + total_cost_campaign_mths
        puts "bsc #{base_services_cost}"
        
        case ms.msterms.to_i
            when 0..35
                term_mulitplier = 1
            when 36..47
                term_multiplier = 1 - MSPricingInputs::MODISCOUNT36
            when 48..59
                term_multiplier = 1 - MSPricingInputs::MODISCOUNT48
            when 60..1000
                term_multiplier = 1 - MSPricingInputs::MODISCOUNT60
        end
        puts "tmult #{term_multiplier}"
        
        case basic.authsource.to_i
            when 1
                id_multiplier = MSPricingInputs::AGSOURCE1
            when 2
                id_multiplier = MSPricingInputs::AGSOURCE1
            when 3
                id_multiplier = MSPricingInputs::AGSOURCE1
        end
        puts "IDmult #{id_multiplier}"
        
        case ms.support
            when "eightbyfive"
                cov_multiplier = MSPricingInputs::AGCOV8X5
            when "eightbyseven"
                cov_multiplier = MSPricingInputs::AGCOV8X7
            when "twentyfourbyfive"
                cov_multiplier = MSPricingInputs::AGCOV24X5
            when "twentyfourbyseven"
                cov_multiplier = MSPricingInputs::AGCOV24X7
        end
        puts "covm #{cov_multiplier}"
        puts "basicd #{basic.discount}"
        
        discount_multiplier = 1 - (basic.discount.to_f / 100)
        
        total_multiplier_discount = discount_multiplier * cov_multiplier * id_multiplier * term_multiplier
        
        puts "tmult #{total_multiplier_discount}"
        
        total_service_cost = total_multiplier_discount * base_services_cost
        puts "tsc #{total_service_cost}"
        
        if ms.msinfrastructure == "cloud"
            cloud_cost = MSPricingInputs::AGONETIME + (MSPricingInputs::AGINFRAMONTH * ms.msterms.to_i) + (MSPricingInputs::IICLICENSING * ms.msterms.to_i / 12)
            cloud_cost = cloud_cost * (1.0 + MSPricingInputs::INFRAMARGIN)
        else
            cloud_cost = 0
        end
        puts "ccost #{cloud_cost}"
        
        swcost = ms.swcost.to_i * (1.0 + MSPricingInputs::SOFTMARGIN)
        puts "swcost #{swcost}"
        
        swmcost = ms.msterms.to_i / 12 * ms.swmcost.to_i * (1.0 + MSPricingInputs::SOFTMARGIN)
        puts "swmcost #{swmcost}"
        total_software_cost = swcost + swmcost
        # swmcost = ms.msterms.to_i / 12 *
        
        total_soft_infra_cost = total_software_cost + cloud_cost + total_service_cost
        puts "tsic #{total_soft_infra_cost}"
        
        if ms.msimplement == "no"
            impcost = 0
        else
            mstotals.includeimp = "Implementation Included"
        end
        
        case ms.svclvl
            when "silver"
                total_contract_value = ((impcost + total_soft_infra_cost) * MSPricingInputs::SL_MULTIPLIER_AG_SILVER) + MSPricingInputs::SL_ADDL_DOLLARS_AG_SILVER
                puts "slm #{MSPricingInputs::SL_MULTIPLIER_AG_SILVER}"
            when "gold"
                total_contract_value = ((impcost + total_soft_infra_cost) * MSPricingInputs::SL_MULTIPLIER_AG_GOLD) + MSPricingInputs::SL_ADDL_DOLLARS_AG_GOLD
                puts "slm #{MSPricingInputs::SL_MULTIPLIER_AG_GOLD}"
            when "platinum"
                total_contract_value = ((impcost + total_soft_infra_cost) * MSPricingInputs::SL_MULTIPLIER_AG_PLATINUM) + MSPricingInputs::SL_ADDL_DOLLARS_AG_PLATINUM
                puts "slm #{MSPricingInputs::SL_MULTIPLIER_AG_PLATINUM}"
        end         
        
        puts "tcv #{total_contract_value}"
        
        mstotals.tcv = total_contract_value
        mstotals.pmv = total_contract_value / ms.msterms.to_i
        mstotals.ppi = mstotals.pmv / basic.numidentities.to_i
        mstotals.infcost = cloud_cost
        
        mstotals
        
    end
    
    def roundup(number, block)
        puts "number ident: #{number}"
        nearest = (number/ block).ceil * block
        puts "nearest: #{nearest}"
        nearest
    end

    
end