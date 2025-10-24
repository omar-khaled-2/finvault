
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}


resource "aws_iam_role" "codebuild_role" {

  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "name" {
    role = aws_iam_role.codebuild_role.name
    policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
}

resource "aws_codebuild_project" "build" {
    name = "finvalut-build"

    service_role = aws_iam_role.codebuild_role.arn
    artifacts {
        type = "S3"
        location = var.artifacts_bucket_name
        packaging = "ZIP"
    }
    environment {
        compute_type = "BUILD_GENERAL1_SMALL"
        image = "aws/codebuild/standard:6.0"
        type = "LINUX_CONTAINER"


    }
    source {
        type = "GITHUB"
        location = "https://github.com/omar-khaled-2/finvault.git"
        buildspec = file("buildspec.yml")
    }
}