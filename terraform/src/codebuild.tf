resource "aws_iam_role" "codebuild_role" {
  name               = "ipa-codebuild-role"
  assume_role_policy = "${data.aws_iam_policy_document.policy_document_codebuild_role.json}"

  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_iam_role_policy" "codebuild_policy" {
  depends_on = ["aws_iam_role.codebuild_role"]
  role       = "${aws_iam_role.codebuild_role.name}"
  policy     = "${data.aws_iam_policy_document.policy_document_codebuild_policy.json}"
}

resource "aws_codebuild_project" "cb_project" {
  name          = "ipa-codebuild"
  build_timeout = "5"
  service_role  = "${aws_iam_role.codebuild_role.arn}"

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type     = "S3"
    location = "${var.bucketName}"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/nodejs:10.14.1"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    # environment_variable {
    #   "name"  = "SOME_KEY1"
    #   "value" = "SOME_VALUE1"
    # }
    # environment_variable {
    #   "name"  = "SOME_KEY2"
    #   "value" = "SOME_VALUE2"
    #   "type"  = "PARAMETER_STORE"
    # }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "api/buildspec.yaml"
  }

  tags = {
    "Environment" = "Test"
  }
}
