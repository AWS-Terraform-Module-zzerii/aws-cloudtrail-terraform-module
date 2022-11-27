# terraform-aws-cloud-trail

terraform-aws-cloud-trail를 생성하는 공통 모듈

## Usage

### `terraform.tfvars`

- 모든 변수는 적절하게 변경하여 사용

```plaintext

account_id      = "123456789" # 아이디 변경 필수
region          = "ap-northeast-2"
prefix          = "test"

trail_name                    = "kcl-test"  # "%s-%s-cloud-trail", var.prefix, var.trail_name
s3_bucket_name                = "test-log-kcl" # s3 bucket 정책이 미리 설정 되어 있어야 합니다.
s3_key_prefix                 = "o-abcdefghi"
include_global_service_events = false
#For capturing events from services like IAM, include_global_service_events must be enabled.

kms_key_name                  = "alias/test" # kms key 정책이 미리 설정 되어 있어야 합니다.

enable_log_file_validation    = true
# Default = false

sns_topic_name                = "topic name" # topic 정책이 미리 설정 되어 있어야 합니다.

cloud_watch_logs_group_arn    = null
cloud_watch_logs_role_arn     = null


# 세부 사항은 locals에서 설정합니다.
# 필요한 arn값의 경우는 여기서 name 정의 후 data에서 불러와 locals에서 가공하여 사용해주세요.
##############################
# Data events - S3
##############################
s3_bucket_name_01                     = "test-log-kcl"

##############################
# Data events - lambda
##############################

##############################
# Data events - Dynamo
##############################

##############################
# Data events - s3_outposts
##############################

#################################
# Data events -managed_blockchain
#################################

################################
# Data events - s3_object_lambda
################################

##############################
# Data events - lake_formation
##############################

################################
# Data events - ebs_direct_apis
################################

################################
# Data events - s3_access_point
################################

################################
# Data events - dynamodb_streams
################################


# insight_type 사용 시 모듈 패치 필요 (null 사용 불가)
# insight_type = "ApiCallRateInsight"  # /"ApiCallRateInsight"/"ApiErrorRateInsight"

tags = {
  "CreatedByTerraform"     = "true"
  "TerraformModuleName"    = "terraform-aws-module-cloud-trail"
  "TerraformModuleVersion" = "v1.0.0"
}

```

------

### `main.tf`

```plaintext

module "aws_cloud_trail" {
    source                                = "../aws-cloud-trail-module"

    current_id                            = data.aws_caller_identity.current.account_id
    current_region                        = data.aws_region.current.name
    
    account_id                            = var.account_id
    region                                = var.region
    
    prefix                                = var.prefix

    trail_name                            = var.trail_name
    s3_bucket_name                        = var.s3_bucket_name
    s3_key_prefix                         = var.s3_key_prefix
    include_global_service_events         = var.include_global_service_events
    kms_key_id                            = data.aws_kms_key.this.arn
    enable_log_file_validation            = var.enable_log_file_validation

    sns_topic_name                        = var.sns_topic_name
    cloud_watch_logs_group_arn            = var.cloud_watch_logs_group_arn
    cloud_watch_logs_role_arn             = var.cloud_watch_logs_role_arn

    selector_data                          = local.selector_data

    # insight_type                           = var.insight_type

    tags                                  = var.tags
}

}
```

------

### `provider.tf`

```plaintext

provider "aws" {
   region = var.region
}



```

------

### `terraform.tf`

```plaintext

terraform {
  required_version = ">= 1.1.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22"
    }
  }

  backend "s3" {
    bucket         = "kcl-terraform-state-backend"
    key            = "123456789/cloudtrail/common/terraform.state"
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}


```

------

### `data.tf`

```plaintext

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}


data "aws_kms_key" "this" {
  key_id = var.kms_key_name
}

##############################
# Data events - S3
##############################
data "aws_s3_bucket" "s3_bucket_01" {
  bucket      = var.s3_bucket_name_01
}


# ##############################
# # Data events - lambda
# ##############################

# ##############################
# # Data events - Dynamo
# ##############################

# ##############################
# # Data events - s3_outposts
# ##############################

# ##############################
# # Data events -managed_blockchain
# ##############################

# ##############################
# # Data events - s3_object_lambda
# ##############################

# ##############################
# # Data events - lake_formation
# ##############################

# ##############################
# # Data events - ebs_direct_apis
# ##############################

# ##############################
# # Data events - s3_access_point
# ##############################

# ##############################
# # Data events - dynamodb_streams
# ##############################


```
------

### `locals.tf`

```plaintext

########################################################
# SELECTOR FORM 
#selector 에 들어가는 기본 세팅입니다.
# 사용하지 않는 요소는 빈칸으로 두시지 마시고 삭제해주세요
########################################################
# eventCategory = {
#             equals      = [ "Data" ]    # "Data"/"Management"
#         }
#         resources_type = {
#             equals          = ["AWS::S3::Object"]
#         }
# resources_arn = {
#         equals          = [ "" ]
#         not_equals      = [ "" ]
#         starts_with     = [ "" ]
#         not_starts_with = [ "" ]
#         ends_with       = [ "" ]
#         not_ends_with   = [ "" ]
#     },
#     readOnly = {
#         equals          = [ "" ]  # true or false
#     },
#     eventName = {
#         equals          = [ "" ]
#         not_equals      = [ "" ]
#         starts_with     = [ "" ]
#         not_starts_with = [ "" ]
#         ends_with       = [ "" ]
#         not_ends_with   = [ "" ]
#     }

##################################
# Data event resources type list
##################################
# s3                   = "AWS::S3::Object"
# lambda               = "AWS::Lambda::Function"
# dynamo               = "AWS::DynamoDB::Table"
# s3_outposts          = "AWS::S3Outposts::Object"
# managed_blockchain   = "AWS::ManagedBlockchain::Node"
# s3_object_lambda     = "AWS::S3ObjectLambda::AccessPoint"
# ebs_direct_apis      = "AWS::EC2::Snapshot"
# s3_access_point      = "AWS::S3::AccessPoint"
# dynamodb_streams     = "AWS::DynamoDB::Stream"
# lake_formation       = "AWS::Glue::Table"


locals {
selector_data={
    ##############################
    # Management events
    ##############################
    management = {
        eventCategory = {
            equals      = [ "Management" ]
        }
    }
    ##############################
    # Data events - S3
    ##############################
    s3={
        eventCategory = {
            equals      = [ "Data" ]
        }
        resources_type = {
            equals          = ["AWS::S3::Object"]
        }
        resources_arn = {
            equals          = ["${data.aws_s3_bucket.s3_bucket_01.arn}/"]
        },
        readOnly = {
            equals      = [ "true" ]
        },
        eventName = {
            equals          = [ "aaa" ]
            not_equals      = [ "bbb" ]
            not_starts_with = [ "ccc", "ddd" ]
        }
    }
    # ##############################
    # # Data events - lambda
    # ##############################
    # lambda={
    # }
    # ##############################
    # # Data events - Dynamo
    # ##############################
    # dynamo={
    # }
    # ##############################
    # # Data events - s3_outposts
    # ##############################
    # s3_outposts={
    # }
    # ##############################
    # # Data events -managed_blockchain
    # ##############################
    # managed_blockchain={
    # }
    # ##############################
    # # Data events - s3_object_lambda
    # ##############################
    # s3_object_lambda={
    # }
    # ##############################
    # # Data events - lake_formation
    # ##############################
    # lake_formation={
    # }
    # ##############################
    # # Data events - ebs_direct_apis
    # ##############################
    # ebs_direct_apis={
    # }
    # ##############################
    # # Data events - s3_access_point
    # ##############################
    # s3_access_point={
    # }
    # ##############################
    # # Data events -dynamodb_streams
    # ##############################
    # dynamodb_streams={
    # }
    }
}


```

------

### `variables.tf`

```plaintext

variable "account_id" {
  description = "Allowed AWS account IDs"
  type = string
}

variable "region" {
    type    = string
    default = ""
}

variable "prefix" {
    type    = string
    default = ""
}


variable "trail_name" {
    type = string
    default = ""
}

variable "s3_bucket_name" {
    type = string
    default = ""
}

variable "s3_key_prefix" {
    type = string
    default = ""
}

variable "include_global_service_events" {
    type = bool
    default = false
}

variable "kms_key_name" {
    type = string
    default = ""
}

variable "enable_log_file_validation" {
    type = bool
    default = true
}

variable "sns_topic_name" {
    type = string
    default = null
}

variable "cloud_watch_logs_group_arn" {
    type = string
    default = null
}

variable "cloud_watch_logs_role_arn" {
    type = string
    default = null
}

variable "s3_bucket_name_01" {
    type = string
    default = ""
}

# variable "insight_type" {
#     type = string
#     default = ""
# }

variable "tags" {
  type = map(string)
  default = {}
}



```

------

### `outputs.tf`

```plaintext

output "result" {
    value = module.aws_cloud_trail
}


```

## 실행방법

```plaintext
terraform init -get=true -upgrade -reconfigure
terraform validate (option)
terraform plan -var-file=terraform.tfvars -refresh=false -out=planfile
terraform apply planfile
```

- "Objects have changed outside of Terraform" 때문에 `-refresh=false`를 사용
- 실제 UI에서 리소스 변경이 없어보이는 것과 low-level Terraform에서 Object 변경을 감지하는 것에 차이가 있는 것 같음, 다음 링크 참고
  - https://github.com/hashicorp/terraform/issues/28776
- 위 이슈로 변경을 감지하고 리소스를 삭제하는 케이스가 발생 할 수 있음