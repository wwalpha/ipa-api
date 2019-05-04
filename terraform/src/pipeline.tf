# resource "aws_iam_role" "codepipeline_role" {
#   name = "test-role"
#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "codepipeline.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }
# resource "aws_iam_role_policy" "codepipeline_policy" {
#   name = "codepipeline_policy"
#   role = "${aws_iam_role.codepipeline_role.id}"
#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect":"Allow",
#       "Action": [
#         "s3:GetObject",
#         "s3:GetObjectVersion",
#         "s3:GetBucketVersioning"
#       ],
#       "Resource": [
#         "${var.bucketArn}",
#         "${var.bucketArn}/*"
#       ]
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "codebuild:BatchGetBuilds",
#         "codebuild:StartBuild"
#       ],
#       "Resource": "*"
#     }
#   ]
# }
# EOF
# }
# resource "aws_codepipeline" "codepipeline" {
#   name     = "tf-test-pipeline"
#   role_arn = "${aws_iam_role.codepipeline_role.arn}"
#   artifact_store {
#     location = "ipa-api-backend"
#     type     = "S3"
#   }
#   stage {
#     name = "Source"
#     action {
#       name             = "Source"
#       category         = "Source"
#       owner            = "ThirdParty"
#       provider         = "GitHub"
#       version          = "1"
#       output_artifacts = ["source_output"]
#       configuration = {
#         Owner  = "wwalpha"
#         Repo   = "ipa-api"
#         Branch = "master"
#       }
#     }
#   }
#   stage {
#     name = "Build"
#     action {
#       name             = "Build"
#       category         = "Build"
#       owner            = "AWS"
#       provider         = "CodeBuild"
#       input_artifacts  = ["source_output"]
#       output_artifacts = ["build_output"]
#       version          = "1"
#       configuration = {
#         ProjectName = "test"
#       }
#     }
#   }
#   stage {
#     name = "Deploy"
#     action {
#       name            = "Deploy"
#       category        = "Deploy"
#       owner           = "AWS"
#       provider        = "CloudFormation"
#       input_artifacts = ["build_output"]
#       version         = "1"
#       configuration {
#         ActionMode     = "REPLACE_ON_FAILURE"
#         Capabilities   = "CAPABILITY_AUTO_EXPAND,CAPABILITY_IAM"
#         OutputFileName = "CreateStackOutput.json"
#         StackName      = "MyStack"
#         TemplatePath   = "build_output::sam-templated.yaml"
#       }
#     }
#   }
# }

