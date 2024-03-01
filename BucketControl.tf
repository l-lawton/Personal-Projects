#create an iam user with an attached policy list, technically making it an iam role
#allow this iam role access over an s3 bucket to control uploading, downloading and deleting from it.
#the actions the iam user has over the s3 bucket depends on the iam policies

#provider is always aws
provider "aws" {
  region = "eu-west-1"  #closest region
}

#create iam role for s3 access
resource "aws_iam_role" "s3_role" {
  name               = "s3-access-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect"    : "Allow",
      "Principal" : {
        "Service" : "s3.amazonaws.com"
      },
      "Action"    : "sts:AssumeRole"
    }]
  })
}

#creating iam policy list for s3 access
resource "aws_iam_policy" "s3_policy" {
  name        = "s3-access-policy"
  description = "Allows access to S3 buckets"
  policy      = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect"   : "Allow",
      "Action"   : "s3:*",
      "Resource" : "*"
    }]
  })
}

#attack policy list to iam role
resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  role       = aws_iam_role.s3_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

#creating s3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name"  #bucket name that is human friendly
  acl    = "private"  # set bucket access control list (acl)
}
