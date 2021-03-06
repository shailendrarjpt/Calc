class MSPricingInputs
    include ActiveModel::Model
    
    IDA_COST_OF_INTERNAL_IDENTITIES_2500_5000 = 3.2
    IDA_COST_OF_INTERNAL_IDENTITIES_5001_10000 = 2.8
    IDA_COST_OF_INTERNAL_IDENTITIES_10001_20000 = 2.3
    IDA_COST_OF_INTERNAL_IDENTITIES_20001_100000 = 1.8
    
    IDA_COST_OF_EXTERNAL_IDENTITIES_0_5000 = 0.8
    IDA_COST_OF_EXTERNAL_IDENTITIES_5001_10000 = 0.72
    IDA_COST_OF_EXTERNAL_IDENTITIES_10001_20000 = 0.65
    IDA_COST_OF_EXTERNAL_IDENTITIES_20001_35000 = 0.55
    IDA_COST_OF_EXTERNAL_IDENTITIES_35001_50000 = 0.45
    IDA_COST_OF_EXTERNAL_IDENTITIES_50001_75000 = 0.35
    IDA_COST_OF_EXTERNAL_IDENTITIES_75001_100000 = 0.30
    
    COST_OF_NON_CAMPAIGN_MONTH = 7200
    COST_OF_CAMPAIGN_MONTH = 10500
    MINIMUM_IDENTITIES = 5000
    INCREMENTAL_IDENTITY_BLOCK = 5000
    MINIMUM_APPLICATIONS = 5
    INCREMENTAL_APPLICATIONS_BLOCK = 5
    ADDL_ID_BLOCK_COST_CAMPAIGN_MONTH = 2500
    ADDL_APPL_BLOCK_COST_CAMPAIGN_MONTH = 1000
    
    #Term Discount
    MODISCOUNT36 = 0
    MODISCOUNT48 = 0.02
    MODISCOUNT60 = 0.05
    
    #ID Source Multiplier
    AGSOURCE1 = 1
    AGSOURCE2 = 1
    AGSOURCE3 = 1
    
    #AGInfra Cost/Month - Fixed Value
    AGINFRAMONTH = 2500.0
    
    # PROBABLY MULTIPLE VALUES - NEEDS FIXED
    AGONETIME = 20000.0
    
    IDA_INT_ONETIME_2500_5000 = 12000.0
    IDA_INT_ONETIME_5001_10000 = 16000.0
    IDA_INT_ONETIME_10001_20000 = 22000.0
    IDA_INT_ONETIME_20001_100000 = 30000.0
    
    IDA_EXT_ONETIME_0_5000 = 4000.0
    IDA_EXT_ONETIME_5001_10000 = 6000.0
    IDA_EXT_ONETIME_10001_20000 = 8000.0
    IDA_EXT_ONETIME_20001_35000 = 10000.0
    IDA_EXT_ONETIME_35001_50000 = 12000.0
    IDA_EXT_ONETIME_50001_75000 = 14000.0
    IDA_EXT_ONETIME_75001_100000 = 16000.0
    
    IICLICENSING = 15000.0
    
    #Running Cost of Cloud
    RUNNING_COST_CLOUD_INT_2500_5000 = 2500.0
    RUNNING_COST_CLOUD_INT_5001_10000 = 3500.0
    RUNNING_COST_CLOUD_INT_10001_20000 = 4500.0
    RUNNING_COST_CLOUD_INT_20001_100000 = 6500.0
    
    RUNNING_COST_CLOUD_EXT_0_5000 = 1000.0
    RUNNING_COST_CLOUD_EXT_5001_10000 = 1500.0
    RUNNING_COST_CLOUD_EXT_10001_20000 = 2000.0
    RUNNING_COST_CLOUD_EXT_20001_35000 = 2500.0
    RUNNING_COST_CLOUD_EXT_35001_50000 = 3000.0
    RUNNING_COST_CLOUD_EXT_50001_75000 = 3500.0
    RUNNING_COST_CLOUD_EXT_75001_100000 = 4000.0
    
    #AG Coverage Multiplier
    AGCOV8X5 = 1.0
    AGCOV8X7 = 1.02
    AGCOV24X5 = 1.05
    AGCOV24X7 = 1.1
    
    IDACOV8X5 = 1.0
    IDACOV8X7 = 1.05
    IDACOV24X5 = 1.20
    IDACOV24X7 = 1.25
    
    #Margin
    INFRAMARGIN = 0.3
    SOFTMARGIN = 0.3
    
    #Service Level
    
    SL_AG_RISKANDISSUE_SILVER = 0
    SL_AG_RISKANDISSUE_GOLD = 0
    SL_AG_RISKANDISSUE_PLATINUM = 0
    
    SL_AG_DEDICATEDSUPPORT_SILVER = 0
    SL_AG_DEDICATEDSUPPORT_GOLD = 0
    SL_AG_DEDICATEDSUPPORT_PLATINUM = 10000.0
    
    SL_AG_IDENTITYORCHESTRATOR_SILVER = 0
    SL_AG_IDENTITYORCHESTRATOR_GOLD = 0
    SL_AG_IDENTITYORCHESTRATOR_PLATINUM = 0
    
    # SL_IDA_RISKANDISSUE_SILVER = 0
    # SL_IDA_RISKANDISSUE_GOLD = 0
    # SL_IDA_RISKANDISSUE_PLATINUM = 0
    
    # SL_IDA_DEDICATEDSUPPORT_SILVER = 0
    # SL_IDA_DEDICATEDSUPPORT_GOLD = 0
    # SL_IDA_DEDICATEDSUPPORT_PLATINUM = 10000.0
    
    # SL_IDA_IDENTITYORCHESTRATOR_SILVER = 0
    # SL_IDA_IDENTITYORCHESTRATOR_GOLD = 0
    # SL_IDA_IDENTITYORCHESTRATOR_PLATINUM = 0
    
    SL_MULTIPLIER_AG_SILVER = 1.0
    SL_MULTIPLIER_AG_GOLD = 1.1
    SL_MULTIPLIER_AG_PLATINUM = 1.155 
    
    SL_MULTIPLIER_IDA_SILVER = 1.0
    SL_MULTIPLIER_IDA_GOLD = 1.1
    SL_MULTIPLIER_IDA_PLATINUM = 1.155 
    
    SL_ADDL_DOLLARS_AG_SILVER = 0.0
    SL_ADDL_DOLLARS_AG_GOLD = 50000.0
    SL_ADDL_DOLLARS_AG_PLATINUM = 116250.0
    
    SL_ADDL_DOLLARS_IDA_SILVER = 0.0
    SL_ADDL_DOLLARS_IDA_GOLD = 50000.0
    SL_ADDL_DOLLARS_IDA_PLATINUM = 288000.0
    
    def self.SLAGDedicatedSupportGoldOrPlatinum(infra, term)
        if infra == "cloud"
            return 50000.0
        else
            return 53000.0 + (300 * term)
        end
    end
    
end
