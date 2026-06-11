output "bucket_name" {
  value = aws_s3_bucket.tf_state.id
}

output "lock_table" {
  value = aws_dynamodb_table.state_lock.name
}
