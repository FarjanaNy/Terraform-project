# Create a S3 bucket
resource "aws_s3_bucket" "mybucket" {
    bucket = var.mybuc
}

#Setting bucket owership
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#Enabling public access
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#Defining the ACL
resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}

#Uploading index.html in the S3 bucket
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.mybucket.id
  key    = "index.html"       # name of the file
  source = "index.html"       # path
  acl = "public-read"
  content_type = "text/html"
}

#Uploading coverimg.jpg in the S3 bucket
resource "aws_s3_object" "picture" {
    bucket = aws_s3_bucket.mybucket.id
    key = "coverimg.jpg"
    source = "coverimg.jpg"
    acl= "public-read"
    content_type = "image/jpeg"
    
}

#Configuring bucket to host staic web 
#Hey AWS, this S3 bucket should behave like a website — here's the homepage
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
  }

  depends_on = [aws_s3_bucket_acl.example]

}