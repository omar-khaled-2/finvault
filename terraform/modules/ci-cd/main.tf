
data "aws_iam_policy_document" "codebuild_assume_role" {
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

  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json
}

resource "aws_iam_role_policy_attachment" "name" {
    role = aws_iam_role.codebuild_role.name
    policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
}

resource "aws_iam_role_policy_attachment" "codebuild_logs" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "codebuild_s3" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_codebuild_project" "build" {
    name = "finvalut-build"

    service_role = aws_iam_role.codebuild_role.arn
    artifacts {
        type = "CODEPIPELINE"
    }
    environment {
        compute_type = "BUILD_GENERAL1_SMALL"
        image = "aws/codebuild/standard:6.0"
        type = "LINUX_CONTAINER"


    }
    source {
        type = "CODEPIPELINE"
    }
}

data "aws_iam_policy_document" "codepipeline_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "codepipeline_role" {

  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role.json
}



data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject",
    ]

    resources = [
      "*"
    ]
  }

  statement {
    effect    = "Allow"
    actions   = ["codestar-connections:UseConnection"]
    resources = [var.github_connection_arn]
  }

  statement {
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "codedeploy:*"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "codepipeline_policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}

resource "aws_codedeploy_app" "app" {
  compute_platform = "Server"
  name             = "app"

}

data "aws_iam_policy_document" "codedeploy_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codedeploy_role" {
  assume_role_policy = data.aws_iam_policy_document.codedeploy_assume_role.json
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role  = aws_iam_role.codedeploy_role.name
}


resource "aws_iam_role_policy_attachment" "AmazonS3ReadOnlyAccess" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
    role = aws_iam_role.codedeploy_role.name
}


resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name = aws_codedeploy_app.app.name
  deployment_group_name = "finvault-deployment-group"
  service_role_arn = aws_iam_role.codedeploy_role.arn
  autoscaling_groups = [var.autoscaling_group_name]
  deployment_config_name = "CodeDeployDefault.OneAtATime"
} 

resource "aws_codepipeline" "pipeline" {
  name     = "finvault-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = var.artifacts_bucket_name
    type     = "S3"
  }


  stage {
    name = "Source"

    action {
      name             = "GitHub_Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = var.github_connection_arn
        FullRepositoryId = "omar-khaled-2/finvault"
        BranchName       = "main"
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
        ProjectName = aws_codebuild_project.build.name
      }
    }
  }

  stage {
    name = "Deploy"
    action {
        name             = "Deploy"
        category         = "Deploy"
        owner            = "AWS"
        provider         = "CodeDeploy"
        version          = "1"
        input_artifacts = ["build_output"]
        configuration = {
          ApplicationName     = aws_codedeploy_app.app.name
          DeploymentGroupName = aws_codedeploy_deployment_group.deployment_group.deployment_group_name
        }

    }
  }

  
}
