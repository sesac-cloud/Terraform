# resource "aws_wafv2_web_acl" "waf" {
#   name        = "waf-set"
#   description = "set of waf_web_acl"
#   scope       = "REGIONAL"

#   default_action {
#     allow {}
#   }

#   rule {
#     name     = "rule-1"
#     priority = 1

#     override_action {
#       count {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesCommonRuleSet"
#         vendor_name = "AWS"

#         rule_action_override {
#           action_to_use {
#             count {}
#           }
#           name = "SizeRestrictions_QUERYSTRING"
#         }

#         rule_action_override {
#           action_to_use {
#             count {}
#           }
#           name = "EC2MetaDataSSRF_QUERYARGUMENTS"
#         }

#         rule_action_override {
#           action_to_use {
#             count {}
#           }
#           name = "GenericLFI_QUERYARGUMENTS"
#         }

#         rule_action_override {
#           action_to_use {
#             count {}
#           }
#           name = "RestrictedExtensions_QUERYARGUMENTS"
#         }

#         rule_action_override {
#           action_to_use {
#             count {}
#           }
#           name = "GenericRFI_QUERYARGUMENTS"
#         }

#         rule_action_override {
#           action_to_use {
#             count {}
#           }
#           name = "CrossSiteScripting_QUERYARGUMENTS"
#         }

#         rule_action_override {
#           action_to_use {
#             count {}
#           }
#           name = "EC2MetaDataSSRF_BODY"
#         }

#         rule_action_override {
#           action_to_use {
#             count {}
#           }
#           name = "EC2MetaDataSSRF_COOKIE"
#         }

#         rule_action_override {
#           action_to_use {
#             count {}
#           }
#           name = "EC2MetaDataSSRF_URIPATH"
#         }

#         rule_action_override {
#           action_to_use {
#             count {}
#           }
#           name = "NoUserAgent_HEADER"
#         }    
#       }    
#     }
#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "waf-cloudwatch-metric"
#       sampled_requests_enabled   = true
#     }
#   }

#   rule {
#     name     = "rule-2"
#     priority = 2

#     override_action {
#         count {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesSQLiRuleSet"
#         vendor_name = "AWS"

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "SizeRestrictions_QUERYSTRING"
#         }

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "SQLi_QUERYARGUMENTS"
#         }

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "SQLiExtendedPatterns_QUERYARGUMENTS"
#         }

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "SQLi_BODY"
#         }

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "SQLi_URIPATH"
#         }

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "SQLi_COOKIE"
#         }
#       }
#     }
#     visibility_config {
#       cloudwatch_metrics_enabled = false
#       metric_name                = "waf-cloudwatch-metric"
#       sampled_requests_enabled   = false    
#     } 
#   }

#     rule {
#       name     = "rule-3"
#       priority = 3

#     override_action {
#         count {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesKnownBadInputsRuleSet"
#         vendor_name = "AWS"

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "ExploitablePaths_URIPATH"
#         }

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "Log4JRCE_HEADER"
#         }

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "Log4JRCE_QUERYSTRING"
#         }

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "Log4JRCE_BODY"
#         }
#       }
#     }
#     visibility_config {
#       cloudwatch_metrics_enabled = false
#       metric_name                = "waf-cloudwatch-metric"
#       sampled_requests_enabled   = false 
#     }
#   }    

#   rule {
#     name     = "rule-4"
#     priority = 4

#     override_action {
#         count {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesATPRuleSet"
#         vendor_name = "AWS"

#         managed_rule_group_configs {
#           aws_managed_rules_atp_rule_set {
#             login_path = "/new-login-path"

#             request_inspection {
#               password_field {
#                 identifier = "/password"
#               }

#               payload_type = "JSON"

#               username_field {
#                 identifier = "/user"
#               }
#             }
#           }
#         }    
#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "AttributePasswordTraversal"
#         }

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "AttributeUsernameTraversal"
#         }

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "AttributeCompromisedCredentials"
#         }

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "SignalMissingCredential"
#         }

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "VolumetricSession"
#         }
#       }
#     }
#     visibility_config {
#       cloudwatch_metrics_enabled = false
#       metric_name                = "waf-cloudwatch-metric"
#       sampled_requests_enabled   = false    
#     }
#   }  

#   rule {
#     name     = "rule-5"
#     priority = 5

#     override_action {
#         count {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesAmazonIpReputationList"
#         vendor_name = "AWS"

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "AWSManagedIPReputationList"
#         }

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "AWSManagedReconnaissanceList"
#         }
#       }
#     }
#     visibility_config {
#       cloudwatch_metrics_enabled = false
#       metric_name                = "waf-cloudwatch-metric"
#       sampled_requests_enabled   = false    
#     }
#   }

#   rule {
#     name     = "rule-6"
#     priority = 6

#     override_action {
#         count {}
#     }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesBotControlRuleSet"
#         vendor_name = "AWS"

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "CategoryAdvertising"
#         }

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "CategoryArchiver"
#         }

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "CategoryContentFetcher"
#         }

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "CategoryHttpLibrary"
#         }

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "CategoryLinkChecker"
#         }

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "CategoryMiscellaneous"
#         }

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "CategoryMonitoring"
#         }

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "CategoryScrapingFramework"
#         }

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "CategorySecurity"
#         }

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "CategorySeo"
#         }

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "CategorySocialMedia"
#         }

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "CategorySearchEngine"
#         }

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "SignalAutomatedBrowser"
#         }

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "SignalKnownBotDataCenter"
#         }

#         rule_action_override {
#             action_to_use {
#                 count {}
#             }
#             name = "SignalNonBrowserUserAgent"
#         }
#       }
#     }
#     visibility_config {
#       cloudwatch_metrics_enabled = false
#       metric_name                = "waf-cloudwatch-metric"
#       sampled_requests_enabled   = false
#     }    
#   }  

#   visibility_config {
#     cloudwatch_metrics_enabled = false
#     metric_name                = "waf-cloudwatch-metric"
#     sampled_requests_enabled   = false
#   }
# }

# /*
# resource "aws_wafv2_web_acl_association" "waf_lb_ass" {
#   resource_arn = LB arn주소
#   web_acl_arn  = aws_wafv2_web_acl.waf.arn
# }
# */
# # token_domains = ["mywebsite.com", "myotherwebsite.com"]
# #  tags = local.resource_tags */

# resource "aws_wafv2_web_acl" "waf_acl" {
#   name        = "waf_web_acl_k8s"
#   description = "mMnaged rule for our project."
#   scope       = "REGIONAL"

#   default_action {
#     allow {}
#   }

#   rule {
#     name     = "AWS-AWSManagedRulesCommonRuleSet"
#     priority = 1
#     override_action {
#       none {}
#     }
#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesCommonRuleSet"
#         vendor_name = "AWS"
#       }
#     }
#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
#       sampled_requests_enabled   = true
#     }
#   }

#   rule {
#     name     = "AWS-AWSManagedRulesSQLiRuleSet"
#     priority = 2
#     override_action {
#       none {}
#     }
#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesSQLiRuleSet"
#         vendor_name = "AWS"
#       }
#     }
#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "AWS-AWSManagedRulesSQLiRuleSet"
#       sampled_requests_enabled   = true
#     }
#   }


#   visibility_config {
#     cloudwatch_metrics_enabled = false
#     metric_name                = "waf-metric-name"
#     sampled_requests_enabled   = false
#   }
# }