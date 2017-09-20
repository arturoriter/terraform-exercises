resource "aws_iam_instance_profile" "test_profile" {
  name  = "test_profile"
  role = "${aws_iam_role.role_ec2.name}"
}

#Trusted Relationship
data "aws_iam_policy_document" "role_ec2_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "role_ec2" {
  name = "${var.role_ec2}"
  path = "/"
  assume_role_policy = "${data.aws_iam_policy_document.role_ec2_policy.json}"
}

### S3
data "aws_iam_policy_document" "bucket_policy" {
  statement {
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.exchange.arn}/*"]
  }
}

resource "aws_iam_policy" "bucket_policy" {
  name        = "bucket_policy"
  path        = "/"
  description = "My s3 test policy"
  policy      = "${data.aws_iam_policy_document.bucket_policy.json}"
}

resource "aws_iam_policy_attachment" "s3_attach" {
  name       = "s3_attachment"
  roles      = ["${aws_iam_role.role_ec2.name}", "${aws_iam_role.role_lambda.name}"]
  policy_arn = "${aws_iam_policy.bucket_policy.arn}"
}

### LAMBDA
#Trusted Relationship
data "aws_iam_policy_document" "role_lambda_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "role_lambda" {
  name = "${var.role_lambda}"
  path = "/"
  assume_role_policy = "${data.aws_iam_policy_document.role_lambda_policy.json}"
}

data "aws_iam_policy_document" "lambda_permission_policy" {
  statement {
    actions   = ["lambda:InvokeFunction"]
    resources = ["${aws_lambda_function.exchange_lambda.arn}"]
  }
}

resource "aws_iam_policy" "lambda_permission_policy" {
  name        = "lambda_policy"
  path        = "/"
  description = "My lambda test policy"
  policy      = "${data.aws_iam_policy_document.lambda_permission_policy.json}"
}

resource "aws_iam_policy_attachment" "lambda_attach" {
  name       = "lambda_attachment"
  roles      = ["${aws_iam_role.role_ec2.name}"]
  policy_arn = "${aws_iam_policy.lambda_permission_policy.arn}"
}
