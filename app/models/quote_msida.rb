class QuoteMSIDA
    
    include ActiveModel::Model
    
    def generate_pricing(basic, idm, msida, impcost)
        mstotals = MsTotals.new
        
        # "msobj"=>{"msterms"=>"36", "mscampaigns"=>"4", "nfrastructure"=>"cloud"}}
        
        cost_of_internal_identities = cost_internal_identities(msida.intident.to_i, msida)
        
        cost_of_external_identities = cost_external_identities(msida.extident.to_i, msida)
        
        base_services_cost = cost_of_internal_identities + cost_of_external_identities
        puts "bsc #{base_services_cost}"
        
        case msida.msterms.to_i
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
        
        case msida.support
            when "eightbyfive"
                cov_multiplier = MSPricingInputs::IDACOV8X5
            when "eightbyseven"
                cov_multiplier = MSPricingInputs::IDACOV8X7
            when "twentyfourbyfive"
                cov_multiplier = MSPricingInputs::IDACOV24X5
            when "twentyfourbyseven"
                cov_multiplier = MSPricingInputs::IDACOV24X7
        end
        puts "covm #{cov_multiplier}"
        puts "basicd #{basic.discount}"
        
        discount_multiplier = 1 - (basic.discount.to_f / 100)
        
        total_multiplier_discount = discount_multiplier * cov_multiplier * id_multiplier * term_multiplier
        
        puts "tmult #{total_multiplier_discount}"
        
        total_service_cost = total_multiplier_discount * base_services_cost
        puts "tsc #{total_service_cost}"
        
        one_time_cloud_cost_internal_identities = onetime_internal_identities(msida.intident.to_i)
        
        one_time_cloud_cost_external_identities = onetime_external_identities(msida.extident.to_i)        
        
        running_cost_of_cloud_internal_identities = running_cost_internal_identities(msida)
        
        running_cost_of_cloud_external_identities = running_cost_external_identities(msida)
        
        puts "one_time_cloud_cost_internal_identities #{one_time_cloud_cost_internal_identities}"
        puts "one_time_cloud_cost_external_identities #{one_time_cloud_cost_external_identities}"
        puts "running_cost_of_cloud_internal_identities #{running_cost_of_cloud_internal_identities}"
        puts "running_cost_of_cloud_external_identities #{running_cost_of_cloud_external_identities}"
        
        iiclicensing = (MSPricingInputs::IICLICENSING * msida.msterms.to_i / 12)
        puts "iiclicensing #{iiclicensing}"

         if msida.msinfrastructure == "cloud"
            cloud_cost = one_time_cloud_cost_internal_identities + one_time_cloud_cost_external_identities + running_cost_of_cloud_internal_identities +running_cost_of_cloud_external_identities + iiclicensing
             
            cloud_cost = cloud_cost * (1.0 + MSPricingInputs::INFRAMARGIN)
        else
            cloud_cost = 0
        end
        
        puts "ccost #{cloud_cost}"
        
        swcost = msida.swcost.to_i * (1.0 + MSPricingInputs::SOFTMARGIN)
        puts "swcost #{swcost}"
        
        swmcost = msida.msterms.to_i / 12 * msida.swmcost.to_i * (1.0 + MSPricingInputs::SOFTMARGIN)
        puts "swmcost #{swmcost}"
        total_software_cost = swcost + swmcost
        
        total_soft_infra_cost = total_software_cost + cloud_cost + total_service_cost
        puts "tsic #{total_soft_infra_cost}"
        
        if msida.msimplement == "no"
            impcost = 0
        else
            mstotals.includeimp = "Implementation Included"
        end
        
        case msida.svclvl
            when "silver"
                total_contract_value = ((impcost + total_soft_infra_cost) * MSPricingInputs::SL_MULTIPLIER_IDA_SILVER) + MSPricingInputs::SL_ADDL_DOLLARS_IDA_SILVER
                puts "slm #{MSPricingInputs::SL_MULTIPLIER_IDA_SILVER}"
            when "gold"
                total_contract_value = ((impcost + total_soft_infra_cost) * MSPricingInputs::SL_MULTIPLIER_IDA_GOLD) +  MSPricingInputs::SL_ADDL_DOLLARS_IDA_GOLD
                puts "slm #{MSPricingInputs::SL_MULTIPLIER_IDA_GOLD}"
            when "platinum"
                total_contract_value = ((impcost + total_soft_infra_cost) * MSPricingInputs::SL_MULTIPLIER_IDA_PLATINUM) +  MSPricingInputs::SL_ADDL_DOLLARS_IDA_PLATINUM
                puts "slm #{MSPricingInputs::SL_MULTIPLIER_IDA_PLATINUM}"
        end         
        
        puts "impcost #{impcost}"
        puts "tcv #{total_contract_value}"
        mstotals.tcv = total_contract_value
        mstotals.pmv = total_contract_value / msida.msterms.to_i
        mstotals.ppi = mstotals.pmv / (msida.intident.to_i + msida.extident.to_i)
        puts "mstotals ppi #{mstotals.ppi}"
        mstotals.infcost = cloud_cost
        
        mstotals
        
    end
    
    def cost_internal_identities(ident, msida)
        case ident
            when 2500..5000
                cost_of_internal_identities = MSPricingInputs::IDA_COST_OF_INTERNAL_IDENTITIES_2500_5000 * msida.intident.to_f * msida.msterms.to_f
            when 5001..10000
                cost_of_internal_identities = MSPricingInputs::IDA_COST_OF_INTERNAL_IDENTITIES_5001_10000 * msida.intident.to_f * msida.msterms.to_f
            when 10001..20000
                cost_of_internal_identities = MSPricingInputs::IDA_COST_OF_INTERNAL_IDENTITIES_10001_20000 * msida.intident.to_f * msida.msterms.to_f
            when 20001..100000
                cost_of_internal_identities = MSPricingInputs::IDA_COST_OF_INTERNAL_IDENTITIES_20001_100000 * msida.intident.to_f * msida.msterms.to_f
            else
                # below 2500 (or above 100,000 but not realistic)
                cost_of_internal_identities = 0
        end
    end
    
    def cost_external_identities(ident, msida)
        
        case ident
            when 0..5000
                cost_of_external_identities = MSPricingInputs::IDA_COST_OF_EXTERNAL_IDENTITIES_0_5000 * msida.extident.to_f * msida.msterms.to_f
            when 5001..10000
                cost_of_external_identities = MSPricingInputs::IDA_COST_OF_EXTERNAL_IDENTITIES_5001_10000 * msida.extident.to_f * msida.msterms.to_f
            when 10001..20000
                cost_of_external_identities = MSPricingInputs::IDA_COST_OF_EXTERNAL_IDENTITIES_10001_20000 * msida.extident.to_f * msida.msterms.to_f
            when 20001..35000
                cost_of_external_identities = MSPricingInputs::IDA_COST_OF_EXTERNAL_IDENTITIES_20001_35000 * msida.extident.to_f * msida.msterms.to_f
            when 35001..50000
                cost_of_external_identities = MSPricingInputs::IDA_COST_OF_EXTERNAL_IDENTITIES_35001_50000 * msida.extident.to_f * msida.msterms.to_f
            when 50001..75000
                cost_of_external_identities = MSPricingInputs::IDA_COST_OF_EXTERNAL_IDENTITIES_50001_75000 * msida.extident.to_f * msida.msterms.to_f
            when 75001..100000
                cost_of_external_identities = MSPricingInputs::IDA_COST_OF_EXTERNAL_IDENTITIES_75001_100000 * msida.extident.to_f * msida.msterms.to_f
        end
    end
    
    def onetime_internal_identities(ident)
        case ident
            when 2500..5000
                one_time_cloud_cost_internal_identities = MSPricingInputs::IDA_INT_ONETIME_2500_5000
             when 500..10000
                one_time_cloud_cost_internal_identities = MSPricingInputs::IDA_INT_ONETIME_5001_10000
             when 10000..20000
                one_time_cloud_cost_internal_identities = MSPricingInputs::IDA_INT_ONETIME_10001_20000
             when 20001..100000
                one_time_cloud_cost_internal_identities = MSPricingInputs::IDA_INT_ONETIME_20001_100000
            else
                one_time_cloud_cost_internal_identities = 0
        end
        one_time_cloud_cost_internal_identities
    end
    
    def onetime_external_identities(ident)
        case ident
            when 0..5000
                one_time_cloud_cost_external_identities = MSPricingInputs::IDA_EXT_ONETIME_0_5000
             when 5001..10000
                one_time_cloud_cost_external_identities = MSPricingInputs::IDA_EXT_ONETIME_5001_10000
             when 10001..20000
                one_time_cloud_cost_external_identities = MSPricingInputs::IDA_EXT_ONETIME_10001_20000
             when 20001..35000
                one_time_cloud_cost_external_identities = MSPricingInputs::IDA_EXT_ONETIME_20001_35000 
             when 35001..50000
                one_time_cloud_cost_external_identities = MSPricingInputs::IDA_EXT_ONETIME_35001_50000
             when 50001..75000
                one_time_cloud_cost_external_identities = MSPricingInputs::IDA_EXT_ONETIME_50001_75000
             when 75001..100000
                one_time_cloud_cost_external_identities = MSPricingInputs::IDA_EXT_ONETIME_75001_100000
            else
                one_time_cloud_cost_external_identities = 0
        end
        one_time_cloud_cost_external_identities
    end
    
    def running_cost_internal_identities(msida)
        case msida.intident.to_i
            when 2500..5000
                running_cost_of_cloud_internal_identities = MSPricingInputs::RUNNING_COST_CLOUD_INT_2500_5000 * msida.msterms.to_i
             when 500..10000
                running_cost_of_cloud_internal_identities = MSPricingInputs::RUNNING_COST_CLOUD_INT_5001_10000 * msida.msterms.to_i
             when 10000..20000
                running_cost_of_cloud_internal_identities = MSPricingInputs::RUNNING_COST_CLOUD_INT_10001_20000 * msida.msterms.to_i
             when 20001..100000
                running_cost_of_cloud_internal_identities = MSPricingInputs::RUNNING_COST_CLOUD_INT_20001_100000 * msida.msterms.to_i
            else
                running_cost_of_cloud_internal_identities = 0
        end
        running_cost_of_cloud_internal_identities
    end
    
    def running_cost_external_identities(msida)
        case msida.extident.to_i
            when 0..5000
                running_cost_of_cloud_external_identities = MSPricingInputs::RUNNING_COST_CLOUD_EXT_0_5000 * msida.msterms.to_i
             when 5001..10000
                running_cost_of_cloud_external_identities = MSPricingInputs::RUNNING_COST_CLOUD_EXT_5001_10000 * msida.msterms.to_i
             when 10001..20000
                running_cost_of_cloud_external_identities = MSPricingInputs::RUNNING_COST_CLOUD_EXT_10001_20000 * msida.msterms.to_i
             when 20001..35000
                running_cost_of_cloud_external_identities = MSPricingInputs::RUNNING_COST_CLOUD_EXT_20001_35000  * msida.msterms.to_i
             when 35001..50000
                running_cost_of_cloud_external_identities = MSPricingInputs::RUNNING_COST_CLOUD_EXT_35001_50000 * msida.msterms.to_i
             when 50001..75000
                running_cost_of_cloud_external_identities = MSPricingInputs::RUNNING_COST_CLOUD_EXT_50001_75000 * msida.msterms.to_i
             when 75001..100000
                running_cost_of_cloud_external_identities = MSPricingInputs::RUNNING_COST_CLOUD_EXT_75001_100000 * msida.msterms.to_i
            else
                running_cost_of_cloud_external_identities = 0
        end
        running_cost_of_cloud_external_identities
    end
    
    def roundup(number, block)
        nearest = (number/ block).ceil * block
        nearest
    end

    
end