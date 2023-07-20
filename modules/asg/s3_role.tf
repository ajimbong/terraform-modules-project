# IAM role for s3 Access
resource "aws_iam_role" "ec2-s3-iam-role" {
  name = "${var.project-name}ec2-s3-access"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "s3-access-policy" {
  name = "${var.project-name}ec2-s3-access-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:Get*",
          "s3:List*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2-s3-policy-attachment" {
  policy_arn = aws_iam_policy.s3-access-policy.arn
  role       = aws_iam_role.ec2-s3-iam-role.name
}

resource "aws_iam_instance_profile" "ec2-s3-access-profile" {
  name = "${var.project-name}-ec2-s3-access-profile"
  role = aws_iam_role.ec2-s3-iam-role.name
}