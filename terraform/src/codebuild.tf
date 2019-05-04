resource "aws_iam_role" "cb_role" {
  name = "ipa-codebuild"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cb_policy" {
  role = "${aws_iam_role.cb_role.name}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeDhcpOptions",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${var.bucketArn}",
        "${var.bucketArn}/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_codebuild_project" "cb_project" {
  name          = "ipa-project"
  build_timeout = "5"
  service_role  = "${aws_iam_role.cb_role.arn}"

  artifacts {
    type = "NO_ARTIFACTS"
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
    type            = "GITHUB"
    location        = "https://github.com/wwalpha/ipa-api.git"
    git_clone_depth = 1
  }

  tags = {
    "Environment" = "Test"
  }
}
