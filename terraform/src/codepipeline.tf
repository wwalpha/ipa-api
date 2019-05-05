# resource "aws_s3_bucket" "codepipeline_bucket" {
#   bucket = "test-bucket"
#   acl    = "private"
# }
resource "aws_iam_role" "codepipeline_role" {
  name               = "ipa-codepipeline-role"
  assume_role_policy = "${data.aws_iam_policy_document.policy_document_codepipeline_role.json}"

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "codepipeline_policy"
  role   = "${aws_iam_role.codepipeline_role.id}"
  policy = "${data.aws_iam_policy_document.policy_document_codepipeline_policy.json}"
}

resource "aws_codepipeline" "codepipeline" {
  name     = "ipa-pipeline"
  role_arn = "${aws_iam_role.codepipeline_role.arn}"

  artifact_store {
    location = "${var.bucketName}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = "wwalpha"
        Repo       = "ipa-api"
        Branch     = "master"
        OAuthToken = "552101969af5b67309bbcbf753074bd549eca109"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "${aws_codebuild_project.cb_project.name}"
      }
    }
  }

  # stage {
  #   name = "Deploy"
  #   action {
  #     name            = "Deploy"
  #     category        = "Deploy"
  #     owner           = "AWS"
  #     provider        = "CloudFormation"
  #     input_artifacts = ["build_output"]
  #     version         = "1"
  #     configuration {
  #       ActionMode     = "REPLACE_ON_FAILURE"
  #       Capabilities   = "CAPABILITY_AUTO_EXPAND,CAPABILITY_IAM"
  #       OutputFileName = "CreateStackOutput.json"
  #       StackName      = "MyStack"
  #       TemplatePath   = "build_output::sam-templated.yaml"
  #     }
  #   }
  # }
}
